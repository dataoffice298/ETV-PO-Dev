pageextension 50071 Paymntterms extends "Payment Terms"
{
    layout
    {
        addafter("Discount %")
        {
            field(Rating; Rec.Rating)
            {
                ApplicationArea = all;
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