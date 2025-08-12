@isTest
private class getQueueMembersTest {
    @isTest
    static void testReturnQueueMembers() {
        // Create test user
        User u = new User(
            Alias = 'testu',
            Email = 'testuser5@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser5' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        // Create a test queue (Group)
        Group queue = new Group(Name = 'TestQueue', DeveloperName = 'TestQueue', Type = 'Queue');
        insert queue;
        // Add user to queue
        GroupMember gm = new GroupMember(GroupId = queue.Id, UserOrGroupId = u.Id);
        insert gm;

        // Prepare QueueRequest
        getQueueMembers.QueueRequest req = new getQueueMembers.QueueRequest();
        req.queueName = 'TestQueue';
        List<getQueueMembers.QueueRequest> reqList = new List<getQueueMembers.QueueRequest>{req};

        Test.startTest();
        List<List<User>> result = getQueueMembers.returnQueueMembers(reqList);
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals(1, result[0].size());
        System.assertEquals(u.Id, result[0][0].Id);
    }

    @isTest
    static void testReturnQueueMembers_noMembers() {
        Group queue = new Group(Name = 'EmptyQueue', DeveloperName = 'EmptyQueue', Type = 'Queue');
        insert queue;
        getQueueMembers.QueueRequest req = new getQueueMembers.QueueRequest();
        req.queueName = 'EmptyQueue';
        List<getQueueMembers.QueueRequest> reqList = new List<getQueueMembers.QueueRequest>{req};
        Test.startTest();
        List<List<User>> result = getQueueMembers.returnQueueMembers(reqList);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assertEquals(0, result[0].size());
    }

    @isTest
    static void testQueueRequestConstructor() {
        getQueueMembers.QueueRequest req = new getQueueMembers.QueueRequest();
        req.queueName = 'Q';
        System.assertEquals('Q', req.queueName);
    }
}
