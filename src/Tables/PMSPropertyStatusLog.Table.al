table 80831 "PMS Property Status Log"
{
    Caption = 'Property Status Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = "PMS Property";
        }
        field(3; "Changed On"; DateTime)
        {
            Caption = 'Changed On';
        }
        field(4; "Changed By"; Code[50])
        {
            Caption = 'Changed By';
        }
        field(5; "Old Status"; Enum "PMS Property Status")
        {
            Caption = 'Old Status';
        }
        field(6; "New Status"; Enum "PMS Property Status")
        {
            Caption = 'New Status';
        }
        field(7; Note; Text[500])
        {
            Caption = 'Note';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Property; "Property ID", "Changed On")
        {
        }
    }
}
