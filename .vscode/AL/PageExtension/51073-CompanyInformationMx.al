pageextension 51073 "Company Information Mx" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("CCE Localidad Mx"; "CCE Localidad")
            {
                Visible = true;
                ApplicationArea = All;

                CaptionML = ENU = 'CCE Localidad Mx', ESM = 'CCE Localidad';
            }




            field("CCE Municipio Mx"; "CCE Municipio")
            {
                Visible = true;
                ApplicationArea = All;

                CaptionML = ENU = 'CCE Municipio Mx', ESM = 'CCE Municipio';
            }


            field("CCE Colonia Mx"; "CCE Colonia")
            {
                Visible = true;
                ApplicationArea = All;

                CaptionML = ENU = 'CCE Colonia Mx', ESM = 'CCE Colonia';
            }

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