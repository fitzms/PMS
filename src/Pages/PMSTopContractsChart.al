page 80830 "PMS Top Contracts Chart"
{
    Caption = 'Top 10 Suppliers by Contract Value';
    PageType = ListPart;
    SourceTable = Vendor;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier number.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier name.';
                }
                field(TotalContractValue; TotalContractValue)
                {
                    ApplicationArea = All;
                    Caption = 'Total Contract Value';
                    ToolTip = 'Specifies the total value of all contracts for this supplier.';
                }
            }
        }
    }

    var
        TotalContractValue: Decimal;

    trigger OnOpenPage()
    begin
        ApplyTop10VendorFilter();
    end;

    trigger OnAfterGetRecord()
    var
        ContractHdr: Record "PMS Contract Header";
    begin
        TotalContractValue := 0;
        ContractHdr.SetRange("Vendor No.", Rec."No.");
        if ContractHdr.FindSet() then
            repeat
                ContractHdr.CalcFields("Contract Value");
                TotalContractValue += ContractHdr."Contract Value";
            until ContractHdr.Next() = 0;
    end;

    local procedure ApplyTop10VendorFilter()
    var
        ContractHdr: Record "PMS Contract Header";
        VendorTotals: Dictionary of [Code[20], Decimal];
        TopVendors: array[10] of Code[20];
        TopValues: array[10] of Decimal;
        VendorNo: Code[20];
        VendorTotal: Decimal;
        TempVendor: Code[20];
        TempVal: Decimal;
        Count: Integer;
        CurrPos: Integer;
        FilterStr: Text;
        I: Integer;
    begin
        // Aggregate total contract value per vendor
        if ContractHdr.FindSet() then
            repeat
                ContractHdr.CalcFields("Contract Value");
                if (ContractHdr."Vendor No." <> '') and (ContractHdr."Contract Value" > 0) then begin
                    VendorNo := ContractHdr."Vendor No.";
                    if VendorTotals.ContainsKey(VendorNo) then
                        VendorTotals.Set(VendorNo, VendorTotals.Get(VendorNo) + ContractHdr."Contract Value")
                    else
                        VendorTotals.Add(VendorNo, ContractHdr."Contract Value");
                end;
            until ContractHdr.Next() = 0;

        // Pick top 10 from aggregated totals
        Count := 0;
        foreach VendorNo in VendorTotals.Keys do begin
            VendorTotal := VendorTotals.Get(VendorNo);
            CurrPos := 0;
            if Count < 10 then begin
                Count += 1;
                TopVendors[Count] := VendorNo;
                TopValues[Count] := VendorTotal;
                CurrPos := Count;
            end else
                if VendorTotal > TopValues[Count] then begin
                    TopVendors[Count] := VendorNo;
                    TopValues[Count] := VendorTotal;
                    CurrPos := Count;
                end;

            while CurrPos > 1 do begin
                if TopValues[CurrPos] > TopValues[CurrPos - 1] then begin
                    TempVal := TopValues[CurrPos];
                    TempVendor := TopVendors[CurrPos];
                    TopValues[CurrPos] := TopValues[CurrPos - 1];
                    TopVendors[CurrPos] := TopVendors[CurrPos - 1];
                    TopValues[CurrPos - 1] := TempVal;
                    TopVendors[CurrPos - 1] := TempVendor;
                    CurrPos -= 1;
                end else
                    CurrPos := 0;
            end;
        end;

        FilterStr := '';
        for I := 1 to Count do begin
            if FilterStr <> '' then
                FilterStr += '|';
            FilterStr += TopVendors[I];
        end;

        if FilterStr <> '' then
            Rec.SetFilter("No.", FilterStr);
    end;
}
