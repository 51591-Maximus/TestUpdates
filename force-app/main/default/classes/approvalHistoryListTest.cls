@isTest
public class approvalHistoryListTest {
    @isTest
    static void testGetApprovalHistory_withData() {
        // Create test user
        User u = new User(
            Alias = 'testu',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com'
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

    // Id approvalId = result.getNewWorkitemIds()[0];
    // String approvalComment = 'Approved';
    
    // Prepare ApproveRequest
    // Approval.ProcessWorkitemRequest workItem = new Approval.ProcessWorkitemRequest();
    // workItem.setComments(approvalComment);
    // workItem.setAction('Approve');
    // workItem.setWorkitemId(approvalId);
    // Approval.ProcessResult wiResult = Approval.process(workItem);
    // System.assert(wiResult.isSuccess(), 'Approval workitem processing should succeed');

    //Test getApprovalHistory with processinstanceID
    List<ProcessInstance> processInstances = [SELECT Id FROM ProcessInstance WHERE TargetObjectId = :bill.Id];
    System.assertEquals(1, processInstances.size(), 'There should be one ProcessInstance');
    Id processInstanceId = processInstances[0].Id;

    //Get processinstanceworkitem id
    List<ProcessInstanceWorkitem> workitems = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId = :processInstanceId];
    System.assertEquals(1, workitems.size(), 'There should be one ProcessInstanceWorkitem');
    Id piwiId2 = workitems[0].Id;

    System.debug('ProcessInstance Id: ' + processInstanceId);
    //Test getApprovalHistory with processinstanceID
    List<Object> resultList2 = approvalHistoryList.getApprovalHistory(piwiId2);
    System.assertNotEquals(null, resultList2);

    }

    @isTest
    static void testGetApprovalHistory_noData() {
        Test.startTest();
        List<Object> result = approvalHistoryList.getApprovalHistory('001000000000000AAA');
        Test.stopTest();
        System.assertEquals(null, result);
    }

    @isTest
    static void testGetProcessHistory() {
        Account acc = new Account(Name = 'Test Account 2');
        insert acc;
        // ProcessInstance pi = new ProcessInstance(TargetObjectId = acc.Id, Status = 'Started');
        // insert pi;
        Test.startTest();
        Map<Id, ProcessInstance> result = approvalHistoryList.getProcessHistory(acc.Id);
        Test.stopTest();
        System.assert(result != null);
    }

    @isTest
    static void testApprovalHistoryConstructor() {
        DateTime dt = System.now();
        approvalHistoryList.ApprovalHistory ah = new approvalHistoryList.ApprovalHistory(dt, 'Approved', 'Actor', 'Original', 'Comment');
        System.assertEquals('Approved', ah.status);
        System.assertEquals('Actor', ah.actualApprover);
        System.assertEquals('Original', ah.assignedTo);
        System.assertEquals('Comment', ah.comments);
    }
}
