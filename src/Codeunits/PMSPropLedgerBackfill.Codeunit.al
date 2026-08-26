codeunit 80802 "PMS Prop Ledger Backfill"
{
    procedure RunBackfill(PropertyFilter: Code[20])
    var
        GLEntry: Record "G/L Entry";
        DimSetEntry: Record "Dimension Set Entry";
        PropLedgEntry: Record "PMS Property Ledger Entry";
        PMSSetup: Record "PMS Setup";
        CatPostingGroup: Record "PMS Cat. Posting Group";
        AccountList: List of [Code[20]];
        AccountNo: Code[20];
        NextEntryNo: Integer;
        EntriesCreated: Integer;
    begin
        PMSSetup.GetRecordOnce();
        PMSSetup.TestField("Property Dimension Code");

        // Collect unique G/L accounts from all Category Posting Groups
        if CatPostingGroup.FindSet() then
            repeat
                if (CatPostingGroup."G/L Account No." <> '') and
                   (not AccountList.Contains(CatPostingGroup."G/L Account No.")) then
                    AccountList.Add(CatPostingGroup."G/L Account No.");
            until CatPostingGroup.Next() = 0;

        if AccountList.Count = 0 then
            Error('No G/L accounts are configured in Category Posting Groups.');

        // Lock once before the loop; incrementing locally avoids per-row lock contention
        NextEntryNo := PropLedgEntry.GetNextEntryNo();

        foreach AccountNo in AccountList do begin
            GLEntry.SetRange("G/L Account No.", AccountNo);
            GLEntry.SetRange("Source Type", GLEntry."Source Type"::Vendor);
            if GLEntry.FindSet() then
                repeat
                    // Primary key lookup: Dimension Set ID + Dimension Code
                    DimSetEntry.Reset();
                    DimSetEntry.SetRange("Dimension Set ID", GLEntry."Dimension Set ID");
                    DimSetEntry.SetRange("Dimension Code", PMSSetup."Property Dimension Code");
                    if PropertyFilter <> '' then
                        DimSetEntry.SetRange("Dimension Value Code", PropertyFilter)
                    else
                        DimSetEntry.SetFilter("Dimension Value Code", '<>%1', '');

                    if DimSetEntry.FindFirst() then begin
                        PropLedgEntry.SetRange("G/L Entry No.", GLEntry."Entry No.");
                        if PropLedgEntry.IsEmpty() then begin
                            PropLedgEntry.Init();
                            PropLedgEntry."Entry No." := NextEntryNo;
                            PropLedgEntry."Property ID" := DimSetEntry."Dimension Value Code";
                            PropLedgEntry."Posting Date" := GLEntry."Posting Date";
                            PropLedgEntry."Document Type" := GLEntry."Document Type";
                            PropLedgEntry."Document No." := GLEntry."Document No.";
                            PropLedgEntry."External Document No." := GLEntry."External Document No.";
                            PropLedgEntry."G/L Account No." := GLEntry."G/L Account No.";
                            PropLedgEntry.Description := GLEntry.Description;
                            PropLedgEntry."Cost Amount" := GLEntry.Amount;
                            PropLedgEntry."Vendor No." := GLEntry."Source No.";
                            PropLedgEntry."Global Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                            PropLedgEntry."Dimension Set ID" := GLEntry."Dimension Set ID";
                            PropLedgEntry."G/L Entry No." := GLEntry."Entry No.";
                            PropLedgEntry.Insert(false);
                            NextEntryNo += 1;
                            EntriesCreated += 1;
                        end;
                    end;
                until GLEntry.Next() = 0;
        end;

        Message('%1 property ledger entr(ies) created.', EntriesCreated);
    end;

    procedure DeletePropertyEntries(PropertyFilter: Code[20])
    var
        PropLedgEntry: Record "PMS Property Ledger Entry";
        DeletedCount: Integer;
    begin
        PropLedgEntry.SetRange("Property ID", PropertyFilter);
        DeletedCount := PropLedgEntry.Count();
        if DeletedCount = 0 then begin
            Message('No property ledger entries found for property %1.', PropertyFilter);
            exit;
        end;
        if not Confirm('Delete %1 property ledger entr(ies) for property %2?', false, DeletedCount, PropertyFilter) then
            exit;
        PropLedgEntry.DeleteAll(false);
        Message('%1 property ledger entr(ies) deleted for property %2.', DeletedCount, PropertyFilter);
    end;
}
