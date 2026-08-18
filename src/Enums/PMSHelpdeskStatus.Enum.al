enum 80808 "PMS Helpdesk Status"
{
    Extensible = true;
    Caption = 'PMS Helpdesk Status';

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(4; Closed)
    {
        Caption = 'Closed';
    }
}
