pageextension 51076 "Sales Invoice Int Commerce Mx" extends "Sales Invoice"
{
    layout
    {

        addafter("Invoice Details")
        {
            group("Internation commercer")
            {
                CaptionML = ENU = 'International commerce', ESM = 'Comercio Exterior';
                Visible = true;
                field("CCE Operation Type Mx"; "CCE Tipo Operacion")
                {
                    Visible = true;
                    ApplicationArea = All;

                    CaptionML = ENU = 'CCE Operation Type Mx', ESM = 'CCE Tipo Operacion';
                }




                field("UUID de Certificado de Origen Mx"; "UUID de Certificado de Origen")
                {
                    Visible = true;
                    ApplicationArea = All;

                    CaptionML = ENU = 'UUID de Certificado de Origen Mx', ESM = 'UUID de Certificado de Origen';
                }
                field("International Commerce Mx"; "International Commerce")
                {
                    Visible = true;
                    ApplicationArea = All;

                    CaptionML = ENU = 'International Commerce Mx', ESM = 'International Commerce';

                    trigger OnValidate()
                    begin

                        IF "International Commerce" = True THEN BEGIN
                            "CCE Tipo Operacion" := '1';
                        END ELSE BEGIN
                            "CCE Tipo Operacion" := '';
                        END;

                    END;
                }
                field("CFDI Exportacion Mx"; "CFDI Exportacion")
                {
                    Visible = true;
                    ApplicationArea = All;

                    CaptionML = ENU = 'Export Code (CFDI)', ESM = 'Código de Exportación (CFDI)';
                    ToolTip = 'Catálogo SAT c_Exportacion (01 No aplica, 02 Definitiva, 03 Temporal, 04 Definitiva con clave de pedimento distinta a la del complemento de Comercio Exterior). Si se deja vacío, el sistema lo calcula automáticamente.';
                }

            }
        }


    }

}