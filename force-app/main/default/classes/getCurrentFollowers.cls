global class getCurrentFollowers {
	
   @InvocableMethod
    webservice static List<List<User>> returnFollowerList (List<ApproverRequest> request)   
    {   
        String recordId = request.get(0).caRecordId;
        
        List<User> thisList = [SELECT Id, Name 
                                            FROM User 
                                            WHERE Id IN(SELECT SubscriberId 
                                                        FROM EntitySubscription 
                                                        WHERE ParentId = :recordId)];
        
        List<List<User>> results = new List<List<User>>();
        results.add(thisList);
        
        return results;
    }
    
    global class ApproverRequest
    {
        @InvocableVariable
        global String caRecordId;
    }
}