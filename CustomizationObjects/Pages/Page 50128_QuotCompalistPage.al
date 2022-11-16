page 50128 "Quotation Comparisions"
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = QuotCompHdr;
    Caption = 'Quotation Comparison';
    CardPageId = "Quotation Comparision Doc";
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Control1102152000)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(RFQNumber; Rec.RFQNumber)
                {
                    ApplicationArea = All;

                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = All;
                }
                field("Orders Created"; Rec."Orders Created")
                {
                    ToolTip = 'Specifies the value of the Orders Created field.';
                    ApplicationArea = All;
                }
                field("Purch. Req. Ref. No."; Rec."Purch. Req. Ref. No.")
                {
                    ToolTip = 'Specifies the value of the Purch. Req. Ref. No. field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;

                }
                field("Created Date"; REc."Created Date")
                {
                    ApplicationArea = All;

                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

}