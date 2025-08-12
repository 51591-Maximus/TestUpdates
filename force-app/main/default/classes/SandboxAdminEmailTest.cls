@isTest
private class SandboxAdminEmailTest {
    @isTest
    static void testRunApexClass() {
        // Create a test user with System Administrator profile
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(
            Alias = 'testadm',
            Email = 'testadm@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = sysAdminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testadm' + System.currentTimeMillis() + '@example.com',
            IsActive = true
        );
        insert u;

        // Create a mock SandboxContext
        Test.startTest();
        SandboxAdminEmail.SandboxContext context = (SandboxAdminEmail.SandboxContext)Test.createStub(SandboxAdminEmail.SandboxContext.class, new Map<String, Object>());
        SandboxAdminEmail cls = new SandboxAdminEmail();
        cls.runApexClass(context);
        Test.stopTest();
        // Query user to check email was updated
        User updated = [SELECT Email FROM User WHERE Id = :u.Id];
        System.assert(!updated.Email.contains('@example.com'), 'Email should be updated');
    }
}
