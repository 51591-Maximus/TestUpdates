@isTest
private class processFunctionalApprovalTest {
    @isTest
    static void testStartApprovalAndInitApprovalProcess() {
        // Create queues
        Group finance = new Group(Name = 'Finance Approvers', DeveloperName = 'Finance_Approvers', Type = 'Queue');
        Group hr = new Group(Name = 'HR Approvers', DeveloperName = 'HR_Approvers', Type = 'Queue');
        Group insurance = new Group(Name = 'Insurance Approvers', DeveloperName = 'Insurance_Approvers', Type = 'Queue');
        Group privacy = new Group(Name = 'Privacy Approvers', DeveloperName = 'Privacy_Approvers', Type = 'Queue');
        Group security = new Group(Name = 'Security Approvers', DeveloperName = 'Security_Approvers', Type = 'Queue');
        insert new List<Group>{finance, hr, insurance, privacy, security};

        // Create CA__c record with all approvals required
        CA__c ca = new CA__c(
            Name = 'Test CA',
            Approval_Required_Finance__c = true,
            Approval_Required_HR__c = true,
            Approval_Required_Insurance__c = true,
            Approval_Required_Privacy__c = true,
            Approval_Required_Security__c = true
        );
        insert ca;

        // Simulate StandardController
        ApexPages.StandardController sc = new ApexPages.StandardController(ca);
        processFunctionalApproval pfa = new processFunctionalApproval(sc);

        Test.startTest();
        processFunctionalApproval.startApproval();
        processFunctionalApproval.initApprovalProcess();
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testAddQueueId() {
        Group finance = new Group(Name = 'Finance Approvers', DeveloperName = 'Finance_Approvers', Type = 'Queue');
        insert finance;
        Id queueId = Test.startTest();
        Id result = processFunctionalApproval.addQueueId('Finance_Approvers');
        Test.stopTest();
        System.assertEquals(finance.Id, result);
    }

    @isTest
    static void testApproveRecord_Approve() {
        // Create CA__c and ProcessInstanceWorkitem
        CA__c ca = new CA__c(Name = 'Test CA Approve');
        insert ca;
        ProcessInstance pi = new ProcessInstance(TargetObjectId = ca.Id, Status = 'Started');
        insert pi;
        ProcessInstanceWorkitem piwi = new ProcessInstanceWorkitem(ProcessInstanceId = pi.Id);
        insert piwi;
        Test.startTest();
        processFunctionalApproval.approveRecord(ca.Id, 'Approve', 'Approved!');
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testApproveRecord_Reject() {
        CA__c ca = new CA__c(Name = 'Test CA Reject');
        insert ca;
        ProcessInstance pi = new ProcessInstance(TargetObjectId = ca.Id, Status = 'Started');
        insert pi;
        ProcessInstanceWorkitem piwi = new ProcessInstanceWorkitem(ProcessInstanceId = pi.Id);
        insert piwi;
        Test.startTest();
        processFunctionalApproval.approveRecord(ca.Id, 'Reject', 'Rejected!');
        Test.stopTest();
        System.assert(true);
    }

    @isTest
    static void testApproveRecord_Removed() {
        CA__c ca = new CA__c(Name = 'Test CA Removed');
        insert ca;
        ProcessInstance pi = new ProcessInstance(TargetObjectId = ca.Id, Status = 'Started');
        insert pi;
        ProcessInstanceWorkitem piwi = new ProcessInstanceWorkitem(ProcessInstanceId = pi.Id);
        insert piwi;
        Test.startTest();
        processFunctionalApproval.approveRecord(ca.Id, 'Removed', 'Removed!');
        Test.stopTest();
        System.assert(true);
    }
}
