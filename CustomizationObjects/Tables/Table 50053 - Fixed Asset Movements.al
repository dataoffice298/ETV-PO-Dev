table 50053 "Fixed Asset Movements"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Fixed Asset Movements";
    DrillDownPageId = "Fixed Asset Movements";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "FA No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "From Location"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "To Location"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Issued Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Created Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Issue to User Id"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Comment"; Text[500])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}