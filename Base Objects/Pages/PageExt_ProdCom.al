pageextension 50074 ProdCompl extends "Prod. Order Components"
{
    layout
    {
        addafter("Expected Quantity")
        {
            field(Inventory; rec.Inventory)
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