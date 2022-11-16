tableextension 50042 tableextension70000017 extends "Item Vendor"
{
    // version NAVW19.00.00.45778,PO

    fields
    {
        field(33002190; "Reference Number"; Boolean)
        {
            Description = 'PH1.0';
        }
        field(33002191; Approved; Boolean)
        {
            Description = 'PH1.0';
            Editable = false;

            trigger OnValidate();
            begin
                //NSS1.0 >> BEGIN
                IF Approved = TRUE THEN
                    "Reference Number" := TRUE
                ELSE
                    "Reference Number" := FALSE;
                //NSS1.0 << END
            end;
        }
        field(33002192; "Certified Agency"; Text[30])
        {
            Description = 'PH1.0';
        }
        field(33002193; Attachment; BLOB)
        {
            Description = 'PH1.0';
        }
        field(33002194; "Certificate of Analysis"; Text[50])
        {
            Description = 'PH1.0';
        }
        field(33002195; "File Extension"; Text[50])
        {
            Description = 'PH1.0';
        }
        field(33002900; "Qty. Supplied With in DueDate"; Decimal)
        {
            Description = 'PO1.0';
            Editable = false;
        }
        field(33002901; "Delivery Rating"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line"."Delivery Rating" WHERE("Buy-from Vendor No." = FIELD("Vendor No."),
                                                                           Type = FILTER(Item),
                                                                           "No." = FIELD("Item No.")));
            Description = 'PO1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33002902; "Avg. Delivery Rating"; Decimal)
        {
            Description = 'PO1.0';
            //Editable = false;
        }
        field(33002903; "Total Qty. Supplied"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line".Quantity WHERE(Type = CONST(Item),
                                                                  "Buy-from Vendor No." = FIELD("Vendor No."),
                                                                  "No." = FIELD("Item No.")));
            Description = 'PO1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33002910; "Avg. Quality Rating"; Decimal)
        {
            Description = 'PO1.0';
            //Editable = false;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

