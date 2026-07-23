
tableextension 51046 "Document Header Ext" extends "Document Header"
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
        field(51045; "International Commerce"; Boolean)
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'International Commerce', ESM = 'Comercio Internacional';
        }
        field(51047; "UUID de Certificado de Origen"; Text[36])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Certificate of Origin UUID', ESM = 'UUID de Certificado de Origen';
        }

        field(51048; "CCE Tipo Operacion"; Code[1])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'CCE Type of Operation', ESM = 'CCE Tipo Operacion';
        }
        /*
        field(51049; "Transfer Post Code"; Code[10])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Transfer Post Code', ESM = 'Transferir Código Postal';
        }
        */
        field(51050; "Transfer Address"; Text[70])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Transfer Address', ESM = 'Dirección de Tranferencia';
        }
        field(51053; "Transfer Colony"; Text[70])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Transfer Colony', ESM = 'Colonia de Tranferencia';
        }
        field(51054; "Transfer Incoterm"; Code[20])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Transfer Intercom', ESM = 'Intercominicador de Tranferencia';
        }

    }

}