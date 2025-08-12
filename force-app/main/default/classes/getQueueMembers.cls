global class getQueueMembers {
    @InvocableMethod
    webservice static List<List<User>> returnQueueMembers (List<QueueRequest> request)
    {    
        String queueName = request.get(0).queueName;
        List<String> userIds = new List<String>();
        
        List<GroupMember> groupMembers = [Select UserOrGroupId 
                    From GroupMember 
                    where GroupId IN (SELECT Id FROM Group 
                                     where type='Queue' 
                                     and DeveloperName=:queueName)];
        
        for(GroupMember thisMember : groupMembers)
        {
            userIds.add(thisMember.UserOrGroupId);
        }
        
        
        List<User> thisList = [SELECT Id, Name 
                                 FROM User 
                                 WHERE Id IN :userIds];
        
        List<List<User>> results = new List<List<User>>();
        results.add(thisList);
        
        return results;                
    }
    
    global class QueueRequest
    {
        @InvocableVariable
        global String queueName;
    }
}