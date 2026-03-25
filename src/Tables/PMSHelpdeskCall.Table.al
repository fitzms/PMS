table 80808 "PMS Helpdesk Call"
{
    Caption = 'Helpdesk Call';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Helpdesk Call List";
    DrillDownPageId = "PMS Helpdesk Call List";

    fields
    {
        field(1; "Call No."; Code[20])
        {
            Caption = 'Call No.';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Call No." <> xRec."Call No." then begin
                    PMSSetup.GetRecordOnce();
                    NoSeries.TestManual(PMSSetup."Helpdesk Nos.");
                end;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(3; Status; Enum "PMS Helpdesk Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Status = Status::Closed then
                    "Closed Date" := WorkDate()
                else
                    "Closed Date" := 0D;
            end;
        }
        field(4; Priority; Enum "PMS Helpdesk Priority")
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            NotBlank = true;
        }
        field(8; Details; Text[2048])
        {
            Caption = 'Details';
        }
        field(9; "Reported Date"; Date)
        {
            Caption = 'Reported Date';
        }
        field(10; "Created By"; Text[100])
        {
            Caption = 'Created By';
        }
        field(11; "Assigned To"; Text[100])
        {
            Caption = 'Assigned To';
        }
        field(12; "Target Resolution Date"; Date)
        {
            Caption = 'Target Resolution Date';
        }
        field(13; "Resolution Notes"; Text[2048])
        {
            Caption = 'Resolution Notes';
        }
        field(14; "Closed Date"; Date)
        {
            Caption = 'Closed Date';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Call No.")
        {
            Clustered = true;
        }
        key(StatusPriority; Status, Priority) { }
    }

    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";

    trigger OnInsert()
    begin
        if "Call No." = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Helpdesk Nos.");
            "No. Series" := PMSSetup."Helpdesk Nos.";
            "Call No." := NoSeries.GetNextNo(PMSSetup."Helpdesk Nos.", WorkDate(), true);
        end;
        if "Reported Date" = 0D then
            "Reported Date" := WorkDate();
        if "Created By" = '' then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
        if Priority = Priority::Low then
            Priority := Priority::Normal;
    end;
}
