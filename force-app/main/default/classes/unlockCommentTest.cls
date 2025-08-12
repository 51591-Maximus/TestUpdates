@isTest
private class unlockCommentTest {
    @isTest
    static void testUnlockCommentTrigger() {
        // Create a CA__c record and lock it
        CA__c ca = new CA__c(Status__c = 'Functional Review');
        insert ca;
        // Lock the record
        Approval.LockResult lockResult = Approval.lock(ca.Id, false);
        System.assert(Approval.isLocked(ca.Id), 'Record should be locked before test');
        // Insert Contract_Action_Comments__c to trigger unlock
        Contract_Action_Comments__c comment = new Contract_Action_Comments__c(Contract_Action__c = ca.Id);
        Test.startTest();
        insert comment;
        Test.stopTest();
        // Check if the record is unlocked
        Boolean isLocked = Approval.isLocked(ca.Id);
        System.assert(!isLocked, 'Record should be unlocked after trigger');
    }

    @isTest
    static void testUnlockCommentTrigger_NotLocked() {
        CA__c ca = new CA__c(Status__c = 'Other Status');
        insert ca;
        // Not locked
        Contract_Action_Comments__c comment = new Contract_Action_Comments__c(Contract_Action__c = ca.Id);
        Test.startTest();
        insert comment;
        Test.stopTest();
        // Should remain unlocked
        Boolean isLocked = Approval.isLocked(ca.Id);
        System.assert(!isLocked, 'Record should remain unlocked');
    }
}
