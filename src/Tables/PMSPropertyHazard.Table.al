table 80829 "PMS Property Hazard"
{
    Caption = 'Property Hazard';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Property Hazard Subform";
    DrillDownPageId = "PMS Property Hazard Subform";

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
        field(3; "Hazard Type"; Enum "PMS Hazard Type")
        {
            Caption = 'Hazard Type';
        }
        field(4; "Surveyor Ref. Number"; Text[50])
        {
            Caption = 'Surveyor Ref. Number';
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(6; "All Areas"; Boolean)
        {
            Caption = 'All Areas';
        }
        field(7; "Extent of Hazard"; Text[250])
        {
            Caption = 'Extent of Hazard';
        }
        field(8; "Hazard Status"; Enum "PMS Hazard Status")
        {
            Caption = 'Hazard Status';
        }
        field(9; "Next Inspection Date"; Date)
        {
            Caption = 'Next Inspection Date';
        }
        field(10; "Information Source"; Text[100])
        {
            Caption = 'Information Source';
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
