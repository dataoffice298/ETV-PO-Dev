pageextension 50107 ItemVendorCatalogExt extends "Item Vendor Catalog"
{
    layout
    {
        addlast(Control1)
        {
            field("Delivery Rating"; Rec."Delivery Rating")
            {
                ApplicationArea = all;
            }
            field("Avg. Delivery Rating"; Rec."Avg. Delivery Rating")
            {
                ApplicationArea = all;
            }
            field("Avg. Quality Rating"; Rec."Avg. Quality Rating")
            {
                ApplicationArea = all;
            }
            Field("Qty. Supplied With in DueDate"; Rec."Qty. Supplied With in DueDate")
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