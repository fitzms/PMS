page 80850 "PMS Property Ledger Entries"
{
    Caption = 'Property Ledger Entries';
    PageType = List;
    SourceTable = "PMS Property Ledger Entry";
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Entries)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor''s invoice reference.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account charged.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description from the posted entry.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor.';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost posted. Credit memos appear as negative amounts.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost centre dimension.';
                }
                field("G/L Entry No."; Rec."G/L Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source G/L entry number.';
                }
            }
        }
        area(FactBoxes)
        {
            part(DimensionSetEntries; 699)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                SubPageLink = "Dimension Set ID" = field("Dimension Set ID");
            }
            part(GLEntriesPart; "G/L Entries Part")
            {
                ApplicationArea = All;
                Caption = 'G/L Entries';
                SubPageLink = "Document No." = field("Document No."), "Posting Date" = field("Posting Date");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(FindEntries)
            {
                ApplicationArea = All;
                Caption = 'Find Entries';
                Image = Navigate;
                ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry.';

                trigger OnAction()
                var
                    NavPage: Page Navigate;
                begin
                    NavPage.SetDoc(Rec."Posting Date", Rec."Document No.");
                    NavPage.Run();
                end;
            }
            action(Dimensions)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View the dimension values for this entry.';

                trigger OnAction()
                var
                    DimSetEntry: Record "Dimension Set Entry";
                begin
                    DimSetEntry.SetRange("Dimension Set ID", Rec."Dimension Set ID");
                    Page.Run(Page::"Dimension Set Entries", DimSetEntry);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Entry)
            {
                Caption = 'Entry';
                actionref(FindEntries_Promoted; FindEntries) { }
                actionref(Dimensions_Promoted; Dimensions) { }
            }
        }
    }

}
