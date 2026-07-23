
tableextension 51042 "Company Information Ext" extends "Company Information"
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
        field(51065; "CCE Localidad"; Text[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Location CCE', ESM = 'CCE Localidad';
        }
        field(51066; "CCE Municipio"; Text[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'City CCE', ESM = 'CCE Municipio';
        }
        field(51067; "CCE Colonia"; Code[5])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Addres CCE ', ESM = 'CCE Colonia';
        }
    }

}