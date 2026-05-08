table 80826 "PMS Property Alarm"
{
    Caption = 'Property Alarm';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Property Alarm Subform";
    DrillDownPageId = "PMS Property Alarm Subform";

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
        field(3; "Alarm Type"; Enum "PMS Alarm Type")
        {
            Caption = 'Alarm Type';
        }
        field(4; "Date Fitted"; Date)
        {
            Caption = 'Date Fitted';
        }
        field(5; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
        }
        field(6; "Model No."; Text[50])
        {
            Caption = 'Model Number';
        }
        field(7; "Location in House"; Text[100])
        {
            Caption = 'Location in House';
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
