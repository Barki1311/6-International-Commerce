# Contexto de trabajo — 6 International Commerce

> Bitácora específica de este módulo. Para el panorama completo del proyecto Kosmostek (todos los módulos), ver `context.md` en la raíz del repositorio general.

## Qué es este módulo

Implementa el **Complemento de Comercio Exterior (CCE, Anexo 20 del SAT)**, namespace vigente `cce20` (`http://www.sat.gob.mx/ComercioExterior20`). Se activa por el campo booleano `"International Commerce"`, replicado en `Customer`, `Sales Header`, `Sales Invoice Header` y la tabla genérica interna `Document Header`.

**Pieza clave:** codeunit 51005 "CODE50140" ([AL/Codeunit/51005-CODE50140.al](.vscode/AL/Codeunit/51005-CODE50140.al)), que se suscribe a los eventos `OnAfterCreateReceipt` y `OnBeforePostSalesDoc`/`OnBeforeInitXML` del motor central de CFDI (codeunit 51002, en el módulo `4 ALCoreBaseEInvoicing`) para armar el nodo `cce20:ComercioExterior` dentro del `Complemento` del XML.

**Importante:** el complemento **NO se genera para Notas de Crédito** — hay un `IF IsCredit THEN EXIT` explícito al inicio del subscriber, y `Sales Cr.Memo Header` ni siquiera tiene el campo `"International Commerce"`. Es una decisión de diseño confirmada, no un bug.

**Decisión de negocio confirmada (2026-07-15):** la empresa solo maneja **Exportación definitiva** (`TipoOperacion='1'`, `ClaveDePedimento='A1'`). No están confirmados como "Exportador Confiable" ante el SAT, y el destinatario final de la mercancía siempre coincide con el Receptor facturado.

---

## Cambios aplicados en este módulo

**Bug raíz encontrado:** 6 lugares del código auto-asignaban `"CCE Tipo Operacion" := '2'` (Exportación *temporal*) cada vez que se marcaba un documento como Comercio Internacional, mientras `ClaveDePedimento` estaba hardcodeado a `'A1'` (que corresponde a exportación *definitiva*, `TipoOperacion='1'`) — combinación de catálogo inconsistente del SAT. Esto probablemente fue la razón por la que alguien comentó el atributo `TipoOperacion` en el XML en 2024-05-30, en vez de corregir el valor real.

### Archivos modificados (`'2'` → `'1'` como valor de `"CCE Tipo Operacion"`):

- [AL/ExtensionTable/51041-SalesHeaderExt.al](.vscode/AL/ExtensionTable/51041-SalesHeaderExt.al) — 2 lugares: validación de `Sell-to Customer No.` (línea ~19) y de `Ship-to Code` (línea ~44).
- [AL/ExtensionTable/51043-SalesInvoiceHeaderExt.al](.vscode/AL/ExtensionTable/51043-SalesInvoiceHeaderExt.al) — validación de `Ship-to Code` (línea ~39).
- [AL/PageExtension/51076-SalesOrdersIntCommerce.al](.vscode/AL/PageExtension/51076-SalesOrdersIntCommerce.al) — toggle manual en Sales Order (línea ~36).
- [AL/PageExtension/51076-SalesInvoiceIntCommerce.al](.vscode/AL/PageExtension/51076-SalesInvoiceIntCommerce.al) — toggle manual en Sales Invoice (línea ~41).
- [AL/PageExtension/51077-PostedSalesinvoiceIntCommerce.al](.vscode/AL/PageExtension/51077-PostedSalesinvoiceIntCommerce.al) — toggle manual en Posted Sales Invoice (línea ~51).

### Armado del XML corregido — [AL/Codeunit/51005-CODE50140.al](.vscode/AL/Codeunit/51005-CODE50140.al) líneas ~299-323:

