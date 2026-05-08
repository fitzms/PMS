table 80828 "PMS Property Boiler"
{
    Caption = 'Property Boiler';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Property Boiler Subform";
    DrillDownPageId = "PMS Property Boiler Subform";

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
        field(3; "Boiler Type"; Text[50])
        {
            Caption = 'Boiler Type';
        }
        field(4; "Boiler Make"; Text[50])
        {
            Caption = 'Boiler Make';
        }
        field(5; "Boiler Model"; Text[50])
        {
            Caption = 'Boiler Model';
        }
        field(6; "Boiler Location"; Text[100])
        {
            Caption = 'Boiler Location';
        }
        field(7; "Burner Model"; Text[50])
        {
            Caption = 'Burner Model';
        }
        field(8; "Heating System Type"; Text[50])
        {
            Caption = 'Type of Heating System';
        }
        field(9; "Date of Next Service"; Date)
        {
            Caption = 'Date of Next Service';
        }
        field(10; "Landlord Cert Inspection Date"; Date)
        {
            Caption = 'Date of New Landlord Certificate Inspection';
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
