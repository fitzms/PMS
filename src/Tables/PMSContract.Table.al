table 80804 "PMS Contract Header"
{
    Caption = 'Contract Header';
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
        field(12; Status; Enum "PMS Contract Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(10; "Vendor No."; Code[20])
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
        field(11; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate()
            begin
                RecalcContractLines();
            end;
        }
        field(4; "End Date"; Date)
        {
            Caption = 'End Date';

            trigger OnValidate()
            begin
                RecalcContractLines();
            end;
        }
        field(5; "PMSCat. Posting Group"; Code[20])
        {
            Caption = 'PMS Cat. Posting Group';
            TableRelation = "PMS Cat. Posting Group";

            trigger OnValidate()
            var
                ContractLine: Record "PMS Contract Line";
                PostingGroup: Record "PMS Cat. Posting Group";
                UpdateLinesQst: Label 'You have changed the PMS Cat. Posting Group. Do you want to update the G/L Account on all contract lines?';
            begin
                if "PMSCat. Posting Group" = xRec."PMSCat. Posting Group" then
                    exit;

                ContractLine.SetRange("Contract ID", "Contract ID");
                if ContractLine.IsEmpty() then
                    exit;

                if not Confirm(UpdateLinesQst, true) then
                    exit;

                if ("PMSCat. Posting Group" <> '') and PostingGroup.Get("PMSCat. Posting Group") then begin
                    if ContractLine.FindSet(true) then
                        repeat
                            ContractLine."G/L Account No." := PostingGroup."G/L Account No.";
                            ContractLine.Modify();
                        until ContractLine.Next() = 0;
                end else begin
                    if ContractLine.FindSet(true) then
                        repeat
                            ContractLine."G/L Account No." := '';
                            ContractLine.Modify();
                        until ContractLine.Next() = 0;
                end;
            end;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(7; "Job Frequency"; Enum "PMS Job Frequency")
        {
            Caption = 'Job Frequency';

            trigger OnValidate()
            var
                ContractLine: Record "PMS Contract Line";
                UpdateLinesQst: Label 'You have changed the Job Frequency. Do you want to update the Job Frequency on all contract lines?';
            begin
                if "Contract ID" = '' then
                    exit;

                if "Job Frequency" = xRec."Job Frequency" then
                    exit;

                ContractLine.SetRange("Contract ID", "Contract ID");
                if ContractLine.IsEmpty() then
                    exit;

                if not Confirm(UpdateLinesQst, true) then
                    exit;

                if ContractLine.FindSet(true) then
                    repeat
                        ContractLine."Job Frequency" := "Job Frequency";
                        ContractLine.CalcTotalLineCost();
                        ContractLine.Modify();
                    until ContractLine.Next() = 0;
            end;
        }
        field(8; "Contract Value"; Decimal)
        {
            Caption = 'Contract Value';
            FieldClass = FlowField;
            CalcFormula = sum("PMS Contract Line"."Contract Line Amount" where("Contract ID" = field("Contract ID")));
            Editable = false;
        }
        field(9; "No. of Contract Lines"; Integer)
        {
            Caption = 'No. of Contract Lines';
            FieldClass = FlowField;
            CalcFormula = count("PMS Contract Line" where("Contract ID" = field("Contract ID")));
            Editable = false;
        }
        field(13; "Contract Type"; Enum "PMS Contract Type")
        {
            Caption = 'Contract Type';

            trigger OnValidate()
            begin
                if "Contract Type" = "Contract Type"::External then begin
                    "Employee No." := '';
                    "Employee Name" := '';
                end else begin
                    "Vendor No." := '';
                    "Vendor Name" := '';
                end;
            end;
        }
        field(14; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                if "Employee No." = '' then
                    "Employee Name" := ''
                else begin
                    Emp.Get("Employee No.");
                    "Employee Name" := CopyStr(Emp."First Name" + ' ' + Emp."Last Name", 1, MaxStrLen("Employee Name"));
                end;
            end;
        }
        field(15; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
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
            "No. Series" := PMSSetup."Contract Nos.";
            "Contract ID" := NoSeries.GetNextNo(PMSSetup."Contract Nos.", WorkDate(), true);
        end;
    end;

    trigger OnDelete()
    var
        ContractLine: Record "PMS Contract Line";
    begin
        ContractLine.SetRange("Contract ID", "Contract ID");
        ContractLine.DeleteAll(true);
    end;

    local procedure RecalcContractLines()
    var
        ContractLine: Record "PMS Contract Line";
    begin
        ContractLine.SetRange("Contract ID", "Contract ID");
        if ContractLine.FindSet(true) then
            repeat
                ContractLine.CalcTotalLineCostWithDates("Start Date", "End Date");
                ContractLine.Modify();
            until ContractLine.Next() = 0;
    end;

    internal procedure CalcNoOfJobs(): Integer
    var
        ContractLine: Record "PMS Contract Line";
        TotalJobs: Integer;
        Multiplier: Integer;
        TotalDays: Integer;
        TotalMonths: Integer;
    begin
        TotalJobs := 0;
        ContractLine.SetRange("Contract ID", "Contract ID");
        if not ContractLine.FindSet() then
            exit(0);

        if ("Start Date" <> 0D) and ("End Date" <> 0D) and ("End Date" >= "Start Date") then begin
            TotalDays := "End Date" - "Start Date" + 1;
            TotalMonths := (Date2DMY("End Date", 3) - Date2DMY("Start Date", 3)) * 12
                         + Date2DMY("End Date", 2) - Date2DMY("Start Date", 2) + 1;
            repeat
                case ContractLine."Job Frequency" of
                    ContractLine."Job Frequency"::Daily:
                        Multiplier := TotalDays;
                    ContractLine."Job Frequency"::Weekly:
                        Multiplier := TotalDays div 7;
                    ContractLine."Job Frequency"::Fortnightly:
                        Multiplier := TotalDays div 14;
                    ContractLine."Job Frequency"::Monthly:
                        Multiplier := TotalMonths;
                    ContractLine."Job Frequency"::Quarterly:
                        Multiplier := (TotalMonths + 2) div 3;
                    ContractLine."Job Frequency"::"Bi-Annually":
                        Multiplier := (TotalMonths + 5) div 6;
                    ContractLine."Job Frequency"::Yearly:
                        Multiplier := (TotalMonths + 11) div 12;
                    ContractLine."Job Frequency"::"Single Charge":
                        Multiplier := 1;
                    else
                        Multiplier := 0;
                end;
                TotalJobs += Multiplier;
            until ContractLine.Next() = 0;
        end else begin
            repeat
                case ContractLine."Job Frequency" of
                    ContractLine."Job Frequency"::Daily:
                        Multiplier := 365;
                    ContractLine."Job Frequency"::Weekly:
                        Multiplier := 52;
                    ContractLine."Job Frequency"::Fortnightly:
                        Multiplier := 26;
                    ContractLine."Job Frequency"::Monthly:
                        Multiplier := 12;
                    ContractLine."Job Frequency"::Quarterly:
                        Multiplier := 4;
                    ContractLine."Job Frequency"::"Bi-Annually":
                        Multiplier := 2;
                    ContractLine."Job Frequency"::Yearly:
                        Multiplier := 1;
                    ContractLine."Job Frequency"::"Single Charge":
                        Multiplier := 1;
                    else
                        Multiplier := 0;
                end;
                TotalJobs += Multiplier;
            until ContractLine.Next() = 0;
        end;
        exit(TotalJobs);
    end;
}
