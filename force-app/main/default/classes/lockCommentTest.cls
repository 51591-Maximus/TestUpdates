@isTest
private class lockCommentTest {
    @isTest
    static void testLockCommentTrigger() {
        // Create a CA__c record with status 'Functional Review'
        CA__c ca = new CA__c(Status__c = 'Functional Review');
        insert ca;
        // Create a Contract_Action_Comments__c record referencing the CA__c
        Contract_Action_Comments__c comment = new Contract_Action_Comments__c(Contract_Action__c = ca.Id);
        Test.startTest();
        insert comment;
        Test.stopTest();
        // Check if the record is locked
        Boolean isLocked = Approval.isLocked(ca.Id);
        System.assert(isLocked, 'Record should be locked for Functional Review');
    }

    @isTest
    static void testLockCommentTrigger_AuthorityMatrixReview() {
        CA__c ca = new CA__c(Status__c = 'Authority Matrix Review');
        insert ca;
        Contract_Action_Comments__c comment = new Contract_Action_Comments__c(Contract_Action__c = ca.Id);
        Test.startTest();
        insert comment;
        Test.stopTest();
        Boolean isLocked = Approval.isLocked(ca.Id);
        System.assert(isLocked, 'Record should be locked for Authority Matrix Review');
    }

    @isTest
    static void testLockCommentTrigger_NotLocked() {
        CA__c ca = new CA__c(Status__c = 'Other Status');
        insert ca;
        Contract_Action_Comments__c comment = new Contract_Action_Comments__c(Contract_Action__c = ca.Id);
        Test.startTest();
        insert comment;
        Test.stopTest();
        Boolean isLocked = Approval.isLocked(ca.Id);
        System.assert(!isLocked, 'Record should not be locked for other status');
    }
}
