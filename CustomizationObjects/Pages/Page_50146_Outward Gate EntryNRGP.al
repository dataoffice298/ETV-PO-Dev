page 50146 "Outward Gate Entry - NRGP"
{
    Caption = 'NRGP-OUTWARD';
    PageType = Document;
    DeleteAllowed = false;
    SourceTable = "Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Outward), Type = const(NRGP));

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
                    Visible = false;
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = ALL;

                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE;
                    end;
                }

                field("Station From/To"; Rec."Station From/To")
                {
                    ApplicationArea = ALL;
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
                field("Gate No."; Rec."Gate No.")
                {
                    ApplicationArea = all;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = ALL;
                }

            }
            part(Control1500028; "Outward Gate Entry SubFrm-NRGP")
            {
                SubPageLink = "Entry Type" = FIELD("Entry Type"),
                "Type" = field("Type"),
                              "Gate Entry No." = FIELD("No.");
                SubPageView = SORTING("Entry Type", "Type", "Gate Entry No.", "Line No.");
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
                    /*trigger OnAction()
                    begin 
                        CheckMandValues();
                    end;*/
                }
                action("Post And Print")
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ApplicationArea = ALL;
                    trigger OnAction()
                    var
                        GateEntryPost: Codeunit "Gate Entry- Post Yes/No";
                    begin
                        Clear(GateEntryPost);
                        GateEntryPost.SetValues(true);
                        GateEntryPost.Run(Rec);
                    end;
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
                /* action("Print")
                 {
                     ApplicationArea = all;
                     Image = Print;
                     trigger OnAction()
                     var
                         uSrSet: Record "User Setup";
                     begin
                         //b2bpksalecorr12 start
                         IF "No. Printed" > 1 then begin
                             uSrSet.get(UserId);
                             IF NOT uSrSet."Reprint Shipmt & GatePass Docs" then
                                 Error('You do not have permissions to reprint the document.');
                         end;
                         "No. Printed" += 1;
                         //b2bpksalecorr12 end
                         GateEntryHeaderGRec.Reset();
                         GateEntryHeaderGRec.SetRange("Entry Type", "Entry Type");
                         GateEntryHeaderGRec.SetRange(Type, Type);
                         GateEntryHeaderGRec.SetRange("No.", "No.");
                         Report.Run(Report::"Non Returnable GatePass1", true, false, GateEntryHeaderGRec);
                     end;
                 }*/
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
                        //CheckMandValues();
                        //IF allinoneCU.CheckGATEApprovalsWorkflowEnabled(Rec) then
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
                        //  allinoneCU.OnCancelGATEForApproval(Rec);
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
    /* Procedure CheckMandValues()
    Var
        GateEntryVar: Record "Gate Entry Header";
    BEGIN
        TestField("Transporter No.");
        TestField("Transporter Name");
       
    END;*/


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
        GateEntryHeaderGRec: Record "Gate Entry Header_B2B";
}

