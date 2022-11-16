page 50144 "Inward Gate Entry-NRGP"
{
    // version NAVIN7.00
    Caption = 'NRGP-INWARD ';
    PageType = Document;
    SourceTable = "Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Inward), Type = const(NRGP));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("No."; Rec."No.")
                {

                    ApplicationArea = ALL;
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE;
                        /*
                            GateEntryLocSetup.GET("Entry Type","Location Code");
                          GateEntryLocSetup.TESTFIELD("Posting No. Series");
                          IF NoSeriesMgt.SelectSeries(GateEntryLocSetup."Posting No. Series","No.","No. Series") THEN
                             NoSeriesMgt.SetSeries("No.");
                        */

                    end;
                }

                field("Station From/To"; Rec."Station From/To")
                {
                    ApplicationArea = ALL;

                }
                field("Gate No."; Rec."Gate No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = ALL;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = ALL;
                }
                field("Document Time"; Rec."Document Time")
                {
                    ApplicationArea = ALL;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = ALL;
                }
                field("Posting Time"; Rec."Posting Time")
                {
                    ApplicationArea = ALL;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = ALL;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = ALL;
                }
                //BaluonNov82022>>
                field(Purpose; rec.Purpose)
                { }
                field(InstallationFromDate; rec.InstallationFromDate)
                {
                    ApplicationArea = all;
                }
                field(InstallationToDate; rec.InstallationToDate)
                {
                    ApplicationArea = all;
                }
                field(ShootingStartDate; rec.ShootingStartDate)
                {
                    ApplicationArea = all;
                }
                field(ShootingEndDate; rec.ShootingEndDate)
                {
                    ApplicationArea = all;
                }
                field(ExpectedDateofReturn; rec.ExpectedDateofReturn)
                {
                    ApplicationArea = all;
                }
                field(SubLocation; rec.SubLocation)
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field(Designation; rec.Designation)
                {
                    ApplicationArea = all;
                }
                field(Program; rec.Program)
                {
                    ApplicationArea = all;
                }
                //BaluonNov82022<<
            }
            part(Control1500028; "Inward Gate Entry SubFrm-NRGP")
            {
                SubPageLink = "Entry Type" = FIELD("Entry Type"),
                "type" = field("Type"),
                              "Gate Entry No." = FIELD("No.");
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                Image = Post;
                action("Po&st")
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gate Entry- Post Yes/No";
                    ShortCutKey = 'F9';
                }
            }
            group(Approval)
            {
                Image = Approvals;
                action("Re&lease")
                {
                    ApplicationArea = all;
                    Caption = 'Re&lease';
                    ShortCutKey = 'Ctrl+F11';
                    Image = ReleaseDoc;
                    trigger OnAction()
                    begin
                        Rec.CHECKMAND();
                        //IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendGATEforApprovalCode()) then
                        //  error('Workflow is enabled. You can not release manually.');

                        IF Rec."Approval Status" <> Rec."Approval Status"::Released then BEGIN
                            Rec."Approval Status" := Rec."Approval Status"::Released;
                            Rec.Modify();
                            Message('Document has been Released.');
                        end;
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = all;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    trigger OnAction();
                    begin
                        RecordRest.Reset();
                        RecordRest.SetRange(ID, 50031);
                        RecordRest.SetRange("Record ID", Rec.RecordId());
                        IF RecordRest.FindFirst() THEN
                            error('This record is under in workflow process. Please cancel approval request if not required.');
                        IF Rec."Approval Status" <> Rec."Approval Status"::Open then BEGIN
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            Rec.Modify();
                            Message('Document has been Reopened.');
                        end;
                    end;
                }

                action(Approve)
                {
                    ApplicationArea = All;
                    Image = Action;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        approvalmngmt.ApproveRecordApprovalRequest(Rec.RecordId());
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = All;
                    Image = SendApprovalRequest;
                    Visible = Not OpenApprEntrEsists and CanrequestApprovForFlow;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        Rec.CHECKMAND();
                        //IF allinoneCU.CheckGATEApprovalsWorkflowEnabled(Rec) then
                        //    allinoneCU.OnSendGATEForApproval(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Visible = CanCancelapprovalforrecord or CanCancelapprovalforflow;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        // allinoneCU.OnCancelGATEForApproval(Rec);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(Rec.RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(Rec.RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
    END;

    var
        approvalmngmt: Codeunit "Approvals Mgmt.";
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";
        OpenAppEntrExistsForCurrUser: Boolean;
        OpenApprEntrEsists: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;
        CanrequestApprovForFlow: Boolean;
        RecordRest: Record "Restricted Record";
        //allinoneCU: Codeunit Codeunit1;
        WorkflowManagement: Codeunit "Workflow Management";
}

