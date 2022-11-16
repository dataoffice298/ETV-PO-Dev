codeunit 50001 ApprovalMgt
{
    trigger OnRun();
    begin
    end;
    //B2BMSOn13Sep2022>>
    [EventSubscriber(ObjectType::Page, Page::"Requests to Approve", 'OnAfterActionEvent', 'Approve', false, false)]
    local procedure InsertArchiveDocument(var Rec: Record "Approval Entry")
    var
        ArchiveVersion: Integer;
        IndentLine: Record 50037;
        IndentHeader: Record 50010;
        ArchiveIndHdr: Record "Archive Indent Header";
        ArchiveIndLine: record "Archive Indent Line";
    begin
        if (Rec."Table ID" = Database::"Indent Header") and (IndentHeader.Get(Rec."Document No.")) then begin
            IndentLine.Reset();
            IndentLine.SetRange("Document No.", IndentHeader."No.");
            IndentLine.SetFilter("No.", '<>%1', '');
            IndentLine.SetFilter("Prev Quantity", '<>%1', 0);
            if IndentLine.FindFirst() then
                if IndentLine."Req.Quantity" <> IndentLine."Prev Quantity" then begin
                    Clear(ArchiveVersion);
                    ArchiveIndHdr.Reset();
                    ArchiveIndHdr.SetCurrentKey("Archived Version");
                    ArchiveIndHdr.SetRange("No.", IndentHeader."No.");
                    if ArchiveIndLine.FindLast() then
                        ArchiveVersion := ArchiveIndLine."Archived Version" + 1
                    else
                        ArchiveVersion := 1;

                    ArchiveIndHdr.Init();
                    ArchiveIndHdr.TransferFields(IndentHeader);
                    ArchiveIndHdr."Archived Version" := ArchiveVersion;
                    ArchiveIndHdr."Archived By" := UserId;
                    ArchiveIndHdr.Insert();

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", IndentHeader."No.");
                    if IndentLine.FindSet() then
                        repeat
                            ArchiveIndLine.Init();
                            ArchiveIndLine.TransferFields(IndentLine);
                            ArchiveIndLine."Archived Version" := ArchiveVersion;
                            ArchiveIndLine."Archived By" := UserId;
                            ArchiveIndLine.Insert();

                            IndentLine."Prev Quantity" := 0;
                            IndentLine.Modify();
                        until IndentLine.Next() = 0;
                end;
        end;
    end;
    //B2BMSOn13Sep2022<<

    /*
        [IntegrationEvent(false, false)]
        Procedure OnSendQCMForApproval(var QCM: Record "Quotation Comparison")
        begin
        end;

        [IntegrationEvent(false, false)]
        Procedure OnCancelQCMForApproval(var QCM: Record "Quotation Comparison")
        begin
        end;

        //Create events for workflow

        procedure RunworkflowOnSendQCMforApprovalCode(): code[128]
        begin
            exit(CopyStr(UpperCase('RunworkflowOnSendQCMforApproval'), 1, 128));
        end;


        [EventSubscriber(ObjectType::Codeunit, codeunit::ApprovalMgt, 'OnSendQCMForApproval', '', false, false)]
        local procedure RunworkflowonsendQCMForApproval(var QCM: Record "Quotation Comparison")
        begin
            WorkflowManagement.HandleEvent(RunworkflowOnSendQCMforApprovalCode(), QCM);
        end;

        procedure RunworkflowOnCancelQCMforApprovalCode(): code[128]
        begin
            exit(CopyStr(UpperCase('OnCancelQCMForApproval'), 1, 128));
        end;

        [EventSubscriber(ObjectType::Codeunit, codeunit::ApprovalMgt, 'OncancelQCMForApproval', '', false, false)]

        local procedure RunworkflowonCancelQCMForApproval(var QCM: Record "Quotation Comparison")
        begin
            WorkflowManagement.HandleEvent(RunworkflowOncancelQCMforApprovalCode(), QCM);
        end;

        //Add events to library

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
        local procedure OnAddWorkflowEventsToLibraryQCM();
        begin
            WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendQCMforApprovalCode(), DATABASE::"Quotation Comparison",
              CopyStr(QCMsendforapprovaleventdesctxt, 1, 250), 0, FALSE);
            WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelQCMforApprovalCode(), DATABASE::"Quotation Comparison",
              CopyStr(QCMrequestcanceleventdesctxt, 1, 250), 0, FALSE);
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
        local procedure OnAddworkfloweventprodecessorstolibraryQCM(EventFunctionName: code[128]);
        begin
            case EventFunctionName of
                RunworkflowOnCancelQCMforApprovalCode():
                    WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelQCMforApprovalCode(), RunworkflowOnSendQCMforApprovalCode());
                WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                    WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendQCMforApprovalCode());
                WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                    WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendQCMforApprovalCode());
                WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                    WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendQCMforApprovalCode());
            end;
        end;

        procedure ISQCMWorkflowenabled(var QCM: Record "Quotation Comparison"): Boolean
        begin
            if QCM."Approval Status" <> QCM."Approval Status"::open then
                exit(false);
            exit(WorkflowManagement.CanExecuteWorkflow(QCM, RunworkflowOnSendQCMforApprovalCode()));
        end;

        Procedure CheckQCMApprovalsWorkflowEnabled(var QCM: Record "Quotation Comparison"): Boolean
        begin
            IF not ISQCMworkflowenabled(QCM) then
                Error((NoworkfloweableErr));
            exit(true);
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', false, false)]
        local procedure OnpopulateApprovalEntriesArgumentQCM(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
        var
            QCM: Record "Quotation Comparison";
        begin
            case RecRef.Number() of
                Database::"Quotation Comparison":
                    begin
                        RecRef.SetTable(QCM);
                        ApprovalEntryArgument."Document No." := FORMAT(QCM."RFQ No.");
                    end;
            end;
        end;

        //Handling workflow response

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', false, false)]
        local procedure OnopendocumentQCM(RecRef: RecordRef; var Handled: boolean)
        var
            QCM: Record "Quotation Comparison";
        begin
            case RecRef.Number() of
                Database::"Quotation Comparison":
                    begin
                        RecRef.SetTable(QCM);
                        QCM."Approval Status" := QCM."Approval Status"::open;
                        QCM.Modify();
                        Handled := true;
                    end;
            end;
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', false, false)]
        local procedure OnReleasedocumentQCM(RecRef: RecordRef; var Handled: boolean)
        var
            QCM: Record "Quotation Comparison";
        begin
            case RecRef.Number() of
                Database::"Quotation Comparison":
                    begin
                        RecRef.SetTable(QCM);
                        QCM."Approval Status" := QCM."Approval Status"::Released;
                        QCM.Modify();
                        Handled := true;
                    end;
            end;
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', false, false)]
        local procedure OnSetstatusToPendingApprovalQCM(RecRef: RecordRef; var IsHandled: boolean)
        var
            QCM: Record "Quotation Comparison";
        begin
            case RecRef.Number() of
                Database::"Quotation Comparison":
                    begin
                        RecRef.SetTable(QCM);
                        QCM."Approval Status" := QCM."Approval Status"::"Pending Approval";
                        QCM.Modify();
                        IsHandled := true;
                    end;
            end;
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', false, false)]
        local procedure OnaddworkflowresponseprodecessorstolibraryQCM(ResponseFunctionName: Code[128])
        var
            workflowresponsehandling: Codeunit "Workflow Response Handling";
        begin
            case ResponseFunctionName of
                workflowresponsehandling.SetStatusToPendingApprovalCode():
                    workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendQCMforApprovalCode());
                workflowresponsehandling.SendApprovalRequestForApprovalCode():
                    workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendQCMforApprovalCode());
                workflowresponsehandling.CancelAllApprovalRequestsCode():
                    workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelQCMforApprovalCode());
                workflowresponsehandling.OpenDocumentCode():
                    workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelQCMforApprovalCode());
            end;
        end;

        //Setup workflow

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', false, false)]
        local procedure OnaddworkflowCategoryTolibraryQCM()
        begin
            workflowsetup.InsertWorkflowCategory(CopyStr(QCMCategoryTxt, 1, 20), CopyStr(QCMCategoryDescTxt, 1, 100));
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', false, false)]
        local procedure OnInsertApprovaltablerelationsQCM()
        Var
            ApprovalEntry: record "Approval Entry";
        begin
            workflowsetup.InsertTableRelation(Database::"Quotation Comparison", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', false, false)]
        local procedure OnInsertworkflowtemplateQCM()
        begin
            InsertQCMApprovalworkflowtemplate();
        end;


        local procedure InsertQCMApprovalworkflowtemplate();
        var
            workflow: record Workflow;
        begin
            workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(QCMDocOCRWorkflowCodeTxt, 1, 17), CopyStr(QCMApprWorkflowDescTxt, 1, 100), CopyStr(QCMCategoryTxt, 1, 20));
            InsertQCMApprovalworkflowDetails(workflow);
            workflowsetup.MarkWorkflowAsTemplate(workflow);
        end;

        local procedure InsertQCMApprovalworkflowDetails(var workflow: record Workflow);
        var
            QCM: Record "Quotation Comparison";
            workflowstepargument: record "Workflow Step Argument";
            Blankdateformula: DateFormula;
        begin
            workflowsetup.PopulateWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

            workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildQCMtypecondition(QCM."Approval Status"::open), RunworkflowOnSendCPXforApprovalCode(), BuildQCMtypecondition(QCM."Approval Status"::"Pending Approval"), RunworkflowOnCancelQCMforApprovalCode(), workflowstepargument, true);
        end;



        local procedure BuildQCMtypecondition(status: integer): Text
        var
            QCM: Record "Quotation Comparison";
        Begin
            QCM.SetRange("Approval Status", Status);
            exit(StrSubstNo(QCMTypeCondnTxt, workflowsetup.Encode(QCM.GetView(false))));
        End;

        //Access record from the approval request page

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', false, false)]
        local procedure OnaftergetpageidQCM(RecordRef: RecordRef; var PageID: Integer)
        begin
            if PageID = 0 then
                PageID := GetConditionalcardPageidQCM(RecordRef)
        end;

        procedure RunworkflowOnSendCPXforApprovalCode(): code[128]
        begin
            exit(CopyStr(UpperCase('RunworkflowOnSendCPXforApproval'), 1, 128));
        end;


        local procedure GetConditionalcardPageidQCM(RecordRef: RecordRef): Integer
        begin
            Case RecordRef.Number() of
                database::"Quotation Comparison":
                    exit(page::"Quotation Comparison"
                    );
            end;
        end;

        var
            QCMDocOCRWorkflowCodeTxt: Label 'QCM';

            TRODocOCRWorkflowCodeTxt: Label 'QCM';
            WorkflowManagement: Codeunit "Workflow Management";

            WorkflowevenHandling: Codeunit "Workflow Event Handling";
            workflowsetup: codeunit "Workflow Setup";
            QCMsendforapprovaleventdescTxt: Label 'Approval of a QCM document is requested';
            QCMrequestcanceleventdescTxt: Label 'Approval of a QCM document is Cancelled';
            NoworkfloweableErr: Label 'No Approval workflow for this record type is enabled.';
            QCMCategoryTxt: Label 'QCM';
            QCMCategoryDescTxt: Label 'QCMDocuments';

            QCMTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="QCM">%1</DataItem></DataItems></ReportParameters>';

            QCMApprWorkflowDescTxt: Label 'QCM Approval Workflow';

    */
}