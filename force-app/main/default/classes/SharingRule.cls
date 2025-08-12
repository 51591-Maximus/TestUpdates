global class SharingRule {
    // Call for Flow action
    @InvocableMethod(label='Sharing Rule' description='Allows and denies access to confidential records.' category='Users')
    global static void manualShareRead(List<ShareJob> request) {
        String caID = request.get(0).recordId;
        String apiName = request.get(0).objectName;
        
        List<String> addList = request.get(0).addIds;
        List<String> deleteList = request.get(0).deleteIds;
        
        System.debug('Add List: ' + addList);
        if(addList != null) {
            for(Integer i = 0; i < addList.size(); i++) {
                
                // Check for duplicate share record
                String userId = addList.get(i);
                String addQuery = 'SELECT COUNT() FROM ' + apiName + 
                                  ' WHERE ParentId = :caID AND userOrGroupId = :userId';
                System.debug('Add query: ' + addQuery);
                boolean isDupeRecord = Database.countQuery(addQuery) > 0;
                
                // If no share record, exist, create one. 
                if(isDupeRecord == false) {
                    
                    // Creates new share record for CA object
                    sObject caShr = Schema.getGlobalDescribe().get(apiName).newSObject() ;
                    
                    // Set the ID of record being shared.
                    caShr.put('ParentId', caID);
                    
                    // Set the ID of user or group being granted access.
                    caShr.put('UserOrGroupId', userId);
                    
                    // Set the access level.
                    caShr.put('AccessLevel', 'Edit');
                    
                    // Set rowCause to 'manual' for manual sharing.
                    caShr.put('RowCause', Schema.CA__Share.RowCause.Manual);
                    
                    // Insert the sharing record and capture the save result. 
                    // The false parameter allows for partial processing if multiple records passed 
                    // into the operation.
                    Database.SaveResult sr = Database.insert(caShr,false);
                }
            }
        }
        
        if(deleteList != null) {
            System.debug('deleteList: ' + deleteList);
            String manual = '\''+ 'Manual' + '\'';
            for(Integer j = 0; j < deleteList.size(); j++) {
                String currentDelete = deleteList.get(j);
                String deleteQuery = 'SELECT userOrGroupId, ParentId, RowCause FROM ' + apiName +
                				     ' WHERE ParentId = :caID AND userOrGroupId = :currentDelete AND RowCause = ' + 
                                     manual + ' LIMIT 1';
                System.debug('Query entered: ' + deleteQuery);
             	List<SObject> shareRecords = Database.query(deleteQuery);
                System.debug('Query returned records: ' + shareRecords);
                delete shareRecords;
            }
        }
    }	
    
    
    
    global class ShareJob {
        
        @InvocableVariable
        global String objectName;
        
        @InvocableVariable
        global String recordId;
        
        @InvocableVariable
        global List<String> addIds;
        
        @InvocableVariable
        global List<String> deleteIds;
        
    }
}