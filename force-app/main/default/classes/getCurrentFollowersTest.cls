@isTest
private class getCurrentFollowersTest {
    @isTest
    static void testReturnFollowerList() {
        // Create test user
        User u = new User(
            Alias = 'testu',
            Email = 'testuser4@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser4' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Create a test object (e.g., Account)
        Account acc = new Account(Name = 'Test Account Follower');
        insert acc;

        // Create EntitySubscription
        EntitySubscription es = new EntitySubscription(ParentId = acc.Id, SubscriberId = u.Id);
        insert es;

        // Prepare ApproverRequest
        getCurrentFollowers.ApproverRequest req = new getCurrentFollowers.ApproverRequest();
        req.caRecordId = acc.Id;
        List<getCurrentFollowers.ApproverRequest> reqList = new List<getCurrentFollowers.ApproverRequest>{req};

        Test.startTest();
        List<List<User>> result = getCurrentFollowers.returnFollowerList(reqList);
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals(1, result[0].size());
        System.assertEquals(u.Id, result[0][0].Id);
    }

    @isTest
    static void testReturnFollowerList_noFollowers() {
        Account acc = new Account(Name = 'No Follower Account');
        insert acc;
        getCurrentFollowers.ApproverRequest req = new getCurrentFollowers.ApproverRequest();
        req.caRecordId = acc.Id;
        List<getCurrentFollowers.ApproverRequest> reqList = new List<getCurrentFollowers.ApproverRequest>{req};
        Test.startTest();
        List<List<User>> result = getCurrentFollowers.returnFollowerList(reqList);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assertEquals(0, result[0].size());
    }

    @isTest
    static void testApproverRequestConstructor() {
        getCurrentFollowers.ApproverRequest req = new getCurrentFollowers.ApproverRequest();
        req.caRecordId = 'testId';
        System.assertEquals('testId', req.caRecordId);
    }
}
