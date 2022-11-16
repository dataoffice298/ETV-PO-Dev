table 50039 "RFQ Numbers"
{
    // version PH1.0,PO1.0

    LookupPageID = 50027;

    fields
    {
        field(1; "RFQ No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF "RFQ No." <> xRec."RFQ No." THEN BEGIN
                    PurchaseSetup.GET;
                    NoSeriesMgt.TestManual(PurchaseSetup."RFQ Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(4; "Created Date"; Date)
        {
        }
        field(5; "Last Modified Date"; Date)
        {
        }
        field(6; Completed; Boolean)
        {
        }
        field(7; "Location Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "RFQ No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "RFQ No." = '' THEN BEGIN
            PurchaseSetup.GET;
            PurchaseSetup.TESTFIELD("RFQ Nos.");
            NoSeriesMgt.InitSeries(PurchaseSetup."RFQ Nos.", xRec."No. Series", 0D, "RFQ No.", "No. Series");
        END;
        "Created Date" := TODAY;
    end;

    trigger OnModify();
    begin
        "Last Modified Date" := TODAY;
    end;

    var
        PurchaseSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

