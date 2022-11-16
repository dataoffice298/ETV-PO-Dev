pageextension 50075 RelProdOrd extends "Released Production Order"
{
    layout
    {

    }

    actions
    {
        addafter(RefreshProductionOrder)
        {
            action("Shortage Report")
            {
                Image = Report;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ShrtReport: Report "Shortage Report";
                begin
                    ShrtReport.GetInden(rec."No.", rec."Shortcut Dimension 2 Code", rec.Quantity, rec."Source No.");
                    ShrtReport.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}