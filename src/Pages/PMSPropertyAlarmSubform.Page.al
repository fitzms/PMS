page 80833 "PMS Property Alarm Subform"
{
    Caption = 'Alarms';
    PageType = ListPart;
    SourceTable = "PMS Property Alarm";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Alarm Type"; Rec."Alarm Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of alarm (Smoke Detector, Heat Detector, CO1 Detector).';
                }
                field("Date Fitted"; Rec."Date Fitted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the alarm was fitted.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiry date of the alarm.';
                }
                field("Model No."; Rec."Model No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the model number of the alarm.';
                }
                field("Location in House"; Rec."Location in House")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location of the alarm in the house.';
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
        PropertyAlarm: Record "PMS Property Alarm";
    begin
        Rec."Property ID" := PropertyIDVar;
        PropertyAlarm.SetRange("Property ID", PropertyIDVar);
        if PropertyAlarm.FindLast() then
            Rec."Line No." := PropertyAlarm."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;

    var
        PropertyIDVar: Code[20];
}
