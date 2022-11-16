table 50052 "Archive Indent Header"
{
    LookupPageId = "Archive Indent List";
    DrillDownPageId = "Archive Indent List";

    fields
    {
        field(1; "No."; Code[20])
        {

        }
        field(2; Description; Text[50])
        {


        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "Due Date"; Date)
        {

        }
        field(8; "Delivery Location"; Code[20])
        {

        }
        field(10; Department; Code[20])
        {

        }
        field(13; "No. Series"; Code[20])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; Indentor; Text[50])
        {
            Editable = false;
        }
        field(16; Comment; Boolean)
        {
        }
        field(21; "Indent Status"; Option)
        {
            OptionCaption = 'Indent,Enquiry,Offer,Order,Cancel,Close';
            OptionMembers = Indent,Enquiry,Offer,"Order",Cancel,Close;
        }
        field(23; "User Id"; Code[30])
        {
            Editable = false;
        }
        field(24; "Released Status"; Option)
        {
            Editable = false;
            OptionMembers = Open,Released,Cancel,Close,"Pending Approval";
        }
        field(25; "Last Modified Date"; Date)
        {
        }
        field(31; "Sent for Authorization"; Boolean)
        {
            Caption = 'Sent for Authorization';
        }
        field(32; Authorized; Boolean)
        {
            Caption = 'Authorized';
        }
        field(33; Declined; Boolean)
        {
            Caption = 'Declined';
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
        field(50003; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50004; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50005; "In-Transit Code"; Code[10])
        {
            Caption = 'In-Transit Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true));
        }
        field(50007; "Ammendent Comments"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50008; "Archived Version"; Integer)
        {
        }
        field(50009; "Archived By"; Code[30])
        {
        }

    }

    keys
    {
        key(Key1; "No.", "Archived Version")
        {
        }
    }

    fieldgroups
    {
    }


}

