table 80809 "PMS Cat. Posting Group"
{
    Caption = 'Cat. Posting Group';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Cat. Posting Group List";
    DrillDownPageId = "PMS Cat. Posting Group List";

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
