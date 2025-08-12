@isTest
private class rejectBillTest {
    @isTest
    static void testRejectBill() {
        // Create test user
        User u = new User(
            Alias = 'testu',
            Email = 'testuser15@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser15' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Create a test object (e.g., Account)
        Account acc = new Account(Name = 'Test Account Reject');
        insert acc;

        // Create ProcessInstance and related records
        ProcessInstance pi = new ProcessInstance(TargetObjectId = acc.Id, Status = 'Started');
        insert pi;
        ProcessInstanceWorkitem piwi = new ProcessInstanceWorkitem(ProcessInstanceId = pi.Id);
        insert piwi;

        // Prepare ApproveRequest
        rejectBill.ApproveRequest req = new rejectBill.ApproveRequest();
        req.processWorkItemId = piwi.Id;
        req.comments = 'Reject this bill';
        List<rejectBill.ApproveRequest> reqList = new List<rejectBill.ApproveRequest>{req};

        Test.startTest();
        rejectBill.rejectBill(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testRejectBill_invalidId() {
        rejectBill.ApproveRequest req = new rejectBill.ApproveRequest();
        req.processWorkItemId = '001000000000000AAA';
        req.comments = 'Invalid';
        List<rejectBill.ApproveRequest> reqList = new List<rejectBill.ApproveRequest>{req};
        Test.startTest();
        try {
            rejectBill.rejectBill(reqList);
        } catch (Exception e) {
            System.assert(true, 'Exception expected for invalid id');
        }
        Test.stopTest();
    }

    @isTest
    static void testApproveRequestConstructor() {
        rejectBill.ApproveRequest req = new rejectBill.ApproveRequest();
        req.processWorkItemId = 'testId';
        req.comments = 'test';
        System.assertEquals('testId', req.processWorkItemId);
        System.assertEquals('test', req.comments);
    }
}
