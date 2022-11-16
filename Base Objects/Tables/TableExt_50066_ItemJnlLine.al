tableextension 50066 ItemJnlLine extends "Item Journal Line"
{
    fields
    {
        field(50150; "Indent No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50151; "Indent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //BaluOn19Oct2022<<
        field(50152; "Issue Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50153; "Issue Sub Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        //BaluOn19Oct2022>>

    }

}