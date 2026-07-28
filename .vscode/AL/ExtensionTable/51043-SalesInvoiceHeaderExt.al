
tableextension 51043 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(51045; "International Commerce"; Boolean)
        {
            Description = 'CCE';
            Editable = true;
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'International Commerce', ESM = 'Comercio Internacional';
        }

        field(51047; "UUID de Certificado de Origen"; Text[36])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Certificate of Origin UUID', ESM = 'UUID de Certificado de Origen';
        }
        field(51048; "CCE Tipo Operacion"; Code[1])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'CCE Type of Operation', ESM = 'CCE Tipo Operacion';
        }
        field(51202; "CFDI Exportacion"; Code[2])
        {
            CaptionML = ENU = 'Export Code (CFDI)', ESM = 'Código de Exportación (CFDI)';
            Description = 'Catálogo c_Exportacion SAT: 01 No aplica, 02 Definitiva, 03 Temporal, 04 Definitiva con clave de pedimento distinta a la del complemento de Comercio Exterior. Mismo Field ID que en Customer/Sales Header/Document Header (módulo 4) para que TRANSFERFIELDS lo propague automáticamente.';
            DataClassification = ToBeClassified;
        }
        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            var
                LCompanyInfo: Record 79;
                LRecShipmentMethod: Record "Ship-to Address";
            begin

                if "Ship-to Code" <> '' then begin
                    if LRecShipmentMethod.Get(Rec."Bill-to Customer No.", Rec."Ship-to Code") then begin
                        LCompanyInfo.Get();
                        if LRecShipmentMethod."Country/Region Code" <> LCompanyInfo."Country/Region Code" then begin
                            "International Commerce" := true;
                            "CCE Tipo Operacion" := '1';
                        end else begin
                            "International Commerce" := false;
                            "CCE Tipo Operacion" := '';
                        end;

                    end;
                end else begin
                    "International Commerce" := false;
                    "CCE Tipo Operacion" := '';
                end;

            end;
        }
    }

}