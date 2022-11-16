table 50047 QuotCompHdr
{
    DataClassification = CustomerContent;

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
            var
                QuotationLines: Record 50046;
            begin
                QuotationLines.Reset();
                QuotationLines.SetRange("Quot Comp No.", rec."No.");
                if QuotationLines.FindSet() then
                    QuotationLines.ModifyAll(Status, Rec.Status);
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
        //B2BMSOn18Oct2022>>
        Field(50003; "Regularization"; Boolean)
        {
            Caption = 'Regularization';
        }
        //B2BMSOn18Oct2022<<

        //B2BMSOn28Oct2022>>
        Field(50004; "No. of Archived Versions"; Integer)
        {
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = max("Archive Quotation Header".Version where("No." = field("No.")));
        }
        //B2BMSOn28Oct2022<<
    }
    keys
    {
        key(pk; "No.")
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
            PurchaseSetUp.TESTFIELD("Quote Comparision");
            NoSeriesMgt.InitSeries(PurchaseSetUp."Quote Comparision", xRec."No. Series", 0D, "No.", "No. Series");
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

    procedure AssistEdit(OldQC: Record QuotCompHdr): Boolean;
    begin
        OldQCGv.COPY(Rec);
        PurchaseSetUp.GET;
        PurchaseSetUp.TestField("Quotation Comparision Nos.");
        //TestNoSeries();
        if NoSeriesMgt.SelectSeries(PurchaseSetUp."Quotation Comparision Nos.", OldQC."No. Series", OldQCGv."No. Series") then begin
            NoSeriesMgt.SetSeries(OldQCGv."No.");
            if OldQCGv.GET(OldQCGv."No.") then
                ERROR(Text004Lbl, LOWERCASE(FORMAT(OldQCGv."No.")));
            Rec := OldQCGv;
            exit(true);
        end;
    end;
}