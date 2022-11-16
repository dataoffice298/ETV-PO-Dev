tableextension 50060 ProdComp extends "Prod. Order Component"
{
    fields
    {
        // Add changes to table fields here
        field(500001; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code"),
                                                                  "Location Code" = FIELD("Location Code"),
                                                                  "Variant Code" = FIELD("Variant Code"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        modify("Expected Quantity")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin

                /* //PKON22M17>>
                CalcFields(rec.Inventory);
                IF Inventory < "Expected Quantity" THEN
                    Error('Inventory availability %1 is less than expected qunatity %2 for item %3', Inventory, "Expected Quantity", "Item No.");*/
            end;
        }
    }

    var
        myInt: Integer;
}