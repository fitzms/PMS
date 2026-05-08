enum 80818 "PMS Valuation Type"
{
    Caption = 'Valuation Type';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; BCIS)
    {
        Caption = 'BCIS';
    }
    value(2; "Index Adjustment")
    {
        Caption = 'Index Adjustment';
    }
    value(3; "RICS Surveyor Valuation")
    {
        Caption = 'RICS Surveyor Valuation';
    }

}
