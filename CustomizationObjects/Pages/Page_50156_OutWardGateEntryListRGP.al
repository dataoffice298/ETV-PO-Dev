page 50156 "Outward Gate Entry List-RGP"
{
    Caption = 'RGP-OUTWARD List';
    UsageCategory = Lists;
    ApplicationArea = ALL;

    CardPageID = "Outward Gate Entry - RGP";
    PageType = List;
    SourceTable = "Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Outward), Type = const(RGP));

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
            }
        }
    }
}

