table 80809 "PMS Cat. Posting Group"
{
    Caption = 'PMS Category Posting Group';
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
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account" where("Account Type" = const(Posting), Blocked = const(false));

            trigger OnValidate()
            var
                GLAccount: Record "G/L Account";
            begin
                if "G/L Account No." = '' then
                    "G/L Account Description" := ''
                else begin
                    GLAccount.Get("G/L Account No.");
                    "G/L Account Description" := GLAccount.Name;
                end;
            end;
        }
        field(4; "G/L Account Description"; Text[100])
        {
            Caption = 'G/L Account Description';
            Editable = false;
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
