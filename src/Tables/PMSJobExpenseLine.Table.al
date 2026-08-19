table 80832 "PMS Job Expense Line"
{
    Caption = 'PMS Job Expense Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = "PMS Job";
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Category Posting Group"; Code[20])
        {
            Caption = 'Category Posting Group';
            TableRelation = "PMS Cat. Posting Group";

            trigger OnValidate()
            var
                CatPostingGroup: Record "PMS Cat. Posting Group";
            begin
                if "Category Posting Group" = '' then begin
                    "G/L Account No." := '';
                    "G/L Account Description" := '';
                end else begin
                    CatPostingGroup.Get("Category Posting Group");
                    "G/L Account No." := CatPostingGroup."G/L Account No.";
                    if "G/L Account No." <> '' then
                        "G/L Account Description" := CatPostingGroup."G/L Account Description";
                end;
            end;
        }
        field(5; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            var
                GLAcc: Record "G/L Account";
            begin
                if "G/L Account No." = '' then
                    "G/L Account Description" := ''
                else begin
                    GLAcc.Get("G/L Account No.");
                    "G/L Account Description" := GLAcc.Name;
                end;
            end;
        }
        field(6; "G/L Account Description"; Text[100])
        {
            Caption = 'G/L Account Description';
            Editable = false;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Line Amount" := Quantity * "Direct Unit Cost";
            end;
        }
        field(8; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DecimalPlaces = 2 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Line Amount" := Quantity * "Direct Unit Cost";
            end;
        }
        field(9; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(10; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;

            trigger OnLookup()
            begin
                ShowDimensions();
            end;
        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(13; "Property ID"; Code[20])
        {
            Caption = 'Property ID';
            FieldClass = FlowField;
            CalcFormula = lookup("PMS Job"."Property ID" where("Job No." = field("Job No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Job No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;

    trigger OnInsert()
    begin
        // Automatically inherit dimensions from Job when new expense line is inserted
        CopyDimensionsFromJob();
    end;

    procedure ShowDimensions()
    var
        DimSetEntry: Record "Dimension Set Entry";
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Job No.", "Line No."));
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            UpdateLineDimensionsFromJobDimensions();
        end;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "Dimension Set ID" <> OldDimSetID then
            Modify();
    end;

    local procedure UpdateLineDimensionsFromJobDimensions()
    begin
        // This will be called when user edits dimensions
        // Future enhancement: inherit from job if needed
    end;

    local procedure CopyDimensionsFromJob()
    var
        DefaultDim: Record "Default Dimension";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimValue: Record "Dimension Value";
        DimSetID: Integer;
    begin
        if "Job No." = '' then
            exit;

        // Check if job has any default dimensions
        DefaultDim.SetRange("Table ID", Database::"PMS Job");
        DefaultDim.SetRange("No.", "Job No.");
        if not DefaultDim.FindSet() then
            exit; // No dimensions to copy

        // Build dimension set from Job's Default Dimensions
        repeat
            if DimValue.Get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then begin
                Clear(TempDimSetEntry);
                TempDimSetEntry."Dimension Code" := DefaultDim."Dimension Code";
                TempDimSetEntry."Dimension Value Code" := DefaultDim."Dimension Value Code";
                // Don't set Dimension Value ID - GetDimensionSetID will handle it
                if TempDimSetEntry.Insert(false) then;
            end;
        until DefaultDim.Next() = 0;

        if TempDimSetEntry.FindFirst() then begin
            DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
            "Dimension Set ID" := DimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(DimSetID, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        end;
    end;
}
