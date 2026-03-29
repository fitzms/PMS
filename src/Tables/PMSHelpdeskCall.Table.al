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
                if Status = Status::Closed then begin
                    "Closed Date" := CurrentDateTime;
                    if "Reported Date" <> 0DT then
                        "Resolution Time" := "Closed Date" - "Reported Date"
                    else
                        "Resolution Time" := 0;
                end else begin
                    "Closed Date" := 0DT;
                    "Resolution Time" := 0;
                end;
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
        field(9; "Reported Date"; DateTime)
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
            ObsoleteState = Removed;
            ObsoleteReason = 'Use Employee No./Vendor No. instead.';
        }
        field(12; "Target Resolution Date"; Date)
        {
            Caption = 'Target Resolution Date';
        }
        field(14; "Closed Date"; DateTime)
        {
            Caption = 'Closed Date';
            Editable = false;
        }
        field(15; "Employee No."; Code[50])
        {
            Caption = 'Employee No.';
            TableRelation = "User Setup";

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                BCUser: Record User;
            begin
                if "Employee No." = '' then begin
                    "Employee Name" := '';
                end else begin
                    UserSetup.Get("Employee No.");
                    BCUser.SetRange("User Name", "Employee No.");
                    if BCUser.FindFirst() then
                        "Employee Name" := CopyStr(BCUser."Full Name", 1, MaxStrLen("Employee Name"))
                    else
                        "Employee Name" := CopyStr("Employee No.", 1, MaxStrLen("Employee Name"));
                end;
            end;
        }
        field(16; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(17; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            NotBlank = true;
            TableRelation = "PMS Property";

            trigger OnValidate()
            var
                Unit: Record "PMS Unit";
            begin
                if ("Unit ID" <> '') and ("Property ID" <> '') then begin
                    if Unit.Get("Unit ID") then
                        if Unit."Property ID" <> "Property ID" then
                            Validate("Unit ID", '');
                end else
                    if "Property ID" = '' then
                        Validate("Unit ID", '');
            end;
        }
        field(18; "Unit ID"; Code[20])
        {
            Caption = 'Unit ID';
            TableRelation = "PMS Unit"."Unit ID" where("Property ID" = field("Property ID"));

            trigger OnValidate()
            var
                Unit: Record "PMS Unit";
            begin
                if "Unit ID" = '' then
                    exit;
                if Unit.Get("Unit ID") then
                    "Property ID" := Unit."Property ID";
            end;
        }
        field(19; "Call Type"; Enum "PMS Contract Type")
        {
            Caption = 'Call Type';

            trigger OnValidate()
            begin
                if "Call Type" = "Call Type"::Internal then begin
                    Validate("Vendor No.", '');
                end else begin
                    Validate("Employee No.", '');
                end;
            end;
        }
        field(20; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if "Vendor No." = '' then
                    "Vendor Name" := ''
                else begin
                    Vend.Get("Vendor No.");
                    "Vendor Name" := Vend.Name;
                end;
            end;
        }
        field(21; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(22; "Acknowledged Date"; DateTime)
        {
            Caption = 'Acknowledged Date';
            Editable = false;
        }
        field(23; "Resolution Time"; Duration)
        {
            Caption = 'Resolution Time';
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
        if "Reported Date" = 0DT then
            "Reported Date" := CurrentDateTime;
        if "Created By" = '' then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
        if Priority = Priority::Low then
            Priority := Priority::Normal;
    end;
}
