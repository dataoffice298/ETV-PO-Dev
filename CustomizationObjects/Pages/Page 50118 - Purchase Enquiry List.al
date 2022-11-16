page 50118 "Purchase Enquiry List"
{
    // version PH1.0,PO1.0

    // PROJECT : WindlassHealthCare
    // **************************************************************************
    // SIGN
    // **************************************************************************
    // B2B : B2B Software Technologies
    // **************************************************************************
    // VER       SIGN       USERID          DATE         DESCRIPTION
    // **************************************************************************
    // 1.2       B2B        Anirudh       30-Apr-2015 --> New Page Created.

    CardPageID = "Purchase Enquiry";
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = filter(Enquiry));
    UsageCategory = Lists;
    ApplicationArea = all;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

