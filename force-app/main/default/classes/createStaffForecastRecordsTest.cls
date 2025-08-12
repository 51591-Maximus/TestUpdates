@isTest
private class createStaffForecastRecordsTest {
    @isTest
    static void testCreateStaffRecords() {
        // Create a test Staff Role value
        String staffRole = 'TestRole';
        // Ensure no Staff_Forecast__c records exist for this role/month
        // Integer monthNumber = createStaffForecastRecords.DateToInt(Date.today().toStartOfMonth());
        // List<Staff_Forecast__c> toDelete = [SELECT Id FROM Staff_Forecast__c WHERE Staff_Role__c = :staffRole AND Month_Number__c = :monthNumber];
        // if (!toDelete.isEmpty()) {
        //     delete toDelete;
        // }
        // Prepare request
        createStaffForecastRecords.CreateStaffForecasts req = new createStaffForecastRecords.CreateStaffForecasts();
        req.StaffRole = staffRole;
        req.RecordCount = 2;
        req.EndDate = Date.today().addMonths(1);
        List<createStaffForecastRecords.CreateStaffForecasts> reqList = new List<createStaffForecastRecords.CreateStaffForecasts>{req};
        Test.startTest();
        createStaffForecastRecords.createStaffRecords(reqList);
        Test.stopTest();
        // Assert records created
        List<Staff_Forecast__c> created = [SELECT Id FROM Staff_Forecast__c WHERE Staff_Role__c = :staffRole];
        System.assert(created.size() >= 1);
    }

    @isTest
    static void testCreateStaffRecords_existingRecord() {
        String staffRole = 'TestRole2';
        // Integer monthNumber = createStaffForecastRecords.DateToInt(Date.today().toStartOfMonth());
        Staff_Forecast__c existing = new Staff_Forecast__c(Staff_Role__c = staffRole, Staff_Count_Forecasted_Total__c = 5, Facility_Spaces_Forecasted_Total__c = 0);
        insert existing;
        createStaffForecastRecords.CreateStaffForecasts req = new createStaffForecastRecords.CreateStaffForecasts();
        req.StaffRole = staffRole;
        req.RecordCount = 1;
        req.EndDate = Date.today();
        List<createStaffForecastRecords.CreateStaffForecasts> reqList = new List<createStaffForecastRecords.CreateStaffForecasts>{req};
        Test.startTest();
        createStaffForecastRecords.createStaffRecords(reqList);
        Test.stopTest();
        // Should not create duplicate for same month/role
        List<Staff_Forecast__c> found = [SELECT Id FROM Staff_Forecast__c WHERE Staff_Role__c = :staffRole];
        System.assertEquals(1, found.size());
    }

    @isTest
    static void testCreateStaffRecords_nullEndDate() {
        String staffRole = 'TestRole3';
        createStaffForecastRecords.CreateStaffForecasts req = new createStaffForecastRecords.CreateStaffForecasts();
        req.StaffRole = staffRole;
        req.RecordCount = 1;
        req.EndDate = null;
        List<createStaffForecastRecords.CreateStaffForecasts> reqList = new List<createStaffForecastRecords.CreateStaffForecasts>{req};
        Test.startTest();
        createStaffForecastRecords.createStaffRecords(reqList);
        Test.stopTest();
        List<Staff_Forecast__c> created = [SELECT Id FROM Staff_Forecast__c WHERE Staff_Role__c = :staffRole];
        System.assert(created.size() >= 1);
    }

    // @isTest
    // static void testDateToIntAndIntToDate() {
    //     Date d = Date.newInstance(2025, 8, 1);
    //     Integer i = createStaffForecastRecords.DateToInt(d);
    //     System.assertEquals(202508, i);
    //     Date d2 = createStaffForecastRecords.IntToDate(i);
    //     System.assertEquals(d, d2);
    // }

    @isTest
    static void testCreateStaffForecastsConstructor() {
        createStaffForecastRecords.CreateStaffForecasts req = new createStaffForecastRecords.CreateStaffForecasts();
        req.StaffRole = 'Role';
        req.RecordCount = 2;
        req.EndDate = Date.today();
        System.assertEquals('Role', req.StaffRole);
        System.assertEquals(2, req.RecordCount);
        System.assertEquals(Date.today(), req.EndDate);
    }
}
