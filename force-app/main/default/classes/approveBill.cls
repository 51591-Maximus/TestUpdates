global class approveBill {
    @InvocableMethod
    webservice static void approveBill(List<ApproveRequest> request)  {
        String recId = request.get(0).processWorkItemId;
        String comment = request.get(0).comments;

        Approval.ProcessWorkitemRequest workItem = new Approval.ProcessWorkitemRequest();
        workItem.setComments(comment);
        workItem.setAction('Approve');
        workItem.setWorkitemId(recId);
        Approval.ProcessResult result = Approval.process(workItem);
    }

    global class ApproveRequest {
        @InvocableVariable
        global String processWorkItemId;
        
        @InvocableVariable
        global String comments;
    }
}