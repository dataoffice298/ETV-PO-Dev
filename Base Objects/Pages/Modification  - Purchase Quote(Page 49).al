pageextension 50073 pageextension70000001 extends "Purchase Quote"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO1.0

    layout
    {
        modify(General)
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }

        modify("Invoice Details")
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }
        modify("Shipping and Payment")
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }
        modify("Foreign Trade")
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }
        modify("Tax Information ")
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }
        addafter("Document Date")
        {
            field("RFQ No."; Rec."RFQ No.")
            {
                ApplicationArea = All;

            }
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    //Unsupported feature: PropertyChange. Please convert manually.
    //B2BVCOn03Oct22>>>
    trigger OnOpenPage()
    begin
        if (Rec.Status = Rec.Status::Released) then
            PageEditable := false
        else
            PageEditable := true;
    end;
    //B2BVCOn03Oct22>>>
    var
        FieldEditable: Boolean;
        PageEditable: Boolean;

}

