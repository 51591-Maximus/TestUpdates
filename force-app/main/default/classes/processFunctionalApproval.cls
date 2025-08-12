public with sharing class processFunctionalApproval {
    
    public static CA__c contractAction {get; set;}
    public static List<String> queueIds = new List<String>();
    
    public processFunctionalApproval(ApexPages.StandardController controller) {
        contractAction = (CA__c) controller.getRecord();
    }
    
    @AuraEnabled
    public static void startApproval() {
        System.debug('----Entered startApproval method----');
        buildQueueIdList();
        initApprovalProcess();
        System.debug('----Exited  startApproval method----');
    }
    
    private static void buildQueueIdList() {
        System.debug('----Entered buildQueueIdList method----');
        System.debug('Finance: ' + contractAction.Approval_Required_Finance__c);
        System.debug('HR: ' + contractAction.Approval_Required_HR__c);
        System.debug('Insurance: ' + contractAction.Approval_Required_Insurance__c);
        if(contractAction.Approval_Required_Finance__c) {
            queueIds.add(addQueueId('Finance_Approvers'));
        }
        if(contractAction.Approval_Required_HR__c) {
            queueIds.add(addQueueId('HR_Approvers'));
        }
        if(contractAction.Approval_Required_Insurance__c) {
            queueIds.add(addQueueId('Insurance_Approvers'));
        }
        if(contractAction.Approval_Required_Privacy__c) {
            queueIds.add(addQueueId('Privacy_Approvers'));
        }
        if(contractAction.Approval_Required_Security__c) {
            queueIds.add(addQueueId('Security_Approvers'));
        }
        System.debug('----Exited buildQueueIdList method----');
        for(String thisQueueId : queueIds) {
            System.debug('Queue Item: ' + thisQueueId);
        }
    }
    
    private static Id addQueueId(String queueName) {
        System.debug('----Entered addQueueId method----');
        System.debug(queueName);
        String queueId;
        queueId = [
            select Id from Group where Type = 'Queue' AND DeveloperNAME = :queueName LIMIT 1
        ].Id;
        System.debug('----Exited addQueueId method----');
        return queueId;
    }
    
    public static void initApprovalProcess() {
        
        List<Approval.ProcessSubmitRequest> approvalRequestList = new List<Approval.ProcessSubmitRequest>();
        
        for (String thisQueueId : queueIds) {
            //Class to submit a record for approval.
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            //Sets the comments to be added to the approval request
            approvalRequest.setComments('Submitting request for approval.');
            //Sets the ID of the record to be submitted for approval. For example, it can specify
            // an account, contact, or custom object record.
            approvalRequest.setObjectId(contractAction.Id);
            //If the next step in your approval process is another Apex approval process, you specify
            // exactly one user ID as the next approver. If not, you cannot specify a user ID and this
            // method must be null
            approvalRequest.setNextApproverIds(new List<String>{thisQueueId});
            
            approvalRequestList.add(approvalRequest);
        }
        
        Approval.process(approvalRequestList);
    }
    
    private static List<ProcessInstanceWorkitem> getProcessInstanceWorkItems(Id objectId) {
        return [
            SELECT
            Id
            FROM
            ProcessInstanceWorkitem
            WHERE
            ProcessInstance.TargetObjectId =: objectId
        ];
    }
    
    //Helper method to create new Process Work Item Request record to process an approval request after it is submitted.
    private static Approval.ProcessWorkitemRequest createProcessWorkItemRequest(Id approvalStepId, Id approverId, String approvalAction, String commentFromApprover){
        Approval.ProcessWorkitemRequest result = new Approval.ProcessWorkitemRequest();
        result.setComments(commentFromApprover);
        result.setAction(approvalAction);
        result.setWorkitemId(approvalStepId);
        if (approverId != null) {
            result.setNextApproverIds(new List<Id>{approverId});
        }
        return result;
    }
    
    public static void approveRecord(Id sObjectId, String action, String commentFromApprover) {
        List<Approval.ProcessWorkitemRequest> approvalRequestList = new List<Approval.ProcessWorkitemRequest>();
        
        if (action == 'Approve') {
            
            for (ProcessInstanceWorkitem workItem : getProcessInstanceWorkItems(sObjectId)) {
                approvalRequestList.add(createProcessWorkItemRequest(workItem.Id, null, action, commentFromApprover));
            }
        } else if (action == 'Reject' || action == 'Removed') {
            for (ProcessInstanceWorkitem workItem : getProcessInstanceWorkItems(sObjectId)) {
                approvalRequestList.add(createProcessWorkItemRequest(workItem.Id, null, action, commentFromApprover));
            }
        }
        
        Approval.process(approvalRequestList);
    }
}