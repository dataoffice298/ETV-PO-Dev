report 50027 "PO Creation"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Document Type" = FILTER(Quote));

            trigger OnAfterGetRecord()
            var
                QuotationComparsion: Record "Quotation Comparison Test";

            begin
                QuotationComparsion.Reset();
                QuotationComparsion.SetRange("Carry Out Action", true);
                QuotationComparsion.SetRange("Parent Quote No.", PurchaseHeader."No.");
                QuotationComparsion.SetRange("Vendor No.", "Buy-from Vendor No.");
                if QuotationComparsion.FindSet() then
                    Repeat
                        PurchaseHeader."No." := '';
                        PurchaseHeader."Posting Date" := Today;
                        PurchaseHeader."Document Date" := WORKDATE();
                        PurchaseHeader.Validate("Order Date", WorkDate());
                        PurchaseHeader.VALIDATE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                        PurchaseHeader."Quotation No." := QuotationComparsion."Parent Quote No.";
                        PurchaseHeader."Quote No." := QuotationComparsion."Parent Quote No.";//Pk-Balu
                        PurchaseHeader."Expected Receipt Date" := QuotationComparsion."Due Date";
                        PurchaseHeader."Currency Code" := QuotationComparsion."Currency Code";
                        PurchaseHeader.INSERT(true);

                    Until QuotationComparsion.Next() = 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        myInt: Integer;
}