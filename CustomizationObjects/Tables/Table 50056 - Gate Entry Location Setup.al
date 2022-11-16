table 50056 "Gate Entry Location Setup_B2B"
{
    // version NAVIN9.00.00.45778

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry Type"; Enum GateEntryInOutWard)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(3; "Posting No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(4; "Allow GateEntry Lines Delete"; Boolean)
        {
            DataClassification = CustomerContent;

        }
        field(5; "Type"; Enum GateEntryType)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Type", "Location Code")
        {
        }
    }

    fieldgroups
    {
    }
}

