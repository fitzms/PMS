enum 80817 "PMS Hazard Status"
{
    Caption = 'Hazard Status';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Clean)
    {
        Caption = 'Clean';
    }
    value(2; Unclean)
    {
        Caption = 'Unclean';
    }
}
