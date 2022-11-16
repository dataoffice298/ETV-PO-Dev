page 50120 "Indent Requisition Document"
{
    // version PO1.0

    PageType = Document;
    SourceTable = "Indent Req Header";
    PromotedActionCategories = 'New,Process,Reports,Functions,Navigate';

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = FieldEditable;//B2BVCOn28Sep22
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
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 1 Code';
                    //Editable = False; //B2BPGON11OCT2022

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 2 Code';
                    //Editable = False; //B2BPGON11OCT2022

                }

            }
            part(Indentrequisations; 50119)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
                Editable = FieldEditable;//B2BVCOn28Sep22
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Requisition Lines")
            {
                Caption = 'Get Indent Lines';
                Promoted = true;
                ApplicationArea = All;
                Image = GetLines;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    Clear(IndentReqLines);
                    IndentReqLines.GetValue(Rec."No.", Rec."Resposibility Center");
                    IndentReqLines.RUN;
                    Message('Lines Inserted Successfully.'); //B2BPAV
                end;
            }
            action("Create &Enquiry")
            {
                Caption = 'Create &Enquiry';
                Promoted = true;
                ApplicationArea = All;
                Image = Create;
                PromotedCategory = Category4;
                PromotedIsBig = true;

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
                                MESSAGE(Text0010);
                            END ELSE
                                EXIT;
                        END;
                    END;
                end;
            }
            action("Create &Quote")
            {
                Caption = 'Create &Quote';
                Promoted = true;
                ApplicationArea = All;
                Image = NewSalesQuote;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction();
                begin

                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Quote);
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
                        IF NOT CONFIRM(Text004) THEN
                            EXIT;
                        CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        CLEAR(VendorList);
                        VendorList.LOOKUPMODE(TRUE);
                        VendorList.RUNMODAL;
                        VendorList.SetSelection(Vendor);
                        IF Vendor.COUNT >= 1 THEN BEGIN
                            POAutomation.CreateQuotes(CreateIndents, Vendor, Rec."No.Series");
                            MESSAGE(Text0011);

                        END ELSE
                            EXIT;
                    END;
                end;
            }
            action("Create &Purchase Order")
            {
                Caption = 'Create &Purchase Order';
                Promoted = true;
                ApplicationArea = All;
                Image = MakeOrder;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Order);
                    Carry := 0;
                    //raju
                    CheckRemainingQuantity;
                    //raju
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
                        IF NOT CONFIRM(Text005) THEN
                            EXIT;
                        CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        //B2B.1.3 S
                        /*
                         CLEAR(VendorList);
                         VendorList.LOOKUPMODE(TRUE);
                         VendorList.RUNMODAL;
                         VendorList.SetSelection(Vendor);

                         IF Vendor.COUNT>=1 THEN BEGIN
                         */

                        UpdateReqQty;
                        POAutomation.CreateOrder2(CreateIndents, Vendor, Rec."No.Series");
                        MESSAGE(Text001);
                        /*
                        MESSAGE(Text001);
                       END ELSE
                       EXIT;
                       */
                        //B2B.1.3 E
                    END;

                end;
            }
            action("Re&lease")
            {
                Caption = 'Re&lease';
                Image = ReleaseDoc;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    IndentReqLine: Record "Indent Requisitions";
                    RelText1: Label 'Document released and Moved to Local Indent Requisition List.';
                    RelText2: Label 'Document released and Moved to Central Indent Requisition List.';
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    //B2BESGOn19May2022++
                    IndentReqLine.Reset();
                    IndentReqLine.SetRange("Document No.", Rec."No.");
                    if not IndentReqLine.FindFirst() then begin
                        Error('No Lines Found');
                    end;
                    //B2BESGOn19May2022--
                    Rec.TestField("Resposibility Center"); //B2BMS
                    Rec.TESTFIELD("Document Date");

                    Rec.Status := Rec.Status::Release;
                    Rec.MODIFY;
                    if Rec."Resposibility Center" = 'LOCAL REQ' then
                        Message(RelText1);
                    if Rec."Resposibility Center" = 'CENTRL REQ' then
                        Message(RelText2);
                end;

            }
            action("Re&open")
            {
                Caption = 'Re&open';
                Image = ReOpen;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    ReText01: Label 'Document has been re-opened and moved to Indent Requisition List.';
                begin
                    Rec.TestField(Status, Rec.Status::Release);
                    Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                    Message(ReText01);
                end;
            }
        }
        area(navigation)
        {
            group(Orders)
            {
                action("Created &Order")
                {
                    Caption = 'Open Created Order';
                    Promoted = true;
                    ApplicationArea = All;
                    Image = Open;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        CreatedOrders;
                    end;
                }

                action(OpenEnquiries)
                {
                    Caption = 'Open Created Enquiries';
                    Promoted = true;
                    ApplicationArea = All;
                    Image = ShowList;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Enquiry);
                        PurchHeader.SETRANGE("Indent Requisition No", Rec."No.");
                        IF PurchHeader.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Purchase Enquiry List", PurchHeader);
                    end;
                }

                action(OpenQuotes)
                {
                    Caption = 'Open Created Quotes';
                    Promoted = true;
                    ApplicationArea = All;
                    Image = EntriesList;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE("Indent Requisition No", Rec."No.");
                        IF PurchHeader.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Purchase Quotes", PurchHeader);
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
        Text001: Label 'Orders are created successfully.';
        Text003: Label 'Do you want to create Enquiries?';
        Text004: Label 'Do you want to create Quotations?';
        Text005: Label 'Do you want to create Orders?';
        Text0010: Label 'Enquiries Created Successfully';
        Text0011: Label 'Quotes Created Successfully';
        FieldEditable: Boolean; //B2BVCOn28Sep22

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

    trigger OnInit()
    begin
        Rec.Status := Rec.Status::Open;
    end;

    //B2BPGON11OCT2022
    trigger OnAfterGetRecord();
    begin

        if (Rec.Status = Rec.Status::Release) then
            FieldEditable := false
        else
            FieldEditable := true;

        //Rec.Status := Rec.Status::Open;
    end;

    trigger OnOpenPage()
    begin
        /*   //B2BVCOn28Sep22>>>>
           if (Rec.Status = Rec.Status::Release) then
               FieldEditable := false
           else
               FieldEditable := true;
           //B2BVCOn28Sep22<<<<
           Rec.Status := Rec.Status::Open;*/  //B2BPGON11OCT2022
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Open;
    end;
}

