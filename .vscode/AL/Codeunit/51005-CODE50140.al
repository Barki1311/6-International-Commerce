codeunit 51005 "International Comm Events Mgt"
{
    Permissions = tabledata 112 = rim, tabledata 36 = rim;


    trigger OnRun()
    begin

    end;

    //2021-11-25>>
    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnAfterCopySalesDocument', '', false, false)]
    local procedure OnAfterCopySalesDocument(FromDocumentType: Option; FromDocumentNo: Code[20]; var ToSalesHeader: Record "Sales Header"; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer; IncludeHeader: Boolean; RecalculateLines: Boolean; MoveNegLines: Boolean)
    begin
        If (ToSalesHeader."Document Type" <> ToSalesHeader."Document Type"::Order) AND (ToSalesHeader."Document Type" <> ToSalesHeader."Document Type"::Invoice) then begin
            ToSalesHeader."International Commerce" := false;
            ToSalesHeader."CCE Tipo Operacion" := '';
            ToSalesHeader.Modify();
        end;
    end;
    //2021-11-25<<

    [EventSubscriber(ObjectType::Page, 132, 'OnBeforePrintPDFInvoice', '', false, false)]
    local procedure OnBeforePrintPDFInvoice(var ReportPDF: Report 51000; var DocumentNo: Code[50])
    var
        lrecCommentLine: Record "Comment Line";
        txtLeyenda: Text;
        LSalesLine: Record 113;
        LTransform: Boolean;
        LUnitOfMeasure: Record "Unit of Measure";
        SalesInvoice: Record 112;
    begin
        SalesInvoice.Get(DocumentNo);
        if SalesInvoice."International Commerce" then begin
            LSalesLine.Reset();
            LSalesLine.SetRange("Document No.", SalesInvoice."No.");
            if LSalesLine.FindSet() then
                repeat
                    if LSalesLine.Type = LSalesLine.Type::Item then begin
                        if LSalesLine."Unit of Measure Code" <> '' then
                            if LUnitOfMeasure.Get(LSalesLine."Unit of Measure Code") then
                                if LUnitOfMeasure."Customs UOM Code" = '03' then
                                    LTransform := true;
                    end;
                until LSalesLine.Next() = 0;
            if LTransform then
                ReportPDF.setInvoice(SalesInvoice);
        end;
    end;
    /* Descomentar
        [EventSubscriber(ObjectType::Page, 143, 'OnBeforePrintPDFInvoice', '', false, false)]
        local procedure OnBeforePrintPDFInvoices(var ReportPDF: Report 51000; var DocumentNo : Code[50])
        var
            lrecCommentLine: Record "Comment Line";
            txtLeyenda: Text;
            LSalesLine: Record 113;
            LTransform: Boolean;
            LUnitOfMeasure: Record "Unit of Measure";
            SalesInvoice: Record "Sales Invoice Header";
        begin
            if SalesInvoice."International Commerce" then begin
                LSalesLine.Reset();
                LSalesLine.SetRange("Document No.", SalesInvoice."No.");
                if LSalesLine.FindSet() then
                    repeat
                        if LSalesLine.Type = LSalesLine.Type::Item then begin
                            if LSalesLine."Unit of Measure Code" <> '' then
                                if LUnitOfMeasure.Get(LSalesLine."Unit of Measure Code") then
                                    if LUnitOfMeasure."Customs UOM Code" = '03' then
                                        LTransform := true;
                        end;
                    until LSalesLine.Next() = 0;
                if LTransform then
                    ReportPDF.setInvoice(SalesInvoice);
            end;

        end;
    */
    [EventSubscriber(ObjectType::Page, 25, 'OnBeforePrintPDFInvoice', '', false, false)]
    local procedure OnBeforePrintPDFInvoiceCustLE(var ReportPDF: Report 51000;

    var
        SalesInvoice: Record 112)
    var
        lrecCommentLine: Record "Comment Line";
        txtLeyenda: Text;
        LSalesLine: Record 113;
        LTransform: Boolean;
        LUnitOfMeasure: Record "Unit of Measure";

    begin
        if SalesInvoice."International Commerce" then begin
            LSalesLine.Reset();
            LSalesLine.SetRange("Document No.", SalesInvoice."No.");
            if LSalesLine.FindSet() then
                repeat
                    if LSalesLine.Type = LSalesLine.Type::Item then begin
                        if LSalesLine."Unit of Measure Code" <> '' then
                            if LUnitOfMeasure.Get(LSalesLine."Unit of Measure Code") then
                                if LUnitOfMeasure."Customs UOM Code" = '03' then
                                    LTransform := true;
                    end;
                until LSalesLine.Next() = 0;
            if LTransform then
                ReportPDF.setInvoice(SalesInvoice);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 51002, 'OnBeforePrintPDFInvoice', '', false, false)]
    local procedure OnBeforePrintPDFInvoice1(var ReportPDF: Report 51000; var SaleHeader: Record 112)
    var
        lrecCommentLine: Record "Comment Line";
        txtLeyenda: Text;
        LSalesLine: Record 113;
        LTransform: Boolean;
        LUnitOfMeasure: Record "Unit of Measure";
        SalesInvoice: Record 112;
    begin

        if SaleHeader."International Commerce" then begin
            LSalesLine.Reset();
            LSalesLine.SetRange("Document No.", SaleHeader."No.");
            if LSalesLine.FindSet() then
                repeat
                    if LSalesLine.Type = LSalesLine.Type::Item then begin
                        if LSalesLine."Unit of Measure Code" <> '' then
                            if LUnitOfMeasure.Get(LSalesLine."Unit of Measure Code") then
                                if LUnitOfMeasure."Customs UOM Code" = '03' then
                                    LTransform := true;
                    end;
                until LSalesLine.Next() = 0;
            if LTransform then
                ReportPDF.setInvoice(SaleHeader);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 51002, 'OnTransferSalesInvoiceLineToTempLine', '', false, false)]
    local procedure OnTransferSalesInvoiceLineToTempLine(var TempDocumentLine: Record "Document Line" temporary; SalesInvoiceLine: Record "Sales Invoice Line")
    begin
        TempDocumentLine."Net Weight" := SalesInvoiceLine."Net Weight"; // 2021-04-06 no tienen mismos id, asi que no se pasan
    end;

    [EventSubscriber(ObjectType::Codeunit, 51002, 'OnTransferSalesCrMemoLineToTempLine', '', false, false)]
    local procedure OnTransferSalesCrMemoLineToTempLine(var TempDocumentLine: Record "Document Line" temporary; SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        TempDocumentLine."Net Weight" := SalesCrMemoLine."Net Weight"; // 2021-04-06 no tienen mismos id, asi que no se pasan
    end;

    [EventSubscriber(ObjectType::Codeunit, 51002, 'OnBeforeInitXML', '', false, false)]
    //local procedure OnBeforeInitXML(DocumentNo: code[50]; var XsiCCE: Text; var XsiVehiculoUsado: Text; var XmlnsVehiculoUsado: Text; var LegendaExist: Boolean; var GschemaLeyendas: Text; var IsInternationalCommerce: Boolean; IsCredit: Boolean);
    local procedure OnBeforeInitXML(TempDocumentHeader: record 10002; var XsiCCE: Text; var XsiVehiculoUsado: Text; var XmlnsVehiculoUsado: Text; var LegendaExist: Boolean; var GschemaLeyendas: Text; var IsInternationalCommerce: Boolean; IsCredit: Boolean);
    var
        C10145: codeunit 10145;
    begin
        IF not IsCredit then
            // 2026-07-28: Exportacion='04' omite el complemento de Comercio Exterior (Anexo 20/22) -
            // no se declara el namespace cce20 ni se marca IsInternationalCommerce para este documento.
            IF TempDocumentHeader."International Commerce" AND (TempDocumentHeader."CFDI Exportacion" <> '04') THEN BEGIN
                XsiCCE := ' http://www.sat.gob.mx/ComercioExterior20 http://www.sat.gob.mx/sitio_internet/cfd/ComercioExterior20/ComercioExterior20.xsd';
                IsInternationalCommerce := true;
            END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 51002, 'OnBeforeRepeatLine', '', false, false)]
    local procedure OnBeforeRepeatLine(ItemNo: Code[50]; TempDocLine: Record 10003; TempDocHeader: Record 10002; IsCredit: Boolean)
    var
        ItemLoc: Record "Item";
        QtyCalc: Decimal;
        NEWQtyUOM: Decimal;
        NewQty: Decimal;
        NewUOM: Text[30];
        Conv: Boolean;
        Currency: Record Currency;
        UOMMgt: Codeunit "Unit of Measure Management";
        Tariff: Record 260;
        lUnitOfMeasure: Record 204;

    begin
        if not IsCredit THEN begin

            // 2021-06-09 >>
            // if Confirm('1 GetNewValuesBeforeRepeatLine - DocNo: ' + TempSalesLine."Document No.") then;
            // 2021-06-09 <<
            IF TempDocHeader."International Commerce" THEN BEGIN

                IF (TempDocLine.Type = TempDocLine.Type::Item) THEN BEGIN
                    //"Unit of Measure Code" := 'QM';
                    ItemLoc.GET(TempDocLine."No.");
                    ItemLoc.TestField("Tariff No.");
                    Tariff.RESET;
                    Tariff.SETRANGE("No.", ItemLoc."Tariff No.");
                    Tariff.FINDFIRST;
                    // if Confirm('2 GetNewValuesBeforeRepeatLine - Tariff.UMT: ' + Tariff.UMT) then;
                    // 2021-06-25 >>
                    lUnitOfMeasure.RESET;
                    lUnitOfMeasure.SETRANGE("Code", TempDocLine."Unit of Measure Code");
                    lUnitOfMeasure.FINDFIRST;
                    // if Tariff.UMT = '03' then begin
                    if (lUnitOfMeasure."Customs UOM Code" = '03') THEN
                        // 2021-06-25 <<

                        // 2021-06-09 >>
                        // if Confirm('3 GetNewValuesBeforeRepeatLine antes - TempDocLine."Unit Price/Direct Unit Cost": ' + format(TempDocLine."Unit Price/Direct Unit Cost")) then;
                        // if Confirm('4 GetNewValuesBeforeRepeatLine antes - TempDocLine.Quantity: ' + format(TempDocLine.Quantity)) then;
                        // 2021-06-09 <<
                        TempDocLine."Unit of Measure Code" := 'QM';
                    IF TempDocHeader."Currency Code" = '' THEN
                        Currency.InitRoundingPrecision
                    ELSE BEGIN
                        TempDocHeader.TESTFIELD("Currency Factor");
                        Currency.GET(TempDocHeader."Currency Code");
                        Currency.TESTFIELD("Amount Rounding Precision");
                    END;
                    NEWQtyUOM := UOMMgt.GetQtyPerUnitOfMeasure(ItemLoc, TempDocLine."Unit of Measure Code");
                    // if Confirm('5 GetNewValuesBeforeRepeatLine Cantidad x UoM - NEWQtyUOM: ' + format(NEWQtyUOM)) then; 

                    TempDocLine."Unit Price/Direct Unit Cost" := ROUND(TempDocLine."Unit Price/Direct Unit Cost" * NEWQtyUOM, Currency."Amount Rounding Precision");
                    TempDocLine.Quantity := ROUND(TempDocLine.Amount / TempDocLine."Unit Price/Direct Unit Cost", Currency."Amount Rounding Precision");

                end;
            END;
        end;
    END;


    [EventSubscriber(ObjectType::Codeunit, 51002, 'OnAfterCreateReceipt', '', false, false)]

    procedure OnAfterCreateReceipt(var TempDocumentHeader: record 10002; GCustomerNo: Record 18; var XMLDoc: DotNet XmlDocument; var XMLCurrNode: DotNet XmlNode; IsCredit: Boolean; GIsTransfer: Boolean; LegendaExist: Boolean; XMLNewChild: DotNet XmlNode; LBoolExento: Boolean)


    // procedure OnAfterCreateReceipt( var TempDocumentHeader: Record 10002 temporary; var Customer: Record 18; var XMLDoc: DotNet XmlDocument; var XMLCurrNode: DotNet XmlNode; IsCredit: Boolean; GIsTransfer: Boolean; LegendaExist: Boolean; XMLNewChild: DotNet XmlNode; var TempDocumentLine: Record 10003; LBoolExento: Boolean);
    var
        LrecCompany: Record 79;
        LrecSalInv2: Record 112;
        CCEDocNameSpace: Text;
        LElectronicInvoicing: Codeunit 51002;
        DocNameSpace: Text;
        lTipoOperacion: code[1];
        TipoCambioUSD: Decimal;
        DecTtotalUSD: Decimal;
        LrecItem: Record 27;
        lCountry: Record "Country/Region";
        UnitPrice: Decimal;
        TariffCode: code[20];
        RecTariff: Record 260;
        LRecUnitOfMeasure: Record "Unit of Measure";
        LrecPostCode: Record "Post Code";
        LrecExchangeRate: Record "Currency Exchange Rate";
        LRecCountryCode: Record "Country/Region";
        LXmlCurrNodeConcepts: DotNet XmlNode;
        LXmlCurrNodeTotalUSD: DotNet XmlNode;
        TempSalesInvoiceLine: Record 113;
        lHttpUtility: DotNet HttpUtility;
        LRecGLAccount: Record 15;
        LDecValorDolares: Decimal;
        LDecNewUSDValue: Decimal;
        LSumUSDValue: Decimal;
        ExchangeRate: Record "Currency Exchange Rate";
        CU80: Codeunit 80;
        LRecCustomer: Record Customer;
    begin
        if IsCredit then
            EXIT;

        IF not IsCredit THEN
            LrecSalInv2.RESET;
        LrecSalInv2.GET(TempDocumentHeader."No.");
        // 2026-07-28: Exportacion='04' omite la construcción del nodo cce20:ComercioExterior (Anexo 20/22) -
        // Leyendas Fiscales (módulo 7) es independiente y sigue funcionando normal.
        IF LrecSalInv2."International Commerce" AND (TempDocumentHeader."CFDI Exportacion" <> '04') THEN BEGIN
            LRecCustomer.Reset;
            LRecCustomer.Get(GCustomerNo."No.");
            if LRecCustomer."CFDI 4.0" THEN
                DocNameSpace := 'http://www.sat.gob.mx/cfd/4'
            else
                DocNameSpace := 'http://www.sat.gob.mx/cfd/3';
            CCEDocNameSpace := 'http://www.sat.gob.mx/ComercioExterior20';
            LrecCompany.RESET;
            LrecCompany.GET;

            XMLCurrNode := XMLCurrNode.ParentNode;
            IF NOT LBoolExento THEN BEGIN
                XMLCurrNode := XMLCurrNode.ParentNode;
            END;
            //Message('Leyenda ' + FORMAT(LegendaExist));

            //IF NOT LegendaExist THEN BEGIN
            /*
            IF LegendaExist THEN BEGIN
                LElectronicInvoicing.AddElementCFDI(XMLCurrNode, 'Complemento', '', DocNameSpace, XMLNewChild);
                XMLCurrNode := XMLNewChild;
            END;
            */
            //// IF Confirm('complemento CCE') THEN;
            LElectronicInvoicing.AddElementCFDI(XMLCurrNode, 'Complemento', '', DocNameSpace, XMLNewChild);
            XMLCurrNode := XMLNewChild;

            //// IF Confirm('Comercio Exterior') THEN;
            LElectronicInvoicing.AddElementCCE(XMLCurrNode, 'ComercioExterior', '', CCEDocNameSpace, XMLNewChild);
            // // IF Confirm('Comercio Exterior') THEN
            XMLCurrNode := XMLNewChild;
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Version', '2.0');
            IF LrecSalInv2."CCE Tipo Operacion" <> '' THEN
                lTipoOperacion := LrecSalInv2."CCE Tipo Operacion"
            ELSE BEGIN
                lTipoOperacion := '1'; // Exportación definitiva - único tipo de operación que maneja la empresa
            END;
            // TipoOperacion removido del XML: SAT ya no permite este atributo en cce20:ComercioExterior (error PAC 301 "XML mal formado" confirmado 2026-07-27). lTipoOperacion se conserva solo para la lógica interna de abajo.
            // 1: Exportación definitiva - [ ClaveDePedimento, CertificadoOrigen, Incoterm, TipoCambioUSD, TotalUSD]
            IF (lTipoOperacion = '1') OR (lTipoOperacion = '2') THEN BEGIN
                LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'ClaveDePedimento', 'A1'); // 1 o 2
                IF LrecSalInv2."UUID de Certificado de Origen" <> '' THEN BEGIN
                    LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CertificadoOrigen', '1');
                    LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumCertificadoOrigen', LrecSalInv2."UUID de Certificado de Origen");
                END ELSE
                    LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CertificadoOrigen', '0');
                IF NOT GIsTransfer THEN BEGIN
                    IF LrecSalInv2."Shipment Method Code" <> '' THEN BEGIN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Incoterm', COPYSTR(LrecSalInv2."Shipment Method Code", 1, 3)) // 1 o 2
                    END ELSE BEGIN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Incoterm', 'FOB');
                    END;
                END ELSE BEGIN
                    // LElectronicInvoicing.AddAttribute(XMLDoc,XMLCurrNode,'Incoterm',COPYSTR(TempDocumentHeader."Shipment Method Code",1,3)) // 1 o 2
                    LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Incoterm', LrecSalInv2."Shipment Method Code"); //Hardcode transfer
                END;
                // Subdivision removido del XML: SAT ya no permite este atributo en cce20:ComercioExterior (Anexo 20/22, confirmado 2026-07-27).
                // 2021-06-07 >>
                LrecSalInv2.CalcFields("Amount Including VAT");
                // 2021-06-07 <<
                // USD CCE >>
                LrecExchangeRate.RESET;
                LrecExchangeRate.SETRANGE("Currency Code", 'USD');
                // 2021-06-30 >>
                LrecExchangeRate.SETFILTER("Starting Date", '..%1', LrecSalInv2."Posting Date");
                // 2021-06-30 <<
                IF LrecExchangeRate.FINDLAST THEN BEGIN
                    // IF (LrecExchangeRate."Currency Code" <> 'USD') THEN BEGIN
                    if LrecSalInv2."Currency Code" <> 'USD' THEN BEGIN
                        // 2021-06-30 >>
                        /*
                        DecTtotalUSD := ((1 / LrecSalInv2."Currency Factor") * LrecSalInv2."Amount Including VAT") /-
                        LrecExchangeRate."Relational Exch. Rate Amount";
                        */
                        // DecTtotalUSD := ROUND(((1 / LrecSalInv2."Currency Factor") * LrecSalInv2."Amount Including VAT")
                        // // 2021-06-30 >>
                        // // / LrecExchangeRate."Relational Exch. Rate Amount", 0.01, '=');
                        // / ExchangeRate.ExchangeAmtFCYToFCY(LrecSalInv2."Posting Date", 'USD', 'MXN', 1.0));
                        // // 2021-06-30 <<
                        // // 2021-06-30
                        // // 2021-06-30 >>
                        // LrecSalInv2.CalcFields("Amount Including VAT");


                        // // TipoCambioUSD := LrecExchangeRate."Relational Exch. Rate Amount";
                        // /// TipoCambioUSD := ExchangeRate.ExchangeAmtFCYToFCY(LrecSalInv2."Posting Date", 'USD', 'MXN', 1.0);
                        // TipoCambioUSD := (1 / LrecSalInv2."Currency Factor") * LrecSalInv2."Amount Including VAT" / DecTtotalUSD;
                        // // 2021-06-30 <<
                        // LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'TipoCambioUSD', FORMAT(TipoCambioUSD, 0, '<Precision,6><Standard Format,2>')); // 1 o 2
                        // // 2021-06-14 >> Correccion Centavo CCE >>
                        // LXmlCurrNodeTotalUSD := XMLCurrNode;
                        // // 2021-06-14 <<
                        // LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'TotalUSD', FORMAT(DecTtotalUSD, 0, '<Precision,2><Standard Format,2>')); // 1 o 2
                        LXmlCurrNodeTotalUSD := XMLCurrNode;
                        LrecSalInv2.CalcFields("Amount Including VAT");
                        DecTtotalUSD := ((1 / LrecSalInv2."Currency Factor") * LrecSalInv2."Amount Including VAT") /
                        LrecExchangeRate."Relational Exch. Rate Amount";
                        // Message('TotalUSD Primero: %1', DecTtotalUSD);
                        TipoCambioUSD := LrecExchangeRate."Relational Exch. Rate Amount";
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'TipoCambioUSD', FormatDEtoMX(FORMAT(TipoCambioUSD, 0, '<Precision,6><Standard Format,2>')));
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'TotalUSD', FormatDEtoMX(FORMAT(DecTtotalUSD, 0, '<Precision,2><Standard Format,2>')));
                    END ELSE BEGIN
                        DecTtotalUSD := LrecSalInv2."Amount Including VAT";
                        // 2021-06-14 >> Correccion Centavo CCE >>
                        LXmlCurrNodeTotalUSD := XMLCurrNode;
                        // 2021-06-14 <<
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'TipoCambioUSD', FormatDEtoMX(FORMAT(1 / LrecSalInv2."Currency Factor", 0, '<Precision,6><Standard Format,2>'))); // 1 o 2
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'TotalUSD', FormatDEtoMX(FORMAT(LrecSalInv2."Amount Including VAT", 0, '<Precision,2><Standard Format,2>'))); // 1 o 2
                    END;
                END;
                // USD CCE <<
            END;

            //// IF Confirm('Emisor') THEN
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>EMISOR
            LElectronicInvoicing.AddElementCCE(XMLCurrNode, 'Emisor', '', CCEDocNameSpace, XMLNewChild);
            XMLCurrNode := XMLNewChild;
            LElectronicInvoicing.AddElementCCE(XMLCurrNode, 'Domicilio', '', CCEDocNameSpace, XMLNewChild);
            XMLCurrNode := XMLNewChild;
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Calle', LrecCompany.Address);
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroExterior', LrecCompany."No. Exterior");
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroInterior', LrecCompany."No. Interior");
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Colonia', LrecCompany."CCE Colonia");
            LrecPostCode.RESET;
            LrecPostCode.SETRANGE(Code, LrecCompany."Post Code");
            IF LrecPostCode.FINDSET THEN;
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Estado', LrecPostCode."CCE Estado");
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Localidad', LrecPostCode."CCE Localidad");
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Municipio', LrecPostCode."CCE Municipio");
            IF lCountry.GET(LrecCompany."Country/Region Code") THEN
                LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Pais', lCountry."SAT Country")
            ELSE
                LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Pais', 'MEX');
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CodigoPostal', LrecCompany."Post Code");
            // Message(TempDocumentHeader."No.");
            XMLCurrNode := XMLCurrNode.ParentNode;
            XMLCurrNode := XMLCurrNode.ParentNode;
            //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<EMISOR

            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>RECEPTOR
            LElectronicInvoicing.AddElementCCE(XMLCurrNode, 'Receptor', '', CCEDocNameSpace, XMLNewChild);
            XMLCurrNode := XMLNewChild;
            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumRegIdTrib', LRecCustomer."VAT Registration No.");
            LElectronicInvoicing.AddElementCCE(XMLCurrNode, 'Domicilio', '', CCEDocNameSpace, XMLNewChild);
            XMLCurrNode := XMLNewChild;
            IF NOT GIsTransfer THEN BEGIN
                LrecPostCode.RESET;
                LrecPostCode.SETRANGE(Code, LrecSalInv2."Ship-to Post Code"); //sadfully
                IF LrecPostCode.FINDSET THEN BEGIN
                    IF LrecSalInv2."Ship-to Address" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Calle', LrecSalInv2."Ship-to Address")
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Calle', '');
                    IF LRecCustomer."No. Exterior" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroExterior', LRecCustomer."No. Exterior")
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroExterior', '');
                    IF LRecCustomer."No. Interior" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroInterior', LRecCustomer."No. Interior")
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroInterior', '');
                    IF LrecSalInv2."Ship-to Address" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Colonia', LrecSalInv2."Ship-to Address 2")   // ship to address 2
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Colonia', '');   // ship to address 2
                    IF LrecPostCode."CCE Estado" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Estado', LrecPostCode."CCE Estado")
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Estado', '');
                    LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Localidad', LrecPostCode."CCE Localidad");
                    IF LrecSalInv2."Ship-to Post Code" <> '' THEN
                        // EE Commented out 2021-15-04 >>++
                        //LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CodigoPostal', DELCHR(LrecSalInv2."Ship-to Post Code", '=', ' /+.-'))
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CodigoPostal', LrecSalInv2."Ship-to Post Code")
                    // EE Commented out 2021-15-04 <<--
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CodigoPostal', '');
                    LRecCountryCode.GET(LRecCustomer."Country/Region Code");
                    LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Pais', LRecCountryCode."SAT Country");
                END;
            END ELSE BEGIN
                //Si es transferencia
                LrecPostCode.RESET;
                LrecPostCode.SETRANGE(Code, LrecSalInv2."Ship-to Address"); //Hardcode Transfer
                IF LrecPostCode.FINDSET THEN BEGIN

                    IF TempDocumentHeader."Transfer Address" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Calle', TempDocumentHeader."Transfer Address") //Hardcode Transfer
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Calle', '');
                    IF LRecCustomer."No. Exterior" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroExterior', TempDocumentHeader."No. Exterior") //Hardcode Transfer
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroExterior', '');
                    IF LRecCustomer."No. Interior" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroInterior', TempDocumentHeader."No. Interior") //Hardcode Transfer
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NumeroInterior', '');
                    IF LrecSalInv2."Ship-to Address" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Colonia', TempDocumentHeader."Transfer Colony")  //Hardcode Transfer
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Colonia', '');   // ship to address 2

                    IF LrecPostCode."CCE Estado" <> '' THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Estado', LrecPostCode."CCE Estado")
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Estado', '');
                    LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Localidad', LrecPostCode."CCE Localidad");
                    IF LrecSalInv2."Ship-to Post Code" <> '' THEN
                        // EE Commented out 2021-15-04 >>++
                        //LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CodigoPostal', DELCHR(LrecSalInv2."Ship-to Post Code", '=', ' /+.-'))
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CodigoPostal', LrecSalInv2."Ship-to Post Code")
                    // EE Commented out 2021-15-04 <<--
                    ELSE
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CodigoPostal', '');
                    IF LRecCountryCode.GET(LrecPostCode."Country/Region Code") THEN
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'Pais', LRecCountryCode."SAT Country");
                END;
            END;
            XMLCurrNode := XMLCurrNode.ParentNode;
            XMLCurrNode := XMLCurrNode.ParentNode;
            //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<EMISOR
            //// IF Confirm('Mercancias') THEN;
            // Message(TempDocumentHeader."No.");
            LElectronicInvoicing.AddElementCCE(XMLCurrNode, 'Mercancias', '', CCEDocNameSpace, XMLNewChild);
            XMLCurrNode := XMLNewChild;
            //-------------------------------------------------Mercancias---------------------
            TempSalesInvoiceLine.RESET;
            TempSalesInvoiceLine.SETRANGE("Document No.", LrecSalInv2."No.");
            //TempSalesInvoiceLine.SetFilter(Quantity, '>%1', 0);
            LXmlCurrNodeConcepts := XMLCurrNode;

            IF ((TempSalesInvoiceLine.FINDSET(false)) /* AND (TempSalesInvoiceLine.Quantity <> 0)*/) THEN
                REPEAT
                    // 2021-04-27 >>
                    // 2021-06-09 >> se descomenta ya que si se cambian los valores >>
                    GetNewValue(TempSalesInvoiceLine);
                    // 2021-06-09 << se descomenta ya que si se cambian los valores <<
                    // 2021-04-27 <<
                    if (TempSalesInvoiceLine.Quantity <> 0) then begin

                        // ------------------------Obtener informacion item
                        //LrecItem.RESET;
                        //IF LrecItem.GET(TempSalesInvoiceLine."No.") THEN;
                        LRecUnitOfMeasure.RESET;
                        IF LRecUnitOfMeasure.GET(TempSalesInvoiceLine."Unit of Measure Code") THEN;

                        IF TempSalesInvoiceLine.Type = TempSalesInvoiceLine.Type::Item THEN BEGIN
                            // ------------------------Obtener informacion item
                            LrecItem.RESET;
                            LrecItem.GET(TempSalesInvoiceLine."No.");
                        END;

                        IF TempSalesInvoiceLine.Type = TempSalesInvoiceLine.Type::"G/L Account" THEN BEGIN
                            // ------------------------Obtener informacion item
                            LRecGLAccount.RESET;
                            LRecGLAccount.GET(TempSalesInvoiceLine."No.");
                        END;

                        LRecUnitOfMeasure.RESET;
                        LRecUnitOfMeasure.GET(TempSalesInvoiceLine."Unit of Measure Code");

                        LElectronicInvoicing.AddElementCCE(XMLCurrNode, 'Mercancia', '', CCEDocNameSpace, XMLNewChild);
                        XMLCurrNode := XMLNewChild;
                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'NoIdentificacion', TempSalesInvoiceLine."No.");
                        // valor unidatio aduanas - valor unitario
                        IF LrecItem."Tariff No." <> '' THEN BEGIN

                            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'FraccionArancelaria', DELCHR(LrecItem."Tariff No.", '=', ' '));
                            TariffCode := LrecItem."Tariff No.";
                        END ELSE begin
                            IF LRecGLAccount."Tariff No." <> '' THEN BEGIN
                                LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'FraccionArancelaria', DELCHR(LRecGLAccount."Tariff No.", '=', ' '));
                                TariffCode := LRecGLAccount."Tariff No.";
                            END;
                        end;

                        /*
                        IF TempSalesInvoiceLine."Tariff No." <> '' THEN BEGIN
                            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'FraccionArancelaria', DELCHR(TempSalesInvoiceLine."Tariff No.", '=', ' '));
                            TariffCode := TempSalesInvoiceLine."Tariff No.";
                        END;
                        */

                        // UnitPrice := ((TempSalesInvoiceLine."Unit Price/Direct Unit Cost"*TempSalesInvoiceLine.Quantity)/TempSalesInvoiceLine."Net Weight") + (TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount);

                        // 2021-06-09 >> correccion Unit Price y Valor USD >>                        
                        // UnitPrice := (TempSalesInvoiceLine."Amount Including VAT" / TempSalesInvoiceLine."Net Weight"); // comentado 2021-06-09
                        LDecValorDolares := 0;
                        UnitPrice := 0;
                        IF (LrecSalInv2."Currency Code" = 'USD') THEN
                            LDecValorDolares := (TempSalesInvoiceLine."Unit Price" * TempSalesInvoiceLine.Quantity -
                                TempSalesInvoiceLine."Line Discount Amount")
                        ELSE begin
                            LrecSalInv2.TestField("Currency Factor");
                            LDecValorDolares :=
                                    (1 / LrecSalInv2."Currency Factor") * ((TempSalesInvoiceLine."Unit Price" * TempSalesInvoiceLine.Quantity)
                                    - TempSalesInvoiceLine."Line Discount Amount"
                                    ) / LrecExchangeRate."Relational Exch. Rate Amount";
                        end;



                        // 2021-06-30 >>
                        // LDecNewUSDValue := UnitPrice * TempSalesInvoiceLine.Quantity;
                        //Start utt007.bb
                        // 2021-11-30 >>
                        // LDecNewUSDValue := LDecNewUSDValue + ROUND(
                        LDecNewUSDValue := Round(
                            // 2021-11-30 <<
                            ((((TempSalesInvoiceLine."Unit Price" * TempSalesInvoiceLine.Quantity) - TempSalesInvoiceLine."Line Discount Amount") /
                                LrecSalInv2."Currency Factor")
                                / LrecExchangeRate."Relational Exch. Rate Amount")
                            , 0.01, '=');
                        //End utt007.bb
                        // UnitPrice := LDecValorDolares / TempSalesInvoiceLine.Quantity;
                        UnitPrice := LDecNewUSDValue / TempSalesInvoiceLine.Quantity;
                        // 2021-06-30 <<

                        // 2021-06-14 >>
                        LSumUSDValue += LDecNewUSDValue;
                        // 2021-06-14 <<
                        // 2021-06-09 <<

                        IF (LrecSalInv2."Currency Code" <> 'MXN') AND (LrecSalInv2."Currency Code" <> '') THEN BEGIN
                            // 2021-06-25 >>
                            // IF RecTariff.GET(TariffCode) THEN
                            //     LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'UnidadAduana', RecTariff.UMT);
                            if LRecUnitOfMeasure.Get(TempSalesInvoiceLine."Unit of Measure Code") then
                                LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'UnidadAduana', LRecUnitOfMeasure."Customs UOM Code");
                            // 2021-06-25 <<
                            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'ValorUnitarioAduana',
                              FormatDEtoMX(FORMAT(UnitPrice, 0, '<Precision,2><Standard Format,1>')));
                            // 2021-06-09 >>
                            // LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CantidadAduana', FORMAT(TempSalesInvoiceLine."Net Weight", 0,  // vuelto a comentar entre mediados de marzo 2018 ------ encontrar solucion cuando haya mas de 1 articulo para el mismo Noidentificacion
                            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'CantidadAduana', FormatDEtoMX(FORMAT(TempSalesInvoiceLine.Quantity, 0,  // vuelto a comentar entre mediados de marzo 2018 ------ encontrar solucion cuando haya mas de 1 articulo para el mismo Noidentificacion
                                                                                                                                                            // 2021-06-09 <<
                              '<Precision,3><Standard Format,1>')));
                        END;
                        // 2021-06-09 >> Corrección para Tomar ValorDolares Correctamente >>>>>>>}
                        /*
                        IF (TempDocumentHeader."Currency Code" <> 'MXN') AND (TempDocumentHeader."Currency Code" <> '') THEN
                            LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'ValorDolares',
                              FORMAT((TempSalesInvoiceLine."Net Weight" * UnitPrice), 0, '<Precision,2><Standard Format,2>'));
                        */

                        LElectronicInvoicing.AddAttribute(XMLDoc, XMLCurrNode, 'ValorDolares', FormatDEtoMX(FORMAT((LDecNewUSDValue), 0, '<Precision,2><Standard Format,2>')));
                        // 2021-06-09 << Corrección para Tomar ValorDolares Correctamente <<<<<<<
                        XMLCurrNode := XMLCurrNode.ParentNode;

                    end;
                UNTIL TempSalesInvoiceLine.NEXT = 0;
            // 2021-06-14 >>
            // if Confirm('trying to fix usd value') then;
            if LSumUSDValue <> DecTtotalUSD then begin

                //Start utt004.bb
                IF DecTtotalUSD - ABS(LSumUSDValue) > 1 THEN begin
                    if not Confirm('Differenz Rundung ist größer als 1') then
                        ERROR('Cancelled')
                    else
                        DecTtotalUSD := LSumUSDValue;
                end ELSE
                    DecTtotalUSD := LSumUSDValue;
                // Message('TotalUSD Despues: %1', DecTtotalUSD);
                // TipoCambioUSD := (1 / LrecSalInv2."Currency Factor") * LrecSalInv2."Amount Including VAT" / DecTtotalUSD;
                // LElectronicInvoicing.AddAttribute(XMLDoc, LXmlCurrNodeTotalUSD, 'TipoCambioUSD', FORMAT(TipoCambioUSD, 0, '<Precision,6><Standard Format,2>')); // 1 o 2
                //End utt004.bb
                LElectronicInvoicing.AddAttribute(XMLDoc, LXmlCurrNodeTotalUSD, 'TotalUSD', FormatDEtoMX(FORMAT((DecTtotalUSD), 0, '<Precision,2><Standard Format,2>')));
            end;

            // 2021-06-14 <<
        END;
    end;

    // Function Checklines from Codeunit 80
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(VAR SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; VAR HideProgressWindow: Boolean)
    var
        SalesLine: Record 37;
        GRecDigitalElectronic: Record "Digital Electronic Acc. SetupE";
        LRecUnitOfMeasure: Record "Unit of Measure";
        LItem: Record 27;
        LRecTariffNo: Record 260;
        LGLAccount: Record 15;
        UTT002: TextConst ENU = 'Electr.Invoice: The unit of measure code (Customs UOM code) in  Line %1   and the code in the tariff number must be the  same !', ESM = 'Electr.Invoice: The unit of measure code (Customs UOM code) in  Line %1   and the code in the tariff number must be the  same !', DEA = 'Electr.Invoice: Der Einiheitencode (Customs UOM code)  der Zeile %1 muss mit  dem Code der  Zolltariffnummer übereinstimmen !';

        UTT003: TextConst ENU = 'the shipment methode code ist not correct, please check it !!', ESM = 'El código de envío no es correcto, por favor revíselo !!', DEA = 'Lieferbedingungscode muss zum dem Standard Incoterms passen, und nicht gr”áer als 3 Stellen sein!', DEU = 'Lieferbedingungscode muss zum dem Standard Incoterms passen, und nicht gr”áer als 3 Stellen sein!';
        UTT004: TextConst DEU = 'Die Zollpositionnr. bei dem Artikel %1 muss 10 stellig sein', ENU = 'the length of the tariffNo. for the Item %1 musst be 10 ', ESM = 'La longitud de la fracción arancelaria del producto %1 debe ser 10 ', DEA = 'Die Zollpositionnr. bei dem Artikel %1 muss 10 stellig sein';
        UTT005: TextConst DEU = 'Die Zollpositionnr. bei dem Sachkonto %1 muss 10 stellig sein', ENU = 'the length of the tariffNo. for the G/L account %1 musst be 10 ', ESM = 'La longitud de la fracción Arancelaria para la Cuenta %1 debe ser 10 ', DEA = 'Die Zollpositionnr. bei dem Sachkonto %1 muss 10 stellig sein';
    begin
        if GRecDigitalElectronic.Get() then begin
            if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) then begin
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                SalesLine.SETFILTER(Quantity, '<>%1', 0);

                IF SalesLine.FIND('-') THEN
                    REPEAT
                        // 2021-06-30
                        /*
                        // IF SalesLine."Unit of Measure" = '' THEN

                            // SalesLine.TESTFIELD("Unit of Measure Code");
                            //ERROR(UTT001,SalesLine."Line No.");
                            //Start utt02.bb
                            LRecUnitOfMeasure.GET(SalesLine."Unit of Measure Code");
                        */

                        SalesLine.TestField("Unit of Measure Code");
                        LRecUnitOfMeasure.GET(SalesLine."Unit of Measure Code");
                        // 2021-06-30 <<
                        IF SalesHeader."International Commerce" THEN BEGIN

                            // 2021-10-20 >>      
                            //Start utt009.bb
                            SalesHeader.TESTFIELD("Shipment Method Code");
                            IF STRLEN(SalesHeader."Shipment Method Code") > 3 THEN
                                ERROR(UTT003, SalesHeader."Shipment Method Code");
                            //End utt009.bb
                            // 2021-10-20 <<

                            CASE SalesLine.Type OF
                                SalesLine.Type::Item:
                                    BEGIN
                                        LItem.GET(SalesLine."No.");

                                        LItem.TESTFIELD("Tariff No.");
                                        LRecTariffNo.GET(LItem."Tariff No.");

                                        // 2021-10-20 >> 
                                        //Start utt009.bb
                                        IF STRLEN(LRecTariffNo."No.") <> 10 THEN
                                            ERROR(UTT004, LItem."No.");
                                        //End utt009.bb
                                        // 2021-10-20 <<

                                        // 2021-06-25 >>
                                        // IF LRecTariffNo.UMT = '03' THEN //wegen spätere Umrechnung von "M" ins "QM"                                    
                                        IF LRecUnitOfMeasure."Customs UOM Code" = '03' THEN //wegen spätere Umrechnung von "M" ins "QM"
                                                                                            // 2021-06-25 <<
                                            LRecUnitOfMeasure.GET('QM');

                                        // LRecUnitOfMeasure.GET('QM');
                                    END;
                                SalesLine.Type::"G/L Account":
                                    BEGIN
                                        LGLAccount.GET(SalesLine."No.");
                                        LGLAccount.TESTFIELD("Tariff No.");
                                        LRecTariffNo.GET(LGLAccount."Tariff No.");

                                        // 2021-10-20 >> 
                                        //Start utt009.bb
                                        IF STRLEN(LRecTariffNo."No.") <> 10 THEN
                                            ERROR(UTT005, LGLAccount."Tariff No.");
                                        //End utt009.bb
                                        // 2021-10-20 <<
                                    END;
                            END;
                            // 2021-06-25 >>
                            // IF LRecTariffNo.UMT = '' THEN
                            if LRecUnitOfMeasure."Customs UOM Code" = '' then
                                // 2021-06-25 <<
                                ERROR(UTT002, SalesLine."Line No.");
                        END;
                    //End utt02.bb

                    UNTIL SalesLine.NEXT = 0;
            end else begin
                SalesHeader."International Commerce" := false;
                SalesHeader."CCE Tipo Operacion" := '';
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnValidateQuantityOnAfterCalcBaseQty', '', false, false)]
    local procedure OnValidateQuantityOnAfterCalcBaseQty(VAR SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line");
    var
        lRecHeader: Record 36;
        lRecItem: Record 27;

    begin
        with SalesLine DO BEGIN


            lRecHeader.RESET;
            lRecHeader.SETRANGE("No.", "Document No.");
            lRecHeader.SETFILTER("Document Type", '%1', "Document Type");
            IF lRecHeader.FINDFIRST THEN BEGIN
                IF (Type = Type::Item) AND (lRecHeader."International Commerce") THEN BEGIN
                    lRecItem.RESET;
                    IF lRecItem.GET("No.") THEN
                        IF lRecItem."Net Weight" <> 0 THEN
                            "Net Weight" := Quantity * lRecItem."Net Weight";
                END;
            END;
        END;
    end;


    procedure GetNewValue(var P_SalesInvLine: record "Sales Invoice Line"): Decimal
    var
        ItemLoc: Record "Item";
        SalesInvHeaderLoc: record "Sales Invoice Header";
        QtyCalc: Decimal;
        NEWQtyUOM: Decimal;
        NewQty: Decimal;
        NewUOM: Text[30];
        Conv: Boolean;
        Currency: Record Currency;
        UOMMgt: Codeunit "Unit of Measure Management";
        Tariff: Record 260;
        lUnitOfMeasure: Record 204;
    begin

        SalesInvHeaderLoc.GET(P_SalesInvLine."Document No.");
        IF SalesInvHeaderLoc."International Commerce" THEN BEGIN
            IF (P_SalesInvLine.Type = P_SalesInvLine.Type::Item) THEN BEGIN
                //"Unit of Measure Code" := 'QM';
                ItemLoc.GET(P_SalesInvLine."No.");
                ItemLoc.TestField("Tariff No.");
                Tariff.RESET;
                Tariff.SETRANGE("No.", ItemLoc."Tariff No.");

                Tariff.FINDFIRST;
                // 2021-06-25 >>

                lUnitOfMeasure.RESET;
                lUnitOfMeasure.SETRANGE("Code", P_SalesInvLine."Unit of Measure Code");
                lUnitOfMeasure.FINDFIRST;
                // if Tariff.UMT = '03' then begin
                IF (lUnitOfMeasure."Customs UOM Code" = '03') THEN
                    // 2021-06-25 <<
                    P_SalesInvLine."Unit of Measure Code" := 'QM';
                SalesInvHeaderLoc.GET(P_SalesInvLine."Document No.");
                IF SalesInvHeaderLoc."Currency Code" = '' THEN
                    Currency.InitRoundingPrecision
                ELSE BEGIN
                    SalesInvHeaderLoc.TESTFIELD("Currency Factor");
                    Currency.GET(SalesInvHeaderLoc."Currency Code");
                    Currency.TESTFIELD("Amount Rounding Precision");
                END;
                NEWQtyUOM := UOMMgt.GetQtyPerUnitOfMeasure(ItemLoc, P_SalesInvLine."Unit of Measure Code");
                P_SalesInvLine."Unit Price" := ROUND(P_SalesInvLine."Unit Price" * NEWQtyUOM, Currency."Amount Rounding Precision");
                P_SalesInvLine.Quantity := ROUND(P_SalesInvLine."Line Amount" / P_SalesInvLine."Unit Price", Currency."Amount Rounding Precision");
            end;
        END;
    END;

    local procedure FormatDEtoMX(_Amount: Text): Text
    begin
        exit(ConvertStr(_Amount, ',', '.'));
    end;


    procedure ModifyPostedInvoice(Var PostedInvoice: Record 112)
    begin
        PostedInvoice.Modify();
    end;


}