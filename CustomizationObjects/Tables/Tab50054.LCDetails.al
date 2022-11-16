table 50054 "LC Details"
{
    Caption = 'LC Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    LCSetup.GET;
                    NoSeriesMgt.TestManual(LCSetup."LC Detail Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionMembers = Purchase,Sale;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Transaction Type" <> xRec."Transaction Type" THEN BEGIN
                    "Issued To/Received From" := '';
                    "Issuing Bank" := '';
                    "LC Value" := 0;
                END;
            end;
        }
        field(4; "Issued To/Received From"; Code[20])
        {
            Caption = 'Issued To/Received From';
            TableRelation = IF ("Transaction Type" = CONST(Sale)) Customer ELSE
            IF ("Transaction Type" = CONST(Purchase)) Vendor;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Issued To/Received From" <> xRec."Issued To/Received From" THEN BEGIN
                    "Issuing Bank" := '';
                    "LC Value" := 0;
                END;
            end;
        }
        field(5; "Issuing Bank"; Code[20])
        {
            Caption = 'Issuing Bank';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Issuing Bank" <> xRec."Issuing Bank" THEN
                    "LC Value" := 0;
            end;

            trigger OnLookup()
            Var
                Bankform: Page "Bank Account List";
                CustBankform: Page "Customer Bank Account List";
                CustBank: Record "Customer Bank Account";
                Bank: Record "Bank Account";
            begin
                CLEAR(Bankform);
                CLEAR(CustBankform);
                IF "Transaction Type" = "Transaction Type"::Sale THEN BEGIN
                    CustBank.SETRANGE("Customer No.", "Issued To/Received From");
                    CustBankform.LOOKUPMODE(TRUE);
                    CustBankform.SETTABLEVIEW(CustBank);
                    IF CustBankform.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        CustBankform.GETRECORD(CustBank);
                        IF NOT Released THEN
                            "Issuing Bank" := CustBank.Code;
                    END;
                END;
                IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
                    Bankform.LOOKUPMODE(TRUE);
                    Bankform.SETTABLEVIEW(Bank);
                    IF Bankform.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        Bankform.GETRECORD(Bank);
                        IF NOT Released THEN
                            "Issuing Bank" := Bank."No.";
                    END;
                END;
                VALIDATE("Issuing Bank");
            end;
        }
        field(6; "Date of Issue"; Date)
        {
            Caption = 'Date of Issue';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Text13703: Label 'Issue Date cannot be after Expiry Date.';
            begin
                IF "Expiry Date" <> 0D THEN
                    IF "Date of Issue" > "Expiry Date" THEN
                        ERROR(Text13703);
            end;
        }
        field(7; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Text13700: Label 'Expiry Date cannot be before Issue Date.';
            begin
                IF "Date of Issue" <> 0D THEN
                    IF "Date of Issue" > "Expiry Date" THEN
                        ERROR(Text13700);
            end;
        }
        field(8; "Type of LC"; Option)
        {
            Caption = 'Type of LC';
            OptionMembers = Inland,Foreign;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Type of LC" = "Type of LC"::Inland THEN BEGIN
                    "Currency Code" := '';
                    "Exchange Rate" := 0;
                END;
                VALIDATE("LC Value");
            end;
        }
        field(9; "Type of Credit Limit"; Option)
        {
            Caption = 'Type of Credit Limit';
            OptionMembers = Fixed,Revolving;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Type of Credit Limit" = "Type of Credit Limit"::Fixed THEN
                    "Revolving Cr. Limit Types" := "Revolving Cr. Limit Types"::" ";
            end;
        }
        field(10; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = IF ("Type of LC" = CONST(Foreign)) Currency.Code;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    CurrExchRate.SETRANGE("Currency Code", "Currency Code");
                    CurrExchRate.SETRANGE("Starting Date", 0D, "Date of Issue");
                    CurrExchRate.FINDLAST;
                    "Exchange Rate" := CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount";
                END;
                VALIDATE("LC Value");
            end;
        }
        field(11; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(12; "LC Value"; Decimal)
        {
            Caption = 'LC Value';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Currency: Record Currency;
            begin
                IF "Currency Code" <> '' THEN BEGIN
                    Currency.GET("Currency Code");
                    "LC Value LCY" := ROUND("LC Value" * "Exchange Rate", Currency."Amount Rounding Precision");
                END ELSE
                    "LC Value LCY" := "LC Value";
                CALCFIELDS("Value Utilised");
                "Remaining Amount" := "LC Value" - "Value Utilised"; //B2BVCOn04Oct22
                "Latest Amended Value" := "LC Value LCY";
            end;
        }
        field(13; "Value Utilised"; Decimal)
        {
            Caption = 'Value Utilised';
            FieldClass = FlowField;
            CalcFormula = Sum("LC Orders"."Order Value" WHERE("LC No." = FIELD("No.")));
        }
        field(14; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            DataClassification = CustomerContent;
        }
        field(15; Closed; Boolean)
        {
            Caption = 'Closed';
            DataClassification = CustomerContent;
        }
        field(16; Released; Boolean)
        {
            Caption = 'Released';
            DataClassification = CustomerContent;
        }
        field(17; "Revolving Cr. Limit Types"; Option)
        {
            Caption = 'Revolving Cr. Limit Types';
            OptionMembers = " ",Automatic,Manual;
            DataClassification = CustomerContent;
        }
        field(18; "Latest Amended Value"; Decimal)
        {
            Caption = 'Latest Amended Value';
            DataClassification = CustomerContent;
        }
        field(21; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                VALIDATE("LC Value");
            end;
        }
        field(22; "LC Value LCY"; Decimal)
        {
            Caption = 'LC Value LCY';
            DataClassification = CustomerContent;
        }
        field(23; "Receiving Bank"; Code[20])
        {
            Caption = 'Receiving Bank';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                Bankform: Page "Bank Account List";
                VendBankForm: Page "Vendor Bank Account List";
                VendBank: Record "Vendor Bank Account";
                Bank: Record "Bank Account";
            begin
                CLEAR(Bankform);
                CLEAR(VendBankForm);
                IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
                    VendBank.SETRANGE("Vendor No.", "Issued To/Received From");
                    VendBankForm.LOOKUPMODE(TRUE);
                    VendBankForm.SETTABLEVIEW(VendBank);
                    IF VendBankForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        VendBankForm.GETRECORD(VendBank);
                        IF NOT Released THEN
                            "Receiving Bank" := VendBank.Code;
                    END;
                END;
                IF "Transaction Type" = "Transaction Type"::Sale THEN BEGIN
                    Bankform.LOOKUPMODE(TRUE);
                    Bankform.SETTABLEVIEW(Bank);
                    IF Bankform.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        Bankform.GETRECORD(Bank);
                        IF NOT Released THEN
                            "Receiving Bank" := Bank."No.";
                    END;
                END;
                VALIDATE("Receiving Bank");
            end;
        }
        field(24; "LC No."; Code[20])
        {
            Caption = 'LC No.';
            DataClassification = CustomerContent;
        }
        field(25; "Renewed Amount"; Decimal)
        {
            Caption = 'Renewed Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("LC Orders"."Order Value" WHERE("LC No." = FIELD("No."), Renewed = CONST(true)));
        }
        field(26; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        }
        field(27; "Date of Receipt"; Date)
        {
            Caption = 'Date of Receipt';
            DataClassification = CustomerContent;
        }
        field(28; "LC advising charges"; Decimal)
        {
            Caption = 'LC advising charges';
            DataClassification = CustomerContent;
        }
        field(29; "Bank Commission"; Decimal)
        {
            Caption = 'Bank Commission';
            DataClassification = CustomerContent;
        }
        field(30; "Bank Interest Rate"; Decimal)
        {
            Caption = 'Bank Interest Rate';
            DataClassification = CustomerContent;
        }
        field(31; "Disc Days by Bank"; Integer)
        {
            Caption = 'Disc Days by Bank';
            DataClassification = CustomerContent;
        }
        field(32; "BILL ID"; Code[20])
        {
            Caption = 'BILL ID';
            DataClassification = CustomerContent;
        }
        field(33; "Int Rate on Credit sale"; Decimal)
        {
            Caption = 'Int Rate on Credit sale';
            DataClassification = CustomerContent;
        }
        field(34; "Debit Note Created"; Boolean)
        {
            Caption = 'Debit Note Created';
            DataClassification = CustomerContent;
        }
        field(35; "Debit Note No."; Code[20])
        {
            Caption = 'Debit Note No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            LCSetup.GET;
            LCSetup.TESTFIELD("LC Detail Nos.");
            NoSeriesMgt.InitSeries(LCSetup."LC Detail Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Date of Issue" := WORKDATE;
    end;

    trigger OnModify()
    begin
        Rec.TestField(Released, false);
    end;

    var
        LCSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(OldLCDetails: Record "LC Details"): Boolean

    begin

        LCSetup.GET;
        LCSetup.TESTFIELD("LC Detail Nos.");
        if NoSeriesMgt.SelectSeries(LCSetup."LC Detail Nos.", OldLCDetails."No. Series", "No. Series") then begin
            LCSetup.GET;
            LCSetup.TESTFIELD("LC Detail Nos.");
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;
}
