table 80814 "PMS Property Type"
{
    Caption = 'Property Type';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Property Type List";
    DrillDownPageId = "PMS Property Type List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
