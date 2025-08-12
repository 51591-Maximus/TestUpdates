trigger lockComment on Contract_Action_Comments__c (after insert) {
    List<Contract_Action_Comments__c> records = Trigger.New;
    if(!records.isEmpty()) {
        for(Contract_Action_Comments__c record: records) {
            if(!Approval.isLocked(record.Contract_Action__c)) {
                CA__c recordStatus = [select status__c from CA__c where ID =: record.Contract_Action__c];
                if(recordStatus.Status__c == 'Functional Review' || recordStatus.Status__c == 'Authority Matrix Review')  {
                    //lock records
                    Approval.LockResult result = Approval.lock(record.Contract_Action__c, false);
                }
            }
        }
    }
}