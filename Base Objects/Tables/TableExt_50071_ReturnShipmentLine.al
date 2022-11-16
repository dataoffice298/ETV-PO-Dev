tableextension 50071 ReturnShipmentLine extends "Return Shipment Line"
{
    fields
    {
        field(60011; "Ref. Posted Gate Entry"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}