codeunit 50014 "Approvals MGt 3"
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    Procedure OnSendQuoteComparisionIRHForApproval(var QuoteComparisionIRH: Record "Indent Req Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelQuoteComparisionIRHForApproval(var QuoteComparisionIRH: Record "Indent Req Header")
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendQuoteComparisionIRHforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendQuoteComparisionIRHforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 3", 'OnSendQuoteComparisionIRHForApproval', '', true, true)]
    local procedure RunworkflowonsendQuoteComparisionIRHForApproval(var QuoteComparisionIRH: Record "Indent Req Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendQuoteComparisionIRHforApprovalCode(), QuoteComparisionIRH);
    end;

    procedure RunworkflowOnCancelQuoteComparisionIRHforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelQuoteComparisionIRHForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 3", 'OnCancelQuoteComparisionIRHForApproval', '', true, true)]

    local procedure RunworkflowonCancelQuoteComparisionIRHForApproval(var QuoteComparisionIRH: Record "Indent Req Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelQuoteComparisionIRHforApprovalCode(), QuoteComparisionIRH);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryQuoteComparisionIRH();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendQuoteComparisionIRHforApprovalCode(), DATABASE::"Indent Req Header",
          CopyStr(QuoteComparisionIRHsendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelQuoteComparisionIRHforApprovalCode(), DATABASE::"Indent Req Header",
          CopyStr(QuoteComparisionIRHrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryQuoteComparisionIRH(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelQuoteComparisionIRHforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelQuoteComparisionIRHforApprovalCode(), RunworkflowOnSendQuoteComparisionIRHforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendQuoteComparisionIRHforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendQuoteComparisionIRHforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendQuoteComparisionIRHforApprovalCode());
        end;
    end;

    procedure ISQuoteComparisionIRHworkflowenabled(var QuoteComparisionIRH: Record "Indent Req Header"): Boolean
    begin
        if (QuoteComparisionIRH.Status <> QuoteComparisionIRH.Status::" ") then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(QuoteComparisionIRH, RunworkflowOnSendQuoteComparisionIRHforApprovalCode()));
    end;

    Procedure CheckQuoteComparisionIRHApprovalsWorkflowEnabled(var QuoteComparisionIRH: Record "Indent Req Header"): Boolean
    begin
        IF not ISQuoteComparisionIRHworkflowenabled(QuoteComparisionIRH) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentQuoteComparisionIRH(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        QuoteComparisionIRH: Record "Indent Req Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(QuoteComparisionIRH);
                    ApprovalEntryArgument."Document No." := FORMAT(QuoteComparisionIRH."RFQ No.");
                end;
        end;
    end;

    //Handling workflow response

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentQuoteComparisionIRH(RecRef: RecordRef; var Handled: boolean)
    var
        QuoteComparisionIRH: Record "Indent Req Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(QuoteComparisionIRH);
                    QuoteComparisionIRH.Status := QuoteComparisionIRH.Status::Open;
                    QuoteComparisionIRH.Modify;
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionIRH."RFQ No.");
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::Open);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentQuoteComparisionIRH(RecRef: RecordRef; var Handled: boolean)
    var
        QuoteComparisionIRH: Record "Indent Req Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(QuoteComparisionIRH);
                    QuoteComparisionIRH.Status := QuoteComparisionIRH.Status::Open;
                    QuoteComparisionIRH.Modify;
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionIRH."RFQ No.");
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::Released);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalQuoteComparisionIRH(RecRef: RecordRef; var IsHandled: boolean)
    var
        QuoteComparisionIRH: Record "Indent Req Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(QuoteComparisionIRH);
                    QuoteComparisionIRH.Status := QuoteComparisionIRH.Status::"Pending Approval";
                    QuoteComparisionIRH.Modify();

                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionIRH."RFQ No.");
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::"Pending Approval");
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryQuoteComparisionIRH(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendQuoteComparisionIRHforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendQuoteComparisionIRHforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelQuoteComparisionIRHforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelQuoteComparisionIRHforApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryQuoteComparisionIRH()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(QuoteComparisionIRHCategoryTxt, 1, 20), CopyStr(QuoteComparisionIRHCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsQuoteComparisionIRH()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::"Indent Req Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateQuoteComparisionIRH()
    begin
        InsertQuoteComparisionIRHApprovalworkflowtemplate();
    end;



    local procedure InsertQuoteComparisionIRHApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(QuoteComparisionIRHDocOCRWorkflowCodeTxt, 1, 17), CopyStr(QuoteComparisionIRHApprWorkflowDescTxt, 1, 100), CopyStr(QuoteComparisionIRHCategoryTxt, 1, 20));
        InsertQuoteComparisionIRHApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertQuoteComparisionIRHApprovalworkflowDetails(var workflow: record Workflow);
    var
        QuoteComparisionIRH: Record "Indent Req Header";
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildQuoteComparisionIRHtypecondition(QuoteComparisionIRH.Status::Open), RunworkflowOnSendQuoteComparisionIRHforApprovalCode(), BuildQuoteComparisionIRHtypecondition(QuoteComparisionIRH.Status::"Pending Approval"), RunworkflowOnCancelQuoteComparisionIRHforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildQuoteComparisionIRHtypecondition(status: integer): Text
    var
        QuoteComparisionIRH: Record "Indent Req Header";
    Begin
        QuoteComparisionIRH.SetRange(Status, status);
        exit(StrSubstNo(QuoteComparisionIRHTypeCondnTxt, workflowsetup.Encode(QuoteComparisionIRH.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidQuoteComparisionIRH(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidQuoteComparisionIRH(RecordRef)
    end;

    local procedure GetConditionalcardPageidQuoteComparisionIRH(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::"Indent Req Header":
                exit(page::"Indent Requisition Document");
        end;
    end;

    //Add QC QuoteComparisionIRH Approval End  <<
    //b2besg  End

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowevenHandling: Codeunit "Workflow Event Handling";
        workflowsetup: codeunit "Workflow Setup";

        //b2besg  Start Variables for QC
        QuoteComparisionIRHsendforapprovaleventdescTxt: Label 'Approval of a QuoteComparisionIRH Document is requested';
        QuoteComparisionIRHCategoryDescTxt: Label 'QuoteComparisionIRHDocuments';
        QuoteComparisionIRHTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=QuoteComparisionIRH>%1</DataItem></DataItems></ReportParameters>';
        QuoteComparisionIRHrequestcanceleventdescTxt: Label 'Approval of a QuoteComparisionIRH Document is Cancelled';
        QuoteComparisionIRHCategoryTxt: Label 'QuoteComparisionIRH specifications';
        QuoteComparisionIRHDocOCRWorkflowCodeTxt: Label 'QC QuoteComparisionIRH';
        QuoteComparisionIRHApprWorkflowDescTxt: Label 'QuoteComparisionIRH Approval Workflow';
        NoworkfloweableErr: Label 'No work flows enabled';



    //b2besg  End Variables for QC


}