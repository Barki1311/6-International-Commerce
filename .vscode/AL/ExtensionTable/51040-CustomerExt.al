
tableextension 51040 "Customer Ext" extends "Customer"
{
    fields
    {
        field(51022; "No. Exterior"; Text[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Exterior No.', ESM = 'No. Exterior';
        }

        field(51023; "No. Interior"; Text[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Interior No.', ESM = 'No. Interior';
        }
        field(51024; "International Commerce"; Boolean)
        {
            Description = 'CCE';
            CaptionML = ENU = 'International Commerce MX', ESM = 'Comercio Exterior MX';
        }

        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            var
                LCompanyInfo: Record 79;
                LRecShipmentMethod: Record "Ship-to Address";
            begin

                if "Ship-to Code" <> '' then begin
                    LRecShipmentMethod.Get(Rec."No.", "Ship-to Code");
                    LCompanyInfo.Get();
                    if LRecShipmentMethod."Country/Region Code" <> LCompanyInfo."Country/Region Code" then
                        "International Commerce" := true
                    else
                        "International Commerce" := false;
                end;
            end;
        }
    }

}