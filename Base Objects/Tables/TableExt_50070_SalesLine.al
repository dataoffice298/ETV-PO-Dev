tableextension 50070 SalesLineExt_B2B extends "Sales Line"
{
    fields
    {
        field(60011; "Ref. Posted Gate Entry"; Code[20])
        {
            TableRelation = "Posted Gate Entry Line_B2B"."Gate Entry No." where("Source No." = field("Document No."));

            trigger OnValidate()
            var
                PurchRcptLine: Record "Return Shipment Line";
                RGPErr: Label 'This gate entry is already used for GRN No. %1.';
            begin
                PurchRcptLine.Reset();
                PurchRcptLine.SetRange("Return Order No.", "Document No.");
                PurchRcptLine.SetRange("Return Order Line No.", "Line No.");
                if PurchRcptLine.FindSet() then
                    repeat
                        if PurchRcptLine."Ref. Posted Gate Entry" = "Ref. Posted Gate Entry" then
                            Error(RGPErr, PurchRcptLine."Document No.");
                    until PurchRcptLine.Next() = 0;
            end;
        }
    }

    var
        myInt: Integer;
}