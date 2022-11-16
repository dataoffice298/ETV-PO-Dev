pageextension 50112 PostPurchInvoiceSubform extends "Posted Purch. Invoice Subform"
{
    //B2BVCOn03Oct22>>>
    layout
    {
        addafter(Description)
        {
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                ApplicationArea = all;
            }
        }
    }
    //B2BVCOn03Oct22<<<
    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}