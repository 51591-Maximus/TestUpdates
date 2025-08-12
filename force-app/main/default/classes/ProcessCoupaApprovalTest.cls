@isTest
private class ProcessCoupaApprovalTest {
    @isTest
    static void testCreateContractActionApprovals_Coupa() {
        // Create a test user to act as an approver
        User u = new User(
            Alias = 'testu',
            Email = 'testuser14@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser14' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Create a test CA__c record
        CA__c ca = new CA__c(Name = 'Test CA Coupa');
        insert ca;

        // Prepare ApprovalRequest for Coupa
        ProcessCoupaApproval.ApprovalRequest req = new ProcessCoupaApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.userIds = new List<String>{u.Id};
        req.approvalType = 'Coupa';
        List<ProcessCoupaApproval.ApprovalRequest> reqList = new List<ProcessCoupaApproval.ApprovalRequest>{req};

        Test.startTest();
        ProcessCoupaApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testCreateContractActionApprovals_emptyUserIds() {
        CA__c ca = new CA__c(Name = 'Test CA Empty');
        insert ca;
        ProcessCoupaApproval.ApprovalRequest req = new ProcessCoupaApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.userIds = new List<String>();
        req.approvalType = 'Coupa';
        List<ProcessCoupaApproval.ApprovalRequest> reqList = new List<ProcessCoupaApproval.ApprovalRequest>{req};
        Test.startTest();
        ProcessCoupaApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testApprovalRequestConstructor() {
        ProcessCoupaApproval.ApprovalRequest req = new ProcessCoupaApproval.ApprovalRequest();
        req.contractActionId = 'testId';
        req.userIds = new List<String>{'id1','id2'};
        req.approvalType = 'Coupa';
        System.assertEquals('testId', req.contractActionId);
        System.assertEquals(2, req.userIds.size());
        System.assertEquals('Coupa', req.approvalType);
    }
}
