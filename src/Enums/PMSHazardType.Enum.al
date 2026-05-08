enum 80816 "PMS Hazard Type"
{
    Caption = 'Hazard Type';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Asbestos)
    {
        Caption = 'Asbestos';
    }
    value(2; Legionella)
    {
        Caption = 'Legionella';
    }
    value(3; "See Savils Report")
    {
        Caption = 'See Savils Report';
    }
}
