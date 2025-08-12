@isTest
private class MaximusProjectSharingTest {
    
    @testSetup static void setup() {
        // Create common test accounts
        List<Maximus_Project__c> MP = new List<Maximus_Project__c>();
        for(Integer i=0;i<2;i++) {
            MP.add(new Maximus_Project__c(Name = 'TestSWP'+i));
        }
        insert MP;
        
    }    
    
    
    // test method 1
    @isTest static void createProjectRep() {
        
        // select maximus project
        Maximus_Project__c MP = [select Id, Name from Maximus_Project__c where Name =: 'TestSWP0' LIMIT 1];    
        
        //select user
        User userTest = new User(
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
        insert userTest;

        
        // create new project rep record
        Project_Rep__c rep = new Project_Rep__c();
        // populate fields
        rep.Maximus_Project__c = MP.Id;    
        rep.User__c = userTest.Id;                
        rep.Project_Role__c = 'Staffing Rep';
        
        insert rep;
        
        
    }

    // test method 2
    @isTest static void InactiveProjectRep() {     
    
        Maximus_Project__c MP = [select Id, Name from Maximus_Project__c where Name =: 'TestSWP0' LIMIT 1];  
        
        User userTest = new User(
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
        insert userTest;
      
        Project_Rep__c rep = new Project_Rep__c();
        rep.Maximus_Project__c = MP.Id;    
        rep.User__c = userTest.Id;               
        rep.Project_Role__c = 'Staffing Rep';
        rep.Active__c = False;
             
        insert rep;
        
    }  

    // test method 3 
    @isTest static void updateProjectRep() {
        
        Maximus_Project__c MP = [select Id, Name from Maximus_Project__c where Name =: 'TestSWP0' LIMIT 1];    

        User userTest = new User(
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
        insert userTest;

        
        Project_Rep__c rep = new Project_Rep__c();        
        rep.Maximus_Project__c = MP.Id;    
        rep.User__c = userTest.Id;               
        rep.Project_Role__c = 'Staffing Rep';
        rep.Active__c = False;             
        insert rep;
        
        String str1 = MP.Id;
        String str2 = userTest.Id;
     
        
        Project_Rep__c reps = [SELECT Id, Maximus_Project__c, User__c, Active__c FROM Project_Rep__c WHERE Active__c =: FALSE AND Maximus_Project__c =: str1 AND User__c =: str2 LIMIT 1];
        reps.Active__c = TRUE;

        update reps;     
        
        }                                            
          
    // test method 4
    @isTest static void deleteProjectRep() {
        
        Maximus_Project__c MP = [select Id, Name from Maximus_Project__c where Name =: 'TestSWP0' LIMIT 1];     
        
        User userTest = new User(
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
        insert userTest;

        
        // create new project rep record
        Project_Rep__c rep = new Project_Rep__c();
        // populate fields
        rep.Maximus_Project__c = MP.Id;    
        rep.User__c = userTest.Id;                
        rep.Project_Role__c = 'Staffing Rep';
        
        insert rep;
        
        Project_Rep__c reps = [SELECT Id, Maximus_Project__c, User__c FROM Project_Rep__c WHERE Maximus_Project__c =: rep.Maximus_Project__c  AND User__c =: rep.User__c AND Project_Role__c =: rep.Project_Role__c LIMIT 1];

        delete reps;

                      
    }    
        
}