page 80847 "PMS Set SP Secret Dlg"
{
    Caption = 'Set SharePoint Client Secret';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(SecretField; SecretValue)
                {
                    ApplicationArea = All;
                    Caption = 'Client Secret';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Enter the client secret from your Azure App Registration.';
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
                ToolTip = 'Save the client secret to secure storage.';

                trigger OnAction()
                begin
                    if SecretValue = '' then
                        Error('Please enter a client secret.');
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

    procedure GetSecret(): Text
    begin
        exit(SecretValue);
    end;

    procedure WasConfirmed(): Boolean
    begin
        exit(Confirmed);
    end;

    var
        SecretValue: Text[500];
        Confirmed: Boolean;
}
