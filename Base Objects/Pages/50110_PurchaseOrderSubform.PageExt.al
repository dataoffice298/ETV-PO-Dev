pageextension 50110 PurchaseOrderSubform1 extends "Purchase Order Subform"
{
    //B2BVCOn03Oct22>>>
    layout
    {
        addafter(Description)
        {
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                //Editable = false;
                ApplicationArea = All;
            }
        }
        addbefore("Shortcut Dimension 1 Code")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Line No."; Rec."Indent Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Req No"; Rec."Indent Req No")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Req Line No"; Rec."Indent Req Line No")
            {
                ApplicationArea = all;
                Editable = false;
            }

            //B2BMSOn03Nov2022>>
            field("QC Enabled B2B"; Rec."QC Enabled B2B")
            {
                ApplicationArea = All;
            }
            field("Qty. to Accept B2B"; Rec."Qty. to Accept B2B")
            {
                ApplicationArea = All;
            }
            field("Qty. to Reject B2B"; Rec."Qty. to Reject B2B")
            {
                ApplicationArea = All;
            }
            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                ApplicationArea = All;
            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                ApplicationArea = All;
            }
            //B2BMSOn03Nov2022<<
        }
    }


    actions
    {
        //B2BMSOn28Oct2022>>
        addafter("Item Tracking Lines")
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import Item Tracking';
                Image = Import;

                trigger OnAction()
                var
                    TrackImport: Report "Purchase Line Tracking Import";
                begin
                    Clear(TrackImport);
                    TrackImport.GetValues(Rec);
                    TrackImport.Run();
                    Commit();
                    Rec.OpenItemTrackingLines;
                end;
            }
        }
        //B2BMSOn28Oct2022<<

        //B2BMSOn03Nov2022>>
        addlast("F&unctions")
        {
            group(RGP)
            {
                action(CreateRGPOutward)
                {
                    Caption = 'Create RGP Outward';
                    ApplicationArea = All;
                    Image = CreateDocument;

                    trigger OnAction()
                    var
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                        GateEntryLine: Record "Gate Entry Line_B2B";
                        OpenText: Label 'An RGP Outward document - %1 is created. \Do you want to open the document?';
                        Err0001: Label 'Gate Entry is already created.';
                    begin
                        if Rec."Ref. Posted Gate Entry" <> '' then
                            Error(Err0001);
                        GateEntryHeader.Init();
                        GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Outward;
                        GateEntryHeader.Type := GateEntryHeader.Type::RGP;
                        GateEntryHeader.Validate("Location Code", Rec."Location Code");
                        GateEntryHeader.Insert(true);

                        GateEntryLine.Init();
                        GateEntryLine."Entry Type" := GateEntryLine."Entry Type"::Outward;
                        GateEntryLine.Type := GateEntryLine.Type::RGP;
                        GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                        GateEntryLine."Line No." := 10000;
                        GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
                        GateEntryLine.Validate("Source No.", Rec."No.");
                        GateEntryLine."Unit of Measure" := Rec."Unit of Measure";
                        GateEntryLine.Insert(true);

                        Rec."Ref. Posted Gate Entry" := GateEntryHeader."No.";
                        Rec.Modify();

                        if Confirm(OpenText, false, GateEntryHeader."No.") then
                            Page.Run(Page::"Outward Gate Entry - RGP", GateEntryHeader);
                    end;
                }

                action(CreateNRGPOutward)
                {
                    Caption = 'Create NRGP Outward';
                    ApplicationArea = All;
                    Image = Create;

                    trigger OnAction()
                    var
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                        GateEntryLine: Record "Gate Entry Line_B2B";
                        OpenText: Label 'An NRGP Outward document - %1 is created. \Do you want to open the document?';
                        Err0001: Label 'Gate Entry is already created.';
                    begin
                        if Rec."Ref. Posted Gate Entry" <> '' then
                            Error(Err0001);
                        GateEntryHeader.Init();
                        GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Outward;
                        GateEntryHeader.Type := GateEntryHeader.Type::NRGP;
                        GateEntryHeader.Validate("Location Code", Rec."Location Code");
                        GateEntryHeader.Insert(true);

                        GateEntryLine.Init();
                        GateEntryLine."Entry Type" := GateEntryLine."Entry Type"::Outward;
                        GateEntryLine.Type := GateEntryLine.Type::NRGP;
                        GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                        GateEntryLine."Line No." := 10000;
                        GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
                        GateEntryLine.Validate("Source No.", Rec."No.");
                        GateEntryLine."Unit of Measure" := Rec."Unit of Measure";
                        GateEntryLine.Insert(true);

                        Rec."Ref. Posted Gate Entry" := GateEntryHeader."No.";
                        Rec.Modify();

                        if Confirm(OpenText, false, GateEntryHeader."No.") then
                            Page.Run(Page::"Outward Gate Entry - NRGP", GateEntryHeader);
                    end;
                }

                action(ShowOutwardDoc)
                {
                    Caption = 'Show Outward Document';
                    ApplicationArea = All;
                    Image = Open;

                    trigger OnAction()
                    var
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                        PostGateEntryHeader: Record "Posted Gate Entry Header_B2B";
                        Err0001: Label 'Gate Entry is not created.';
                    begin
                        if Rec."Ref. Posted Gate Entry" = '' then
                            Error(Err0001);
                        if GateEntryHeader.Get(GateEntryHeader."Entry Type"::Outward, GateEntryHeader.Type::RGP, Rec."Ref. Posted Gate Entry") then
                            Page.Run(Page::"Outward Gate Entry - RGP", GateEntryHeader)
                        else
                            if PostGateEntryHeader.Get(PostGateEntryHeader."Entry Type"::Outward, PostGateEntryHeader.Type::RGP, Rec."Ref. Posted Gate Entry") then
                                Page.Run(Page::"Posted Outward Gate Entry-RGP", PostGateEntryHeader)
                            else
                                if GateEntryHeader.Get(GateEntryHeader."Entry Type"::Outward, GateEntryHeader.Type::NRGP, Rec."Ref. Posted Gate Entry") then
                                    Page.Run(Page::"Outward Gate Entry - NRGP", GateEntryHeader)
                                else
                                    if PostGateEntryHeader.Get(PostGateEntryHeader."Entry Type"::Outward, PostGateEntryHeader.Type::NRGP, Rec."Ref. Posted Gate Entry") then
                                        Page.Run(Page::"Posted Outward Gate Entry-NRGP", PostGateEntryHeader);
                    end;
                }
            }
            //B2BMSOn03Nov2022<<
        }
    }

    var
        myInt: Integer;
    //B2BVCOn03Oct22<<<
}