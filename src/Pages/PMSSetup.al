page 80808 "PMS Setup"
{
    Caption = 'Property Management Setup';
    PageType = Card;
    SourceTable = "PMS Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Default Job Type"; Rec."Default Job Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default job type for maintenance work: Planned Maintenance, Reactive, or Internal.';
                }
                field("Job Frequency"; Rec."Job Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default job frequency for contracts.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Contract Nos."; Rec."Contract Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new contracts.';
                }
                field("Property Nos."; Rec."Property Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new properties.';
                }
                field("Unit Nos."; Rec."Unit Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to assign IDs to new units.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetRecordOnce();
    end;
}
