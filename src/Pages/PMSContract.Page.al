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
                    Editable = false;
                    ToolTip = 'Specifies the current status of the contract.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether this is an external supplier contract or an internal employee contract.';
                }
                group(VendorGroup)
                {
                    ShowCaption = false;
                    Visible = Rec."Contract Type" = Rec."Contract Type"::External;
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
                group(EmployeeGroup)
                {
                    ShowCaption = false;
                    Visible = Rec."Contract Type" = Rec."Contract Type"::Internal;
                    field("Employee No."; Rec."Employee No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the employee for this internal contract.';
                    }
                    field("Employee Name"; Rec."Employee Name")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the name of the employee for this contract.';
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

                    // trigger OnValidate()
                    // begin
                    //     if Rec."Contract ID" <> '' then begin
                    //         Rec.CalcFields("Contract Value");
                    //         NoOfJobs := Rec.CalcNoOfJobs();
                    //         CurrPage.Update(false);
                    //     end;
                    // end;
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
                field(NoOfJobs; NoOfJobs)
                {
                    ApplicationArea = All;
                    Caption = 'No. of Jobs';
                    Editable = false;
                    ToolTip = 'Specifies the total number of job visits across all contract lines, based on each line''s frequency and the contract start and end dates.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the purchase order created when jobs were generated for this contract.';
                }
            }
            part(Lines; "PMS Contract Line Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Contract ID" = field("Contract ID");
                Editable = IsContractEditable;
            }
            part(Jobs; "PMS Jobs Part")
            {
                ApplicationArea = All;
                Caption = 'Jobs';
                SubPageLink = "Source Type" = const(Contract), "Source No." = field("Contract ID");
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
            action(ViewJobs)
            {
                ApplicationArea = All;
                Caption = 'View Jobs';
                Image = ViewWorksheet;
                ToolTip = 'Open the list of all jobs generated for this contract.';

                trigger OnAction()
                var
                    PMSJob: Record "PMS Job";
                begin
                    PMSJob.SetRange("Source Type", PMSJob."Source Type"::Contract);
                    PMSJob.SetRange("Source No.", Rec."Contract ID");
                    Page.Run(Page::"PMS Job List", PMSJob);
                end;
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
                ToolTip = 'Generate PMS jobs for every contract line occurrence. For external contracts this also creates a purchase order with one line per job.';
                trigger OnAction()
                var
                    PMSJobMgt: Codeunit "PMS Job Management";
                begin
                    PMSJobMgt.CreateJobsFromContract(Rec);
                    CurrPage.Update(false);
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
                actionref(ViewJobs_Promoted; ViewJobs) { }
            }
        }
    }

    var
        LockContractEnabled: Boolean;
        IsContractEditable: Boolean;
        NoOfJobs: Integer;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PMSSetup: Record "PMS Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Rec.Status := Rec.Status::Open;
        IsContractEditable := true;
        LockContractEnabled := true;
        PMSSetup.GetRecordOnce();
        if PMSSetup."Contract Nos." <> '' then begin
            Rec."No. Series" := PMSSetup."Contract Nos.";
            Rec."Contract ID" := NoSeries.GetNextNo(Rec."No. Series");
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Contract Value", "No. of Contract Lines");
        LockContractEnabled := Rec.Status in [Rec.Status::Open, Rec.Status::Active];
        IsContractEditable := Rec.Status in [Rec.Status::Open, Rec.Status::Active];
        NoOfJobs := Rec.CalcNoOfJobs();
    end;
}
