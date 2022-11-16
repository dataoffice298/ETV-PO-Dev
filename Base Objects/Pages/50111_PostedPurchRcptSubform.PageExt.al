pageextension 50111 PostedPurchRcptSubform extends "Posted Purchase Rcpt. Subform"
{
    Editable = false;
    layout
    {
        addafter(Description)
        {
            //B2BVCOn03Oct22>>>
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                ApplicationArea = all;
            }
            //B2BVCOn03Oct22<<<
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}