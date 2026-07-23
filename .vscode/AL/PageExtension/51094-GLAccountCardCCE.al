pageextension 51094 "GL Account Card CCE" extends 17
{
    layout
    {
        addafter("Cod. Prod. Serv. SAT")
        {
            field("Tariff No."; "Tariff No.")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }
}