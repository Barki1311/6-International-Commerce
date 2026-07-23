pageextension 51075 "Customer List IntCommerce Mx" extends "Customer List"
{
    layout
    {
        addafter("Post Code")
        {

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
        }
    }

}