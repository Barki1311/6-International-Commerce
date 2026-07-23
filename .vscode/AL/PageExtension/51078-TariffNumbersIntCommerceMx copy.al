pageextension 51078 "Tariff Numbers Mx" extends "Tariff Numbers"
{
    layout
    {
        addafter(Description)
        {
            field("UMT Mx"; "UMT")
            {
                Visible = true;
                ApplicationArea = All;

                CaptionML = ENU = 'UMT Mx', ESM = 'UMT';
            }



        }
    }

}