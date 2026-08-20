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
                Res: Record Resource;
            begin
                if "Employee No." = '' then begin
                    "Employee Name" := '';
                    "Resource No." := '';
                    "Resource Name" := '';
                end else begin
                    UserSetup.Get("Employee No.");
                    BCUser.SetRange("User Name", "Employee No.");
                    if BCUser.FindFirst() then
                        "Employee Name" := CopyStr(BCUser."Full Name", 1, MaxStrLen("Employee Name"))
                    else
                        "Employee Name" := CopyStr("Employee No.", 1, MaxStrLen("Employee Name"));

                    // Auto-populate Resource No. if there's a matching Resource name
                    if "Employee Name" <> '' then begin
                        Res.SetRange(Name, "Employee Name");
                        if Res.FindFirst() then
                            Validate("Resource No.", Res."No.");
                    end;
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
                PropertyRec: Record "PMS Property";
                Unit: Record "PMS Unit";
            begin
                if "Property ID" = '' then begin
                    Validate("Unit ID", '');
                    exit;
                end;
                if PropertyRec.Get("Property ID") then begin
                    if PropertyRec."Single Unit" then
                        "Unit ID" := "Property ID"
                    else begin
                        // Multi-unit: clear unit if it no longer belongs
                        if "Unit ID" <> '' then
                            if Unit.Get("Unit ID") then
                                if Unit."Property ID" <> "Property ID" then
                                    Validate("Unit ID", '');
                    end;
                end;

                // Copy dimensions from Property when Call No. exists
                CopyDimensionsFromProperty("Property ID");
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
            Caption = 'Job Created Date';
            Editable = false;
        }
        field(23; "Resolution Time"; Duration)
        {
            Caption = 'Resolution Time';
            Editable = false;
        }
        field(24; "Tenant ID"; Code[20])
        {
            Caption = 'Tenant ID';
            TableRelation = "PMS Tenant";
        }
        field(25; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;

            trigger OnValidate()
            var
                Res: Record Resource;
            begin
                if "Resource No." = '' then
                    "Resource Name" := ''
                else begin
                    Res.Get("Resource No.");
                    "Resource Name" := CopyStr(Res.Name, 1, MaxStrLen("Resource Name"));
                end;
            end;
        }
        field(26; "Resource Name"; Text[100])
        {
            Caption = 'Resource Name';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(481; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(482; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
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

        // Copy dimensions from Property if set
        if "Property ID" <> '' then
            CopyDimensionsFromProperty("Property ID");
    end;

    trigger OnDelete()
    var
        Job: Record "PMS Job";
    begin
        // Prevent deletion if there are associated jobs
        Job.SetRange("Source Type", Job."Source Type"::"Helpdesk Call");
        Job.SetRange("Source No.", "Call No.");
        if not Job.IsEmpty() then
            Error('Cannot delete helpdesk call %1 because it has associated jobs.', "Call No.");
    end;

    local procedure CopyDimensionsFromProperty(PropertyID: Code[20])
    var
        SourceDefaultDim: Record "Default Dimension";
        DestDefaultDim: Record "Default Dimension";
    begin
        if PropertyID = '' then
            exit;

        // Must have Call No. to create default dimensions
        if "Call No." = '' then
            exit;

        // Copy all default dimensions from the Property to this Call
        SourceDefaultDim.SetRange("Table ID", Database::"PMS Property");
        SourceDefaultDim.SetRange("No.", PropertyID);
        if SourceDefaultDim.FindSet() then
            repeat
                // Only copy if the dimension doesn't already exist for this call
                if not DestDefaultDim.Get(Database::"PMS Helpdesk Call", "Call No.", SourceDefaultDim."Dimension Code") then begin
                    DestDefaultDim.Init();
                    DestDefaultDim."Table ID" := Database::"PMS Helpdesk Call";
                    DestDefaultDim."No." := "Call No.";
                    DestDefaultDim."Dimension Code" := SourceDefaultDim."Dimension Code";
                    DestDefaultDim."Dimension Value Code" := SourceDefaultDim."Dimension Value Code";
                    DestDefaultDim."Value Posting" := SourceDefaultDim."Value Posting";
                    DestDefaultDim.Insert(true);
                end;
            until SourceDefaultDim.Next() = 0;
    end;
}
