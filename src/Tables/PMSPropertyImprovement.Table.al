table 80827 "PMS Property Improvement"
{
    Caption = 'Property Improvement';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Prop Improvement Subform";
    DrillDownPageId = "PMS Prop Improvement Subform";

    fields
    {
        field(1; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            NotBlank = true;
            TableRelation = "PMS Property";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Improvement Type"; Enum "PMS Improvement Type")
        {
            Caption = 'Type of Improvement';
        }
        field(4; "Date of Improvement"; Date)
        {
            Caption = 'Date of Improvement';
        }
        field(5; "Area of Improvement"; Text[100])
        {
            Caption = 'Area of Improvement';
        }
    }

    keys
    {
        key(PK; "Property ID", "Line No.")
        {
            Clustered = true;
        }
    }
}
