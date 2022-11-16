page 50119 "Indent Requisitions SubForm"
{
    // version PO1.0

    AutoSplitKey = false;
    PageType = ListPart;
    SourceTable = "Indent Requisitions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Order No"; Rec."Order No")
                {
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    var
                        PurchHeader: Record 38;
                        PurchLine: Record 39;
                    begin
                        //B2B.1.3
                        PurchLine.RESET;
                        PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SETRANGE(PurchLine."Indent No.", Rec."Document No.");
                        PurchLine.SETRANGE(PurchLine."Indent Line No.", Rec."Line No.");
                        IF PurchLine.FINDSET THEN
                            PAGE.RUNMODAL(0, PurchLine);
                        //B2B.1.3
                    end;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                //B2BMSOn01Nov2022>>
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                }
                //B2BMSOn01Nov2022<<
                field("Carry out Action"; Rec."Carry out Action")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Manufacturer Code"; Rec."Manufacturer Code")
                {
                    Caption = 'Vendor';
                    TableRelation = "Item Vendor"."Vendor No." WHERE("Item No." = FIELD("Item No."));
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        IndentLine.RESET;
                        IndentLine.SETRANGE("Indent Req No", Rec."Document No.");
                        IndentLine.SETRANGE("Indent Req Line No", Rec."Line No.");
                        PAGE.RUNMODAL(0, IndentLine);
                    end;
                }
                field("Received Quantity"; Rec."Received Quantity")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Qty. Ordered"; Rec."Qty. Ordered")
                {
                    ApplicationArea = All;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                }
                field("Qty. To Order"; Rec."Qty. To Order")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Vendor Min.Ord.Qty"; Rec."Vendor Min.Ord.Qty")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                    ApplicationArea = All;
                    Visible = false; //B2BMSOn10Oct2022

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
        }
    }

    actions
    {
    }

    var
        CreateIndents: Record 50038;
        Indent: Text[1024];
        Carry: Integer;
        IndentLine: Record 50037;
        PurchaseOrder: Record 38;
        Vendor: Record 99;
}