- `TipoOperacion` ahora **se escribe** en el XML (antes estaba comentado con `// ... // 2024-05-30`).
- Valor por defecto cuando el campo viene vacío: `'2'` → `'1'`.
- Se eliminó la rama que comparaba contra `'A'` (no es un valor válido del catálogo SAT `c_TipoOperacion`, que solo admite `'1'`, `'2'`, `'3'`).
- La condición que activa `ClaveDePedimento`/`CertificadoOrigen`/`Incoterm`/`Subdivision`/`TipoCambioUSD`/`TotalUSD` ahora evalúa `'1'` correctamente (antes, si alguien ponía manualmente `'1'` en el campo, todo el bloque se saltaba — bug adicional resuelto de paso).
- `Subdivision='0'` ahora **se escribe** (antes comentado) — valor correcto para el caso estándar de un solo pedimento por CFDI.

**Pendiente de validar:** compilar este módulo y generar un CFDI de prueba con Comercio Exterior activo; confirmar en el XML que `cce20:ComercioExterior` trae `TipoOperacion="1"` y `Subdivision="0"` junto con los atributos que ya funcionaban (`ClaveDePedimento`, `CertificadoOrigen`, `Incoterm`, `TipoCambioUSD`, `TotalUSD`). Idealmente validar contra XSD/PAC de pruebas antes de producción.

---

## Gaps identificados, NO implementados (sin cambios de código)

| Elemento | Estado | Nota |
|---|---|---|
| `NumeroExportador` / `NumExportadorConfiable` | No implementado | Pendiente confirmar con área fiscal si aplica "Exportador Confiable" |
| Nodo `Destinatario` | No implementado | Confirmado que no aplica (destinatario = receptor siempre) |
| `DescripcionesEspecificas` (subnodo de `Mercancia`) | No implementado | Solo obligatorio para ciertas fracciones arancelarias específicas |
| Atributo `Referencia` en `Domicilio` (Emisor/Receptor) | No implementado | Opcional en la norma |
| `ClaveDePedimento` hardcodeado a `'A1'` | Sin cambio | Correcto mientras solo se maneje exportación definitiva; no viene de catálogo/tabla Pedimento (no existe tal tabla en el sistema) |

---

## Interacción con el módulo `7 Virtual Export` (Leyendas Fiscales) — solo auditoría, nada modificado aquí

Cuando un documento tiene **Comercio Exterior + Leyendas Fiscales** activos al mismo tiempo (solo posible en Facturas, nunca en Notas de Crédito), ambos módulos comparten el mismo evento `OnAfterCreateReceipt` de 51002. Se verificó que la interacción es correcta:

- El nodo `Complemento` se crea una sola vez — este módulo (CCE) lo crea, y el módulo de Leyendas lo detecta y reutiliza (no lo duplica).
- Al terminar este codeunit, `XMLCurrNode` queda posicionado en `Mercancias` (2 niveles debajo de `Complemento`), que es justo donde el módulo de Leyendas necesita estar para navegar de vuelta correctamente (`.ParentNode.ParentNode`).
- Esto depende de que el subscriber de **este módulo se ejecute antes** que el de Leyendas Fiscales — no es una garantía formal de la plataforma BC, pero está reforzada por una dependencia explícita en `7 Virtual Export\app.json` sobre este módulo.

**Pendiente opcional (no aplicado):** agregar un comentario de advertencia en `51005-CODE50140.al` documentando esta dependencia de orden de ejecución con el módulo `7 Virtual Export`, para que no se rompa sin darse cuenta si se reestructuran las extensiones en el futuro.

---

## Checklist de datos maestros — condición para que el nodo `ComercioExterior` se genere completo (2026-07-23)

El código del codeunit 51005 está listo (ver arriba). Lo que falta para producción es **confirmar datos/configuración**, no código:

