global class rejectBill {
    @InvocableMethod
    webservice static void rejectBill(List<ApproveRequest> request) {
        String recId = request.get(0).processWorkItemId;
        String comment = request.get(0).comments;

        Approval.ProcessWorkitemRequest workItem = new Approval.ProcessWorkitemRequest();
        workItem.setComments(comment);
        workItem.setAction('Reject');
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