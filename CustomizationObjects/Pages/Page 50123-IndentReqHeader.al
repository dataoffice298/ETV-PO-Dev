page 50123 "IndentRequisitionDocument New"
{
    // version PO1.0

    PageType = Document;
    SourceTable = "Indent Req Header";
    Caption = 'Quotation Comparision Doc';
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Resposibility Center"; Rec."Resposibility Center")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No.Series"; Rec."No.Series")
                {
                    ApplicationArea = All;
                }
            }
            part(Indentrequisations; 50122)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {

            action("&Calculate Plan")
            {
                Caption = '&Calculate Plan';
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                begin

                    POAutomation.InsertQuotationLines(RFQNumber);
                    QuoteCompare.RESET;
                    CurrPage.UPDATE(FALSE);
                    InitTempTable;
                    //SetRecFilters;
                    CurrPage.UPDATE(FALSE);
                end;
            }
            action("Create &Enquiry")
            {
                Caption = 'Create &Enquiry';
                Promoted = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Enquiry);
                    Carry := 0;
                    Indentreqline.RESET;
                    Indentreqline.SETRANGE("Document No.", Rec."No.");
                    IF Indentreqline.FIND('-') THEN
                        REPEAT
                            IF Indentreqline."Carry out Action" THEN
                                Carry += 1;
                        UNTIL Indentreqline.NEXT = 0;
                    IF Carry <= 0 THEN
                        ERROR('Carry out action should not be blank');
                    IF Indentreqline.FIND('-') THEN BEGIN
                        IF NOT CONFIRM(Text003) THEN
                            EXIT;
                        CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        CLEAR(VendorList);
                        VendorList.LOOKUPMODE(TRUE);
                        IF VendorList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            VendorList.SetSelection(Vendor);
                            IF Vendor.COUNT >= 1 THEN BEGIN
                                POAutomation.CreateEnquiries(CreateIndents, Vendor, Rec."No.Series");
                                MESSAGE(Text0010)
                            END ELSE
                                EXIT;
                        END;
                    END;
                end;
            }

            action("Re&lease")
            {
                Caption = 'Re&lease';
                Image = ReleaseDoc;
                Promoted = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                    IndentReqLine: Record "Indent Requisitions";
                begin
                    //B2BESGOn19May2022++
                    IndentReqLine.Reset();
                    IndentReqLine.SetRange("Document No.", Rec."No.");
                    if not IndentReqLine.FindFirst() then begin
                        Error('No Lines Found');
                    end;
                    //B2BESGOn19May2022--

                    Rec.TESTFIELD("Document Date");
                    IF Rec.Status = Rec.Status::Release THEN
                        EXIT
                    ELSE
                        Rec.Status := Rec.Status::Release;
                    Rec.MODIFY;
                end;
            }
            action("Re&open")
            {
                Caption = 'Re&open';
                Image = ReOpen;
                Promoted = true;
                ApplicationArea = All;

                trigger OnAction();
                begin

                    IF Rec.Status = Rec.Status::Open THEN
                        EXIT
                    ELSE
                        Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                end;
            }
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
            action("C&arryout Action")
            {
                Caption = 'C&arryout Action';
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                var
                    QuoteCompareLocal: Record 50041;
                begin
                    /*
                    QuoteCompareArchive.SETRANGE("RFQ No.","RFQ No.");
                    IF QuoteCompareArchive.FIND('-') THEN
                      REPEAT
                        QuoteCompareArchive.DELETE;
                      UNTIL QuoteCompareArchive.NEXT=0;
                    QuoteCompareArchive.RESET;
                    QuoteCompareArchive.SETFILTER("Line No.",'>%1',1);
                    QuoteCompareArchive.SETRANGE("RFQ No.",'');
                    IF QuoteCompareArchive.FIND('-') THEN
                      QuoteCompareArchive.DELETE;
                    QuotationComparisionDelete.RESET;
                    REPEAT
                      ArchiveQCS(QuotationComparisionDelete);
                    UNTIL QuotationComparisionDelete.NEXT=0;

                    //REPORT.RUN(REPORT::"Purchase Order Creation"); //REP1.0
                    QuotationComparisionDelete.DELETEALL;
                    CurrPage.UPDATE;

                    *///B2B1.1

                    IF Noseries2 = '' THEN
                        ERROR('Please select the No.Series');

                    CheckQtyBeforePO;

                    QuoteCompareArchive.SETRANGE("RFQ No.", Rec."RFQ No.");
                    IF QuoteCompareArchive.FIND('-') THEN
                        REPEAT
                            QuoteCompareArchive.DELETE;
                        UNTIL QuoteCompareArchive.NEXT = 0;
                    QuoteCompareArchive.RESET;
                    QuoteCompareArchive.SETFILTER("Line No.", '>%1', 1);
                    QuoteCompareArchive.SETRANGE("RFQ No.", '');
                    IF QuoteCompareArchive.FIND('-') THEN
                        QuoteCompareArchive.DELETE;
                    QuotationComparisionDelete.RESET;
                    REPEAT
                        ArchiveQCS(QuotationComparisionDelete);
                    UNTIL QuotationComparisionDelete.NEXT = 0;

                    POCreationReport.GetValues(Noseries2);
                    POCreationReport.RUN;

                    //B2B1.1START

                    QuotationComparisionDelete.RESET;
                    QuotationComparisionDelete.SETRANGE("Carry Out Action", TRUE);
                    IF QuotationComparisionDelete.FINDFIRST THEN BEGIN
                        QuotationComparisionDelete.DELETE;//B2B1.1
                    END;

                    //END B2B1.1
                    CurrPage.UPDATE;

                end;
            }

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Visible = true;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin

                    //   IF approvalmngmt.CheckQuoteComparisionIRHApprovalsWorkflowEnabled(Rec) then
                    //       approvalmngmt.OnSendQuoteComparisionIRHForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                Visible = true;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    // approvalmngmt.OnCancelQuoteComparisionIRHForApproval(Rec);
                end;
            }

        }
        area(navigation)
        {
            group(Orders)
            {
                action("Created &Order")
                {
                    Image = Card;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        CreatedOrders;
                    end;
                }
            }
        }
    }

    var
        Carry: Integer;
        IndentReqHeader: Record 50045;
        Indentreqline: Record 50038;
        POAutomation: Codeunit 50026;
        CreateIndents: Record 50038;
        QuoteCompare: Record 50041;
        Vendor: Record 23;
        VendorList: Page 27;
        PurchaseOrder: Record 38;
        Usermgt: Codeunit 5700;
        "-----Mail": Integer;
        Email: Text[50];
        StrVar: Text[50];
        Chr: Char;
        MailCreated: Boolean;
        "---": Integer;
        UserSetupApproval: Page 119;
        UserSetup2: Record 91;
        IndentReqLines: Report 50001;
        RFQNumber: Code[20];
        ReqLine: Record 50041;
        TempReqLine: Record 50041 temporary;
        approvalmngmt: Codeunit 50001;
        "Location CodeEmphasize": Boolean;
        Text19068734: Label 'RFQ No.';
        "-B2B1.1-": Integer;
        Noseries2: Code[20];
        PPsetup: Record 312;
        NoSeries: Record 310;
        POQty: Decimal;
        PQQty: Decimal;
        PORaiseQty: Decimal;
        PurchHeader: Record 38;
        PurchLine: Record 39;
        QuotationComparisionDelete: Record 50041;

        QuoteCompareArchive: Record 50044;



        OpenApprEntrEsists: Boolean;
        CanrequestApprovForFlow: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;
        OpenAppEntrExistsForCurrUser: Boolean;
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";
        // -B2BMS
        Text50000: Label 'Quantity Exceeded than  Order Raised';
        POCreationReport: Report 50099;
        Text001: Label 'Orders are created successfully.';
        Text003: Label 'Do you want to create Enquiries?';
        Text004: Label 'Do you want to create Quotations?';
        Text005: Label 'Do you want to create Orders?';
        Text0010: Label 'Enquiries Created Successfully';
        Text0011: Label 'Quotes Created Successfully';

    procedure CheckRemainingQuantity();
    var
        IndentReqHeaderCheck: Record 50045;
        IndentRequisitionsCheck: Record 50038;
        CountVar: Integer;
        Text001: Label 'You Cannot create PO . Quantity not more than Zero.';
    begin
        CountVar := 0;
        IndentReqHeaderCheck.RESET;
        IndentReqHeaderCheck.SETRANGE("No.", Rec."No.");
        IF IndentReqHeaderCheck.FINDFIRST THEN
            IndentRequisitionsCheck.RESET;
        IndentRequisitionsCheck.SETRANGE("Document No.", IndentReqHeaderCheck."No.");
        IF IndentRequisitionsCheck.FINDSET THEN
            REPEAT
                //  IF IndentRequisitionsCheck."Remaining Quantity" <> 0 THEN
                CountVar += 1;
            UNTIL IndentRequisitionsCheck.NEXT = 0;
        IF CountVar = 0 THEN
            ERROR(Text001);
    end;

    procedure ArchiveQCS(QuotationComparision2: Record 50041);
    begin
        QuoteCompareArchive.RESET;
        QuoteCompareArchive.INIT;
        QuoteCompareArchive.TRANSFERFIELDS(QuotationComparision2);
        IF NOT (QuoteCompareArchive."Line No." = 0) THEN
            QuoteCompareArchive.INSERT(TRUE);
    end;

    procedure CheckQtyBeforePO();
    begin
        IF RFQNumber = '' THEN
            ERROR('Please select the RFQ Number');

        POQty := 0;
        PQQty := 0;
        PORaiseQty := 0;

        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchHeader.FINDSET THEN BEGIN
            PurchLine.RESET;
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            //PurchLine.SETRANGE("No.", Rec."Item No.");
            IF PurchLine.FINDSET THEN
                REPEAT
                    PQQty += PurchLine.Quantity;
                UNTIL PurchLine.NEXT = 0;
        END;

        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchHeader.FINDSET THEN
            REPEAT
                PurchLine.RESET;
                PurchLine.SETRANGE("Document No.", PurchHeader."No.");
                //PurchLine.SETRANGE("No.", Rec."Item No.");
                IF PurchLine.FINDSET THEN
                    REPEAT
                        POQty += PurchLine.Quantity;
                    UNTIL PurchLine.NEXT = 0;
            UNTIL PurchHeader.NEXT = 0;

        QuoteCompare.RESET;
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETRANGE("Carry Out Action", TRUE);
        //QuoteCompare.SETRANGE("Item No.", Rec."Item No.");
        IF QuoteCompare.FINDSET THEN
            REPEAT
                PORaiseQty += QuoteCompare.Quantity;
            UNTIL QuoteCompare.NEXT = 0;
        IF (PORaiseQty + POQty) > PQQty THEN
            ERROR(Text50000);
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

    procedure CreatedOrders();
    var
        PurchHeader: Record 38;
    begin
        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("Indent Requisition No", Rec."No.");
        IF PurchHeader.FINDSET THEN
            PAGE.RUNMODAL(0, PurchHeader);
    end;

    local procedure ExpandAll();
    var
        ReqLine: Record 50041;
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

    procedure UpdateReqQty();
    var
        IndenReqRec: Record 50038;
        IndentLineRec: Record 50037;
        IndentReqHeaderRec: Record 50045;
        QuantyLvar: Decimal;
        IndentLineRec2: Record 50037;
    begin
        //B2B.1.4 START
        IndenReqRec.RESET;
        IndenReqRec.SETRANGE("Document No.", Rec."No.");
        IF IndenReqRec.FINDSET THEN BEGIN
            REPEAT

                CLEAR(QuantyLvar);
                IF IndenReqRec."Qty. To Order" > IndenReqRec."Vendor Min.Ord.Qty" THEN
                    QuantyLvar := IndenReqRec."Qty. To Order"
                ELSE
                    // QuantyLvar := IndenReqRec."Vendor Min.Ord.Qty" ;
                    IndentLineRec.RESET;
                IndentLineRec.SETRANGE("Indent Req No", IndenReqRec."Document No.");
                IndentLineRec.SETRANGE("Indent Req Line No", IndenReqRec."Line No.");
                IndentLineRec.SETFILTER(IndentLineRec."Req.Quantity", '<>%1', 0);
                IndentLineRec.SETFILTER(IndentLineRec."Req.Quantity", '>=%1', QuantyLvar);
                IF IndentLineRec.FINDSET THEN BEGIN
                    IndentLineRec."Req.Quantity" := IndentLineRec."Req.Quantity" - QuantyLvar;
                    IF IndentLineRec."Req.Quantity" < 0 THEN
                        IndentLineRec."Req.Quantity" := 0;
                    IndentLineRec.MODIFY;
                    CLEAR(QuantyLvar);
                END ELSE
                    IndentLineRec2.RESET;
                IndentLineRec2.SETRANGE("Indent Req No", IndenReqRec."Document No.");
                IndentLineRec2.SETRANGE("Indent Req Line No", IndenReqRec."Line No.");
                IndentLineRec2.SETFILTER("Req.Quantity", '<>%1', 0);
                IndentLineRec2.SETFILTER("Req.Quantity", '<%1', QuantyLvar);
                IF IndentLineRec2.FINDSET THEN
                    REPEAT

                        IF ((QuantyLvar <> 0) AND (QuantyLvar >= IndentLineRec2."Req.Quantity")) THEN BEGIN
                            QuantyLvar -= IndentLineRec2."Req.Quantity";
                            IndentLineRec2."Req.Quantity" := 0;
                            IndentLineRec2.MODIFY;
                        END ELSE
                            IF ((QuantyLvar <> 0) AND (QuantyLvar < IndentLineRec2."Req.Quantity")) THEN BEGIN
                                IndentLineRec2."Req.Quantity" -= QuantyLvar;
                                IndentLineRec2.MODIFY;
                                CLEAR(QuantyLvar);
                            END;

                    UNTIL IndentLineRec2.NEXT = 0;

            UNTIL IndenReqRec.NEXT = 0;
        END;

        //Commented //B2B.1.4
        /*
        IndenReqRec.RESET;
        IndenReqRec.SETRANGE("Document No.","No.");
        IF IndenReqRec.FINDSET THEN BEGIN
            IF IndentLineRec.GET(IndenReqRec."Indent No.",IndenReqRec."Indent Line No.") THEN BEGIN
                IF IndenReqRec."Qty. To Order" > IndenReqRec."Vendor Min.Ord.Qty" THEN
                  IndentLineRec."Req.Quantity" := IndentLineRec."Req.Quantity" - IndenReqRec."Qty. To Order"
                ELSE IF IndenReqRec."Qty. To Order" < IndenReqRec."Vendor Min.Ord.Qty" THEN BEGIN
                  IndentLineRec."Req.Quantity" := IndentLineRec."Req.Quantity" - IndenReqRec."Vendor Min.Ord.Qty";
                  IF IndentLineRec."Req.Quantity" < 0 THEN
                    IndentLineRec."Req.Quantity" := 0;
                END;
                IndentLineRec.MODIFY;
            END;
          UNTIL IndenReqRec.NEXT = 0;
        END;
        
         */
        //B2B.1.4 END

    end;


    trigger OnAfterGetRecord();
    begin


        // +B2BMS
        /*
        OpenAppEntrExistsForCurrUser := approvalmngmt.
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
        // -B2BMS
        */

    end;
}