| Requisito | Dónde se usa en 51005-CODE50140.al | Riesgo si falta |
|---|---|---|
| Tipo de cambio USD vigente (`Starting Date` ≤ fecha de contabilización) | líneas ~328-333 (`LrecExchangeRate.FINDLAST`) | **Riesgo más serio**: si no existe, `TipoCambioUSD`/`TotalUSD` no se escriben en absoluto, sin error — SAT los exige cuando `TipoOperacion='1'` |
| `Country/Region Code` en el Customer | línea ~444 (`LRecCountryCode.GET` sin chequeo) | Error en tiempo de ejecución **después** de contabilizar (el `OnAfterCreateReceipt` corre post-posteo) |
| `Tariff No.` (10 dígitos) en Item/G/L Account | validado en `OnBeforePostSalesDoc` (líneas ~695-703) | Bloquea el posteo con error claro (protegido) |
| `Customs UOM Code` en Unit of Measure | validado en `OnBeforePostSalesDoc` (línea ~729) | Bloquea el posteo con error claro (protegido) |
| `Shipment Method Code` (Incoterm, máx. 3 caracteres) | línea ~684-686 | Bloquea el posteo con error claro (protegido) |
| Setup **"Digital Electronic Acc. SetupE"** debe existir | línea ~658 (`GRecDigitalElectronic.Get()`) | Si no existe, **ninguna** de las validaciones de `OnBeforePostSalesDoc` corre — un documento con Tariff No./UOM faltante se postearía sin avisar |
| `CCE Estado/Localidad/Municipio` en Post Code (empresa y ship-to del cliente) | líneas ~390-395, ~413-436 | No truena, pero deja atributos vacíos — inválido ante XSD/PAC |
| `VAT Registration No.`, `No. Exterior/Interior` en Customer | nodo Receptor | Quedan vacíos si no están cargados (no error) |

**Acción en curso (2026-07-23):** se envió correo a **Brahim Barki** pidiendo que valide en sandbox contabilizando una factura con Comercio Internacional + Leyendas Fiscales activos simultáneamente, y que revise el XML resultante contra el checklist de arriba. **Pendiente su respuesta.**

---

## Leyendas Fiscales (módulo `7 Virtual Export`) — auditoría de código (2026-07-23)

Pieza propia: codeunit 51006 "VirtualExport Events Mgt" ([7-Virtual-Export/.vscode/AL/Codeunit/51006-CODE50140.al](../7-Virtual-Export/.vscode/AL/Codeunit/51006-CODE50140.al)). **Veredicto: funcionalmente completo, sin ramas a medio implementar.** No tiene `context.md` propio (no existe en el repo).

**Cómo funciona:** reutiliza la tabla genérica `Comment Line`, filtrando por `Table Name = Customer` + `Ident = "Elektronische Rechnung"` (definido en `7-Virtual-Export/.vscode/AL/ExtensionTable/51048-CommentLineExt.al`, un `Option` reciclado de otra industria — solo se usa ese último valor). Si hay al menos un comentario con ese filtro, se agrega el nodo `leyendasFisc:LeyendasFiscales` con:
- `disposicionFiscal='LA,RGCE'` — hardcodeado.
- `norma` — texto legal hardcodeado (Art. 105 y 112 Ley Aduanera + reglas 4.3.21, 5.2.4-II, 5.2.7 RGCE).
- `textoLeyenda` — concatenación de **todos** los comentarios que matcheen el filtro.

**Deuda técnica identificada (no bloqueante):**
- Filtro adicional por `Type::"Fiscal Remark"` fue comentado en 2021 y no revertido — riesgo latente si `Ident="Elektronische Rechnung"` se reutiliza para otra cosa (sin evidencia de que pase hoy).
- `disposicionFiscal`/`norma` fijos por código, no configurables.
- Solo soporta **una** leyenda por cliente (todo se concatena en un solo texto).
- Sin validación de longitud del texto `norma` contra el XSD real (mismo pendiente que CCE).
- Leyendas Fiscales **sí aplican a Notas de Crédito** (a diferencia de CCE, que las excluye explícitamente) — parece intencional (la leyenda es del cliente, no de la operación de exportación).
- Interacción con módulo CCE (nodo `Complemento` compartido) confirmada correcta — ver sección de arriba.

---

## Pedimento — confirmado que el sistema NO lo maneja, y es correcto que no lo haga (2026-07-23)

Búsqueda exhaustiva en todo el repo (`grep -i Pedimento` en módulos 2-8):

