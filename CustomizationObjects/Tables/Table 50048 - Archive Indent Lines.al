table 50048 "Archive Indent Line"
{
    LookupPageId = "Archive Indent Subform";
    DrillDownPageId = "Archive Indent Subform";
    fields
    {
        field(1; "Document No."; Code[20])
        {

        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "No."; Code[20])
        {

        }
        field(4; Description; Text[50])
        {

        }
        field(5; "Req.Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;


        }
        field(6; "Available Stock"; Decimal)
        {
        }
        field(10; "Due Date"; Date)
        {


        }
        field(11; "Delivery Location"; Code[20])
        {
        }
        field(12; "Unit of Measure"; Code[10])
        {

        }
        field(17; "Indent Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Indent,Enquiry,Offer,Order,Cancel,Closed';
            OptionMembers = Indent,Enquiry,Offer,"Order",Cancel,Closed;
        }
        field(18; "Avail.Qty"; Decimal)
        {
            Editable = false;
        }
        field(20; Department; Code[20])
        {


        }
        field(22; "Indent Req No"; Code[20])
        {
            Editable = false;

        }
        field(23; "Indent Req Line No"; Integer)
        {
        }
        field(30; Type; Option)
        {

            OptionMembers = Item,"Fixed Assets",Description,"G/L Account";

        }
        field(32; "Unit Cost"; Decimal)
        {


        }
        field(33; Amount; Decimal)
        {


        }
        field(36; "Release Status"; Option)
        {

            OptionCaption = 'Open,Released,Cancel,Closed,Pending Approval';
            OptionMembers = Open,Released,Cancel,Closed,"Pending Approval";
        }
        field(37; "Description 2"; Text[50])
        {
        }
        field(38; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';

        }
        field(39; Remarks; Text[30])
        {
        }
        field(41; "Vendor No."; Code[20])
        {

        }
        field(50000; "Quantity (Base)"; Decimal)
        {
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
        field(50003; "Prev Quantity"; Decimal)
        {
        }

        field(50004; "Transfer Order No."; Code[20])
        {
        }
        //B2BMSOn13Sep2022<<

        field(50005; "Qty To Issue"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcFields("Qty issued");
                if "Qty To Issue" > "Avail.Qty" then
                    Error('Qty Should not be greater than Available Qty');

                if "Qty To Issue" > (Rec."Req.Quantity" - abs(Rec."Qty Issued")) then
                    Error('Qty to return should not be greater than %1', (Rec."Req.Quantity" - abs(Rec."Qty Issued")));
            end;
        }
        field(50006; "Qty To Return"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcFields("Qty Returned");
                if "Qty To Return" > "Avail.Qty" then
                    Error('Qty Should not be greater than Available Qty');

                if "Qty To Return" > (Rec."Req.Quantity" - Abs(Rec."Qty Returned")) then
                    Error('Qty to return should not be greater than %1', (Rec."Req.Quantity" - Abs(Rec."Qty Returned")));
            end;
        }
        field(50007; "Qty Issued"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Indent No." = field("Document No."), "Indent Line No." = field("Line No."), Quantity = filter(< 0)));
        }
        field(50008; "Qty Returned"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Indent No." = field("Document No."), "Indent Line No." = field("Line No."), Quantity = filter(> 0)));
        }
        field(50009; "Archived Version"; Integer)
        {
        }
        field(50010; "Archived By"; Code[30])
        {
        }
    }



    keys
    {
        key(Key1; "Document No.", "Line No.", "Archived Version")
        {
        }
    }

    fieldgroups
    {
    }


    var
        IndentHeader: Record 50010;
        Item: Record 27;
        ItemVariant: Record 5401;
        cust: Record 18;
        loc: Record 14;
        ProdOrderRoutingLine: Record 5409;
        changeIndentLine: Boolean;
        SalesPurchase: Record 13;
        Text000: Label 'Item dont have unit of measure %1';
        ItemLedgerEntry: Record 32;
        Compsetup: Record 79;
        Fixedasset: Record 5600;
        GLAccount: Record 15;


}