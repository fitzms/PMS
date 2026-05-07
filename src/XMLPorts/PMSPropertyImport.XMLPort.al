xmlport 80810 "PMS Property Import"
{
    Caption = 'Property Import';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ',';
    FieldDelimiter = '"';
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(PropertyImport; "PMS Property")
            {
                fieldelement(PropertyID; PropertyImport."Property ID") { }
                fieldelement(KnownAs; PropertyImport."Known As") { }
                fieldelement(Address; PropertyImport.Address) { }
                fieldelement(Address2; PropertyImport."Address 2") { }
                fieldelement(Address3; PropertyImport."Address 3") { }
                fieldelement(City; PropertyImport.City) { }
                fieldelement(County; PropertyImport.County) { }
                fieldelement(Postcode; PropertyImport.Postcode) { }
                fieldelement(CountryRegionCode; PropertyImport."Country/Region Code") { }
                fieldelement(PropertyTypeCode; PropertyImport."Property Type Code") { }
                fieldelement(Status; PropertyImport.Status) { }
                fieldelement(SingleUnit; PropertyImport."Single Unit") { }
                fieldelement(VATElected; PropertyImport."VAT Elected") { }
                fieldelement(LocalAuthority; PropertyImport."Local Authority") { }
                fieldelement(WaterCompany; PropertyImport."Water Company") { }
                fieldelement(Sewerage; PropertyImport.Sewerage) { }

                trigger OnBeforeInsertRecord()
                begin
                    LineCount += 1;

                    if SkipHeaders and (LineCount = 1) then
                        currXMLport.Skip();

                    if PropertyImport."Property ID" = '' then begin
                        PMSSetup.GetRecordOnce();
                        PMSSetup.TestField("Property Nos.");
                        PropertyImport."Property ID" := NoSeries.GetNextNo(PMSSetup."Property Nos.", WorkDate(), true);
                    end;
                end;

                trigger OnAfterInsertRecord()
                begin
                    InsertedCount += 1;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(SkipHeadersField; SkipHeaders)
                    {
                        Caption = 'File Contains Header Row';
                        ApplicationArea = All;
                        ToolTip = 'Enable this if the first row of the CSV file contains column headers.';
                    }
                }
            }
        }
    }

    trigger OnPostXMLport()
    begin
        if GuiAllowed then
            Message(ImportCompleteMsg, InsertedCount);
    end;

    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";
        SkipHeaders: Boolean;
        LineCount: Integer;
        InsertedCount: Integer;
        ImportCompleteMsg: Label '%1 properties imported successfully.';
}
