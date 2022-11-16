enumextension 50000 PurchaseDoc extends "Purchase Document Type"
{
    value(6; Enquiry)
    {
        Caption = 'Enquiry';
    }

}

//B2BMSOn12Sep2022>>
enumextension 50001 PurchaseCommentDoc extends "Purchase Comment Document Type"
{
    value(10; Indent)
    {
        CaptionML = ENU = 'Indent', ENN = 'Indent';
    }
    value(11; Enquiry)
    {
        CaptionML = ENU = 'Enquiry', ENN = 'Enquiry';
    }

}
//B2BMSOn12Sep2022<<

enum 50002 ApprovalStatus
{
    Extensible = true;
    Value(0; Open)
    {

    }
    value(1; "Pending for Approval")
    {

    }
    value(2; Released)
    {

    }
}

enum 50003 PurchaseType
{
    Extensible = true;

    value(0; Import)
    {

    }
    value(1; "Local")
    {

    }
    value(2; "PMS")
    {

    }
    value(3; "Import File")
    {

    }
    value(4; "Service")
    {

    }
    Value(5; " ")
    {

    }
    value(6; "Import Charge")
    {

    }
}

enum 50004 VehicleStatus
{
    Extensible = true;
    value(0; Open)
    {

    }
    Value(1; Release)
    {

    }
    Value(2; Close)
    {

    }
    value(3; "Pending For Approval")
    {

    }
}


enum 50005 GateEntryInOutWard
{
    Extensible = true;
    value(0; Inward)
    {

    }
    value(1; Outward)
    {

    }
}

enum 50006 GateEntryType
{
    Extensible = true;
    value(0; " ")
    {

    }
    value(1; RGP)
    {

    }
    value(2; NRGP)
    {

    }
}