- El sistema **solo maneja `ClaveDePedimento` catalogada** (`'A1'` hardcodeado), consistente entre módulo 6 (`51005-CODE50140.al:307`) y módulo `8-Transfer-CFDI` (`51007-CFDI Transfer.al:858`). No existe tabla ni catálogo de pedimentos individuales en ningún módulo.
- Existe código legado para `NumeroPedimento`/nodo `InformacionAduanera` en el motor central (`4-ALCoreBaseEInvoicing/.vscode/AL/Codeunit/51002-EInvoiceMgtKT.al`, líneas ~3234-3258), pero:
  - Comentado desde 2020 (`"KTS FE Commented Out Not Pediment 2020"`).
  - Aplica bajo `IF NOT IsInternationalCommerce` — es decir, es para mercancía **importada** en CFDI normal, no para el CCE de exportación.
  - **No compilaría si se reactivara**: usa una variable `PedimentReservation` no declarada, y depende de un campo `"Pediment No."` en `Reservation Entry` que no existe como table extension en ningún módulo.
- No hay módulo de aduanas/importación en el repo — módulos 6 y 7 son exclusivamente de exportación.

**Conclusión:** dado que la empresa solo opera exportación definitiva (decisión de negocio ya confirmada arriba), la ausencia de manejo de pedimento real **no es un gap que les afecte hoy**. Solo sería relevante si en el futuro empiezan a facturar mercancía importada — escenario distinto y no contemplado actualmente.

---

## Para continuar mañana

1. **Esperar respuesta de Brahim Barki** sobre la prueba en sandbox (factura con Comercio Exterior + Leyendas Fiscales) — ver checklist de datos maestros arriba.
2. Si el XML sale incompleto, lo primero a revisar es el **tipo de cambio USD** (el gap silencioso más probable) y el registro **"Digital Electronic Acc. SetupE"**.
3. Validar contra XSD/PAC de pruebas antes de producción (pendiente original, sigue vigente).

---

## Prueba en sandbox (2026-07-27) — resultados y corrección adicional

Brahim probó en sandbox (documento FVR26-1006). Hallazgos, en orden:

1. **Error inicial "Unable to connect to the remote server"** al hacer Request Stamp — era el PAC de pruebas (Finkok) sin activar en sandbox. Confirmado como configuración, no código. Resuelto por el cliente.
2. **`Sello`, `Certificado`, `NoCertificado` vacíos/ausentes en el XML de salida (`salida.xml`)** — investigado a fondo, **es correcto y por diseño**: el código (`4-ALCoreBaseEInvoicing/.vscode/AL/Codeunit/51002-EInvoiceMgtKT.al`, líneas ~6322-6330) usa explícitamente el método SOAP **`sign_stamp`** de Finkok (no `stamp`), que recibe el CFDI **sin firmar** y Finkok lo firma (con el CSD que tiene almacenado) y timbra en una sola llamada. El XML completo con estos atributos llenos queda en `GRecDigitalElectrAccSetup."Path for E-Invoice" + '\temp\responseStamp.xml'` (línea 6375) — **ese** es el archivo a validar, no `salida.xml`. Sin cambios de código, solo aclaración.
3. **Error real del PAC al timbrar — CodigoError 301 "XML mal formado":**
   > `Element '{http://www.sat.gob.mx/ComercioExterior20}ComercioExterior', attribute 'TipoOperacion': The attribute 'TipoOperacion' is not allowed.`

   Confirmado por Brahim contra Anexo 20/22 vigente: el SAT **ya no permite** los atributos `TipoOperacion` ni `Subdivision` en `cce20:ComercioExterior` (versión de complemento vigente). Esto reemplaza lo que se creía "el fix" del 2026-07-15 — no bastaba con corregir el *valor* de `TipoOperacion` a `'1'`, el atributo **ya no debe existir en absoluto**.

### Corrección aplicada (2026-07-27) — [AL/Codeunit/51005-CODE50140.al](.vscode/AL/Codeunit/51005-CODE50140.al)

