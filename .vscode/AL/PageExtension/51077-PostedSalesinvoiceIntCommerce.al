pageextension 51077 "Posted Sales Invoice IntCom Mx" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Invoice Details")
        {
            group("Internation commercer")
            {
                CaptionML = ENU = 'International commerce', ESM = 'Comercio Exterior';
                Visible = true;
                field("CCE Tipo Operacion Mx"; GOperationCCE)
                {
                    Visible = true;
                    ApplicationArea = All;
                    Editable = GBoolModifyRecord;
                    CaptionML = ENU = 'CCE Operation Type Mx', ESM = 'CCE Tipo Operacion';
                    trigger OnValidate()
                    begin
                        GRecSalesInvHeader.get(Rec."No.");
                        GRecSalesInvHeader."CCE Tipo Operacion" := GOperationCCE;
                        GCodElectronicInvoicing.ModifyPostedInvoice(GRecSalesInvHeader);
                    end;
                }

                field("UUID de Certificado de Origen Mx"; GUUIDOrigin)
                {
                    Visible = true;
                    ApplicationArea = All;
                    Editable = GBoolModifyRecord;
                    CaptionML = ENU = 'UUID de Certificado de Origen Mx', ESM = 'UUID de Certificado de Origen';
                    trigger OnValidate()
                    begin
                        GRecSalesInvHeader.get(Rec."No.");
                        GRecSalesInvHeader."UUID de Certificado de Origen" := GUUIDOrigin;
                        GCodElectronicInvoicing.ModifyPostedInvoice(GRecSalesInvHeader);
                    end;
                }

                field("International Commerce Mx"; GInternationalCommerce)
                {
                    Visible = true;
                    ApplicationArea = All;
                    Editable = GBoolModifyRecord;
                    CaptionML = ENU = 'International Commerce Mx', ESM = 'International Commerce';

                    trigger OnValidate()
                    begin
                        GRecSalesInvHeader.get(Rec."No.");
                        GRecSalesInvHeader."International Commerce" := GInternationalCommerce;
                        if GInternationalCommerce then
                            GRecSalesInvHeader."CCE Tipo Operacion" := '1'
                        else
                            GRecSalesInvHeader."CCE Tipo Operacion" := '';
                        GCodElectronicInvoicing.ModifyPostedInvoice(GRecSalesInvHeader);
                    end;

                }

                field("CFDI Exportacion Mx"; GCFDIExportacion)
                {
                    Visible = true;
                    ApplicationArea = All;
                    Editable = GBoolModifyRecord;
                    CaptionML = ENU = 'Export Code (CFDI)', ESM = 'Código de Exportación (CFDI)';
                    ToolTip = 'Catálogo SAT c_Exportacion (01 No aplica, 02 Definitiva, 03 Temporal, 04 Definitiva con clave de pedimento distinta a la del complemento de Comercio Exterior). Si se deja vacío, el sistema lo calcula automáticamente.';
                    trigger OnValidate()
                    begin
                        GRecSalesInvHeader.get(Rec."No.");
                        GRecSalesInvHeader."CFDI Exportacion" := GCFDIExportacion;
                        GCodElectronicInvoicing.ModifyPostedInvoice(GRecSalesInvHeader);
                    end;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        GInternationalCommerce := Rec."International Commerce";
        GUUIDOrigin := Rec."UUID de Certificado de Origen";
        GOperationCCE := Rec."CCE Tipo Operacion";
        GCFDIExportacion := Rec."CFDI Exportacion";
        GBoolModifyRecord := Rec."Electronic Document Status" <> Rec."Electronic Document Status"::"Stamp Received";
    end;

    var
        GInternationalCommerce: Boolean;
        GUUIDOrigin: Text[36];
        GOperationCCE: Code[1];
        GCFDIExportacion: Code[2];
        GRecSalesInvHeader: Record 112;
        GCodElectronicInvoicing: Codeunit 51005;
        GBoolModifyRecord: Boolean;

}