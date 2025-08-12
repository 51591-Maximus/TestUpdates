@isTest
public class ITSolutionRoleDefinitionTest {
    @isTest
    static void testInsertITSolutionRole() {
        // Ensure a record exists for insert
        IT_Solution__c itSolution = new IT_Solution__c();
        insert itSolution;

        Employee__c employee = new Employee__c(Name = 'Test Employee', Employee_ID__c = 'EMP123', Email__c = 'test@example.com');
        insert employee;

        Role_Definition__c roleDef = new Role_Definition__c(Name = 'Test Role Definition', Object__c = 'IT_Solution__c', 
            Match_Role_Text__c = 'Test Role', access__c = 'Read', Text_Name_Field__c = 'Role_Solution_Architect__c');
        insert roleDef;

        // Use related records in IT_Solution_Role__c
        IT_Solution_Role__c role = new IT_Solution_Role__c(
            IT_Solution__c = itSolution.Id,
            Employee__c = employee.Id,
            Role_Definition__c = roleDef.Id
        );
        insert role;
        System.assertNotEquals(null, role.Id, 'Record should be inserted');
    }

    @isTest
    static void testTriggerFlow() {      
        // Ensure a record exists for update/delete
        IT_Solution__c itSolution = new IT_Solution__c();
        insert itSolution;

        Employee__c employee = new Employee__c(Name = 'Test Employee', Employee_ID__c = 'EMP123', Email__c = 'test@example.com');
        insert employee;

        Role_Definition__c roleDef = new Role_Definition__c(Name = 'Test Role Definition', Object__c = 'IT_Solution__c', 
            Match_Role_Text__c = 'Test Role', access__c = 'Read', Text_Name_Field__c = 'Role_Solution_Architect__c');
        insert roleDef;

        IT_Solution_Role__c role = new IT_Solution_Role__c(
            IT_Solution__c = itSolution.Id,
            Employee__c = employee.Id,
            Role_Definition__c = roleDef.Id
        );
        insert role;
        role.Primary__c = !role.Primary__c;
        update role;
        delete role;
    }
}