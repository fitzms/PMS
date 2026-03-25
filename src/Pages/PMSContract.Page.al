page 80806 "PMS Contract Header"
{
    Caption = 'Contract';
    PageType = Document;
    SourceTable = "PMS Contract Header";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = IsContractEditable;

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the unique identifier for the contract.';

                    trigger OnAssistEdit()
                    var
                        PMSSetup: Record "PMS Setup";
                        NoSeries: Codeunit "No. Series";
                    begin
                        PMSSetup.GetRecordOnce();
                        PMSSetup.TestField("Contract Nos.");
                        if NoSeries.LookupRelatedNoSeries(PMSSetup."Contract Nos.", Rec."No. Series") then begin
                            Rec."Contract ID" := NoSeries.GetNextNo(Rec."No. Series");
                            CurrPage.Update();
                        end;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies a description of the contract.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the contract.';
                }
                group(VendorGroup)
                {
                    ShowCaption = false;
                    field("Vendor No."; Rec."Vendor No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the vendor for this contract.';
                    }
                    field("Vendor Name"; Rec."Vendor Name")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the name of the vendor for this contract.';
                    }
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date the contract starts.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date the contract ends.';
                }
                field("PMS Cat. Posting Group"; Rec."PMSCat. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PMS category posting group for this contract.';
                }
                field("Job Frequency"; Rec."Job Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how frequently the contract job recurs.';
                }
                field("Contract Value"; Rec."Contract Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total value of all contract lines.';
                }
                field("No. of Contract Lines"; Rec."No. of Contract Lines")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of lines on this contract.';
                }
            }
            part(Lines; "PMS Contract Line Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Contract ID" = field("Contract ID");
                Editable = IsContractEditable;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ContractList)
            {
                ApplicationArea = All;
                Caption = 'Contract List';
                Image = List;
                RunObject = page "PMS Contract List";
                ToolTip = 'View the list of all contracts.';
            }
        }
        area(Processing)
        {
            action(OpenContract)
            {
                ApplicationArea = All;
                Caption = 'Open Contract';
                Enabled = Rec.Status <> Rec.Status::Open;
                Image = ReOpen;
                ToolTip = 'Re-open this contract to allow editing.';
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(LockContract)
            {
                ApplicationArea = All;
                Caption = 'Lock Contract';
                Enabled = LockContractEnabled;
                Image = Lock;
                ToolTip = 'Lock this contract to prevent further changes.';
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Locked;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(CopyContract)
            {
                ApplicationArea = All;
                Caption = 'Clone Contract';
                Image = Copy;
                ToolTip = 'Clone this contract to create a new one.';
                trigger OnAction()
                begin
                    // TODO: Implement copy contract logic
                    Message('Copy Contract - to be implemented.');
                end;
            }
            action(CreateContractJob)
            {
                ApplicationArea = All;
                Caption = 'Create Contract Jobs';
                Image = NewDocument;
                ToolTip = 'Create jobs from this contract.';
                trigger OnAction()
                begin
                    // TODO: Implement create contract job logic
                    Message('Create Contract Job - to be implemented.');
                end;
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                Caption = 'New';
                actionref(CopyContract_Promoted; CopyContract) { }
            }
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(OpenContract_Promoted; OpenContract) { }
                actionref(LockContract_Promoted; LockContract) { }
                actionref(CreateContractJob_Promoted; CreateContractJob) { }
            }
            group(Category_Navigate)
            {
                Caption = 'Navigate';
                actionref(ContractList_Promoted; ContractList) { }
            }
        }
    }

    var
        LockContractEnabled: Boolean;
        IsContractEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Contract Value", "No. of Contract Lines");
        LockContractEnabled := Rec.Status in [Rec.Status::Open, Rec.Status::Active];
        IsContractEditable := Rec.Status in [Rec.Status::Open, Rec.Status::Active];
    end;
}
