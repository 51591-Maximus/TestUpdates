@isTest
private class createListTest {
    @isTest
    static void testCreateList() {
        createList.thingsList req = new createList.thingsList();
        req.RecordCount = 5;
        List<createList.thingsList> reqList = new List<createList.thingsList>{req};
        Test.startTest();
        List<List<Integer>> result = createList.createList(reqList);
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals(5, result[0].size());
        System.assertEquals(1, result[0][0]);
        System.assertEquals(5, result[0][4]);
    }

    @isTest
    static void testCreateList_zeroCount() {
        createList.thingsList req = new createList.thingsList();
        req.RecordCount = 0;
        List<createList.thingsList> reqList = new List<createList.thingsList>{req};
        Test.startTest();
        List<List<Integer>> result = createList.createList(reqList);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assertEquals(0, result[0].size());
    }

    @isTest
    static void testThingsListConstructor() {
        createList.thingsList req = new createList.thingsList();
        req.RecordCount = 3;
        System.assertEquals(3, req.RecordCount);
    }
}
