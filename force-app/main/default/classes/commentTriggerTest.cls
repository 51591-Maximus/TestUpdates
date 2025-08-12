@isTest
public class commentTriggerTest {

    static testMethod void commentTriggersTest(){
        CA__C testCA = new CA__C();
        List<RecordType> recTypeId = [SELECT Id FROM RecordType where Name = 'Other'];
        testCA.RecordTypeId = recTypeId.get(0).Id;
        testCA.Subject__c = 'Test';
        date testDate = date.newInstance(2023, 1, 1);
        testCA.CA_Needed_By_Date__c = testDate;
        testCA.Agreement_Type__c = 'Other';
        testCA.Contracting_Entity__c = 'MAXIMUS, Inc.';
        testCA.Jurisdiction__c = 'Illinois';
        testCA.Key_Action_Detail__c = 'Test';
        testCA.Urgency_Comment__c = 'Test';
        testCA.BusinessArea__c = 'USS: Central';
        testCA.Contract_Paper__c = 'Maximus';
        Account acc = new Account(name='Test Account');
        insert acc;
        testCA.Account__c = acc.Id;
        insert testCA;
        
        Contract_Action_Comments__c comment = new Contract_Action_Comments__c();
        comment.Contract_Action__c = testCA.Id;
        comment.Comment__c = 'Test Comment';
        comment.Subject__c = 'Test Subject';
        
        Test.startTest();
        insert comment;
        Test.stopTest();
    }
}