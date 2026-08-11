page 80846 "PMS Vacate Dlg"
{
    Caption = 'Vacate Property';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(VacateDateField; VacateDate)
                {
                    ApplicationArea = All;
                    Caption = 'Vacate Date';
                    ToolTip = 'Enter the date the tenant will vacate the property.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Confirm)
            {
                ApplicationArea = All;
                Caption = 'OK';
                Image = Approve;
                ToolTip = 'Confirm the vacate date and update the movement.';

                trigger OnAction()
                begin
                    if VacateDate = 0D then
                        Error('A vacate date must be entered.');
                    Confirmed := true;
                    CurrPage.Close();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(Confirm_Promoted; Confirm) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        VacateDate := WorkDate();
    end;

    procedure GetVacateDate(): Date
    begin
        exit(VacateDate);
    end;

    procedure WasConfirmed(): Boolean
    begin
        exit(Confirmed);
    end;

    var
        VacateDate: Date;
        Confirmed: Boolean;
}
