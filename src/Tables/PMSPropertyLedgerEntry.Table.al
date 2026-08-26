table 80833 "PMS Property Ledger Entry"
{
    Caption = 'PMS Property Ledger Entry';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Property Ledger Entries";
    DrillDownPageId = "PMS Property Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = "PMS Property";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "External Document No."; Text[35])
        {
            Caption = 'External Document No.';
        }
        field(7; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            AutoFormatType = 1;
        }
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(11; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(12; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
        }
        field(13; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.';
            TableRelation = "G/L Entry";
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(PropertyDate; "Property ID", "Posting Date") { }
        key(GLEntryNo; "G/L Entry No.") { }
    }

    trigger OnInsert()
    begin
        if "Entry No." = 0 then
            "Entry No." := GetNextEntryNo();
    end;

    // Call before a bulk insert loop to lock once and avoid repeated per-row locks.
    procedure GetNextEntryNo(): Integer
    var
        LastEntry: Record "PMS Property Ledger Entry";
    begin
        LastEntry.LockTable();
        if LastEntry.FindLast() then
            exit(LastEntry."Entry No." + 1);
        exit(1);
    end;
}
