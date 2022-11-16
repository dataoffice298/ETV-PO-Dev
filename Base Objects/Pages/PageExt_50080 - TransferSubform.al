pageextension 50080 TransferSubform extends "Transfer Order Subform"
{  //B2BPG11OCT2022
    layout
    {
        addlast(Control1)
        {
            field("Indent No."; Rec."Indent No.")
            {
                Caption = 'Indent No.';
                ApplicationArea = All;
            }

            field("Indent Date"; Rec."Indent Date")
            {
                Caption = 'Indent Date';
                ApplicationArea = All;
            }
        }
    }


}