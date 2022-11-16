page 50025 "Purchase Enquiry"
{
    // version PH1.0,PO1.0

    Caption = 'Purchase Enquiry';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = FILTER('Enquiry'));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = PageEditable; //B2BVCOn28Sep22
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Contact No."; Rec."Buy-from Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Address"; Rec."Buy-from Address")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Address 2"; Rec."Buy-from Address 2")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    Caption = 'Buy-from Post Code/City';
                    ApplicationArea = All;
                }
                field("Buy-from City"; Rec."Buy-from City")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = All;
                }
            }
            part(PurchLines; "Purchase Enquiry Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
                Editable = PageEditable; //B2BVCOn28Sep22
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                Editable = PageEditable; //B2BVCOn28Sep22
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        PaytoVendorNoOnAfterValidate;
                    end;
                }
                field("Pay-to Contact No."; Rec."Pay-to Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Address"; Rec."Pay-to Address")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Address 2"; Rec."Pay-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                    Caption = 'Pay-to Post Code/City';
                    ApplicationArea = All;
                }
                field("Pay-to City"; Rec."Pay-to City")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Contact"; Rec."Pay-to Contact")
                {
                    ApplicationArea = All;
                }
                field("<Purchaser Code2>"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                }
                field("<Due Date2>"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                Editable = PageEditable; //B2BVCOn28Sep22
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code/City';
                    ApplicationArea = All;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Enquiry")
            {
                Caption = '&Enquiry';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 26;
                    RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 66;
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                separator("Process")
                {
                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        StdVendPurchCode: Record 175;
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator("Process4")
                {
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RUNMODAL;
                        CLEAR(CopyPurchDoc);
                    end;
                }
                action("Archi&ve Document")
                {
                    Caption = 'Archi&ve Document';
                    Image = Archive;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                separator("Process1")
                {
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    RunObject = Codeunit "Release Purchase Document";
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = All;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        ReleasePurchDoc: Codeunit 415;
                    begin
                        ReleasePurchDoc.Reopen(Rec);
                    end;
                }
                separator("Process3")
                {
                }
            }
            action("Make to &Quote")
            {
                Caption = 'Make to &Quote';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                var
                    //NoSeriesMgt : Codeunit 396;//Balu
                    Text000: Label 'Do you want to convert the Enquiry to Quote?';
                    Text001: Label 'Enquiry %1 has been changed to Quote %2';
                    PurchaseHeader: Record 38;
                    PurchaseLine: Record 39;
                    PurchaseSetup: Record 312;
                    PurchaseLineQuote: Record 39;
                begin
                    Rec.TESTFIELD("Buy-from Vendor No.");
                    Rec.TESTFIELD(Status, Rec.Status::Released);
                    IF NOT CONFIRM(Text000, FALSE) THEN
                        EXIT;
                    ArchiveManagement.ArchivePurchDocument(Rec);
                    POAutomation.ConvertEnquirytoQuote(Rec);
                end;
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //DocPrint.PrintPurchHeader(Rec);
                    PurchHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(50073, TRUE, FALSE, PurchHeader);
                end;
            }
        }
    }

    //B2BPGON11OCT2022
    trigger OnAfterGetRecord();

    begin
        if (Rec.Status = Rec.Status::Released) then
            PageEditable := false
        else
            PageEditable := true;
    end;

    //B2BVCOn28Sep22>>>
    /* trigger OnOpenPage()
     begin
         if (Rec.Status = Rec.Status::Released) then
             PageEditable := false
         else
             PageEditable := true;
     end;
     //B2BVCOn28Sep22>>>*/

    var
        PurchSetup: Record 312;
        ChangeExchangeRate: Page 511;
        CopyPurchDoc: Report 492;
        DocPrint: Codeunit 229;
        UserMgt: Codeunit 5700;
        ArchiveManagement: Codeunit 5063;
        "-- NAVIN": Integer;
        Text13000: Label 'No Setup exists for this Amount.';
        Text13001: Label 'Do you want to send the quote for Authorization?';
        Text13002: Label 'The Quote Is Authorized, You Cannot Resend For Authorization';
        Text13003: Label 'You Cannot Resend For Authorization';
        Text13004: Label 'This Quote Has been Rejected. Please Create A New Quote.';
        MLTransactionType: Option Purchase,Sale;
        PurchHeader: Record 38;
        POAutomation: Codeunit 50026;
        PageEditable: Boolean;//B2BVCOn28Sep22

    local procedure PaytoVendorNoOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;
}

