page 80844 "PMS Prop Status Change Dlg"
{
    Caption = 'Change Property Status';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(CurrentStatusField; CurrentStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Current Status';
                    Editable = false;
                    ToolTip = 'Specifies the current status of the property.';
                }
                field(NewStatusField; NewStatus)
                {
                    ApplicationArea = All;
                    Caption = 'New Status';
                    ToolTip = 'Select the new status for this property.';
                }
                field(ChangeNoteField; ChangeNote)
                {
                    ApplicationArea = All;
                    Caption = 'Note';
                    MultiLine = true;
                    ToolTip = 'Enter a reason or note for this status change.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConfirmChange)
            {
                ApplicationArea = All;
                Caption = 'Confirm Change';
                Image = Approve;
                ToolTip = 'Confirm the status change.';

                trigger OnAction()
                begin
                    if NewStatus = CurrentStatus then
                        Error('The new status is the same as the current status.');
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
                actionref(ConfirmChange_Promoted; ConfirmChange) { }
            }
        }
    }

    procedure SetCurrentStatus(Status: Enum "PMS Property Status")
    begin
        CurrentStatus := Status;
        NewStatus := Status;
    end;

    procedure GetNewStatus(): Enum "PMS Property Status"
    begin
        exit(NewStatus);
    end;

    procedure GetNote(): Text[500]
    begin
        exit(ChangeNote);
    end;

    procedure WasConfirmed(): Boolean
    begin
        exit(Confirmed);
    end;

    var
        CurrentStatus: Enum "PMS Property Status";
        NewStatus: Enum "PMS Property Status";
        ChangeNote: Text[500];
        Confirmed: Boolean;
}
