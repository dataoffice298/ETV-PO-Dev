page 50143 "Outward Gate Entry Line List"
{
    // version NAVIN7.00
    UsageCategory = Lists;
    ApplicationArea = ALL;

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Posted Gate Entry Line_B2B";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Gate Entry No."; Rec."Gate Entry No.")
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
            }
        }
    }

    actions
    {

    }
}

