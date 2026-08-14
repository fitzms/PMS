xmlport 80811 "PMS Vendor Invoice Import CRE"
{
    // Based on "Vendor Invoice Import CRE" (50006) with the addition of Direct Unit Cost field.
    // MF01 - 010812 - Modify mapping of "Retouch No." to File No. to support recharge importing of invoices.
    // JF02 - 080812 - Check for valid retouch numbers
    // MF02 - 200213 - Remove the Validate on File Nos
    // JF03 - 150313 - FIX - To fix upload when there is no VAT
    // JF04 - 010414 - FIX - Fix upload for error on FINDFIRST
    // MF03 - 170914 - Modified BEM dimension to "EMPLOYEE" in order to facilitate change of Code Manadatory.
    // AK06 - 051214 - Field added [EsosValue], validation added to fail import if mandatory Esos value is missing.
    // AK07 - 190215 - Fields added [PropertyDim], [TelephoneDim], [VehicleDim].
    // AK08 - 110717 - Fix to import blank decimal values.
    // PMS01 - Added [DirectUnitCost] field; used in preference to computed unit cost when provided.

    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Xml;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(vendorinvoicebuffer; "Vendor Invoice Import Buffer")
            {
                XmlName = 'VendorInvoiceBuffer';
                UseTemporary = true;
                fieldelement(DocumentID; VendorInvoiceBuffer.DocumentID)
                {
                }
                fieldelement(LineNo; VendorInvoiceBuffer.LineNo)
                {
                }
                fieldelement(HorseInvoice; VendorInvoiceBuffer.HorseInvoice)
                {
                }
                fieldelement(QubeDocument; VendorInvoiceBuffer.QubeDocument)
                {
                }
                fieldelement(DocumentType; VendorInvoiceBuffer.DocumentType)
                {
                }
                textelement(documentdate)
                {
                    XmlName = 'DocumentDate';

                    trigger OnAfterAssignVariable()
                    begin
                        Evaluate(VendorInvoiceBuffer.DocumentDate, FormatData(DocumentDate));
                    end;
                }
                fieldelement(BuyfromVendorCode; VendorInvoiceBuffer.BuyFromVendorCode)
                {
                }
                fieldelement(PaytoVendorCode; VendorInvoiceBuffer.PaytoVendorCode)
                {
                }
                textelement(documentgrosstotal)
                {
                    XmlName = 'DocumentGrossTotal';

                    trigger OnAfterAssignVariable()
                    var
                        DecValue: Text[20];
                    begin
                        DecValue := GetNumber(DocumentGrossTotal);
                        if DecValue = '' then
                            VendorInvoiceBuffer.DocumentGrossTotal := 0
                        else
                            Evaluate(VendorInvoiceBuffer.DocumentGrossTotal, DecValue);
                    end;
                }
                fieldelement(Currency; VendorInvoiceBuffer.Currency)
                {
                }
                fieldelement(LineType; VendorInvoiceBuffer.LineType)
                {
                }
                fieldelement(No; VendorInvoiceBuffer.No)
                {
                }
                fieldelement(HMSHorseID; VendorInvoiceBuffer.HMSHorseID)
                {
                }
                fieldelement(HorseID; VendorInvoiceBuffer.HorseID)
                {
                }
                fieldelement(HorseName; VendorInvoiceBuffer.HorseName)
                {
                }
                fieldelement(Dam; VendorInvoiceBuffer.Dam)
                {
                }
                fieldelement(Sire; VendorInvoiceBuffer.Sire)
                {
                }
                fieldelement(YOB; VendorInvoiceBuffer.YOB)
                {
                }
                fieldelement(Description; VendorInvoiceBuffer.Description)
                {
                    trigger OnAfterAssignField()
                    begin
                        VendorInvoiceBuffer.Description := GodolphinFunctions.Ansi2Ascii(VendorInvoiceBuffer.Description);
                    end;
                }
                fieldelement(RetouchNo; VendorInvoiceBuffer."Retouch No.")
                {
                }
                fieldelement(CostCentreDim; VendorInvoiceBuffer.CostCentreDim)
                {
                }
                fieldelement(HorseCatDim; VendorInvoiceBuffer.HorseCatDim)
                {
                }
                fieldelement(BEMDim; VendorInvoiceBuffer.BEMDim)
                {
                }
                fieldelement(ActivityDim; VendorInvoiceBuffer.ActivityDim)
                {
                }
                fieldelement(StallionDim; VendorInvoiceBuffer.StallionDim)
                {
                }
                fieldelement(EntityDim; VendorInvoiceBuffer.EntityDim)
                {
                }
                textelement(quantity)
                {
                    XmlName = 'Quantity';

                    trigger OnAfterAssignVariable()
                    var
                        IntValue: Text[20];
                    begin
                        IntValue := GetNumber(Quantity);
                        if IntValue = '' then
                            VendorInvoiceBuffer.Quantity := 0
                        else
                            Evaluate(VendorInvoiceBuffer.Quantity, IntValue);
                    end;
                }
                textelement(netlineamount)
                {
                    XmlName = 'NetLineAmount';

                    trigger OnAfterAssignVariable()
                    var
                        DecValue: Text[20];
                    begin
                        DecValue := GetNumber(NetLineAmount);
                        if DecValue = '' then
                            VendorInvoiceBuffer.NetLineAmount := 0
                        else
                            Evaluate(VendorInvoiceBuffer.NetLineAmount, DecValue);
                    end;
                }
                textelement(vatlineamount)
                {
                    XmlName = 'VATLineAmount';

                    trigger OnAfterAssignVariable()
                    var
                        DecValue: Text[20];
                    begin
                        DecValue := GetNumber(VATLineAmount);
                        if DecValue = '' then
                            VendorInvoiceBuffer.VATLineAmount := 0
                        else
                            Evaluate(VendorInvoiceBuffer.VATLineAmount, DecValue);
                    end;
                }
                textelement(grosslineamount)
                {
                    XmlName = 'GrossLineAmount';

                    trigger OnAfterAssignVariable()
                    var
                        DecValue: Text[20];
                    begin
                        DecValue := GetNumber(GrossLineAmount);
                        if DecValue = '' then
                            VendorInvoiceBuffer.GrossLineAmount := 0
                        else
                            Evaluate(VendorInvoiceBuffer.GrossLineAmount, DecValue);
                    end;
                }
                textelement(esosvalue)
                {
                    XmlName = 'EsosValue';

                    trigger OnAfterAssignVariable()
                    var
                        DecValue: Text[20];
                    begin
                        DecValue := GetNumber(EsosValue);
                        if DecValue = '' then
                            VendorInvoiceBuffer.EsosValue := 0
                        else
                            Evaluate(VendorInvoiceBuffer.EsosValue, DecValue);
                    end;
                }
                textelement(directunitcost)
                {
                    XmlName = 'DirectUnitCost';

                    trigger OnAfterAssignVariable()
                    var
                        DecValue: Text[20];
                    begin
                        DecValue := GetNumber(DirectUnitCost);
                        if DecValue = '' then
                            VendorInvoiceBuffer."Direct Unit Cost" := 0
                        else
                            Evaluate(VendorInvoiceBuffer."Direct Unit Cost", DecValue);
                    end;
                }
                fieldelement(PropertyDim; VendorInvoiceBuffer.PropertyDim)
                {
                }
                fieldelement(TelephoneDim; VendorInvoiceBuffer.TelephoneDim)
                {
                }
                fieldelement(VehicleDim; VendorInvoiceBuffer.VehicleDim)
                {
                }

                trigger OnAfterInitRecord()
                begin
                    if HeaderExists then begin
                        HeaderExists := false;
                        currXMLport.Skip();
                    end;
                end;

                trigger OnAfterInsertRecord()
                begin
                    if VendorInvoiceBuffer.DocumentID <> '' then begin
                        VendorInvoiceBuffer."Applies-to Document No." := UserId;
                        TempImportBuffer.Init();
                        TempImportBuffer := VendorInvoiceBuffer;
                        TempImportBuffer.Insert();
                    end;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        VendorInvoiceBuffer.SetRange("Applies-to Document No.", UserId);
        TempImportBuffer.Reset();
        if TempImportBuffer.Count > 0 then begin
            if GuiAllowed then Window.Open(Window001 + Window002);
            if CheckEntries then begin
                Commit();
                if not MultipleDocs then
                    if Confirm(Text017) then begin
                        PgPostingDescription.LookupMode(true);
                        if PgPostingDescription.RunModal = Action::LookupOK then
                            PostingDescription := PgPostingDescription.GetDesc;
                    end;
                CreateInvoices;
                Message(StrSubstNo(Text013, EquisoftLogHeader."Equisoft Log No."));
            end
            else
                Message(StrSubstNo(Text012, EquisoftLogHeader."Equisoft Log No."));
            TempImportBuffer.DeleteAll();
        end;
    end;

    trigger OnPreXmlPort()
    begin
        CostCentreDimCode := 'COSTCENTRE';
        HorseCatDimCode := 'HORSECATEGORY';
        BEMDimCode := 'EMPLOYEE';
        ActivityDimCode := 'ACTIVITY';
        StallionDimCode := 'STALLION';
        EntityDimCode := 'ENTITY';

        //AK07 190215 -
        PropertyDimCode := 'PROPERTY';
        TelephoneDimCode := 'TELEPHONE';
        VehicleDimCode := 'VEHICLE';
        //AK07 190215 +

        EquisoftSetup.Get();
        HeaderExists := EquisoftSetup."Purchase File Headings";

        CreateLogHeader(EquisoftLogHeader);
        ErrorLineNo := 100;
    end;

    var
        EquisoftSetup: Record "Equisoft Setup";
        TempImportBuffer: Record "Vendor Invoice Import Buffer" temporary;
        EquisoftLogHeader: Record "Equisoft Log Header";
        Curr: Record Currency;
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        ChargeItem: Record "Item Charge";
        FA: Record "Fixed Asset";
        Horse: Record "Horse";
        Item: Record Item;
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchHeader: Record "Purchase Header";
        Job: Record Job;
        PgPostingDescription: Page "Posting Description CRE";
        GodolphinFunctions: Codeunit "Godolphin Functions CRE";
        FileManagement: Codeunit "File Management";
        varText: Text[1000];
        strFilename: Text[250];
        strFile: Text[250];
        Text001: label 'Buy-from Vendor No. %1 does not exist on line no. %2.';
        Text002: label 'Pay-to Vendor No. %1 does not exist on line no. %2.';
        Text003: label 'Line Type %1 is not valid on line no. %2';
        Text004: label '%1 No. %2 does not exist on line no. %3';
        Text005: label 'Horse ID %1 does not exist on line no. %2';
        Text006: label '%1 dimension code value %2 does not exist on line no. %3';
        Text007: label 'The net and vat amount does not total the gross amount on line no. %1';
        Text008: label 'Currency Code %1 does not exist on line no. %2';
        Text009: label 'Sum of line total does not equal invoice total';
        Text010: label 'Purchase %1 No. %2 created for documentid %3.';
        Text011: label 'You cannot import entries into a document when lines already exist.';
        Text012: label 'Log No. %1\\Errors exist in the import file. Please check the Equisoft log entries for details.';
        Text013: label 'Log No. %1\\Records import successfully. Please check the Equisoft log entries for details.';
        Text014: label 'Vendor No. %1 document number %2 already exists on their ledger - line no. %3';
        Text015: label 'Vendor No. %1 document number %2 already exists as an unposted invoice - line no. %3';
        Text016: label 'Vendor No. %1 document number %2 already exists as an unposted credit memo - line no. %3';
        Text017: label 'As only one document is being imported, would you like to give it a posting description?';
        Text018: label 'File %1 does not exist on line no. %2';
        Window001: label 'Checking Lines     @1@@@@@@@@@@@@@@@@@\';
        Window002: label 'Creating Documents @2@@@@@@@@@@@@@@@@@';
        Text019: label 'ESOS Value on line no. %1 must not be zero as %2 No. %3 flagged as ESOS value mandatory.';
        PostingDescription: Text[100];
        CostCentreDimCode: Code[20];
        HorseCatDimCode: Code[20];
        BEMDimCode: Code[20];
        ActivityDimCode: Code[20];
        StallionDimCode: Code[20];
        EntityDimCode: Code[20];
        DocNo: Code[20];
        PropertyDimCode: Code[20];
        TelephoneDimCode: Code[20];
        VehicleDimCode: Code[20];
        ErrorFile: File;
        ErrorLineNo: Integer;
        DocType: Integer;
        iRec: Integer;
        iRecs: Integer;
        II: Integer;
        Window: Dialog;
        bErrorFile: Boolean;
        HeaderExists: Boolean;
        SingleInvoiceRecord: Boolean;
        bInsert: Boolean;
        LogCreated: Boolean;
        MultipleDocs: Boolean;
        DocErrors: Boolean;

    /// <summary>Strips a leading currency symbol (£, $, ú) from a numeric string.</summary>
    /// <param name="StrIn">The raw text value from the import file.</param>
    /// <returns>The numeric portion of the string, or empty if the input is empty.</returns>
    procedure GetNumber(StrIn: Text[1024]): Text[1024]
    var
        StrOut: Text[1024];
    begin
        if StrLen(StrIn) = 0 then exit('');
        if CopyStr(StrIn, 1, 1) in ['£', '$', 'ú'] then
            exit(CopyStr(StrIn, 2, StrLen(StrIn) - 1))
        else
            exit(StrIn);
    end;

    /// <summary>Initialises and inserts a new Equisoft Log Header record for a Purchase Invoice import run.</summary>
    /// <param name="EqLogHeader">Returns the newly created log header.</param>
    procedure CreateLogHeader(var EqLogHeader: Record "Equisoft Log Header")
    begin
        EqLogHeader.Init();
        EqLogHeader."Import Type" := EqLogHeader."import type"::"Purchase Invoices";
        EqLogHeader.Insert(true);
        LogCreated := true;
    end;

    /// <summary>Returns the Equisoft Log Header created during the current import run.</summary>
    /// <param name="pEquisoftLogHeader">Set to the current log header on return.</param>
    procedure GetLogHeader(var pEquisoftLogHeader: Record "Equisoft Log Header")
    begin
        pEquisoftLogHeader := EquisoftLogHeader;
    end;

    /// <summary>Appends a detail line to the Equisoft import log.</summary>
    /// <param name="EqLogHeader">The parent log header record.</param>
    /// <param name="LogLineNo">Current log line sequence number; incremented by 100 on exit.</param>
    /// <param name="LineType">Severity/category of the log entry.</param>
    /// <param name="No">Document or record identifier associated with this entry.</param>
    /// <param name="LogDetails">Human-readable description of the log event.</param>
    /// <param name="OldValue">Previous field value (for change-tracking entries).</param>
    /// <param name="NewValue">New field value (for change-tracking entries).</param>
    /// <param name="RecordType">Optional link back to a related record type.</param>
    /// <param name="RecordNo">Optional linked record number.</param>
    /// <param name="ReturnLineNo">Unused out parameter retained for signature compatibility.</param>
    procedure CreateLogLine(EqLogHeader: Record "Equisoft Log Header"; var LogLineNo: Integer; LineType: Option " ",Data,Journal,"Record"; No: Code[20]; LogDetails: Text[250]; OldValue: Text[50]; NewValue: Text[50]; RecordType: Option " ",Customer; RecordNo: Code[20]; var ReturnLineNo: Integer)
    var
        EqLogLines: Record "Equisoft Log Lines";
    begin
        EqLogLines."Equisoft Log No." := EqLogHeader."Equisoft Log No.";
        EqLogLines."Import Type" := EqLogHeader."Import Type";
        EqLogLines."Line No." := LogLineNo;
        EqLogLines."Line Type" := "Equisoft Log Line Type CRE".FromInteger(LineType);
        EqLogLines."No." := No;
        EqLogLines.Details := LogDetails;
        EqLogLines."Old Value" := OldValue;
        EqLogLines."New Value" := NewValue;
        EqLogLines."Record Link" := "Equisoft Log Record Link CRE".FromInteger(RecordType);
        EqLogLines."Record No." := RecordNo;
        EqLogLines.Insert();
        LogLineNo := LogLineNo + 100;
    end;

    /// <summary>Validates all records in the import buffer: document totals, vendor existence, duplicate detection, currency, line types, dimensions, and ESOS values.</summary>
    /// <returns>True if no errors were found; false if any validation failed.</returns>
    procedure CheckEntries(): Boolean
    var
        ImportBuffer2: Record "Vendor Invoice Import Buffer";
        DocNo: Code[20];
        DocTotal: Decimal;
        DocLineTotal: Decimal;
    begin
        bInsert := true;

        //Checking document totals
        TempImportBuffer.Reset();
        if TempImportBuffer.FindSet() then begin
            iRecs := TempImportBuffer.Count;
            DocNo := TempImportBuffer.DocumentID;
            DocTotal := TempImportBuffer.DocumentGrossTotal;
            repeat
                if DocNo <> TempImportBuffer.DocumentID then begin
                    if DocLineTotal <> DocTotal then begin
                        CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, TempImportBuffer.DocumentID,
                          Text009 + ' ' + Format(DocTotal) + ' - ' + Format(DocLineTotal), '', '', 0, '', TempImportBuffer.LineNo);
                        bInsert := false;
                        DocNo := TempImportBuffer.DocumentID;
                        DocTotal := TempImportBuffer.DocumentGrossTotal;
                        DocLineTotal := 0;
                        MultipleDocs := true;
                    end
                    else begin
                        DocNo := TempImportBuffer.DocumentID;
                        DocTotal := TempImportBuffer.DocumentGrossTotal;
                        DocLineTotal := 0;
                        MultipleDocs := true;
                    end;
                end;
                DocLineTotal += TempImportBuffer.GrossLineAmount;
            until TempImportBuffer.Next() = 0;
            if DocLineTotal <> DocTotal then begin
                CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, TempImportBuffer.DocumentID,
                  Text009 + ' ' + Format(DocTotal) + ' - ' + Format(DocLineTotal), '', '', 0, '', TempImportBuffer.LineNo);
                bInsert := false;
                DocTotal := TempImportBuffer.DocumentGrossTotal;
                DocLineTotal := 0;
            end;
        end;

        if not bInsert then begin
            DocErrors := true;
            TempImportBuffer."Line Error" := true;
            TempImportBuffer.Modify();
            ImportBuffer2.SetRange(DocumentID, TempImportBuffer.DocumentID);
            ImportBuffer2.ModifyAll("Document Error", true);
        end;

        TempImportBuffer.Reset();
        if TempImportBuffer.FindSet() then begin
            repeat
                if GuiAllowed then Window.Update(1, ROUND(iRec / iRecs * 10000, 1));
                iRec += 1;
                bInsert := true;
                with TempImportBuffer do begin
                    if not SingleInvoiceRecord then begin
                        if not Vend.Get(BuyFromVendorCode) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text001, BuyFromVendorCode, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                        if not Vend.Get(PaytoVendorCode) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text002, PaytoVendorCode, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end
                        else begin
                            VendLedgEntry.SetCurrentkey("External Document No.", "Document Type", "Vendor No.");
                            VendLedgEntry.SetRange("External Document No.", DocumentID);
                            VendLedgEntry.SetRange("Vendor No.", PaytoVendorCode);
                            if VendLedgEntry.FindSet() then begin
                                CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                  StrSubstNo(Text014, PaytoVendorCode, DocumentID, LineNo), '', '', 0, '', LineNo);
                                bInsert := false;
                            end
                            else begin
                                case DocumentType of
                                    'Invoice':
                                        begin
                                            PurchHeader.SetRange("Document Type", PurchHeader."document type"::Invoice);
                                            PurchHeader.SetRange("Vendor Invoice No.", DocumentID);
                                            PurchHeader.SetRange("Pay-to Vendor No.", PaytoVendorCode);
                                            if PurchHeader.FindSet() then begin
                                                CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                                  StrSubstNo(Text015, PaytoVendorCode, DocumentID, LineNo), '', '', 0, '', LineNo);
                                                bInsert := false;
                                            end;
                                        end;
                                    'Credit Memo':
                                        begin
                                            PurchHeader.SetRange("Document Type", PurchHeader."document type"::Invoice);
                                            PurchHeader.SetRange("Vendor Cr. Memo No.", DocumentID);
                                            PurchHeader.SetRange("Pay-to Vendor No.", PaytoVendorCode);
                                            if PurchHeader.FindSet() then begin
                                                CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                                  StrSubstNo(Text016, PaytoVendorCode, DocumentID, LineNo), '', '', 0, '', LineNo);
                                                bInsert := false;
                                            end;
                                        end;
                                end;
                            end;
                        end;
                    end;

                    GLSetup.Get();
                    if GLSetup."LCY Code" <> Currency then begin
                        if not Curr.Get(Currency) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text008, Currency, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;

                    if not (LineType in ['G/L Account', 'Item', 'Fixed Asset', 'Charge (Item)', 'Horse']) then begin
                        CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                          StrSubstNo(Text003, LineType, LineNo), '', '', 0, '', LineNo);
                        bInsert := false;
                    end
                    else begin
                        case LineType of
                            'Item':
                                begin
                                    if not Item.Get(No) then begin
                                        CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                          StrSubstNo(Text004, LineType, No, LineNo), '', '', 0, '', LineNo);
                                        bInsert := false;
                                    end;
                                end;
                            'G/L Account':
                                begin
                                    if not GLAcc.Get(No) then begin
                                        CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                          StrSubstNo(Text004, LineType, No, LineNo), '', '', 0, '', LineNo);
                                        bInsert := false;
                                    end
                                    else begin
                                        if (GLAcc."ESOS Mand. For PurInvCre CRE") and
                                          (TempImportBuffer.EsosValue = 0)
                                        then begin
                                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                              StrSubstNo(Text019, LineNo, LineType, No), '', '', 0, '', LineNo);
                                            bInsert := false;
                                        end;
                                    end;
                                end;
                            'Fixed Asset':
                                begin
                                    if not FA.Get(No) then begin
                                        CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                          StrSubstNo(Text004, LineType, No, LineNo), '', '', 0, '', LineNo);
                                        bInsert := false;
                                    end;
                                end;
                            'Horse':
                                begin
                                    if not Horse.Get(No) then begin
                                        CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                          StrSubstNo(Text004, LineType, No, LineNo), '', '', 0, '', LineNo);
                                        bInsert := false;
                                    end;
                                end;
                            'Charge (Item)':
                                begin
                                    if not ChargeItem.Get(No) then begin
                                        CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                                          StrSubstNo(Text004, LineType, No, LineNo), '', '', 0, '', LineNo);
                                        bInsert := false;
                                    end;
                                end;
                        end;
                    end;

                    if HMSHorseID <> '' then begin
                        if not Horse.Get(HMSHorseID) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text005, HMSHorseID, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    //Check Dimensions
                    if CostCentreDim <> '' then begin
                        if not DimValue.Get(CostCentreDimCode, CostCentreDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, CostCentreDimCode, CostCentreDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    if HorseCatDim <> '' then begin
                        if not DimValue.Get(HorseCatDimCode, HorseCatDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, HorseCatDimCode, HorseCatDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    if BEMDim <> '' then begin
                        if not DimValue.Get(BEMDimCode, BEMDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, BEMDimCode, BEMDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    if ActivityDim <> '' then begin
                        if not DimValue.Get(ActivityDimCode, ActivityDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, ActivityDimCode, ActivityDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    if StallionDim <> '' then begin
                        if not DimValue.Get(StallionDimCode, StallionDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, StallionDimCode, StallionDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    if EntityDim <> '' then begin
                        if not DimValue.Get(EntityDimCode, EntityDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, EntityDimCode, EntityDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;

                    //JF02 080812 -
                    if "Retouch No." <> '' then begin
                        if not Job.Get("Retouch No.") then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text018, "Retouch No.", LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    //JF02 080812 +

                    if (NetLineAmount + VATLineAmount) <> GrossLineAmount then begin
                        CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                          StrSubstNo(Text007, LineNo), '', '', 0, '', LineNo);
                        bInsert := false;
                    end;

                    //AK07 19/20/15 -
                    if PropertyDim <> '' then begin
                        if not DimValue.Get(PropertyDimCode, PropertyDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, PropertyDimCode, PropertyDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    if TelephoneDim <> '' then begin
                        if not DimValue.Get(TelephoneDimCode, TelephoneDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, TelephoneDimCode, TelephoneDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    if VehicleDim <> '' then begin
                        if not DimValue.Get(VehicleDimCode, VehicleDim) then begin
                            CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, DocumentID,
                              StrSubstNo(Text006, VehicleDimCode, VehicleDim, LineNo), '', '', 0, '', LineNo);
                            bInsert := false;
                        end;
                    end;
                    //AK07 19/20/15 +

                end;

                if not bInsert then begin
                    DocErrors := true;
                    TempImportBuffer."Line Error" := true;
                    TempImportBuffer.Modify();
                    ImportBuffer2.SetRange(DocumentID, TempImportBuffer.DocumentID);
                    ImportBuffer2.ModifyAll("Document Error", true);
                end;
            until TempImportBuffer.Next() = 0;
            exit(not DocErrors);
        end;
    end;

    /// <summary>Creates Purchase Header and Line records from validated import buffer rows, applying dimensions, horse matrix entries, and VAT difference adjustments.</summary>
    procedure CreateInvoices()
    var
        EquisoftSetup: Record "Equisoft Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        HorseMatrixLine: Record "Horse Matrix Buffer";
        Text001: label 'Document type does not exist %1.';
        ReleaseDoc: Codeunit "Release Purchase Document";
        LineNo: Integer;
        cDocumentTotal: Decimal;
        DocNo: Code[20];
        Horse: Record "Horse";
        DocGrossAmount: Decimal;
    begin
        iRec := 1;
        TempImportBuffer.SetRange("Document Error", false);
        TempImportBuffer.SetRange("Document Created", false);
        if TempImportBuffer.FindSet() then begin
            if not LogCreated then CreateLogHeader(EquisoftLogHeader);
            EquisoftSetup.Get();
            EquisoftSetup.TestField("VAT Prod. Posting Group");
            EquisoftSetup.TestField("No VAT Prod. Posting Group");

            iRecs := TempImportBuffer.Count;
            repeat
                if DocNo <> TempImportBuffer.DocumentID then begin
                    if DocNo <> '' then begin
                        //Check Document Total for VAT difference
                        cDocumentTotal := CalcTotalAmount(PurchHeader);
                        //JF04 - 010414 -
                        if DocGrossAmount <> cDocumentTotal then begin
                            //JF04 - 010414 +
                            PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                            PurchLine.SetRange("Document No.", PurchHeader."No.");
                            PurchLine.SetRange("VAT Prod. Posting Group", EquisoftSetup."VAT Prod. Posting Group");
                            PurchLine.FindFirst();
                            PurchLine."VAT Difference" := PurchHeader."Document Total CRE" - cDocumentTotal;
                            PurchLine.Modify(true);
                        end;
                    end;

                    PurchHeader.SetHideValidationDialog(true);
                    PurchHeader.Init();
                    if TempImportBuffer.DocumentType = 'Invoice' then
                        PurchHeader."Document Type" := PurchHeader."document type"::Invoice
                    else
                        if TempImportBuffer.DocumentType = 'Credit Memo' then
                            PurchHeader."Document Type" := PurchHeader."document type"::"Credit Memo"
                        else
                            Error(StrSubstNo(Text001, TempImportBuffer.DocumentType));
                    PurchHeader."No." := '';
                    PurchHeader.Insert(true);
                    CreateLogLine(EquisoftLogHeader, ErrorLineNo, 3, TempImportBuffer.DocumentID,
                      StrSubstNo(Text010, PurchHeader."Document Type", PurchHeader."No.",
                        TempImportBuffer.DocumentID), '', '', 0, '', LineNo);

                    PurchHeader.Validate("Posting Date", TempImportBuffer.DocumentDate);
                    PurchHeader.Validate("Buy-from Vendor No.", TempImportBuffer.BuyFromVendorCode);
                    PurchHeader.Validate("Pay-to Vendor No.", TempImportBuffer.PaytoVendorCode);
                    PurchHeader.Validate("Currency Code", GetCurrencyCode(TempImportBuffer.Currency));
                    if PurchHeader."Document Type" = PurchHeader."document type"::Invoice then
                        PurchHeader."Vendor Invoice No." := TempImportBuffer.DocumentID;
                    if PurchHeader."Document Type" = PurchHeader."document type"::"Credit Memo" then
                        PurchHeader."Vendor Cr. Memo No." := TempImportBuffer.DocumentID;
                    PurchHeader."Horse Invoice CRE" := TempImportBuffer.HorseInvoice;
                    PurchHeader."Qube Document CRE" := TempImportBuffer.QubeDocument;
                    PurchHeader."Document Total CRE" := TempImportBuffer.DocumentGrossTotal;
                    if PostingDescription <> '' then
                        PurchHeader."Posting Description" := PostingDescription
                    else begin
                        if PurchHeader."Horse Invoice CRE" then begin
                            PurchHeader."Posting Description" := CopyStr(StrSubstNo('%1 - %2', Format(PurchHeader."Document Date"),
                              TempImportBuffer.Description), 1, 100);
                        end
                        else begin
                            PurchHeader."Posting Description" := TempImportBuffer.Description;
                        end;
                    end;
                    PurchHeader."Imported CRE" := true;
                    PurchHeader.Modify(true);

                    LineNo := 10000;
                    DocNo := TempImportBuffer.DocumentID;
                end;

                if GuiAllowed then Window.Update(2, ROUND(iRec / iRecs * 10000, 1));
                iRec += 1;

                PurchLine.Init();
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := LineNo;
                PurchLine.Insert(true);
                Evaluate(PurchLine.Type, TempImportBuffer.LineType);
                PurchLine.Validate("No.", TempImportBuffer.No);
                PurchLine."Job No." := TempImportBuffer."Retouch No."; //MF02
                PurchLine.Validate(Quantity, TempImportBuffer.Quantity);
                if TempImportBuffer.VATLineAmount <> 0 then
                    PurchLine.Validate("VAT Prod. Posting Group", EquisoftSetup."VAT Prod. Posting Group")
                else
                    PurchLine.Validate("VAT Prod. Posting Group", EquisoftSetup."No VAT Prod. Posting Group");
                //PMS01 - use supplied Direct Unit Cost when provided, otherwise derive from line amounts
                if TempImportBuffer."Direct Unit Cost" <> 0 then
                    PurchLine.Validate("Direct Unit Cost", TempImportBuffer."Direct Unit Cost")
                else if PurchHeader."Prices Including VAT" then
                    PurchLine.Validate("Direct Unit Cost", TempImportBuffer.NetLineAmount + TempImportBuffer.VATLineAmount)
                else
                    PurchLine.Validate("Direct Unit Cost", TempImportBuffer.NetLineAmount);
                PurchLine.Description := TempImportBuffer.Description;

                PurchLine.Validate("ESOS Unit CRE", TempImportBuffer.EsosValue);  //AK06 ESOS Value

                if TempImportBuffer.HMSHorseID <> '' then begin
                    PurchLine.Validate("Horse ID CRE", TempImportBuffer.HMSHorseID);
                    if PurchHeader."Horse Invoice CRE" then begin
                        PurchLine."Horse Line CRE" := true;
                        Horse.Get(PurchLine."Horse ID CRE");
                        PurchLine.Description := CopyStr(StrSubstNo('%1 - %2', Horse.Name, TempImportBuffer.Description), 1, 100);
                        HorseMatrixLine.SetRange("Document Type", PurchHeader."Document Type");
                        HorseMatrixLine.SetRange("Document No.", PurchHeader."No.");
                        HorseMatrixLine.SetRange("Horse ID", PurchLine."Horse ID CRE");
                        if not HorseMatrixLine.FindFirst() then begin
                            HorseMatrixLine.Init();
                            HorseMatrixLine."Document Type" := PurchHeader."Document Type";
                            HorseMatrixLine."Document No." := PurchHeader."No.";
                            HorseMatrixLine."Line No." := PurchLine."Line No.";
                            HorseMatrixLine."Horse ID" := PurchLine."Horse ID CRE";
                            HorseMatrixLine.Insert();
                        end;
                    end;
                end;
                PurchLine.Modify(true);

                if TempImportBuffer.CostCentreDim <> '' then
                    AddDimensionLine(PurchLine, CostCentreDimCode, TempImportBuffer.CostCentreDim);
                if TempImportBuffer.HorseCatDim <> '' then
                    AddDimensionLine(PurchLine, HorseCatDimCode, TempImportBuffer.HorseCatDim);
                if TempImportBuffer.BEMDim <> '' then
                    AddDimensionLine(PurchLine, BEMDimCode, TempImportBuffer.BEMDim);
                if TempImportBuffer.ActivityDim <> '' then
                    AddDimensionLine(PurchLine, ActivityDimCode, TempImportBuffer.ActivityDim);
                if TempImportBuffer.StallionDim <> '' then
                    AddDimensionLine(PurchLine, StallionDimCode, TempImportBuffer.StallionDim);
                if TempImportBuffer.EntityDim <> '' then
                    AddDimensionLine(PurchLine, EntityDimCode, TempImportBuffer.EntityDim);

                //AK07 19/20/15 -
                if TempImportBuffer.PropertyDim <> '' then
                    AddDimensionLine(PurchLine, PropertyDimCode, TempImportBuffer.PropertyDim);
                if TempImportBuffer.TelephoneDim <> '' then
                    AddDimensionLine(PurchLine, TelephoneDimCode, TempImportBuffer.TelephoneDim);
                if TempImportBuffer.VehicleDim <> '' then
                    AddDimensionLine(PurchLine, VehicleDimCode, TempImportBuffer.VehicleDim);
                //AK07 19/20/15 +

                LineNo += 10000;
                TempImportBuffer."Document Created" := true;
                TempImportBuffer.Modify();
                DocGrossAmount := TempImportBuffer.DocumentGrossTotal;
            until TempImportBuffer.Next() = 0;

            //Check Document Total for VAT difference
            cDocumentTotal := CalcTotalAmount(PurchHeader);
            //JF03 - 150313 -
            if TempImportBuffer.DocumentGrossTotal <> cDocumentTotal then begin
                //JF03 - 150313 +
                PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                PurchLine.SetRange("Document No.", PurchHeader."No.");
                PurchLine.SetRange("VAT Prod. Posting Group", EquisoftSetup."VAT Prod. Posting Group");
                PurchLine.FindFirst();
                PurchLine."VAT Difference" := PurchHeader."Document Total CRE" - cDocumentTotal;
                PurchLine.Modify(true);
            end;
        end;
    end;

    /// <summary>Adds or updates a dimension value on a purchase line, rebuilding the Dimension Set ID afterwards.</summary>
    /// <param name="PurchLine">The purchase line to update; modified in place.</param>
    /// <param name="DimensionCode">The dimension code to set (e.g. COSTCENTRE).</param>
    /// <param name="DimensionValueCode">The dimension value to assign.</param>
    procedure AddDimensionLine(var PurchLine: Record "Purchase Line"; DimensionCode: Code[20]; DimensionValueCode: Code[20])
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, PurchLine."Dimension Set ID");
        TempDimSetEntry.SetRange("Dimension Set ID", PurchLine."Dimension Set ID");
        TempDimSetEntry.SetRange("Dimension Code", DimensionCode);
        if not TempDimSetEntry.FindFirst() then begin
            TempDimSetEntry.Reset();
            TempDimSetEntry.Init();
            TempDimSetEntry.Validate("Dimension Set ID", PurchLine."Dimension Set ID");
            TempDimSetEntry.Validate("Dimension Code", DimensionCode);
            TempDimSetEntry.Validate("Dimension Value Code", DimensionValueCode);
            TempDimSetEntry.Insert();
            PurchLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
            DimMgt.UpdateGlobalDimFromDimSetID(
              PurchLine."Dimension Set ID", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code");
            PurchLine.Modify();
        end else begin
            TempDimSetEntry.Validate("Dimension Value Code", DimensionValueCode);
            TempDimSetEntry.Modify();
            PurchLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
            DimMgt.UpdateGlobalDimFromDimSetID(
              PurchLine."Dimension Set ID", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code");
            PurchLine.Modify();
        end;
    end;

    /// <summary>Converts an import currency code to a BC currency code, returning blank when the code matches the local currency.</summary>
    /// <param name="CurrCode">The currency code from the import file.</param>
    /// <returns>The BC currency code, or empty string for LCY.</returns>
    procedure GetCurrencyCode(CurrCode: Code[20]) CurrencyCode: Code[20]
    var
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
    begin
        GLSetup.Get();
        if CurrCode = GLSetup."LCY Code" then exit('');

        Currency.Reset();
        Currency.SetRange(Code, CurrCode);
        if Currency.FindFirst() then
            exit(Currency.Code)
        else
            Error(StrSubstNo(Text004, CurrCode));
    end;

    /// <summary>Calculates the sum of Amount Including VAT across all purchase lines for the given header.</summary>
    /// <param name="PurchHeader">The purchase document to total.</param>
    /// <returns>The gross document total in document currency.</returns>
    procedure CalcTotalAmount(PurchHeader: Record "Purchase Header"): Decimal
    var
        PurchLine: Record "Purchase Line";
        Total: Decimal;
    begin
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindSet() then
            repeat
                Total += PurchLine."Amount Including VAT";
            until PurchLine.Next() = 0;
        exit(Total);
    end;

    /// <summary>Normalises a raw text value by evaluating it as an integer, decimal, or datetime and returning the standard BC-formatted string; used to coerce date strings from the import file.</summary>
    /// <param name="TextToFormat">The raw text value to normalise.</param>
    /// <returns>The normalised string, or the original value if no type matched.</returns>
    procedure FormatData(TextToFormat: Text[250]): Text[250]
    var
        FormatInteger: Integer;
        FormatDecimal: Decimal;
        FormatDate: Date;
        FormatDateTime: DateTime;
    begin
        case true of
            Evaluate(FormatInteger, TextToFormat):
                exit(Format(FormatInteger));
            Evaluate(FormatDecimal, TextToFormat):
                exit(Format(FormatDecimal));
            Evaluate(FormatDateTime, TextToFormat):
                exit(Format(Dt2Date(FormatDateTime)));
            else
                exit(TextToFormat);
        end;
    end;

    /// <summary>Returns the overall success status of the import run.</summary>
    /// <returns>True if no errors were encountered; false otherwise.</returns>
    procedure GetErrorStatus(): Boolean
    begin
        exit(not DocErrors);
    end;
}
