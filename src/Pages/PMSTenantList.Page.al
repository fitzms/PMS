page 80821 "PMS Tenant List"
{
    Caption = 'Tenants';
    PageType = List;
    SourceTable = "PMS Tenant";
    CardPageId = "PMS Tenant";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the tenant.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the tenant.';
                }


                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the tenant.';
                }

                field(CurrentPropertyKnownAs; CurrentPropertyKnownAs)
                {
                    ApplicationArea = All;
                    Caption = 'Property Known As';
                    Editable = false;

                    ToolTip = 'Specifies the property where the tenant currently resides.';
                }

                field("Billing Code"; Rec."Billing Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the billing code for this tenant.';
                }

            
            }
        }
        area(FactBoxes)
        {
            part(DocAttachList; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(Database::"PMS Tenant"), "No." = field("Tenant ID");
            }
            part(CustomerDetails; "Customer Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Tenant ID");
            }
            part(CustomerStatistics; "Customer Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Tenant ID");
            }
            part(SalesHistSellto; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Tenant ID");
            }
            // part(JobCost; "Job Cost FactBox")
            // {
            //     ApplicationArea = All;
            //     SubPageLink = "No." = field("Tenant ID");
            // }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Comments)
            {
                ApplicationArea = All;
                Caption = 'Comments';
                Image = ViewComments;
                ToolTip = 'View or add comments for this tenant.';

                trigger OnAction()
                var
                    RecordLink: Record "Record Link";
                begin
                    RecordLink.SetRange("Record ID", Rec.RecordId);
                    RecordLink.SetRange(Type, RecordLink.Type::Note);
                    Page.RunModal(0, RecordLink);
                end;
            }
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'View or add attachments for this tenant.';

                trigger OnAction()
                var
                    DocAttachDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocAttachDetails.OpenForRecRef(RecRef);
                    DocAttachDetails.RunModal();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Navigate)
            {
                Caption = 'Tenant';

                actionref(Comments_Promoted; Comments) { }
                actionref(Attachments_Promoted; Attachments) { }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrentPropertyKnownAs := '';
        if Rec.Status = Rec.Status::Current then begin
            Movement.SetRange("Tenant ID", Rec."Tenant ID");
            Movement.SetRange(Status, Movement.Status::Current);
            if Movement.FindFirst() then begin
                Movement.CalcFields("Property Known As");
                CurrentPropertyKnownAs := Movement."Property Known As";
            end;
        end;
    end;

    var
        Movement: Record "PMS Tenant Movement";
        CurrentPropertyKnownAs: Text[100];
}
