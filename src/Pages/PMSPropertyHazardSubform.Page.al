page 80836 "PMS Property Hazard Subform"
{
    Caption = 'Hazards';
    PageType = ListPart;
    SourceTable = "PMS Property Hazard";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
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

    procedure SetPropertyID(NewPropertyID: Code[20])
    begin
        PropertyIDVar := NewPropertyID;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PropertyHazard: Record "PMS Property Hazard";
    begin
        Rec."Property ID" := PropertyIDVar;
        PropertyHazard.SetRange("Property ID", PropertyIDVar);
        if PropertyHazard.FindLast() then
            Rec."Line No." := PropertyHazard."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;

    var
        PropertyIDVar: Code[20];
}
