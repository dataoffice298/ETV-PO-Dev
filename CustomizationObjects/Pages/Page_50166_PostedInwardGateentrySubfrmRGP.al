page 50166 "Posted Inward Gate SubFm-RGP"
{

    Caption = 'Posted RGP-INWARD Subform';
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
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = ALL;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Posted RGP OUT NO."; Rec."Posted RGP OUT NO.")
                {
                    ApplicationArea = all;
                }
                field("Posted RGP OUT NO. Line"; Rec."Posted RGP OUT NO. Line")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

