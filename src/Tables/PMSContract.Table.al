table 80804 "PMS Contract"
{
    Caption = 'Contract';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Contract List";
    DrillDownPageId = "PMS Contract List";

    fields
    {
        field(1; "Contract ID"; Code[20])
        {
            Caption = 'Contract ID';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Contract ID" <> xRec."Contract ID" then begin
                    PMSSetup.GetRecordOnce();
                    NoSeries.TestManual(PMSSetup."Contract Nos.");
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(4; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(5; "Cat. Posting Group"; Code[20])
        {
            Caption = 'Cat. Posting Group';
            TableRelation = "PMS Cat. Posting Group";
        }
    }

    keys
    {
        key(PK; "Contract ID")
        {
            Clustered = true;
        }
    }

    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";

    trigger OnInsert()
    begin
        if "Contract ID" = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Contract Nos.");
            "Contract ID" := NoSeries.GetNextNo(PMSSetup."Contract Nos.", WorkDate(), true);
        end;
    end;
}
