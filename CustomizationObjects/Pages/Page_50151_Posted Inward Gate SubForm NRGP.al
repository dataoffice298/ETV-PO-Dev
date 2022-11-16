page 50151 "Posted Inward Gate SubFm-NRGP"
{
    Caption = 'Posted NRGP-INWARD Subform';
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
                    ApplicationArea = ALL;
                    OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Item,Fixed Asset,Others';
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}

