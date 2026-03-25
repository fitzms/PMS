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
        field(3; Status; Enum "PMS Tenant Status")
        {
            Caption = 'Status';
        }
        field(4; "Unit ID"; Code[20])
        {
            Caption = 'Unit ID';
            TableRelation = "PMS Unit";

            trigger OnValidate()
            var
                Unit: Record "PMS Unit";
            begin
                if "Unit ID" = '' then
                    "Property ID" := ''
                else
                    if Unit.Get("Unit ID") then
                        "Property ID" := Unit."Property ID";
            end;
        }
        field(8; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = "PMS Property";
            Editable = false;
        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(6; "End Date"; Date)
        {
            Caption = 'End Date';

            trigger OnValidate()
            begin
                if "End Date" <> 0D then
                    Status := Status::Previous
                else
                    if Status = Status::Previous then
                        Status := Status::Current;
            end;
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
