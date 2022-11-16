page 50127 QuotationComparSubForm
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Quotation Comparison Test";
    Caption = 'Quotation Comparison Subform';

    layout
    {
        area(content)
        {
            repeater(Control1102152000)
            {
                field("Actual Expansion Status"; ActualExpansionStatus)
                {
                    Caption = 'Expand';
                    Editable = false;
                    //OptionCaption = 'Integer';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ActualExpansionStatusOnPush();
                    end;
                }
                field("Quote No."; Rec."Quote No.")
                {
                    Editable = false;
                    ApplicationArea = all;

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;

                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Caption = 'No.';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Quality; Rec.Quality)
                {
                    Caption = 'Quality weight';
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    trigger OnValidate();
                    begin
                        CheckQtyBeforePO();
                    end;
                }
                field(Rate; Rec.Rate)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Last Direct Cost"; Rec."Last Direct Cost")
                {
                    BlankZero = true;
                    ApplicationArea = all;

                }
                //B2BMSOn06Oct21>>
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    Visible = false;
                }
                //B2BMSOn06Oct21<<
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = all;
                }

                field("Amt. including Tax"; Rec."Amt. including Tax")
                {
                    ToolTip = 'Specifies the value of the Amt. including Tax field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Budget Name"; Rec."Budget Name")
                {
                    ToolTip = 'Specifies the value of the Budget Name field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("CWIP No."; Rec."CWIP No.")
                {
                    ToolTip = 'Specifies the value of the CWIP No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Capex Line No."; Rec."Capex Line No.")
                {
                    ToolTip = 'Specifies the value of the Capex Line No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Capex No."; Rec."Capex No.")
                {
                    ToolTip = 'Specifies the value of the Capex No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field(Description2; Rec.Description2)
                {
                    ToolTip = 'Specifies the value of the Description2 field.';
                    ApplicationArea = All;
                }
                field(Discount; Rec.Discount)
                {
                    ToolTip = 'Specifies the value of the Discount field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.';
                    ApplicationArea = All;
                }
                field(Freight; Rec.Freight)
                {
                    ToolTip = 'Specifies the value of the Freight field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Excise Duty"; Rec."Excise Duty")
                {
                    ToolTip = 'Specifies the value of the Excise Duty field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("FA Posting Group"; Rec."FA Posting Group")
                {
                    ToolTip = 'Specifies the value of the FA Posting Group field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ToolTip = 'Specifies the value of the Indent Line No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ToolTip = 'Specifies the value of the Indent No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Insurance; Rec.Insurance)
                {
                    ToolTip = 'Specifies the value of the Insurance field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Is Leaf"; Rec."Is Leaf")
                {
                    ToolTip = 'Specifies the value of the Is Leaf field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Level; Rec.Level)
                {
                    ToolTip = 'Specifies the value of the Level field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ToolTip = 'Specifies the value of the Line Type field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Manufacturer Code"; Rec."Manufacturer Code")
                {
                    ToolTip = 'Specifies the value of the Manufacturer Code field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Manufacturer Ref. No."; Rec."Manufacturer Ref. No.")
                {
                    ToolTip = 'Specifies the value of the Manufacturer Ref. No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Material req No.s"; Rec."Material req No.s")
                {
                    ToolTip = 'Specifies the value of the Material req No.s field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("P & F"; Rec."P & F")
                {
                    ToolTip = 'Specifies the value of the P & F field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Parent Quote Line No"; Rec."Parent Quote Line No")
                {
                    ToolTip = 'Specifies the value of the Parent Quote Line No field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                    ToolTip = 'Specifies the value of the Payment Term Code field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Purc. Req No"; Rec."Purc. Req No")
                {
                    ToolTip = 'Specifies the value of the Purc. Req No field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Purch. Req Line No"; Rec."Purch. Req Line No")
                {
                    ToolTip = 'Specifies the value of the Purch. Req Line No field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quot Comp No."; Rec."Quot Comp No.")
                {
                    ToolTip = 'Specifies the value of the Quot Comp No. field.';
                    ApplicationArea = All;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    ToolTip = 'Specifies the value of the RFQ No. field.';
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ToolTip = 'Specifies the value of the Rating field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ToolTip = 'Specifies the value of the Requested Receipt Date field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Sales Tax"; Rec."Sales Tax")
                {
                    ToolTip = 'Specifies the value of the Sales Tax field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Service Code"; Rec."Service Code")
                {
                    ToolTip = 'Specifies the value of the Service Code field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Standard Price"; Rec."Standard Price")
                {
                    ToolTip = 'Specifies the value of the Standard Price field.';
                    ApplicationArea = All;
                    Visible = true;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field(Structure; Rec.Structure)
                {
                    ToolTip = 'Specifies the value of the Structure field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(VAT; Rec.VAT)
                {
                    ToolTip = 'Specifies the value of the VAT field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                    ApplicationArea = All;

                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Parent Quote No."; Rec."Parent Quote No.")
                {
                    Editable = false;
                    Caption = 'Quote No.';
                    Visible = false;
                }
                field("Parent Vendor"; Rec."Parent Vendor")
                {
                    Editable = false;
                    Caption = 'Vendor No.';
                    Visible = false;
                }

                field("Total Amount"; Rec."Total Amount")
                {
                    Editable = false;
                    ApplicationArea = all;
                }

                field("Variant Code"; Rec."Variant Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Carry Out Action"; Rec."Carry Out Action")
                {
                    ApplicationArea = all;
                }
                field(Price; Rec.Price)
                {
                    BlankZero = true;
                    Caption = 'Price Weightage';
                    Editable = false;
                }
                field(Delivery; Rec.Delivery)
                {
                    BlankZero = true;
                    Caption = 'Delivery Weightage';
                    Editable = false;
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Total Weightage"; Rec."Total Weightage")
                {
                    BlankZero = true;
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("&Expand")
            {
                Caption = '&Expand';
                action("E&xpand All")
                {
                    Caption = 'E&xpand All';
                    Image = ExplodeBOM;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        ExpandAll;
                    end;
                }
                action("C&ollapse All")
                {
                    Caption = 'C&ollapse All';
                    Image = CollapseDepositLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        InitTempTable;
                    end;
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ENN = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 66;
                    ApplicationArea = All;
                    RunPageLink = "RFQ No." = FIELD("RFQ No."),
                                  "Vendor No." = FIELD("Vendor No.");
                }
            }
        }
    }




    trigger OnDeleteRecord(): Boolean;
    begin
        //IF Rec.Status <> Rec.Status::Open then
        // error('You can only delete the lines when approval status is in open.');
        /*TempReqLine := Rec;

        WHILE (TempReqLine.NEXT() <> 0) AND (TempReqLine.Level > Level) DO
            TempReqLine.DELETE(TRUE);
        TempReqLine := Rec;
        EXIT(TempReqLine.DELETE());*/
    end;


    trigger OnModifyRecord(): Boolean;
    begin
        IF (Rec.Status <> Rec.Status::Open) or (Rec.Status <> Rec.Status::" ") then
            error('You can only Modify the lines when approval status is in open.');

    end;

    procedure InitTempTable();
    begin
        ReqLine.RESET;
        ReqLine.COPYFILTERS(TempReqLine);
        TempReqLine.DELETEALL;
        //IF RFQNumber <>'' THEN
        //ReqLine.SETRANGE("RFQ No.",RFQNumber);
        IF ReqLine.FIND('-') THEN
            REPEAT
                IF ReqLine.Level = 0 THEN BEGIN
                    TempReqLine := ReqLine;
                    TempReqLine.INSERT;
                END;
            UNTIL ReqLine.NEXT = 0;
    end;

    local procedure ExpandAll();
    var
        ReqLine: Record "Quotation Comparison Test";
    begin
        ReqLine.RESET;
        ReqLine.COPYFILTERS(TempReqLine);
        TempReqLine.DELETEALL;

        IF ReqLine.FIND('-') THEN
            REPEAT
                TempReqLine := ReqLine;
                TempReqLine.INSERT;
            UNTIL ReqLine.NEXT = 0;
    end;





    var
        ReqLine: Record "Quotation Comparison Test";
        TempReqLine: Record "Quotation Comparison Test" temporary;
        QuoteCompare: Record "Quotation Comparison Test";
        PurchHeader: Record 38;
        PurchLine: Record 39;
        //RFQNumbers: Record 50017;
        RFQNumber: Code[20];
        [InDataSet]
        POQty: Decimal;
        PQQty: Decimal;
        PORaiseQty: Decimal;
        Text011Lbl: Label 'Quantity Exceeded than  Order Raised';
        ActualExpansionStatus: Integer;

    local procedure IsExpanded(ActualReqLine: Record "Quotation Comparison Test"): Boolean;
    begin
        TempReqLine := ActualReqLine;
        IF TempReqLine.NEXT() = 0 THEN
            EXIT(FALSE);
        EXIT(TempReqLine.Level > ActualReqLine.Level);
    end;

    local procedure ToggleExpandCollapse();
    var
    begin
        IF ActualExpansionStatus = 0 THEN BEGIN // Has children, but not expanded
            ReqLine.SETRANGE(Level, Rec.Level, Rec.Level + 1);
            ReqLine := Rec;
            IF ReqLine.NEXT() <> 0 THEN
                REPEAT
                    IF ReqLine.Level > Rec.Level THEN BEGIN
                        TempReqLine := ReqLine;
                        IF TempReqLine.INSERT() THEN;
                    END;
                UNTIL (ReqLine.NEXT() = 0) OR (ReqLine.Level = Rec.Level);
        END ELSE
            IF ActualExpansionStatus = 1 THEN BEGIN // Has children and is already expanded
                TempReqLine := Rec;
                WHILE (TempReqLine.NEXT() <> 0) AND (TempReqLine.Level > Rec.Level) DO
                    TempReqLine.DELETE();

            END;
        CurrPage.UPDATE();
    end;

    procedure SetExpansionStatus();
    begin
        CASE TRUE OF
            IsExpanded(Rec):
                ActualExpansionStatus := 1;
            Rec.Level = 0:
                ActualExpansionStatus := 0
            ELSE
                ActualExpansionStatus := 2;
        END;
    end;

    local procedure SelectCurrentRFQNo();
    begin
        Rec.RESET();
        Rec.SETRANGE("RFQ No.", RFQNumber);
        IF Rec.FINDFIRST() THEN
            CurrPage.UPDATE(true)
        else begin
            Rec.SETRANGE("RFQ No.", '');
            CurrPage.UPDATE(true);
        end;

    end;


    local procedure ActualExpansionStatusOnPush();
    begin
        ToggleExpandCollapse();
    end;

    procedure CheckQtyBeforePO();
    begin
        IF Rec."RFQ No." = '' THEN
            ERROR('Please select the RFQ Number');

        POQty := 0;
        PQQty := 0;
        PORaiseQty := 0;

        PurchHeader.RESET();
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchHeader.FINDSET() THEN BEGIN
            PurchLine.RESET();
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            PurchLine.SETRANGE("No.", Rec."Item No.");
            IF PurchLine.FINDSET() THEN
                REPEAT
                    PQQty += PurchLine.Quantity;
                UNTIL PurchLine.NEXT() = 0;
        END;

        PurchHeader.RESET();
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchHeader.FINDSET() THEN
            REPEAT
                PurchLine.RESET();
                PurchLine.SETRANGE("Document No.", PurchHeader."No.");
                PurchLine.SETRANGE("No.", Rec."Item No.");
                IF PurchLine.FINDSET() THEN
                    REPEAT
                        POQty += PurchLine.Quantity;
                    UNTIL PurchLine.NEXT() = 0;
            UNTIL PurchHeader.NEXT() = 0;

        QuoteCompare.RESET();
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETRANGE("Carry Out Action", TRUE);
        QuoteCompare.SETRANGE("Item No.", Rec."Item No.");
        IF QuoteCompare.FINDSET() THEN
            REPEAT
                PORaiseQty += QuoteCompare.Quantity;
            UNTIL QuoteCompare.NEXT() = 0;
        IF (PORaiseQty + POQty) > PQQty THEN
            ERROR(Text011Lbl);
    end;


    procedure CheckQtyBeforePOAll();
    begin
        IF RFQNumber = '' THEN
            ERROR('Please select the RFQ Number');

        POQty := 0;
        PQQty := 0;
        PORaiseQty := 0;
        PurchHeader.RESET();
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchHeader.FINDSET() THEN BEGIN
            PurchLine.RESET();
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            PurchLine.SETRANGE("No.", Rec."Item No.");
            IF PurchLine.FINDSET() THEN
                REPEAT
                    PQQty += PurchLine.Quantity;
                UNTIL PurchLine.NEXT() = 0;
        END;

        PurchHeader.RESET();
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchHeader.FINDSET() THEN
            REPEAT
                PurchLine.RESET();
                PurchLine.SETRANGE("Document No.", PurchHeader."No.");
                PurchLine.SETRANGE("No.", Rec."Item No.");
                IF PurchLine.FINDSET() THEN
                    REPEAT
                        POQty += PurchLine.Quantity;
                    UNTIL PurchLine.NEXT() = 0;
            UNTIL PurchHeader.NEXT() = 0;

        QuoteCompare.RESET();
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETRANGE("Carry Out Action", TRUE);
        QuoteCompare.SETRANGE("Item No.", Rec."Item No.");
        IF QuoteCompare.FINDSET() THEN
            REPEAT
                PORaiseQty += QuoteCompare.Quantity;
            UNTIL QuoteCompare.NEXT() = 0;
        IF (PORaiseQty + POQty) > PQQty THEN
            ERROR(Text011Lbl);
    end;

    procedure SetRecFilters();
    begin
        Rec.RESET;
        Rec.SetRange("Quote No.", '');

        CurrPage.UPDATE(FALSE);
    end;

    trigger OnOpenPage()
    var

    begin
        /*RFQNumbers.RESET;
        RFQNumbers.SETRANGE(RFQNumbers."RFQ No.", '');

        //END
        RFQNumber := Rec."RFQ No.";
        IF RFQNumber <> '' THEN
            IF NOT RFQNumbers.GET(RFQNumber) THEN
                RFQNumber := '';

        IF RFQNumber = '' THEN BEGIN
            //RFQNumbers.SETRANGE("Location Code",FALSE);//REACH UD
            RFQNumbers.SETRANGE(Completed, FALSE);
            IF RFQNumbers.FIND('-') THEN
                RFQNumber := RFQNumbers."RFQ No."
            ELSE
                RFQNumber := '';
        END;
        SelectCurrentRFQNo;
        RFQNumber := '';
        InitTempTable;
        SetRecFilters;
        CurrPage.UPDATE(FALSE);*/
    end;

}