enum 80808 "PMS Helpdesk Status"
{
    Extensible = true;
    Caption = 'PMS Helpdesk Status';

    value(0; New)
    {
        Caption = 'New';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; "On Hold")
    {
        Caption = 'On Hold';
    }
    value(3; Resolved)
    {
        Caption = 'Resolved';
    }
    value(4; Closed)
    {
        Caption = 'Closed';
    }
}
