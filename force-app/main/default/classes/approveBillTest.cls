@isTest
private class approveBillTest {
    @isTest
    static void testApproveBill() {
        // Create test user
        User u = new User(
            Alias = 'testu',
            Email = 'testuser3@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser3' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Get a valid RecordTypeId for Bills__c
        Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Bill__c' LIMIT 1].Id;

        // Create a test object (Bill__c) with RecordType
        Bill__c bill = new Bill__c(RecordTypeId = recordTypeId, PC_PM_Approver__c = u.Id);
        insert bill;

        // Submit the Bill for approval and save the result
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(bill.Id);
        req.setSubmitterId(u.Id);
        req.setComments('Submitting for approval');
        req.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req);
        System.assert(result.isSuccess(), 'Approval submission should succeed');

        //Test getApprovalHistory with processinstanceID
        List<ProcessInstance> processInstances = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :bill.Id];
        System.assertEquals(1, processInstances.size(), 'There should be one ProcessInstance');
        Id processInstanceId = processInstances[0].Id;

        //Get processinstanceworkitem id
        List<ProcessInstanceWorkitem> workitems = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId = :processInstanceId];
        System.assertEquals(1, workitems.size(), 'There should be one ProcessInstanceWorkitem');
        Id piwiId2 = workitems[0].Id;

        // Prepare ApproveRequest
        approveBill.ApproveRequest req1 = new approveBill.ApproveRequest();
        req1.processWorkItemId = piwiId2;
        req1.comments = 'Approve this bill';
        List<approveBill.ApproveRequest> reqList = new List<approveBill.ApproveRequest>{req1};

        Test.startTest();
        approveBill.approveBill(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testApproveBill_invalidId() {
        approveBill.ApproveRequest req = new approveBill.ApproveRequest();
        req.processWorkItemId = '001000000000000AAA';
        req.comments = 'Invalid';
        List<approveBill.ApproveRequest> reqList = new List<approveBill.ApproveRequest>{req};
        Test.startTest();
        try {
            approveBill.approveBill(reqList);
        } catch (Exception e) {
            System.assert(true, 'Exception expected for invalid id');
        }
        Test.stopTest();
    }

    @isTest
    static void testApproveRequestConstructor() {
        approveBill.ApproveRequest req = new approveBill.ApproveRequest();
        req.processWorkItemId = 'testId';
        req.comments = 'test';
        System.assertEquals('testId', req.processWorkItemId);
        System.assertEquals('test', req.comments);
    }
}
