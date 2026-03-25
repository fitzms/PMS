enum 80810 "PMS Contract Type"
{
    Extensible = true;
    Caption = 'Contract Type';

    value(0; External)
    {
        Caption = 'External (Supplier)';
    }
    value(1; Internal)
    {
        Caption = 'Internal (Employee)';
    }
}
