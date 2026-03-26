enum 80811 "PMS Job Status"
{
    Extensible = true;
    Caption = 'PMS Job Status';

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Scheduled)
    {
        Caption = 'Scheduled';
    }
    value(2; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(3; "On Hold")
    {
        Caption = 'On Hold';
    }
    value(4; Completed)
    {
        Caption = 'Completed';
    }
    value(5; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
