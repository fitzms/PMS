table 80823 "PMS Contract Line"
{
    Caption = 'Contract Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Contract ID"; Code[20])
        {
            Caption = 'Contract ID';
            NotBlank = true;
            TableRelation = "PMS Contract Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = "PMS Property";

            trigger OnValidate()
            var
                PMSProperty: Record "PMS Property";
            begin
                if ("Property ID" <> xRec."Property ID") and (xRec."Property ID" <> '') then
                    if not Confirm(StrSubstNo(ConfirmChangeQst, FieldCaption("Property ID")), false) then begin
                        "Property ID" := xRec."Property ID";
                        exit;
                    end;

                if "Property ID" = '' then begin
                    Description := '';
                    "Global Dimension 1 Code" := '';
                    "Special Instructions" := '';
                end else begin
                    PMSProperty.Get("Property ID");
                    Description := PMSProperty."Known As";
                    "Global Dimension 1 Code" := PMSProperty."Global Dimension 1 Code";
                    "Special Instructions" := '';
                end;
            end;
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Line Amount" := Quantity * "Unit Price";
                CalcTotalLineCost();
            end;
        }
        field(6; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 2 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Line Amount" := Quantity * "Unit Price";
                CalcTotalLineCost();
            end;
        }
        field(7; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DecimalPlaces = 2 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Quantity <> 0 then
                    "Unit Price" := "Line Amount" / Quantity;
                CalcTotalLineCost();
            end;
        }
        field(8; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
        }
        field(9; "Job Frequency"; Enum "PMS Job Frequency")
        {
            Caption = 'Job Frequency';

            trigger OnValidate()
            begin
                CalcTotalLineCost();
            end;
        }
        field(10; "Special Instructions"; Text[100])
        {
            Caption = 'Special Instructions';
        }
        field(11; "Contract Line Amount"; Decimal)
        {
            Caption = 'Contract Line Amount';
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Contract ID", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ContractHeader: Record "PMS Contract Header";
        PostingGroup: Record "PMS Cat. Posting Group";
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();

        if Quantity = 0 then
            Quantity := 1;

        if ContractHeader.Get("Contract ID") then begin
            if "G/L Account No." = '' then
                if ContractHeader."PMSCat. Posting Group" <> '' then
                    if PostingGroup.Get(ContractHeader."PMSCat. Posting Group") then
                        "G/L Account No." := PostingGroup."G/L Account No.";

            if "Job Frequency" = "Job Frequency"::" " then
                "Job Frequency" := ContractHeader."Job Frequency";
        end;
    end;

    local procedure GetNextLineNo(): Integer
    var
        ContractLine: Record "PMS Contract Line";
    begin
        ContractLine.SetRange("Contract ID", "Contract ID");
        if ContractLine.FindLast() then
            exit(ContractLine."Line No." + 10000);
        exit(10000);
    end;

    var
        ConfirmChangeQst: Label 'Changing the %1 will update the Description, G/L Account, and Dimension fields and clear the Special Instructions on this line. Do you want to continue?';

    internal procedure CalcTotalLineCost()
    var
        ContractHeader: Record "PMS Contract Header";
    begin
        if ContractHeader.Get("Contract ID") then
            CalcTotalLineCostWithDates(ContractHeader."Start Date", ContractHeader."End Date")
        else
            CalcTotalLineCostWithDates(0D, 0D);
    end;

    internal procedure CalcTotalLineCostWithDates(StartDate: Date; EndDate: Date)
    var
        Multiplier: Integer;
        TotalMonths: Integer;
        TotalDays: Integer;
    begin
        if (StartDate <> 0D) and (EndDate <> 0D) and (EndDate >= StartDate) then begin
            TotalDays := EndDate - StartDate + 1;
            TotalMonths := (Date2DMY(EndDate, 3) - Date2DMY(StartDate, 3)) * 12
                         + Date2DMY(EndDate, 2) - Date2DMY(StartDate, 2) + 1;
            case "Job Frequency" of
                "Job Frequency"::Daily:
                    Multiplier := TotalDays;
                "Job Frequency"::Weekly:
                    Multiplier := TotalDays div 7;
                "Job Frequency"::Fortnightly:
                    Multiplier := TotalDays div 14;
                "Job Frequency"::Monthly:
                    Multiplier := TotalMonths;
                "Job Frequency"::Quarterly:
                    Multiplier := (TotalMonths + 2) div 3;
                "Job Frequency"::"Bi-Annually":
                    Multiplier := (TotalMonths + 5) div 6;
                "Job Frequency"::Yearly:
                    Multiplier := (TotalMonths + 11) div 12;
                else
                    Multiplier := 0;
            end;
        end else begin
            // Fall back to standard annual number of periods when no dates set
            case "Job Frequency" of
                "Job Frequency"::Daily:
                    Multiplier := 365;
                "Job Frequency"::Weekly:
                    Multiplier := 52;
                "Job Frequency"::Fortnightly:
                    Multiplier := 26;
                "Job Frequency"::Monthly:
                    Multiplier := 12;
                "Job Frequency"::Quarterly:
                    Multiplier := 4;
                "Job Frequency"::"Bi-Annually":
                    Multiplier := 2;
                "Job Frequency"::Yearly:
                    Multiplier := 1;
                else
                    Multiplier := 0;
            end;
        end;
        "Contract Line Amount" := "Line Amount" * Multiplier;
    end;
}
