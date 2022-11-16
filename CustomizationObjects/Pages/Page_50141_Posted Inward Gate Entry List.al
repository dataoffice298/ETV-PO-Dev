page 50141 "PostedInwardGateEntryList-NRGP"
{
    // version NAVIN7.00
    Caption = 'Posted NRGP-INWARD List';
    UsageCategory = Lists;
    ApplicationArea = ALL;

    CardPageID = "Posted Inward Gate Entry-NRGP";
    PageType = List;
    SourceTable = "Posted Gate Entry Header_B2B";
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
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }

}

