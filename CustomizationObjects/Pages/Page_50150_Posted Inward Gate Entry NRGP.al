page 50150 "Posted Inward Gate Entry-NRGP"
{
    Caption = 'Posted NRGP-INWARD';
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Inward), Type = const(NRGP));
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = ALL;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                }
                field("Station From/To"; Rec."Station From/To")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = ALL;
                }
                field("Posting Time"; Rec."Posting Time")
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
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    ApplicationArea = ALL;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = ALL;
                }
                field("Gate Entry No."; Rec."Gate Entry No.")
                {
                    ApplicationArea = ALL;
                }
            }
            part(Control1500028; "Posted Inward Gate SubFm-NRGP")
            {
                SubPageLink = "Entry Type" = FIELD("Entry Type"),
                "Type" = field("Type"),
                              "Gate Entry No." = FIELD("No.");
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        /*area(navigation)
        {
            group("&Gate Entry")
            {

                Image = InwardEntry;
                action(List)
                {
                    Image = OpportunitiesList;
                    RunObject = Page "PostedInwardGateEntryList-NRGP";
                    ShortCutKey = 'Shift+Ctrl+L';
                    ApplicationArea = ALL;
                }
            }
        }*/
    }
}

