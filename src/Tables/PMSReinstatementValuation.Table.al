table 80830 "PMS Reinstatement Valuation"
{
    Caption = 'Reinstatement Valuation';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Reinstatement Val Subform";
    DrillDownPageId = "PMS Reinstatement Val Subform";

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
        field(3; "Valuation Date"; Date)
        {
            Caption = 'Valuation Date';
        }
        field(4; "Valuation Type"; Enum "PMS Valuation Type")
        {
            Caption = 'Valuation Type';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }
        field(6; "Valuation Notes"; Text[250])
        {
            Caption = 'Valuation Notes';
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
