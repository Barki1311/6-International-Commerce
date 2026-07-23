
tableextension 51047 "Document Line Ext" extends "Document Line"
{
    fields
    {
        field(51022; "Net Weight"; Decimal)
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Net Weight', ESM = 'Peso Neto';
        }

        field(51023; "Tariff No."; code[20])
        {
            Description = 'CCE';
            //CaptionML = 'ENU=SAT Country;ESM=Pais SAT';
            CaptionML = ENU = 'Tariff No.', ESM = 'No. Tarifa';
        }
    }

}