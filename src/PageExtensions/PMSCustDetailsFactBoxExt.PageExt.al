pageextension 80871 "PMS Cust Details FactBox Ext" extends "Customer Details FactBox"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the mobile phone number of the customer.';
            }
        }
    }
}
