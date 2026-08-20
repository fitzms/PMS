table 80824 "PMS Job"
{
    Caption = 'PMS Job';
    DataClassification = CustomerContent;
    LookupPageId = "PMS Job List";
    DrillDownPageId = "PMS Job List";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Job No." <> xRec."Job No." then begin
                    PMSSetup.GetRecordOnce();
                    NoSeries.TestManual(PMSSetup."Job Nos.");
                end;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Source Type"; Enum "PMS Job Source Type")
        {
            Caption = 'Source Type';
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(6; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(7; "Occurrence No."; Integer)
        {
            Caption = 'Occurrence No.';
        }
        field(8; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = "PMS Property";

            trigger OnValidate()
            var
                PropertyRec: Record "PMS Property";
                UnitRec: Record "PMS Unit";
            begin
                if "Property ID" = '' then begin
                    "Unit ID" := '';
                    exit;
                end;
                if PropertyRec.Get("Property ID") then begin
                    if PropertyRec."Single Unit" then begin
                        "Unit ID" := "Property ID";
                    end;
                    // Inherit Global Dimension 1 from Property if not already set
                    if ("Global Dimension 1 Code" = '') and (PropertyRec."Global Dimension 1 Code" <> '') then
                        "Global Dimension 1 Code" := PropertyRec."Global Dimension 1 Code";
                    // Copy all default dimensions from Property to Job
                    CopyDimensionsFromProperty("Property ID");
                end;
                // Multi-unit: clear unit if it no longer belongs
                if "Unit ID" <> '' then
                    if UnitRec.Get("Unit ID") then
                        if UnitRec."Property ID" <> "Property ID" then
                            "Unit ID" := '';
            end;
        }
        field(9; "Unit ID"; Code[20])
        {
            Caption = 'Unit ID';
            TableRelation = "PMS Unit"."Unit ID" where("Property ID" = field("Property ID"));

            trigger OnValidate()
            var
                UnitRec: Record "PMS Unit";
            begin
                if "Unit ID" = '' then
                    exit;
                if UnitRec.Get("Unit ID") then
                    "Property ID" := UnitRec."Property ID";
            end;
        }
        field(30; "Property Known As"; Text[100])
        {
            Caption = 'Property Known As';
            FieldClass = FlowField;
            CalcFormula = lookup("PMS Property"."Known As" where("Property ID" = field("Property ID")));
            Editable = false;
        }
        field(31; "SharePoint Folder URL"; Text[500])
        {
            Caption = 'SharePoint Folder URL';
            ExtendedDatatype = URL;
        }
        field(32; Details; Text[2048])
        {
            Caption = 'Details';
        }
        field(10; Status; Enum "PMS Job Status")
        {
            Caption = 'Status';

            trigger OnValidate()
            var
                PMSJobMgt: Codeunit "PMS Job Management";
            begin
                if Status in [Status::Completed, Status::Cancelled, Status::Spawned] then begin
                    if "Completed Date" = 0DT then
                        "Completed Date" := CurrentDateTime;
                    if "Created Date" <> 0DT then
                        "Resolution Time" := "Completed Date" - "Created Date"
                    else
                        "Resolution Time" := 0;

                    // Check if all jobs for helpdesk call are complete and close if needed
                    if ("Source Type" = "Source Type"::"Helpdesk Call") and ("Source No." <> '') then
                        PMSJobMgt.CheckAndCloseHelpdeskCall("Source No.", "Job No.", Status);
                end else begin
                    if xRec.Status in [Status::Completed, Status::Cancelled, Status::Spawned] then begin
                        "Completed Date" := 0DT;
                        "Resolution Time" := 0;
                    end;
                end;
            end;
        }
        field(11; Priority; Enum "PMS Helpdesk Priority")
        {
            Caption = 'Priority';
        }
        field(12; "Job Type"; Enum "PMS Contract Type")
        {
            Caption = 'Job Type';

            trigger OnValidate()
            begin
                if "Job Type" = "Job Type"::External then begin
                    "Employee No." := '';
                    "Employee Name" := '';
                    "Resource No." := '';
                    "Resource Name" := '';
                end else begin
                    "Vendor No." := '';
                    "Vendor Name" := '';
                    "Purchase Order No." := '';
                    "Purchase Order Line No." := 0;
                end;
            end;
        }
        field(13; "Vendor No."; Code[20])
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
        field(14; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
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
        field(17; "Scheduled Date"; Date)
        {
            Caption = 'Scheduled Date';
        }
        field(33; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(18; "Completed Date"; DateTime)
        {
            Caption = 'Completed/Spawned Date';
        }
        field(34; "Resolution Time"; Duration)
        {
            Caption = 'Resolution Time';
            Editable = false;
        }
        field(19; "Estimated Cost"; Decimal)
        {
            Caption = 'Estimated Cost';
            DecimalPlaces = 2 : 5;
            MinValue = 0;
        }
        field(20; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(21; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
        }
        field(22; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(23; "Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Order Line No.';
            Editable = false;
        }
        field(24; "Special Instructions"; Text[100])
        {
            Caption = 'Special Instructions';
        }
        field(25; Notes; Text[2048])
        {
            Caption = 'Notes';
        }
        field(26; "Resolution Notes"; Text[2048])
        {
            Caption = 'Resolution Notes';
        }
        field(27; "Related Job No."; Code[20])
        {
            Caption = 'Related Job No.';
            Editable = false;
            TableRelation = "PMS Job";
        }
        field(28; "Resource No."; Code[20])
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
        field(29; "Resource Name"; Text[100])
        {
            Caption = 'Resource Name';
            Editable = false;
        }
        field(35; "Spawned By"; Code[50])
        {
            Caption = 'Spawned By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(36; "Spawn Reason"; Text[250])
        {
            Caption = 'Spawn Reason';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(37; "Suggested Vendor No."; Code[20])
        {
            Caption = 'Suggested Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(38; "Estimated Quantity"; Decimal)
        {
            Caption = 'Estimated Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Estimated Unit Cost" <> 0 then
                    "Estimated Cost" := "Estimated Quantity" * "Estimated Unit Cost";
            end;
        }
        field(39; "Estimated Unit Cost"; Decimal)
        {
            Caption = 'Estimated Unit Cost';
            DecimalPlaces = 2 : 5;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Estimated Quantity" <> 0 then
                    "Estimated Cost" := "Estimated Quantity" * "Estimated Unit Cost";
            end;
        }
        field(40; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry"."Dimension Set ID";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(41; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(42; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), Blocked = const(false));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(PK; "Job No.")
        {
            Clustered = true;
        }
        key(SourceKey; "Source Type", "Source No.", "Source Line No.", "Occurrence No.") { }
        key(StatusScheduled; Status, "Scheduled Date") { }
    }

    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;

    trigger OnInsert()
    begin
        if "Job No." = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Job Nos.");
            "No. Series" := PMSSetup."Job Nos.";
            "Job No." := NoSeries.GetNextNo(PMSSetup."Job Nos.", WorkDate(), true);
        end;

        // Only set Created Date if not already set (e.g., from helpdesk call)
        if "Created Date" = 0DT then
            "Created Date" := CurrentDateTime;

        // For manually created jobs (not from Contract or Helpdesk Call)
        if "Source Type" = "Source Type"::" " then begin
            "Source Type" := "Source Type"::Job;
            "Source No." := "Job No.";
        end;
    end;

    local procedure CopyDimensionsFromProperty(PropertyID: Code[20])
    var
        SourceDefaultDim: Record "Default Dimension";
        DestDefaultDim: Record "Default Dimension";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimValue: Record "Dimension Value";
    begin
        // Copy all default dimensions from the Property to this Job
        SourceDefaultDim.SetRange("Table ID", Database::"PMS Property");
        SourceDefaultDim.SetRange("No.", PropertyID);
        if SourceDefaultDim.FindSet() then
            repeat
                // Only copy if the dimension doesn't already exist for this job
                if not DestDefaultDim.Get(Database::"PMS Job", "Job No.", SourceDefaultDim."Dimension Code") then begin
                    DestDefaultDim.Init();
                    DestDefaultDim."Table ID" := Database::"PMS Job";
                    DestDefaultDim."No." := "Job No.";
                    DestDefaultDim."Dimension Code" := SourceDefaultDim."Dimension Code";
                    DestDefaultDim."Dimension Value Code" := SourceDefaultDim."Dimension Value Code";
                    DestDefaultDim."Value Posting" := SourceDefaultDim."Value Posting";
                    DestDefaultDim.Insert(true);
                end;
                
                // Also build dimension set for the Job header
                if DimValue.Get(SourceDefaultDim."Dimension Code", SourceDefaultDim."Dimension Value Code") then begin
                    TempDimSetEntry.Init();
                    TempDimSetEntry."Dimension Code" := SourceDefaultDim."Dimension Code";
                    TempDimSetEntry."Dimension Value Code" := SourceDefaultDim."Dimension Value Code";
                    TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
                    if TempDimSetEntry.Insert() then;
                end;
            until SourceDefaultDim.Next() = 0;
        
        // Set Job's Dimension Set ID from the built set
        if TempDimSetEntry.FindFirst() then begin
            "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        end;
    end;

    procedure CopyDimensionsFromPropertyPublic(PropertyID: Code[20])
    begin
        CopyDimensionsFromProperty(PropertyID);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" := DimMgt.EditDimensionSet("Dimension Set ID", "Job No.");
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;
}
