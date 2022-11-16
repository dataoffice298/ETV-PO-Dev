page 50142 "Posted Gate Entry Line List"
{
    // version NAVIN7.00
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    SourceTable = "Posted Gate Entry Line_B2B";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field("Gate Entry No."; Rec."Gate Entry No.")
                {
                    ApplicationArea = ALL;
                }
                field("Line No."; Rec."Line No.")
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
                }
                field("Challan No."; Rec."Challan No.")
                {
                    ApplicationArea = ALL;
                }
                field("Challan Date"; Rec."Challan Date")
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
            }
        }
    }
    actions
    {
    }
    procedure SetSelection(var Grl: Record "Posted Gate Entry Line_B2B")
    begin
        CurrPage.SetSelectionFilter(Grl);
    end;
}

