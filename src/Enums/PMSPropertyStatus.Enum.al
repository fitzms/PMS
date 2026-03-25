enum 80806 "PMS Property Status"
{
    Extensible = true;
    Caption = 'PMS Property Status';

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Allocated)
    {
        Caption = 'Allocated';
    }
    value(2; "In Construction")
    {
        Caption = 'In Construction';
    }
    value(3; "Non Operational")
    {
        Caption = 'Non Operational';
    }
    value(4; Operational)
    {
        Caption = 'Operational';
    }
    value(5; Rehoming)
    {
        Caption = 'Rehoming';
    }
    value(6; Relocated)
    {
        Caption = 'Relocated';
    }
    value(7; Sold)
    {
        Caption = 'Sold';
    }
    value(8; "Tenancy Occupied")
    {
        Caption = 'Tenancy Occupied';
    }
    value(9; Vacant)
    {
        Caption = 'Vacant';
    }
}
