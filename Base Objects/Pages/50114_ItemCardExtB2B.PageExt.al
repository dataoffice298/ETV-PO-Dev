pageextension 50115 ItemCardExtB2B extends "Item Card"
{
    //B2BMSOn04Nov2022
    layout
    {
        addlast(Item)
        {
            group(QC)
            {
                Caption = 'QC';
                field("QC Enabled B2B"; Rec."QC Enabled B2B")
                {
                    ApplicationArea = all;
                }
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