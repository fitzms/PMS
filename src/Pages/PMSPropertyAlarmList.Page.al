page 80841 "PMS Property Alarm List"
{
    Caption = 'Alarm Entries';
    PageType = List;
    SourceTable = "PMS Property Alarm";
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
                    ToolTip = 'Specifies the property this alarm belongs to.';
                }
                field("Alarm Type"; Rec."Alarm Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of alarm.';
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
}
