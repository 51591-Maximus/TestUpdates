trigger unlockComment on Contract_Action_Comments__c (before insert) {
    List<Contract_Action_Comments__c> records = Trigger.New;
    if(!records.isEmpty()) {
        for(Contract_Action_Comments__c record: records) {
            if(Approval.isLocked(record.Contract_Action__c)) {
                //Unlock records
                Approval.UnlockResult result = Approval.unlock(record.Contract_Action__c, false);
            }
        }
    }
}