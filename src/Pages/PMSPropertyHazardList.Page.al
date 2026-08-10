page 80839 "PMS Property Hazard List"
{
    Caption = 'Hazard Entries';
    PageType = List;
    SourceTable = "PMS Property Hazard";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property this hazard belongs to.';
                }
                field("Hazard Type"; Rec."Hazard Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of hazard.';
                }
                field("Hazard Status"; Rec."Hazard Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the hazard.';
                }
                field("Surveyor Ref. Number"; Rec."Surveyor Ref. Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the surveyor reference number for this hazard.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the hazard.';
                }
                field("All Areas"; Rec."All Areas")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the hazard affects all areas of the property.';
                }
                field("Extent of Hazard"; Rec."Extent of Hazard")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the extent of the hazard.';
                }
                field("Next Inspection Date"; Rec."Next Inspection Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the next inspection for this hazard.';
                }
                field("Information Source"; Rec."Information Source")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source of information for this hazard.';
                }
            }
        }
    }
}
