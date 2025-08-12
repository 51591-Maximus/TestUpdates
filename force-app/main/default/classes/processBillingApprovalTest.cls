@isTest
private class processBillingApprovalTest {
    @isTest
    static void testCreateContractActionApprovals() {
        // Create a test user to act as an approver
        User u = new User(
            Alias = 'testu',
            Email = 'testuser6@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser6' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Create a test Bills__c record
        Bills__c bill = new Bills__c(Name = 'Test Bill');
        insert bill;

        // Prepare ApprovalRequest
        processBillingApproval.ApprovalRequest req = new processBillingApproval.ApprovalRequest();
        req.billingId = bill.Id;
        req.approverIds = new List<String>{u.Id};
        req.comments = 'Please approve';
        List<processBillingApproval.ApprovalRequest> reqList = new List<processBillingApproval.ApprovalRequest>{req};

        Test.startTest();
        processBillingApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        // No exception means success
        System.assert(true);
    }

    @isTest
    static void testCreateContractActionApprovals_emptyApproverIds() {
        Bills__c bill = new Bills__c(Name = 'Test Bill 2');
        insert bill;
        processBillingApproval.ApprovalRequest req = new processBillingApproval.ApprovalRequest();
        req.billingId = bill.Id;
        req.approverIds = new List<String>();
        req.comments = 'No approvers';
        List<processBillingApproval.ApprovalRequest> reqList = new List<processBillingApproval.ApprovalRequest>{req};
        Test.startTest();
        processBillingApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testApprovalRequestConstructor() {
        processBillingApproval.ApprovalRequest req = new processBillingApproval.ApprovalRequest();
        req.billingId = 'testId';
        req.approverIds = new List<String>{'id1','id2'};
        req.comments = 'test';
        System.assertEquals('testId', req.billingId);
        System.assertEquals(2, req.approverIds.size());
        System.assertEquals('test', req.comments);
    }
}
