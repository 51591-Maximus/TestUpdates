global class processBillingApproval {

    @InvocableMethod(label='Process Billing Approvals' description='Given a list of Queue IDs, create a Billing approval process.' category='Bills__c')
    global static void createContractActionApprovals(List<ApprovalRequest> request) {
        
        String billingId = request.get(0).billingId;
        List<String> approverIds = request.get(0).approverIds;
        String comments = request.get(0).comments;
        List<Approval.ProcessSubmitRequest> approvalRequestList = new List<Approval.ProcessSubmitRequest>();
        
        for (String thisQueueId : approverIds) {
            //Class to submit a record for approval.
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            //Sets the comments to be added to the approval request
            approvalRequest.setComments(comments);
            //Sets the ID of the record to be submitted for approval. For example, it can specify
            // an account, contact, or custom object record.
            approvalRequest.setObjectId(billingId);
            //If the next step in your approval process is another Apex approval process, you specify
            // exactly one user ID as the next approver. If not, you cannot specify a user ID and this
            // method must be null
            //approvalRequest.setProcessDefinitionNameOrId('PM_Approval');
            approvalRequest.setNextApproverIds(new List<String>{thisQueueId});
            approvalRequestList.add(approvalRequest);
        }
        
        Approval.process(approvalRequestList);
    }
        global class ApprovalRequest {
        @InvocableVariable
        global String billingId;
        
        @InvocableVariable
        global List<String> approverIds;
        
        @InvocableVariable
        global String comments;
    }
}