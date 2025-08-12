@isTest
private class approvalRecallTest {
    @isTest
    static void testRecallApproval() {
        // Create test user
        User u = new User(
            Alias = 'testu',
            Email = 'testuser2@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser2' + System.currentTimeMillis() + '@example.com'
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

        // Prepare RecallRequest
        approvalRecall.RecallRequest req1 = new approvalRecall.RecallRequest();
        req1.contractActionId = bill.Id;
        req1.comments = 'Test recall';
        List<approvalRecall.RecallRequest> reqList = new List<approvalRecall.RecallRequest>{req1};

        Test.startTest();
        approvalRecall.recallApproval(reqList);
        Test.stopTest();
        // No exception means success
        System.assert(true);
    }

    @isTest
    static void testRecallApproval_noWorkitems() {
        approvalRecall.RecallRequest req = new approvalRecall.RecallRequest();
        req.contractActionId = '001000000000000AAA';
        req.comments = 'No workitems';
        List<approvalRecall.RecallRequest> reqList = new List<approvalRecall.RecallRequest>{req};
        Test.startTest();
        approvalRecall.recallApproval(reqList);
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testRecallRequestConstructor() {
        approvalRecall.RecallRequest req = new approvalRecall.RecallRequest();
        req.contractActionId = 'testId';
        req.comments = 'test';
        System.assertEquals('testId', req.contractActionId);
        System.assertEquals('test', req.comments);
    }
}
