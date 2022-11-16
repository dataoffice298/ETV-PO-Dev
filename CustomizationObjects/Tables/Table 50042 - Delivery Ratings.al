table 50042 "Delivery Ratings"
{
    // version PH1.0,PO1.0

    //LookupPageID = 50015;//balu

    fields
    {
        field(1; "Minumum Value"; Integer)
        {
        }
        field(2; "Maximum Value"; Integer)
        {
        }
        field(3; Rating; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0 : 2;
        }
    }

    keys
    {
        key(Key1; "Minumum Value", "Maximum Value", Rating)
        {
        }
    }

    fieldgroups
    {
    }
}

