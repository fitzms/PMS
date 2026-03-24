enum 80804 "PMS Contract Status"
{
    Extensible = true;
    Caption = 'PMS Contract Status';

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Active)
    {
        Caption = 'Active';
    }
    value(2; Closed)
    {
        Caption = 'Closed';
    }
    value(3; Archived)
    {
        Caption = 'Archived';
    }
}
