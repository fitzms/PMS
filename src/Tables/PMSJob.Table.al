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
        }
        field(9; "Unit ID"; Code[20])
        {
            Caption = 'Unit ID';
            TableRelation = "PMS Unit";
        }
        field(10; Status; Enum "PMS Job Status")
        {
            Caption = 'Status';
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
            begin
                if "Employee No." = '' then
                    "Employee Name" := ''
                else begin
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
        field(17; "Scheduled Date"; Date)
        {
            Caption = 'Scheduled Date';
        }
        field(18; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
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

    trigger OnInsert()
    begin
        if "Job No." = '' then begin
            PMSSetup.GetRecordOnce();
            PMSSetup.TestField("Job Nos.");
            "No. Series" := PMSSetup."Job Nos.";
            "Job No." := NoSeries.GetNextNo(PMSSetup."Job Nos.", WorkDate(), true);
        end;
    end;
}
