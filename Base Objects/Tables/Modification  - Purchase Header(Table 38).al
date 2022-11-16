tableextension 50054 tableextension70000010 extends "Purchase Header"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,B2BQC1.00.00,PO

    fields
    {
        modify("Document Type")
        {
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Enquiry', ENN = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Enquiry';

            //Unsupported feature: Change OptionString on ""Document Type"(Field 1)". Please convert manually.

        }
        field(51000; Subject; Text[200])
        {
            Caption = 'Subject';
        }
        field(50110; "LC No."; Code[20])
        {
            Caption = 'LC No.';
            TableRelation = "LC Details"."No." WHERE("Transaction Type" = CONST(Purchase), "Issued To/Received From" = FIELD("Pay-to Vendor No."), Closed = CONST(false), Released = CONST(true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                LCDetail: Record "LC Details";
                Text13700: Label 'The LC which you have selected is Foreign type you cannot utilise for this order.';
            begin
                IF "LC No." <> '' THEN BEGIN
                    LCDetail.GET("LC No.");
                    IF LCDetail."Type of LC" = LCDetail."Type of LC"::Foreign THEN
                        IF "Currency Code" = '' THEN
                            ERROR(Text13700);
                END;
            end;
        }
        Field(50111; "Bill of Entry No"; Code[20])
        {
            Caption = 'Bill of Entry No';
        }
        Field(50112; "EPCG No."; Code[20])
        {
            Caption = 'EPCG No';
        }
        field(50113; "EPCG Scheme"; Option)
        {
            OptionMembers = "Under EPCG","Non EPCG";
            OptionCaption = 'Under EPCG,Non EPCG';
        }
        field(50114; "Import Type"; Option)
        {
            OptionMembers = Import,Indigenous;
            OptionCaption = 'Import,Indigenous';
        }
        //B2BMSOn18Oct2022>>
        Field(50115; "Regularization"; Boolean)
        {
            Caption = 'Regularization';
        }
        //B2BMSOn18Oct2022<<
        field(33002900; "RFQ No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "RFQ Numbers"."RFQ No." WHERE(Completed = FILTER(false));

            trigger OnValidate();
            var
                RFQNumbers: Record "RFQ Numbers";
            begin
                IF RFQNumbers.GET("RFQ No.") THEN BEGIN
                    IF RFQNumbers."Location Code" <> '' THEN BEGIN
                        RFQNumbers.MODIFY;
                        IF RFQNumbers."Location Code" <> "Location Code" THEN
                            ERROR('Should not use this RFQ Numbers at this location');
                    END ELSE
                        RFQNumbers."Location Code" := "Location Code";
                    RFQNumbers.MODIFY;
                END;
            end;
        }
        field(33002901; "Quotation No."; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002902; "ICN No."; Code[20])
        {
            Description = 'PO1.0';
            Editable = false;
            TableRelation = "Quotation Comparison";
        }
        field(33002903; "Indent Requisition No"; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002904; "Approval Status"; Option)
        {
            OptionMembers = ,Open,"Pending Approval",Released;
            OptionCaption = ' ,Open,Pending Approval,Released';
        }

    }


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
      ERROR(
        Text023,
        RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

    PurchPost.DeleteHeader(
      Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
      ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
    VALIDATE("Applies-to ID",'');
    VALIDATE("Incoming Document Entry No.",0);

    #12..47
    GateEntryAttachment2.SETRANGE("Entry Type",GateEntryAttachment2."Entry Type"::Inward);
    GateEntryAttachment2.SETRANGE("Source No.","No.");
    GateEntryAttachment2.DELETEALL;

    IF (PurchRcptHeader."No." <> '') OR
       (PurchInvHeader."No." <> '') OR
       (PurchCrMemoHeader."No." <> '') OR
       (ReturnShptHeader."No." <> '') OR
       (PurchInvHeaderPrepmt."No." <> '') OR
       (PurchCrMemoHeaderPrepmt."No." <> '')
    THEN
      MESSAGE(PostedDocsToPrintCreatedMsg);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    PurchPost.TestDeleteHeader(
      Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
      ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
    #51..57
    THEN BEGIN
      DELETE;

      IF PurchRcptHeader."No." <> '' THEN
        IF CONFIRM(
             Text000,TRUE,
             PurchRcptHeader."No.")
        THEN BEGIN
          PurchRcptHeader.SETRECFILTER;
          PurchRcptHeader.PrintRecords(TRUE);
        END;

      IF PurchInvHeader."No." <> '' THEN
        IF CONFIRM(
             Text001,TRUE,
             PurchInvHeader."No.")
        THEN BEGIN
          PurchInvHeader.SETRECFILTER;
          PurchInvHeader.PrintRecords(TRUE);
        END;

      IF PurchCrMemoHeader."No." <> '' THEN
        IF CONFIRM(
             Text002,TRUE,
             PurchCrMemoHeader."No.")
        THEN BEGIN
          PurchCrMemoHeader.SETRECFILTER;
          PurchCrMemoHeader.PrintRecords(TRUE);
        END;

      IF ReturnShptHeader."No." <> '' THEN
        IF CONFIRM(
             Text024,TRUE,
             ReturnShptHeader."No.")
        THEN BEGIN
          ReturnShptHeader.SETRECFILTER;
          ReturnShptHeader.PrintRecords(TRUE);
        END;

      IF PurchInvHeaderPrepmt."No." <> '' THEN
        IF CONFIRM(
             Text043,TRUE,
             PurchInvHeader."No.")
        THEN BEGIN
          PurchInvHeaderPrepmt.SETRECFILTER;
          PurchInvHeaderPrepmt.PrintRecords(TRUE);
        END;

      IF PurchCrMemoHeaderPrepmt."No." <> '' THEN
        IF CONFIRM(
             Text044,TRUE,
             PurchCrMemoHeaderPrepmt."No.")
        THEN BEGIN
          PurchCrMemoHeaderPrepmt.SETRECFILTER;
          PurchCrMemoHeaderPrepmt.PrintRecords(TRUE);
        END;
      PurchPost.DeleteHeader(
        Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
        ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
    END;

    #9..50
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        Text000: TextConst ENU = 'Do you want to print receipt %1?', ENN = 'Do you want to print receipt %1?';
        Text001: TextConst ENU = 'Do you want to print invoice %1?', ENN = 'Do you want to print invoice %1?';
        Text002: TextConst ENU = 'Do you want to print credit memo %1?', ENN = 'Do you want to print credit memo %1?';

    var
        Text024: TextConst ENU = 'Do you want to print return shipment %1?', ENN = 'Do you want to print return shipment %1?';

    var
        Text043: TextConst ENU = 'Do you want to print prepayment invoice %1?', ENN = 'Do you want to print prepayment invoice %1?';
        Text044: TextConst ENU = 'Do you want to print prepayment credit memo %1?', ENN = 'Do you want to print prepayment credit memo %1?';

    var
        "-B2BQC1.00.00-": Integer;
        //InspectJnlLine: Codeunit "33000253";//Balu
        "---PH--": Integer;
        IndentHeader: Record "Indent Header";
        IndentLine: Record "Indent Line";
        PurchLine1: Record "Purchase Line";
        PurchLineNo: Integer;

}

