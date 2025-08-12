global class ProcessContractActionApproval {
	@InvocableMethod(label='Process Contract Action Approvals' description='Given a list of Queue IDs, create a Contract Action approval process.' category='CA__c')
    global static void createContractActionApprovals(List<ApprovalRequest> request) {
        
        String contractActionId = request.get(0).contractActionId;
        List<String> queueIds = request.get(0).queueIds;
        String approvalType = request.get(0).approvalType;
        List<Approval.ProcessSubmitRequest> approvalRequestList = new List<Approval.ProcessSubmitRequest>();
        
        for (String thisQueueId : queueIds) {
            //Class to submit a record for approval.
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            //Sets the comments to be added to the approval request
            approvalRequest.setComments('Submitting request for ' + approvalType + ' approval.');
            //Sets the ID of the record to be submitted for approval. For example, it can specify
            // an account, contact, or custom object record.
            approvalRequest.setObjectId(contractActionId);
            //If the next step in your approval process is another Apex approval process, you specify
            // exactly one user ID as the next approver. If not, you cannot specify a user ID and this
            // method must be null
            approvalRequest.setNextApproverIds(new List<String>{thisQueueId});
            approvalRequestList.add(approvalRequest);
        }
        
        Approval.process(approvalRequestList);
        
        if(approvalType == 'Functional') {
            CA__c thisContractAction = [SELECT Status__c FROM CA__c WHERE Id = :contractActionId];
        	thisContractAction.Status__c = 'Functional Review';
			thisContractAction.Approval_Count__c = queueIds.size();
            thisContractAction.Approval_Type__c = 'Functional';
            
        	// Perform isAccessible() and isUpdateable() checks here 
        	update thisContractAction;
        }
        
        if(approvalType == 'Authority Matrix') {
            CA__c thisContractAction = [SELECT Status__c FROM CA__c WHERE Id = :contractActionId];
        	thisContractAction.Status__c = 'Authority Matrix Review';
			thisContractAction.Approval_Count__c = queueIds.size();
            thisContractAction.Approval_Type__c = 'Authority Matrix';
            
        	// Perform isAccessible() and isUpdateable() checks here 
        	update thisContractAction;
        }
        
        if(approvalType == 'Awaiting Signature') {
            CA__c thisContractAction = [SELECT Status__c FROM CA__c WHERE Id = :contractActionId];
        	thisContractAction.Status__c = 'Authority Matrix Review';
			thisContractAction.Approval_Count__c = queueIds.size();
            thisContractAction.Approval_Type__c = 'Awaiting Signature';
            
        	// Perform isAccessible() and isUpdateable() checks here 
        	update thisContractAction;
        }
    }
    
    global class ApprovalRequest {
        @InvocableVariable
        global String contractActionId;
        
        @InvocableVariable
        global List<String> queueIds;
        
        @InvocableVariable
        global String approvalType;
    }
}