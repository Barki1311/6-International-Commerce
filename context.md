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
