table 50049 "Archive Quotation Header"
{

    DataClassification = CustomerContent;
    Caption = 'Archive Quotation Header';
    LookupPageId = "Archive Quotation List";
    DrillDownPageId = "Archive Quotation List";

    fields
    {
        field(1; "No."; Code[20])
        {

            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                TestStatusOpen();
            end;
        }
        field(2; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate();
            begin
                TestStatusOpen();
            end;
        }
        field(13; Status; Option)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            OptionMembers = " ",Open,"Pending Approval",Released;
            OptionCaption = ' ,Open,Pending Approval,Released';
            trigger OnValidate();
            begin
            end;


        }
        field(15; "No. Series"; Code[20])
        {

            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            trigger OnLookup();
            begin
                PurchaseSetup.GET;
                Noseries.SETRANGE(Code, PurchaseSetup."Order Nos.");
                IF PAGE.RUNMODAL(458, Noseries) = ACTION::LookupOK THEN
                    "No. Series" := Noseries."Series Code";
            end;
        }
        field(16; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                TestStatusOpen();
            end;
        }
        field(17; "Created Date"; DateTime)
        {
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                TestStatusOpen();
            end;
        }
        field(18; "Last Modified By"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(19; "Last Modified Date"; DateTime)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; RFQNumber; Code[20])
        {
            TableRelation = "RFQ Numbers" where(Completed = filter(false));
            DataClassification = CustomerContent;
            trigger Onvalidate()
            var
                QuoyComp: Record QuotCompHdr;
            begin
                If RFQNumber <> '' then begin
                    QuoyComp.RESET();
                    QuoyComp.SetRange(RFQNumber, RFQNumber);
                    IF QuoyComp.findfirst() then
                        error('RFQ Number is already selected in %1 Quotation comparision.', QuoyComp."No.");
                end;
            end;
        }
        field(21; "Orders Created"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Purch. Req. Ref. No."; Code[20])
        {
            Editable = false;
            //TableRelation = "Purch. Req Header";
        }
        field(23; "Version"; Integer)
        { }
        field(50001; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));

        }
        field(50002; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
            Blocked = CONST(false));
        }
    }
    keys
    {
        key(pk; "No.", Version)
        {
            Clustered = true;
        }
    }

    var
        PurchaseSetUp: Record "Purchases & Payables Setup";
        OldQCGv: Record QuotCompHdr;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text004Lbl: Label 'Document No. %1 already exists.';
        Noseries: Record "No. Series Relationship";

    trigger OnInsert()
    begin
        PurchaseSetUp.GET();

        if "No." = '' then begin
            TestNoSeries();
            NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series", "Document Date", "No.", "No. Series");
        end;

        "Document Date" := WORKDATE();
        "Created By" := COPYSTR(USERID(), 1, 50);
        "Created Date" := CURRENTDATETIME();
    end;

    trigger OnModify()
    begin
        "Last Modified By" := COPYSTR(USERID(), 1, 50);
        "Last Modified Date" := CURRENTDATETIME();
    end;

    trigger OnDelete()
    begin
        TestStatusOpen();
        /*
        ReqLine.RESET();
        ReqLine.SETRANGE("Document No.", "No.");
        ReqLine.DELETEALL(true);*/
    end;

    trigger OnRename()
    begin
        TestStatusOpen();
    end;

    procedure TestStatusOpen();
    begin
        TESTFIELD(Status, Status::Open);
    end;

    local procedure TestNoSeries(): Boolean;
    begin
        PurchaseSetUp.TESTFIELD(PurchaseSetUp."Quote Comparision");
    end;

    local procedure GetNoSeriesCode(): Code[20];
    begin
        exit(PurchaseSetUp."Quote Comparision");
    end;


}