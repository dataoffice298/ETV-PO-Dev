pageextension 50108 SalesOrderPageExtB2B extends "Sales Order"
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
        modify(Post)
        {
            trigger OnBeforeAction()
            begin

                GateEntry.Reset();
                GateEntry.SetRange("Source No.", Rec."No.");
                if GateEntry.FindFirst() then begin
                    salesLine.Reset();
                    salesLine.SetRange("Document No.", Rec."No.");
                    if salesLine.FindSet() then
                        repeat
                            if (salesLine."Ref. Posted Gate Entry" = '') then
                                Error('Gate entry available for the purchase document. Hence, It must be filled in Line No. %1.', salesLine."Line No.");
                        until salesLine.Next = 0;
                end;

            end;
        }
    }

    var
        GateEntry: Record "Posted Gate Entry Line_B2B";
        salesLine: Record "Sales Line";
}