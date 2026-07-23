
tableextension 51041 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                LCust: Record Customer;
            begin
                // 2021-11-25>>
                if (Rec."Document Type" = Rec."Document Type"::Order) OR (Rec."Document Type" = Rec."Document Type"::Invoice) then
                    // 2021-11-25<<
                    if Rec."Sell-to Customer No." <> '' then begin
                        if LCust.Get(Rec."Sell-to Customer No.") then begin
                            Rec."International Commerce" := LCust."International Commerce";
                            if LCust."International Commerce" then begin
                                Rec."CCE Tipo Operacion" := '1';
                            end else begin
                                Rec."CCE Tipo Operacion" := '';
                            end;

                        end;
                    end;
            end;
        }
        // 2021-09-15 >> --
        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            var
                LCompanyInfo: Record 79;
                LRecShipmentMethod: Record "Ship-to Address";
            begin
                // 2021-11-25>>
                if (Rec."Document Type" = Rec."Document Type"::Order) OR (Rec."Document Type" = Rec."Document Type"::Invoice) then begin
                    // 2021-11-25<<
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
                end else begin
                    "International Commerce" := false;
                    "CCE Tipo Operacion" := '';
                end;
            end;
        }
        // 2021-09-15 << ++
        field(51047; "UUID de Certificado de Origen"; Text[36])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Certificate of Origin UUID', ESM = 'UUID de Certificado de Origen';
        }

        field(51048; "CCE Tipo Operacion"; Code[1])
        {
            Description = 'CCE';
            CaptionML = ENU = 'CCE Type of Operation', ESM = 'CCE Tipo Operacion';
            //Caption = 'CCE Tipo Operacion';
        }
        field(51045; "International Commerce"; Boolean)
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'International Commerce', ESM = 'Comercio Internacional';
        }
    }

}