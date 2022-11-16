page 50026 "Purchase Enquiry Subform"
{
    // version PH1.0,PO1.0

    // //Dm 27Jan09   Commented code because its not presenet in

    AutoSplitKey = true;
    Caption = 'Purchase Enquiry Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Enquiry));

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;

                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;
                    end;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;

                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                    ApplicationArea = All;

                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;

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
                field("Indent Req No"; Rec."Indent Req No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Indent Req Line No"; Rec."Indent Req Line No")
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

    trigger OnAfterGetRecord();
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.Type := xRec.Type;
        CLEAR(ShortcutDimCode);
    end;

    var
        TransferExtendedText: Codeunit 378;
        ShortcutDimCode: array[8] of Code[20];

    procedure ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)", Rec);
    end;

    procedure CalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount", Rec);
    end;

    procedure ExplodeBOM();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM", Rec);
    end;

    procedure GetPhaseTaskStep();
    begin
        //CODEUNIT.RUN(CODEUNIT::"Purch.-Get Phase/...",Rec);//DM commented by
    end;

    procedure InsertExtendedText(Unconditionally: Boolean);
    begin
        IF TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertPurchExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    end;

    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin);
    begin
        //Rec.ItemAvailability(AvailabilityType);
    end;

    procedure ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure ItemChargeAssgnt();
    begin
        Rec.ShowItemChargeAssgnt;
    end;

    procedure OpenItemTrackingLines();
    begin
        Rec.OpenItemTrackingLines;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure "---NAVIN---"();
    begin
    end;
    /*
        procedure ShowStrDetailsForm();
        var
            StrOrderLineDetails : Record "Structure Order Line Details";
            StrOrderLineDetailsForm : Page 16306;
        begin
            StrOrderLineDetails.RESET;
            StrOrderLineDetails.SETRANGE(Type,StrOrderLineDetails.Type::Purchase);
            StrOrderLineDetails.SETRANGE("Document Type","Document Type");
            StrOrderLineDetails.SETRANGE("Document No.","Document No.");
            StrOrderLineDetails.SETRANGE("Item No.","No.");
            StrOrderLineDetails.SETRANGE("Line No.","Line No.");
            StrOrderLineDetailsForm.SETTABLEVIEW(StrOrderLineDetails);
            StrOrderLineDetailsForm.RUNMODAL;
        end;
    *///Balu
    procedure "---B2B---"();
    begin
    end;

    procedure OpenAttachments();
    begin
        /*
        Attachment.RESET;
        Attachment.SETRANGE("Table ID",DATABASE::"Purchase Header");
        Attachment.SETRANGE("Document No.","Document No.");
        Attachment.SETRANGE("Document Type","Document Type");
        PAGE.RUN(PAGE::Form50038,Attachment);
        */

    end;

    local procedure NoOnAfterValidate();
    begin
        InsertExtendedText(FALSE);
        IF (Rec.Type = Rec.Type::"Charge (Item)") AND (Rec."No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    end;
}

