page 50174 "Transfer Indent Line"
{
    // version PH1.0,PO1.0

    AutoSplitKey = true;
    //DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Indent Line";
    Caption = 'Transfer Indent Line';
    SourceTableView = where("Indent Transfer" = const(true));//BaluOn19Oct2022>>


    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Department; rec.Department)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Delivery Location"; rec."Delivery Location")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }
                field("Avail.Qty"; Rec."Avail.Qty")
                {
                    ApplicationArea = all;
                }
                field("Req.Quantity"; rec."Req.Quantity")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Indent Status"; rec."Indent Status")
                {
                    ApplicationArea = All;
                }
                field(Remarks; rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Qty To Issue"; Rec."Qty To Issue")
                {
                    ApplicationArea = all;
                }
                field("Qty Issued"; Rec."Qty Issued")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Qty To Return"; Rec."Qty To Return")
                {
                    ApplicationArea = all;
                }
                field("Qty Returned"; Rec."Qty Returned")
                {
                    ApplicationArea = all;
                    Editable = false;
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
                        PurchaseSetup: Record "Purchases & Payables Setup";
                    BEGIN
                        PurchaseSetup.Get();
                        ItemJournalLine.reset;
                        ItemJournalLine.SetRange("Journal Template Name", PurchaseSetup."Indent Issue Jnl. Template");
                        ItemJournalLine.SetRange("Journal Batch Name", PurchaseSetup."Indent Issue Jnl. Batch");
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
                        PurchaseSetup: Record "Purchases & Payables Setup";
                    BEGIN
                        PurchaseSetup.Get();
                        ItemJournalLine.reset;
                        ItemJournalLine.SetRange("Journal Template Name", PurchaseSetup."Indent Return Jnl. Template");
                        ItemJournalLine.SetRange("Journal Batch Name", PurchaseSetup."Indent Return Jnl. Batch");
                        ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                        ItemJournalLine.SetRange("Item No.", Rec."No.");
                        IF ItemJournalLine.findset then;
                        Page.RunModal(40, ItemJournalLine);
                    END;
                }
                action(createFAMovement)
                {
                    ApplicationArea = ALL;
                    Caption = 'create FA Movement';
                    Image = CreateMovement;
                    trigger onaction()
                    var
                        FAMovement: Codeunit MyBaseSubscr;
                    BEGIN
                        Rec.TestField(Type, Rec.Type::"Fixed Assets");
                        FAMovement.CreateFAMovememt(rec);
                    END;
                }
                action(OpenFAMovementEntries)
                {
                    ApplicationArea = ALL;
                    Caption = 'FA Movement Entries';
                    Image = Entries;
                    trigger onaction()
                    var
                        FAMovement: Record "Fixed Asset Movements";
                    BEGIN
                        Rec.TestField(Type, Rec.Type::"Fixed Assets");
                        FAMovement.Reset();
                        FAMovement.SetRange("Document No.", Rec."Document No.");
                        FAMovement.SetRange("Document Line No.", Rec."Line No.");
                        if FAMovement.FindSet() then
                            Page.Run(0, FAMovement);
                    END;
                }

            }
        }

    }
    //BaluOn19Oct2022>>
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec."Indent Transfer" := true;
    end;
    //BaluOn19Oct2022<<

    var
        ItemLedgerEntry: Record 32;
        IndentHeader: Record 50010;
        IndentLine: Record 50037;

}

