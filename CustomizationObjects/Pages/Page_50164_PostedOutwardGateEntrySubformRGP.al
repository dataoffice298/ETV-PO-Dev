page 50164 "Posted Outward Gate SubFm-RGP"
{
    Caption = 'Posted RGP-OUTWARD Subform';
    AutoSplitKey = true;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Posted Gate Entry Line_B2B";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Challan No."; Rec."Challan No.")
                {
                    ApplicationArea = ALL;
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    ApplicationArea = ALL;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = ALL;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = all;
                }
                //Balu 05212021>>
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
                //Balu 05212021<<
            }
        }
    }
}

