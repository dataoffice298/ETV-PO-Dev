report 50100 Indent
{
    // version B2BLIFT1.00.00

    DefaultLayout = RDLC;
    RDLCLayout = 'CustomizationObjects\Reports\Layouts\Indent.rdl';

    Caption = 'Indent';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            column(CompanyInformationPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyInformationName; CompanyInformation.Name)
            {
            }
            column(IndentNoCaptionLbl; IndentNoCaptionLbl)
            {
            }
            column(IndentDateCaptionLbl; IndentDateCaptionLbl)
            {
            }
            column(DescriptionCaptionLbl; DescriptionCaptionLbl)
            {
            }
            column(DeliveryLocationCaptionLbl; DeliveryLocationCaptionLbl)
            {
            }
            column(SentForAuthorizationCaptionLbl; SentForAuthorizationCaptionLbl)
            {
            }
            column(IndentorCaptionLbl; IndentorCaptionLbl)
            {
            }
            column(TypeCaptionLbl; TypeCaptionLbl)
            {
            }
            column(NoCaptionLbl; NoCaptionLbl)
            {
            }
            column(UOMCaptionLbl; UOMCaptionLbl)
            {
            }
            column(IndentStatusCaptionLbl; IndentStatusCaptionLbl)
            {
            }
            column(DepartmentCaptionLbl; DepartmentCaptionLbl)
            {
            }
            column(QuantityCaptionLbl; QuantityCaptionLbl)
            {
            }
            column(INdentByCaptionLbl; INdentByCaptionLbl)
            {
            }
            column(DateCaptionLbl; DateCaptionLbl)
            {
            }
            column(SignCaptionLbl; SignCaptionLbl)
            {
            }
            column(AuthorizedByCaptionLbl; AuthorizedByCaptionLbl)
            {
            }
            column(PurchaseIndentCaptionLbl; PurchaseIndentCaptionLbl)
            {
            }
            column(No_IndentHeader; "Indent Header"."No.")
            {
            }
            column(Description_IndentHeader; "Indent Header".Description)
            {
            }
            column(DocumentDate_IndentHeader; "Indent Header"."Document Date")
            {
            }
            column(DeliveryLocation_IndentHeader; "Indent Header"."Delivery Location")
            {
            }
            column(Indentor_IndentHeader; "Indent Header".Indentor)
            {
            }
            column(SentforAuthorization_IndentHeader; "Indent Header"."Sent for Authorization")
            {
            }
            dataitem("Indent Line B2B"; "Indent Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Type_IndentLine; "Indent Line B2B".Type)
                {
                }
                column(No_IndentLine; "Indent Line B2B"."No.")
                {
                }
                column(Description_IndentLine; "Indent Line B2B".Description)
                {
                }
                column(UnitofMeasure_IndentLine; "Indent Line B2B"."Unit of Measure")
                {
                }
                column(IndentStatus_IndentLine; "Indent Line B2B"."Indent Status")
                {
                }
                column(Department_IndentLine; "Indent Line B2B".Department)
                {
                }
                column(ReqQuantity_IndentLine; "Indent Line B2B"."Req.Quantity")
                {
                }
            }

            trigger OnPreDataItem();
            begin

                CompanyInformation.FIND('-');
                CompanyInformation.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
        IndentNoCaptionLbl: Label 'Indent No';
        IndentDateCaptionLbl: Label 'Indent Date';
        DescriptionCaptionLbl: Label 'Description';
        DeliveryLocationCaptionLbl: Label 'Delivery Location';
        SentForAuthorizationCaptionLbl: Label 'Sent For Authorization';
        IndentorCaptionLbl: Label 'Indentor';
        TypeCaptionLbl: Label 'Type';
        NoCaptionLbl: Label 'No.';
        UOMCaptionLbl: Label 'UOM';
        IndentStatusCaptionLbl: Label 'Indent Status';
        DepartmentCaptionLbl: Label 'Department';
        QuantityCaptionLbl: Label 'Quantity';
        INdentByCaptionLbl: Label 'Indent By';
        DateCaptionLbl: Label 'Date';
        SignCaptionLbl: Label 'Sign';
        AuthorizedByCaptionLbl: Label 'Authorized By';
        PurchaseIndentCaptionLbl: Label 'Purchase Indent';
}

