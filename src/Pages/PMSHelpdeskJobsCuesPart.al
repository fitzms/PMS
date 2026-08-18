page 80804 "PMS Helpdesk Jobs Cues Part"
{
    Caption = 'Helpdesk and Jobs';
    PageType = CardPart;
    SourceTable = "PMS Role Center Cues";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            // ── Helpdesk All ──────────────────────────────────────────────────
            cuegroup("Helpdesk All")
            {
                Caption = 'Helpdesk - All';

                field("Open Calls"; Rec."Open Calls")
                {
                    ApplicationArea = All;
                    Caption = 'Open Calls';
                    StyleExpr = OpenCallsStyle;

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetFilter(Status, '<>%1', HelpdeskCall.Status::Closed);
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
                field("New Helpdesk Calls"; Rec."New Helpdesk Calls")
                {
                    ApplicationArea = All;
                    Caption = 'Open Calls';
                    StyleExpr = NewCallsStyle;

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetRange(Status, HelpdeskCall.Status::Open);
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
                field("Critical Calls"; Rec."Critical Calls")
                {
                    ApplicationArea = All;
                    Caption = 'Critical';
                    StyleExpr = CriticalCallsStyle;

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetRange(Priority, HelpdeskCall.Priority::Critical);
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
            }

            cuegroup("My Helpdesk Calls")
            {
                Caption = 'My Helpdesk Calls';

                field("My New Calls"; Rec."My New Calls")
                {
                    ApplicationArea = All;
                    Caption = 'My Open Calls';
                    StyleExpr = MyNewCallsStyle;

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetRange(Status, HelpdeskCall.Status::Open);
                        HelpdeskCall.SetRange("Employee No.", UserId());
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
                field("My Calls"; Rec."My Calls")
                {
                    ApplicationArea = All;
                    Caption = 'Calls';
                    StyleExpr = MyCallsStyle;

                    trigger OnDrillDown()
                    var
                        HelpdeskCall: Record "PMS Helpdesk Call";
                        HelpdeskList: Page "PMS Helpdesk Call List";
                    begin
                        HelpdeskCall.SetRange("Call Type", HelpdeskCall."Call Type"::Internal);
                        HelpdeskCall.SetRange("Employee No.", UserId());
                        HelpdeskCall.SetFilter(Status, '<>%1', HelpdeskCall.Status::Closed);
                        HelpdeskList.SetTableView(HelpdeskCall);
                        HelpdeskList.Run();
                    end;
                }
            }

            // ── Jobs All ──────────────────────────────────────────────────────
            cuegroup("Jobs All")
            {
                Caption = 'Jobs - All';

                field("Open Jobs"; Rec."Open Jobs")
                {
                    ApplicationArea = All;
                    Caption = 'Open';
                    StyleExpr = OpenJobsStyle;
                    DrillDownPageId = "PMS Job List";

                    trigger OnDrillDown()
                    var
                        Job: Record "PMS Job";
                        JobList: Page "PMS Job List";
                    begin
                        Job.SetRange(Status, Job.Status::Open);
                        JobList.SetTableView(Job);
                        JobList.Run();
                    end;
                }
                field("Jobs In Progress"; Rec."Jobs In Progress")
                {
                    ApplicationArea = All;
                    Caption = 'In Progress';
                    StyleExpr = InProgressJobsStyle;
                    DrillDownPageId = "PMS Job List";

                    trigger OnDrillDown()
                    var
                        Job: Record "PMS Job";
                        JobList: Page "PMS Job List";
                    begin
                        Job.SetRange(Status, Job.Status::"In Progress");
                        JobList.SetTableView(Job);
                        JobList.Run();
                    end;
                }
                field("Jobs Due Today"; Rec."Jobs Due Today")
                {
                    ApplicationArea = All;
                    Caption = 'Due Today';
                    StyleExpr = DueTodayStyle;
                    DrillDownPageId = "PMS Job List";

                    trigger OnDrillDown()
                    var
                        Job: Record "PMS Job";
                        JobList: Page "PMS Job List";
                    begin
                        Job.SetRange("Scheduled Date", Today);
                        Job.SetFilter(Status, '<%1', Job.Status::Completed);
                        JobList.SetTableView(Job);
                        JobList.Run();
                    end;
                }
                field("Overdue Jobs"; Rec."Overdue Jobs")
                {
                    ApplicationArea = All;
                    Caption = 'Overdue';
                    StyleExpr = OverdueJobsStyle;
                    DrillDownPageId = "PMS Job List";

                    trigger OnDrillDown()
                    var
                        Job: Record "PMS Job";
                        JobList: Page "PMS Job List";
                    begin
                        Job.SetFilter("Scheduled Date", '<%1', Today);
                        Job.SetFilter(Status, '<%1', Job.Status::Completed);
                        JobList.SetTableView(Job);
                        JobList.Run();
                    end;
                }
                field("External Jobs Awaiting PO"; Rec."External Jobs Awaiting PO")
                {
                    ApplicationArea = All;
                    Caption = 'Awaiting PO';
                    StyleExpr = AwaitingPOStyle;
                    DrillDownPageId = "PMS Job List";

                    trigger OnDrillDown()
                    var
                        Job: Record "PMS Job";
                        JobList: Page "PMS Job List";
                    begin
                        Job.SetRange("Job Type", Job."Job Type"::External);
                        Job.SetRange("Purchase Order No.", '');
                        Job.SetFilter(Status, '<%1', Job.Status::Completed);
                        JobList.SetTableView(Job);
                        JobList.Run();
                    end;
                }
            }

            cuegroup(MyJobs)
            {
                Caption = 'My Jobs';

                field("My Jobs"; Rec."My Jobs")
                {
                    ApplicationArea = All;
                    Caption = 'My Jobs';
                    StyleExpr = MyJobsStyle;
                    DrillDownPageId = "PMS Job List";

                    trigger OnDrillDown()
                    var
                        Job: Record "PMS Job";
                        JobList: Page "PMS Job List";
                    begin
                        Job.SetRange("Job Type", Job."Job Type"::Internal);
                        Job.SetRange("Employee No.", UserId());
                        Job.SetFilter(Status, '<%1', Job.Status::Completed);
                        JobList.SetTableView(Job);
                        JobList.Run();
                    end;
                }
            }
        }
    }

    var
        OpenCallsStyle: Text;
        NewCallsStyle: Text;
        CriticalCallsStyle: Text;
        MyCallsStyle: Text;
        MyNewCallsStyle: Text;
        OpenJobsStyle: Text;
        InProgressJobsStyle: Text;
        DueTodayStyle: Text;
        OverdueJobsStyle: Text;
        AwaitingPOStyle: Text;
        MyJobsStyle: Text;

    trigger OnAfterGetRecord()
    begin
        // Helpdesk styling
        Rec.SetRange("Employee No. Filter", UserId());
        Rec.CalcFields(
            "Open Calls",
            "New Helpdesk Calls",
            "Critical Calls",
            "My Calls",
            "My New Calls");
        Rec.SetRange("Employee No. Filter");

        if Rec."Open Calls" > 0 then
            OpenCallsStyle := 'Attention'
        else
            OpenCallsStyle := 'Favorable';

        if Rec."New Helpdesk Calls" > 0 then
            NewCallsStyle := 'Unfavorable'
        else
            NewCallsStyle := 'Favorable';

        if Rec."Critical Calls" > 0 then
            CriticalCallsStyle := 'Unfavorable'
        else
            CriticalCallsStyle := 'Favorable';

        if Rec."My Calls" > 0 then
            MyCallsStyle := 'Attention'
        else
            MyCallsStyle := 'Favorable';

        if Rec."My New Calls" > 0 then
            MyNewCallsStyle := 'Unfavorable'
        else
            MyNewCallsStyle := 'Favorable';

        // Job styling
        Rec.SetRange("Date Filter", Today);
        Rec.SetRange("Employee No. Filter", UserId());
        Rec.CalcFields(
            "Open Jobs",
            "Jobs In Progress",
            "Jobs Due Today",
            "Overdue Jobs",
            "External Jobs Awaiting PO",
            "My Jobs");
        Rec.SetRange("Date Filter");
        Rec.SetRange("Employee No. Filter");

        if Rec."Open Jobs" > 0 then
            OpenJobsStyle := 'Attention'
        else
            OpenJobsStyle := 'Favorable';

        if Rec."Jobs In Progress" > 0 then
            InProgressJobsStyle := 'Ambiguous'
        else
            InProgressJobsStyle := 'Favorable';

        if Rec."Jobs Due Today" > 0 then
            DueTodayStyle := 'Attention'
        else
            DueTodayStyle := 'Favorable';

        if Rec."Overdue Jobs" > 0 then
            OverdueJobsStyle := 'Unfavorable'
        else
            OverdueJobsStyle := 'Favorable';

        if Rec."External Jobs Awaiting PO" > 0 then
            AwaitingPOStyle := 'Attention'
        else
            AwaitingPOStyle := 'Favorable';

        Rec.SetRange("Employee No. Filter", UserId());
        Rec.CalcFields("My Jobs");
        Rec.SetRange("Employee No. Filter");
        if Rec."My Jobs" > 0 then
            MyJobsStyle := 'Attention'
        else
            MyJobsStyle := 'Favorable';
    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
