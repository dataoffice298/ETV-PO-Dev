page 50113 "Indent SubForm List"
{
    // version PO1.0

    AutoSplitKey = true;
    DelayedInsert = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Indent Line";

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Delivery Location"; Rec."Delivery Location")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }
                field("Avail.Qty"; Rec."Avail.Qty")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    begin
                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETRANGE("Item No.", Rec."No.");
                        ItemLedgerEntry.SETRANGE("Variant Code", Rec."Variant Code");
                        //ItemLedgerEntry.SETRANGE("Location Code","Delivery Location");
                        PAGE.RUNMODAL(0, ItemLedgerEntry);
                    end;
                }
                field("Req.Quantity"; Rec."Req.Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    Caption = 'Preferred Vendor';
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Indent Status"; Rec."Indent Status")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(ShowItemJournalIssue)
                {
                    ApplicationArea = ALL;
                    Caption = 'Show Item Journal Issue';
                    Image = ShowList;
                    trigger onaction()
                    var
                        ItemJournalLine: Record "Item Journal Line";
                        ItemJournal: Page "Item Journal";
                    BEGIN
                        ItemJournalLine.reset;
                        ItemJournalLine.SetRange("Journal Template Name", 'ISSUE');
                        ItemJournalLine.SetRange("Journal Batch Name", Rec."Document No.");
                        ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
                        ItemJournalLine.SetRange("Item No.", Rec."No.");
                        IF ItemJournalLine.findset then;
                        Page.RunModal(40, ItemJournalLine);
                    END;
                }

                action(ShowItemJournalBatchReturn)
                {
                    ApplicationArea = ALL;
                    Caption = 'Show ItemJournal Batch Return';
                    Image = ShowList;
                    trigger onaction()
                    var
                        ItemJournalLine: Record "Item Journal Line";
                        ItemJournal: Page "Item Journal";
                    BEGIN
                        ItemJournalLine.reset;
                        ItemJournalLine.SetRange("Journal Template Name", 'RETURN');
                        ItemJournalLine.SetRange("Journal Batch Name", Rec."Document No.");
                        ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                        ItemJournalLine.SetRange("Item No.", Rec."No.");
                        IF ItemJournalLine.findset then;
                        Page.RunModal(40, ItemJournalLine);
                    END;
                }

            }
        }


    }

    var
        ItemLedgerEntry: Record 32;
}

