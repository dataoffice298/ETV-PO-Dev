pageextension 50109 PostedSaleInvExtB2B extends "Posted Sales Invoice"
{
    layout
    {
        addlast("Shipping and Billing")
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}