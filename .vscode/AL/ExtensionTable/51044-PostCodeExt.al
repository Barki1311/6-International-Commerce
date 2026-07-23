
tableextension 51044 "Post Code Ext" extends "Post Code"
{
    fields
    {
        field(51065; "CCE Localidad"; Text[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Locality CCE', ESM = 'CCE Localidad';
        }
        field(51066; "CCE Municipio"; Text[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'City CCE', ESM = 'CCE Municipio';
        }

        field(51070; "CCE Estado"; Text[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'State CCE', ESM = 'CCE Estado';
        }
        field(51071; "CCE Colonia"; Text[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Colony CCE', ESM = 'CCE Colonia';
        }

    }

}