- Línea ~304: se removió `AddAttribute(XMLDoc, XMLCurrNode, 'TipoOperacion', lTipoOperacion)`. La variable `lTipoOperacion` **se conserva** — sigue determinando internamente si se agregan `ClaveDePedimento`/`CertificadoOrigen`/`Incoterm`/`TipoCambioUSD`/`TotalUSD` (bloque `IF (lTipoOperacion = '1') OR (lTipoOperacion = '2') THEN`).
- Línea ~323: se removió `AddAttribute(XMLDoc, XMLCurrNode, 'Subdivision', '0')`.
- Ambos quedaron como comentarios explicativos en el código, no eliminados silenciosamente.

**Pendiente de validar:** repetir el Request Stamp en sandbox con este cambio y confirmar que el error 301 ya no aparece, y que el resto del nodo `ComercioExterior` (`ClaveDePedimento`, `CertificadoOrigen`, `Incoterm`, `TipoCambioUSD`, `TotalUSD`, `Emisor`, `Receptor`, `Mercancias`) se timbra correctamente sin ellos.

**Confirmado por Brahim (2026-07-27):** timbrado exitoso tras remover `TipoOperacion`/`Subdivision`. Cierre de este punto.

---

## Campo `"CFDI Exportacion"` capturable en Cliente — reemplaza la inferencia automática (2026-07-28)

**Motivación de negocio (discutida con el usuario, no solo técnica):** el atributo `Exportacion` del CFDI 4.0 (catálogo SAT `c_Exportacion`: `01` No aplica, `02` Definitiva, `03` Temporal, `04` Definitiva con clave de pedimento distinta a la del complemento de Comercio Exterior) se calculaba en el motor central (módulo 4) con una cascada hardcodeada basada en flags técnicos (Comercio Exterior → `02`, Leyendas Fiscales → `03`). Per Anexo 20/22 y la Miscelánea Fiscal, el código correcto depende de la **naturaleza de la operación**, no de una inferencia técnica — por eso se decidió (recomendación propia, aceptada por el usuario) agregar un campo capturable en la ficha del cliente, heredado a la factura, **siempre editable**, en vez de automatizar por completo la selección del código.

**Implementación:** campo `"CFDI Exportacion"` (Code[2], Field ID `51202` en las 4 tablas para aprovechar `TRANSFERFIELDS`) agregado en:
- Customer, Sales Header, Document Header — en el módulo 4 (`4-ALCoreBaseEInvoicing/context.md` tiene el detalle técnico completo de esta parte: herencia Customer→Sales Header, override sobre la cascada existente, y el ajuste de versión 1.0.5.28 entre módulos).
- Sales Invoice Header — en este módulo (`51043-SalesInvoiceHeaderExt.al`), mismo ID, para no tocar el módulo 2 (Core Base Library) compartido por todo el sistema.

**Caso Exportación `04`:** por diseño, este código omite el nodo `cce20:ComercioExterior` por completo (no aplica clave de pedimento en el complemento), pero **sí puede coexistir con Leyendas Fiscales** (módulo 7, independiente) — confirmado contra el criterio del usuario, sujeto a lo que finalmente indique el Anexo 22 si se ajusta. Implementado en `51005-CODE50140.al`:
- `OnBeforeInitXML`: no declara namespace `cce20` ni marca `IsInternationalCommerce` cuando Exportación=`04`.
- `OnAfterCreateReceipt`: no construye el nodo cuando Exportación=`04`, aunque `"International Commerce"` sea `true`.

**Editable en:** ficha de Cliente (módulo 4), Sales Order/Invoice sin contabilizar, y Posted Sales Invoice (solo si no se ha timbrado) — mismo patrón ya usado para `International Commerce`/`CCE Tipo Operacion`.

**Pendiente de validar en sandbox:**
1. Capturar el código en un cliente, confirmar que se hereda a una factura nueva.
2. Dejar el campo vacío en otro caso y confirmar que la cascada automática sigue funcionando igual que antes (compatibilidad hacia atrás).
3. Probar el caso `04`: confirmar que el nodo `ComercioExterior` no aparece en el XML, y que Leyendas Fiscales sí aparece si el cliente las tiene configuradas.
4. Nota conocida, no corregida: el bloque de `Exportacion` para CFDI de pagos/REP en el módulo 4 sigue fijo en `'01'` sin aplicar esta lógica — pendiente de decidir si aplica corregirlo.
