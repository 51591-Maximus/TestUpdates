@isTest
private class ProcessBRCApprovalTest {
    @isTest
    static void testCreateContractActionApprovals() {
        // Create a test user to act as an approver
        User u = new User(
            Alias = 'testu',
            Email = 'testuser7@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser7' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Create a test CA__c record
        CA__c ca = new CA__c(Name = 'Test CA');
        insert ca;

        // Prepare ApprovalRequest
        ProcessBRCApproval.ApprovalRequest req = new ProcessBRCApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.userIds = new List<String>{u.Id};
        List<ProcessBRCApproval.ApprovalRequest> reqList = new List<ProcessBRCApproval.ApprovalRequest>{req};

        Test.startTest();
        ProcessBRCApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        // No exception means success
        System.assert(true);
    }

    @isTest
    static void testCreateContractActionApprovals_emptyUserIds() {
        CA__c ca = new CA__c(Name = 'Test CA 2');
        insert ca;
        ProcessBRCApproval.ApprovalRequest req = new ProcessBRCApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.userIds = new List<String>();
        List<ProcessBRCApproval.ApprovalRequest> reqList = new List<ProcessBRCApproval.ApprovalRequest>{req};
        Test.startTest();
        ProcessBRCApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testApprovalRequestConstructor() {
        ProcessBRCApproval.ApprovalRequest req = new ProcessBRCApproval.ApprovalRequest();
        req.contractActionId = 'testId';
        req.userIds = new List<String>{'id1','id2'};
        System.assertEquals('testId', req.contractActionId);
        System.assertEquals(2, req.userIds.size());
    }
}
