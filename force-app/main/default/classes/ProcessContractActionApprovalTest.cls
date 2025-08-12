@isTest
private class ProcessContractActionApprovalTest {
    @isTest
    static void testCreateContractActionApprovals_Functional() {
        // Create a test user to act as an approver
        User u = new User(
            Alias = 'testu',
            Email = 'testuser10@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser10' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Create a test CA__c record
        CA__c ca = new CA__c(Name = 'Test CA Functional');
        insert ca;

        // Prepare ApprovalRequest for Functional
        ProcessContractActionApproval.ApprovalRequest req = new ProcessContractActionApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.queueIds = new List<String>{u.Id};
        req.approvalType = 'Functional';
        List<ProcessContractActionApproval.ApprovalRequest> reqList = new List<ProcessContractActionApproval.ApprovalRequest>{req};

        Test.startTest();
        ProcessContractActionApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        // Check CA__c updated
        CA__c updated = [SELECT Status__c, Approval_Count__c, Approval_Type__c FROM CA__c WHERE Id = :ca.Id];
        System.assertEquals('Functional Review', updated.Status__c);
        System.assertEquals(1, updated.Approval_Count__c);
        System.assertEquals('Functional', updated.Approval_Type__c);
    }

    @isTest
    static void testCreateContractActionApprovals_AuthorityMatrix() {
        User u = new User(
            Alias = 'testu',
            Email = 'testuser11@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser11' + System.currentTimeMillis() + '@example.com'
        );
        insert u;
        CA__c ca = new CA__c(Name = 'Test CA Authority');
        insert ca;
        ProcessContractActionApproval.ApprovalRequest req = new ProcessContractActionApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.queueIds = new List<String>{u.Id};
        req.approvalType = 'Authority Matrix';
        List<ProcessContractActionApproval.ApprovalRequest> reqList = new List<ProcessContractActionApproval.ApprovalRequest>{req};
        Test.startTest();
        ProcessContractActionApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        CA__c updated = [SELECT Status__c, Approval_Count__c, Approval_Type__c FROM CA__c WHERE Id = :ca.Id];
        System.assertEquals('Authority Matrix Review', updated.Status__c);
        System.assertEquals(1, updated.Approval_Count__c);
        System.assertEquals('Authority Matrix', updated.Approval_Type__c);
    }

    @isTest
    static void testCreateContractActionApprovals_AwaitingSignature() {
        User u = new User(
            Alias = 'testu',
            Email = 'testuser12@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser12' + System.currentTimeMillis() + '@example.com'
        );
        insert u;
        CA__c ca = new CA__c(Name = 'Test CA Awaiting');
        insert ca;
        ProcessContractActionApproval.ApprovalRequest req = new ProcessContractActionApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.queueIds = new List<String>{u.Id};
        req.approvalType = 'Awaiting Signature';
        List<ProcessContractActionApproval.ApprovalRequest> reqList = new List<ProcessContractActionApproval.ApprovalRequest>{req};
        Test.startTest();
        ProcessContractActionApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        CA__c updated = [SELECT Status__c, Approval_Count__c, Approval_Type__c FROM CA__c WHERE Id = :ca.Id];
        System.assertEquals('Authority Matrix Review', updated.Status__c);
        System.assertEquals(1, updated.Approval_Count__c);
        System.assertEquals('Awaiting Signature', updated.Approval_Type__c);
    }

    @isTest
    static void testCreateContractActionApprovals_OtherType() {
        User u = new User(
            Alias = 'testu',
            Email = 'testuser13@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser13' + System.currentTimeMillis() + '@example.com'
        );
        insert u;
        CA__c ca = new CA__c(Name = 'Test CA Other');
        insert ca;
        ProcessContractActionApproval.ApprovalRequest req = new ProcessContractActionApproval.ApprovalRequest();
        req.contractActionId = ca.Id;
        req.queueIds = new List<String>{u.Id};
        req.approvalType = 'Other';
        List<ProcessContractActionApproval.ApprovalRequest> reqList = new List<ProcessContractActionApproval.ApprovalRequest>{req};
        Test.startTest();
        ProcessContractActionApproval.createContractActionApprovals(reqList);
        Test.stopTest();
        // Should not update CA__c for other type
        CA__c updated = [SELECT Status__c, Approval_Count__c, Approval_Type__c FROM CA__c WHERE Id = :ca.Id];
        System.assertEquals(null, updated.Status__c);
        System.assertEquals(null, updated.Approval_Count__c);
        System.assertEquals(null, updated.Approval_Type__c);
    }

    @isTest
    static void testApprovalRequestConstructor() {
        ProcessContractActionApproval.ApprovalRequest req = new ProcessContractActionApproval.ApprovalRequest();
        req.contractActionId = 'testId';
        req.queueIds = new List<String>{'id1','id2'};
        req.approvalType = 'Functional';
        System.assertEquals('testId', req.contractActionId);
        System.assertEquals(2, req.queueIds.size());
        System.assertEquals('Functional', req.approvalType);
    }
}
