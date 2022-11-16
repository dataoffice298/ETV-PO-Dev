tableextension 50048 tableextension70000013 extends "Purch. Comment Line"
{
    // version NAVW17.00,PO

    fields
    {
        /*
        modify("Document Type")
        {
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Receipt,Posted Invoice,Posted Credit Memo,Posted Return Shipment,Indent,Enquiry', ENN = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Receipt,Posted Invoice,Posted Credit Memo,Posted Return Shipment,Indent,Enquiry';

            //Unsupported feature: Change OptionString on ""Document Type"(Field 1)". Please convert manually.

        }
        */
        field(50000; "General Condition"; Option)
        {
            OptionMembers = " ","Term of Payment",Freight,"Mode of Shipment","Delivery Time",packing,"Invoice Narration";
        }
        field(50001; "RFQ No."; Code[20])
        {
        }
        field(50002; "Vendor No."; Code[20])
        {
        }
    }
    keys
    {
        key(Key1; "RFQ No.", "Vendor No.")
        {
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

