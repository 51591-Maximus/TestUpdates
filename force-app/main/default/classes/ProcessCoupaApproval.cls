global class ProcessCoupaApproval {
    @InvocableMethod(label='Process Coupa Approvals' description='Given a list of Queue IDs, create a Contract Action approval process.' category='CA__c')
    global static void createContractActionApprovals(List<ApprovalRequest> request) {
        
        String contractActionId = request.get(0).contractActionId;
        List<String> userId = request.get(0).userIds;
        String approvalType = request.get(0).approvalType;
        String submitComment;
        String approveComment;
        
        if(approvalType == 'Coupa') {
            submitComment = 'Submitting request for Approval.';
            approveComment = 'Request approved in Coupa.';
        }
            
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(submitComment);
        req.setObjectId(contractActionId);
        req.setProcessDefinitionNameOrId('AM_Approvals');
        req.setSkipEntryCriteria(true);
        req.setNextApproverIds(userId);
        
        //Submit for Approval
        Approval.ProcessResult result = Approval.process(req);
        
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(approveComment);
        req2.setAction('Approve');
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        
    }
    
    global class ApprovalRequest {
        @InvocableVariable
        global String contractActionId;
        
        @InvocableVariable
        global List<String> userIds;
        
        @InvocableVariable
        global String approvalType;
    }
}