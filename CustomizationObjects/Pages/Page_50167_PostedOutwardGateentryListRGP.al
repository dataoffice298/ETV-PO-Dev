page 50167 "PostedOutwardGateEntryList-RGP"
{
    Caption = 'Posted RGP-OUTWARD List';
    CardPageID = "Posted Outward Gate Entry-RGP";
    UsageCategory = Lists;
    ApplicationArea = ALL;
    PageType = List;
    SourceTable = "Posted Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = FILTER(Outward), Type = const(RGP));

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                Editable = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
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

    actions
    {
    }

}

