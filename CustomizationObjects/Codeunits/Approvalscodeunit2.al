codeunit 50013 "Approvals MGt 2"
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    Procedure OnSendQuoteComparisionForApproval(var QuoteComparision: Record QuotCompHdr)
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelQuoteComparisionForApproval(var QuoteComparision: Record QuotCompHdr)
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendQuoteComparisionforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendQuoteComparisionforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 2", 'OnSendQuoteComparisionForApproval', '', true, true)]
    local procedure RunworkflowonsendQuoteComparisionForApproval(var QuoteComparision: Record QuotCompHdr)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendQuoteComparisionforApprovalCode(), QuoteComparision);
    end;

    procedure RunworkflowOnCancelQuoteComparisionforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelQuoteComparisionForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 2", 'OnCancelQuoteComparisionForApproval', '', true, true)]

    local procedure RunworkflowonCancelQuoteComparisionForApproval(var QuoteComparision: Record QuotCompHdr)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelQuoteComparisionforApprovalCode(), QuoteComparision);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryQuoteComparision();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendQuoteComparisionforApprovalCode(), DATABASE::QuotCompHdr,
          CopyStr(QuoteComparisionsendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelQuoteComparisionforApprovalCode(), DATABASE::QuotCompHdr,
          CopyStr(QuoteComparisionrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryQuoteComparision(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelQuoteComparisionforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelQuoteComparisionforApprovalCode(), RunworkflowOnSendQuoteComparisionforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendQuoteComparisionforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendQuoteComparisionforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendQuoteComparisionforApprovalCode());
        end;
    end;

    procedure ISQuoteComparisionworkflowenabled(var QuoteComparision: Record QuotCompHdr): Boolean
    begin
        if (QuoteComparision.Status <> QuoteComparision.Status::Open) then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(QuoteComparision, RunworkflowOnSendQuoteComparisionforApprovalCode()));
    end;

    Procedure CheckQuoteComparisionApprovalsWorkflowEnabled(var QuoteComparision: Record QuotCompHdr): Boolean
    begin
        IF not ISQuoteComparisionworkflowenabled(QuoteComparision) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentQuoteComparision(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        QuoteComparision: Record QuotCompHdr;
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparision);
                    ApprovalEntryArgument."Document No." := FORMAT(QuoteComparision."No.");
                end;
        end;
    end;

    //Handling workflow response

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentQuoteComparision(RecRef: RecordRef; var Handled: boolean)
    var
        QuoteComparision: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparision);
                    QuoteComparision.SetRange("No.", QuoteComparision."No.");
                    QuoteComparision.Status := QuoteComparision.Status::Open;
                    //QuoteComparision.ModifyAll(Status, QuoteComparision.Status::Open);
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparision."No.");
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::Open);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentQuoteComparision(RecRef: RecordRef; var Handled: boolean)
    var
        QuoteComparision: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparision);
                    QuoteComparision.SetRange("No.", QuoteComparision."No.");
                    QuoteComparision.Status := QuoteComparision.Status::Open;
                    //QuoteComparision.ModifyAll("Approval Status", QuoteComparision."Approval Status"::Released);
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparision."No.");
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::Released);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalQuoteComparision(RecRef: RecordRef; var IsHandled: boolean)
    var
        QuoteComparision: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparision);
                    QuoteComparision.SetRange("No.", QuoteComparision."No.");
                    QuoteComparision.Status := QuoteComparision.Status::"Pending Approval";
                    //QuoteComparision.ModifyAll("Approval Status", QuoteComparision."Approval Status"::"Pending Approval");
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparision."No.");
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::"Pending Approval");
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryQuoteComparision(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendQuoteComparisionforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendQuoteComparisionforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelQuoteComparisionforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelQuoteComparisionforApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryQuoteComparision()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(QuoteComparisionCategoryTxt, 1, 20), CopyStr(QuoteComparisionCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsQuoteComparision()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::QuotCompHdr, 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateQuoteComparision()
    begin
        InsertQuoteComparisionApprovalworkflowtemplate();
    end;



    local procedure InsertQuoteComparisionApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(QuoteComparisionDocOCRWorkflowCodeTxt, 1, 17), CopyStr(QuoteComparisionApprWorkflowDescTxt, 1, 100), CopyStr(QuoteComparisionCategoryTxt, 1, 20));
        InsertQuoteComparisionApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertQuoteComparisionApprovalworkflowDetails(var workflow: record Workflow);
    var
        QuoteComparision: Record QuotCompHdr;
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildQuoteComparisiontypecondition(QuoteComparision.Status::Open), RunworkflowOnSendQuoteComparisionforApprovalCode(), BuildQuoteComparisiontypecondition(QuoteComparision.Status::"Pending Approval"), RunworkflowOnCancelQuoteComparisionforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildQuoteComparisiontypecondition(status: integer): Text
    var
        QuoteComparision: Record QuotCompHdr;
    Begin
        QuoteComparision.SetRange(Status, status);
        exit(StrSubstNo(QuoteComparisionTypeCondnTxt, workflowsetup.Encode(QuoteComparision.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidQuoteComparision(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidQuoteComparision(RecordRef)
    end;

    local procedure GetConditionalcardPageidQuoteComparision(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::QuotCompHdr:
                exit(page::"Quotation Comparision Doc");
        end;
    end;

    //Add QC QuoteComparision Approval End  <<
    //b2besg  End

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowevenHandling: Codeunit "Workflow Event Handling";
        workflowsetup: codeunit "Workflow Setup";

        //b2besg  Start Variables for QC
        QuoteComparisionsendforapprovaleventdescTxt: Label 'Approval of a QuoteComparision Document is requested';
        QuoteComparisionCategoryDescTxt: Label 'QuoteComparisionDocuments';
        QuoteComparisionTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=QuoteComparision>%1</DataItem></DataItems></ReportParameters>';
        QuoteComparisionrequestcanceleventdescTxt: Label 'Approval of a QuoteComparision Document is Cancelled';
        QuoteComparisionCategoryTxt: Label 'QuoteComparision specifications';
        QuoteComparisionDocOCRWorkflowCodeTxt: Label 'QC QuoteComparision';
        QuoteComparisionApprWorkflowDescTxt: Label 'QuoteComparision Approval Workflow';
        NoworkfloweableErr: Label 'No work flows enabled';



    //b2besg  End Variables for QC


}