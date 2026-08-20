page 80848 "PMS Spawn Job Dlg"
{
    Caption = 'Spawn New External Job';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Spawn Details';

                field(SpawnReasonField; SpawnReason)
                {
                    ApplicationArea = All;
                    Caption = 'Reason for Spawning';
                    MultiLine = true;
                    ToolTip = 'Explain why this job cannot be completed internally and needs to be assigned to a vendor.';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        UpdateConfirmEnabled();
                    end;
                }
                field(SuggestedVendorField; SuggestedVendorNo)
                {
                    ApplicationArea = All;
                    Caption = 'Suggested Vendor';
                    TableRelation = Vendor;
                    ToolTip = 'Optionally suggest a vendor who should handle this job.';

                    trigger OnValidate()
                    var
                        Vend: Record Vendor;
                    begin
                        if SuggestedVendorNo = '' then
                            SuggestedVendorName := ''
                        else begin
                            if Vend.Get(SuggestedVendorNo) then
                                SuggestedVendorName := Vend.Name
                            else
                                SuggestedVendorName := '';
                        end;
                    end;
                }
                field(SuggestedVendorNameField; SuggestedVendorName)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                    Editable = false;
                    ToolTip = 'The name of the suggested vendor.';
                }
                field(CategoryPostingGroupField; CategoryPostingGroup)
                {
                    ApplicationArea = All;
                    Caption = 'Category Posting Group';
                    TableRelation = "PMS Cat. Posting Group";
                    ToolTip = 'Select the category posting group for this expense. This determines the G/L account.';
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        CatPostingGroup: Record "PMS Cat. Posting Group";
                    begin
                        if CategoryPostingGroup <> '' then begin
                            if CatPostingGroup.Get(CategoryPostingGroup) then
                                CategoryDescription := CatPostingGroup."G/L Account Description"
                            else
                                CategoryDescription := '';
                        end else
                            CategoryDescription := '';
                        UpdateConfirmEnabled();
                    end;
                }
                field(CategoryDescriptionField; CategoryDescription)
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account Description';
                    Editable = false;
                    ToolTip = 'The G/L account that will be used based on the selected category.';
                }
                field(QuantityField; Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    ToolTip = 'Enter the estimated quantity for this job.';
                    DecimalPlaces = 0 : 5;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        LineAmount := Quantity * DirectUnitCost;
                    end;
                }
                field(DirectUnitCostField; DirectUnitCost)
                {
                    ApplicationArea = All;
                    Caption = 'Direct Unit Cost';
                    ToolTip = 'Enter the estimated unit cost for this job.';
                    DecimalPlaces = 2 : 5;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        LineAmount := Quantity * DirectUnitCost;
                    end;
                }
                field(LineAmountField; LineAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Estimated Cost';
                    Editable = false;
                    ToolTip = 'Calculated total: Quantity × Direct Unit Cost';
                    DecimalPlaces = 2 : 5;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(PriorityField; Priority)
                {
                    ApplicationArea = All;
                    Caption = 'Priority';
                    ToolTip = 'Adjust the priority for the spawned job if needed.';
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
                Caption = 'Spawn Job';
                Image = CreateDocument;
                ToolTip = 'Complete this internal job and create the new external job.';
                Enabled = ConfirmEnabled;

                trigger OnAction()
                begin
                    if SpawnReason = '' then
                        Error('Please provide a reason for spawning this job.');
                    Confirmed := true;
                    CurrPage.Close();
                end;
            }
            action(Save)
            {
                ApplicationArea = All;
                Caption = 'Save';
                Image = Save;
                ToolTip = 'Save and spawn the external job.';
                Enabled = ConfirmEnabled;

                trigger OnAction()
                begin
                    if SpawnReason = '' then
                        Error('Please provide a reason for spawning this job.');
                    Confirmed := true;
                    CurrPage.Close();
                end;
            }
            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                Image = Cancel;
                ToolTip = 'Cancel the spawn operation.';

                trigger OnAction()
                begin
                    Confirmed := false;
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
                actionref(Save_Promoted; Save) { }
                actionref(Cancel_Promoted; Cancel) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateConfirmEnabled();
    end;

    local procedure UpdateConfirmEnabled()
    begin
        ConfirmEnabled := (SpawnReason <> '') and (CategoryPostingGroup <> '');
    end;

    procedure SetDefaults(DefaultEstimatedCost: Decimal; DefaultPriority: Enum "PMS Helpdesk Priority")
    begin
        // Set default quantity to 1 and calculate unit cost from total
        Quantity := 1;
        DirectUnitCost := DefaultEstimatedCost;
        LineAmount := Quantity * DirectUnitCost;
        Priority := DefaultPriority;
    end;

    procedure GetSpawnReason(): Text[250]
    begin
        exit(CopyStr(SpawnReason, 1, 250));
    end;

    procedure GetSuggestedVendor(): Code[20]
    begin
        exit(SuggestedVendorNo);
    end;

    procedure GetQuantity(): Decimal
    begin
        exit(Quantity);
    end;

    procedure GetDirectUnitCost(): Decimal
    begin
        exit(DirectUnitCost);
    end;

    procedure GetLineAmount(): Decimal
    begin
        exit(LineAmount);
    end;

    procedure GetPriority(): Enum "PMS Helpdesk Priority"
    begin
        exit(Priority);
    end;

    procedure GetCategoryPostingGroup(): Code[20]
    begin
        exit(CategoryPostingGroup);
    end;

    procedure WasConfirmed(): Boolean
    begin
        exit(Confirmed);
    end;

    var
        SpawnReason: Text;
        SuggestedVendorNo: Code[20];
        SuggestedVendorName: Text[100];
        CategoryPostingGroup: Code[20];
        CategoryDescription: Text[100];
        Quantity: Decimal;
        DirectUnitCost: Decimal;
        LineAmount: Decimal;
        Priority: Enum "PMS Helpdesk Priority";
        Confirmed: Boolean;
        ConfirmEnabled: Boolean;
}
