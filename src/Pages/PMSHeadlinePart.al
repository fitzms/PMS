page 80829 "PMS Headline Part"
{
    Caption = 'PMS Headlines';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(CallsToday)
            {
                field(CallsTodayQualifier; CallsTodayQualifier)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Importance = Additional;
                }
                field(CallsTodayText; CallsTodayText)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
        }
    }

    var
        CallsTodayQualifier: Text;
        CallsTodayText: Text;

    trigger OnOpenPage()
    begin
        UpdateHeadlines();
    end;

    local procedure UpdateHeadlines()
    var
        HelpdeskCall: Record "PMS Helpdesk Call";
        CallCount: Integer;
        StartDT: DateTime;
        EndDT: DateTime;
    begin
        StartDT := CreateDateTime(Today, 0T);
        EndDT := CreateDateTime(Today + 1, 0T) - 1;
        HelpdeskCall.SetRange("Reported Date", StartDT, EndDT);
        CallCount := HelpdeskCall.Count();

        CallsTodayQualifier := 'Helpdesk · Today';
        if CallCount = 1 then
            CallsTodayText := '1 call has been logged today'
        else
            CallsTodayText := Format(CallCount) + ' calls have been logged today';
    end;
}
