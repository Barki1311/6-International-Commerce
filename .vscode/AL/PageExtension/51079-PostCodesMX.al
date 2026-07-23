pageextension 51079 "Post Codes Mx" extends "Post Codes"
{
    layout
    {
        addafter(TimeZone)
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


            field("CCE Estado Mx"; "CCE Estado")
            {
                Visible = true;
                ApplicationArea = All;

                CaptionML = ENU = 'CCE Estado Mx', ESM = 'CCE Estado';
            }

            field("CCE Colonia"; "CCE Colonia")
            {
                Visible = true;
                ApplicationArea = All;
            }



        }


    }


}