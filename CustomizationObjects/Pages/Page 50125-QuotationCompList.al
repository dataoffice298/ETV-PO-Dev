page 50125 "Quotation Comparison List"
{
    PageType = Card;
    //ApplicationArea = All;
    SourceTable = 50041;


    layout
    {
        area(Content)
        {
            group(General)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;

                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}