public class approvalHistoryList {
    @AuraEnabled
    public static List<Object> getApprovalHistory(String recordId){
        
        
        List<ProcessInstanceWorkitem> piwiList = [Select Id, ProcessInstanceId from ProcessInstanceWorkitem where Id = :recordId];
        if(piwiList != null && !piwiList.isEmpty()) {
            List<ProcessInstance> allPi = [Select TargetObjectId from ProcessInstance where Id = :piwiList.get(0).ProcessInstanceId ORDER BY CreatedDate DESC];
            
            if(allPi != null && !allPi.isEmpty())  {
                List<ApprovalHistory> returnList = new List<ApprovalHistory>();
                
                for(ProcessInstance pI: getProcessHistory(allPi.get(0).TargetObjectId).values())  {
                    for(ProcessInstanceHistory pih : pI.StepsandWorkitems)  {
                        if(pih.StepStatus != 'Started')  {
                            returnList.add(new ApprovalHistory(pih.CreatedDate, pih.StepStatus, pih.Actor.Name, pih.OriginalActor.Name, pih.comments));
                        }
                    }
                }
                
                if(returnList != null && !returnList.isEmpty())  {
                    return returnList;
                }
            }
            
        }

        return null;
    }
    
    @AuraEnabled  
    public static Map<Id,ProcessInstance> getProcessHistory(Id recordId)  
    {
        return new Map<Id,ProcessInstance>([SELECT Id, (SELECT ID, CreatedDate, TargetObjectId, ProcessNodeId, StepStatus, Comments, Actor.Name, OriginalActor.Name 
                                                        FROM StepsAndWorkitems ORDER BY createdDate DESC) 
                                            FROM ProcessInstance WHERE TargetObjectId = :recordId
                                            ORDER BY createdDate DESC]);
        
    }  
    
    public class ApprovalHistory  
    {  
        @AuraEnabled  
        public string crDate {get;set;}  
        @AuraEnabled  
        public string actualApprover {get;set;}  
        @AuraEnabled  
        public string status {get;set;}  
        @AuraEnabled  
        public string assignedTo {get;set;}
        @AuraEnabled  
        public string comments {get;set;} 
        
        public ApprovalHistory(DateTime createDate, string stepStatus, string actorName, string originalActor, string comment)  
        {  
            crDate = createDate.format();  
            actualApprover = actorName;  
            status = stepStatus;  
            assignedTo = originalActor;
            comments = comment;
        }  
    }
}