page 50157 "Outward Gate Entry - RGP"
{
    Caption = 'RGP-OUTWARD';
    PageType = Document;
    SourceTable = "Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Outward), Type = const(RGP));

    layout
    {
        area(content)
        {
            group(General)
            {
                /*field(Type; Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                }*/
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
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
                    Visible = false;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = ALL;
                    Visible = false;
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
                    trigger OnValidate()
                    begin
                        Rec.TestField("Vehicle No.");
                    end;
                }
                field("Gate No."; Rec."Gate No.")
                {
                    ApplicationArea = all;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = ALL;
                }

            }
            part(Control1500028; "Outward Gate Entry SubFrm-RGP")
            {
                SubPageLink = "Entry Type" = FIELD("Entry Type"),
                              "Type" = field("Type"),
                              "Gate Entry No." = FIELD("No.");
                SubPageView = SORTING("Entry Type", "type", "Gate Entry No.", "Line No.");
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        /*area(navigation)
        {
            group("&Gate Entry")
            {

                Image = InwardEntry;
                action(List)
                {
                    Image = OpportunitiesList;
                    RunObject = Page 50104;
                    ShortCutKey = 'Shift+Ctrl+L';
                    ApplicationArea = ALL;
                }
            }
        }*/

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
                    ApplicationArea = ALL;
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
                        // IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendGATEforApprovalCode()) then
                        //    error('Workflow is enabled. You can not release manually.');
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
                        // IF allinoneCU.CheckGATEApprovalsWorkflowEnabled(Rec) then
                        //   allinoneCU.OnSendGATEForApproval(Rec);
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

