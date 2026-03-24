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
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(7; "Job Frequency"; Option)
        {
            Caption = 'Job Frequency';
            OptionCaption = ' ,Daily,Weekly,Fortnightly,Monthly,Quarterly,Bi-Annually,Yearly';
            OptionMembers = " ",Daily,Weekly,Fortnightly,Monthly,Quarterly,"Bi-Annually",Yearly;
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

    local procedure RecalcContractLines()
    var
        ContractLine: Record "PMS Contract Line";
    begin
        ContractLine.SetRange("Contract ID", "Contract ID");
        if ContractLine.FindSet(true) then
            repeat
                ContractLine.Validate("Job Frequency", ContractLine."Job Frequency");
                ContractLine.Modify();
            until ContractLine.Next() = 0;
    end;
}
