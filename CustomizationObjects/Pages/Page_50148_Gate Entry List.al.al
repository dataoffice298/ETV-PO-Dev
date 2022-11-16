page 50148 "Gate Entry List"
{
    Caption = 'NRGP-INWARD List';
    CardPageID = "Inward Gate Entry-NRGP";
    PageType = List;
    SourceTable = "Gate Entry Header_B2B";
    UsageCategory = Lists;
    ApplicationArea = ALL;
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = FILTER(Inward), Type = const(NRGP));
    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                Editable = false;
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = ALL;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = ALL;
                }
                field("Document Time"; Rec."Document Time")
                {
                    ApplicationArea = ALL;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}

