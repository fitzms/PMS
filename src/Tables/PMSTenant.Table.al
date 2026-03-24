table 80820 "PMS Tenant"
{
    Caption = 'Tenant';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Tenant List";
    DrillDownPageId = "PMS Tenant List";

    fields
    {
        field(1; "Tenant ID"; Code[20])
        {
            Caption = 'Tenant ID';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Tenant ID" <> xRec."Tenant ID" then begin
                    PMSSetup.GetRecordOnce();
                    NoSeries.TestManual(PMSSetup."Tenant Nos.");
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Current,Previous';
            OptionMembers = " ",Current,Previous;
        }
        field(4; "Unit ID"; Code[20])
        {
            Caption = 'Unit ID';
            TableRelation = "PMS Unit";
        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(6; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Tenant ID")
        {
            Clustered = true;
        }
    }

    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";

    trigger OnInsert()
    begin
        if "Tenant ID" = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Tenant Nos.");
            "No. Series" := PMSSetup."Tenant Nos.";
            "Tenant ID" := NoSeries.GetNextNo(PMSSetup."Tenant Nos.", WorkDate(), true);
        end;
    end;
}
