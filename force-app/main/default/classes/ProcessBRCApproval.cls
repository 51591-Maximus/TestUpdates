global class ProcessBRCApproval {
	@InvocableMethod(label='Process BRC Approvals' description='Given a list of Queue IDs, create a Contract Action approval process.' category='CA__c')
    global static void createContractActionApprovals(List<ApprovalRequest> request) {
        
        String contractActionId = request.get(0).contractActionId;
        List<String> userId = request.get(0).userIds;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for BRC Approval.');
        req.setObjectId(contractActionId);
        req.setProcessDefinitionNameOrId('BRC_Approval_Process');
        req.setSkipEntryCriteria(true);
        req.setNextApproverIds(userId);
        
        //Submit for Approval
        Approval.ProcessResult result = Approval.process(req);
        
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approved by BRC');
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
    }
}