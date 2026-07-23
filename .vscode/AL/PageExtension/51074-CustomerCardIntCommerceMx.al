pageextension 51074 "Customer Card Int. Comerce Mx" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group(InternationalCommerce)
            {
                Visible = true;
                CaptionML = ENU = 'International Commerce MX', ESM = 'Comercio Exterior MX';
                field("No. Exterior Mx"; "No. Exterior")
                {
                    Visible = true;
                    ApplicationArea = All;
                    CaptionML = ENU = 'No. Exterior Mx', ESM = 'No. Exterior';
                }

                field("No. Interior Mx"; "No. Interior")
                {
                    Visible = true;
                    ApplicationArea = All;
                    CaptionML = ENU = 'No. Interior Mx', ESM = 'No. Interior';
                }
                field("International Commerce"; "International Commerce")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
            }

        }
    }

}