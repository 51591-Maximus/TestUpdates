global class approvalRecall
{
   @InvocableMethod
    webservice static void recallApproval(List<RecallRequest> request)   
    {   
        String recId = request.get(0).contractActionId;
        String comment = request.get(0).comments;
        
        List<ProcessInstanceWorkitem> piwi = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: recId];
        for (ProcessInstanceWorkitem thisPI : piwi) {
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        	req.setAction('Removed');       
        	req.setWorkitemId(thisPI.Id);
            req.setComments(comment);
   			Approval.process(req,false);
        }
    }
    
    global class RecallRequest {
        @InvocableVariable
        global String contractActionId;
        
        @InvocableVariable
        global String comments;
    }
}