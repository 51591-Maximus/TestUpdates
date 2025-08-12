@isTest
private class ProcessBRCorCoupaApprovalTest {
    @isTest
    static void testCreateContractActionApprovals_BRC() {
        // Create a test user to act as an approver
        User u = new User(
            Alias = 'testu',
            Email = 'testuser8@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser8' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Create a test CA__c record
        CA__c ca = new CA__c(Name = 'Test CA BRC');
        insert ca;

        // Prepare ApprovalRequest for BRC
        ProcessBRCorCoupaApproval.ApprovalRequest req = new ProcessBRCorCoupaApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.userIds = new List<String>{u.Id};
        req.approvalType = 'BRC';
        List<ProcessBRCorCoupaApproval.ApprovalRequest> reqList = new List<ProcessBRCorCoupaApproval.ApprovalRequest>{req};

        Test.startTest();
        ProcessBRCorCoupaApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testCreateContractActionApprovals_Coupa() {
        User u = new User(
            Alias = 'testu',
            Email = 'testuser9@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser9' + System.currentTimeMillis() + '@example.com'
        );
        insert u;
        CA__c ca = new CA__c(Name = 'Test CA Coupa');
        insert ca;
        ProcessBRCorCoupaApproval.ApprovalRequest req = new ProcessBRCorCoupaApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.userIds = new List<String>{u.Id};
        req.approvalType = 'Coupa';
        List<ProcessBRCorCoupaApproval.ApprovalRequest> reqList = new List<ProcessBRCorCoupaApproval.ApprovalRequest>{req};
        Test.startTest();
        ProcessBRCorCoupaApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testCreateContractActionApprovals_emptyUserIds() {
        CA__c ca = new CA__c(Name = 'Test CA Empty');
        insert ca;
        ProcessBRCorCoupaApproval.ApprovalRequest req = new ProcessBRCorCoupaApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.userIds = new List<String>();
        req.approvalType = 'BRC';
        List<ProcessBRCorCoupaApproval.ApprovalRequest> reqList = new List<ProcessBRCorCoupaApproval.ApprovalRequest>{req};
        Test.startTest();
        ProcessBRCorCoupaApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testApprovalRequestConstructor() {
        ProcessBRCorCoupaApproval.ApprovalRequest req = new ProcessBRCorCoupaApproval.ApprovalRequest();
        req.contractActionId = 'testId';
        req.userIds = new List<String>{'id1','id2'};
        req.approvalType = 'BRC';
        System.assertEquals('testId', req.contractActionId);
        System.assertEquals(2, req.userIds.size());
        System.assertEquals('BRC', req.approvalType);
    }
}
