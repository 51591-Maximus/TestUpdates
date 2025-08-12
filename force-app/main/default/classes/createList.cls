global class createList
{
   @InvocableMethod
    webservice static List<List<Integer>> createList (List<thingsList> request)   
    {   
      
                   List<Integer> things = new List<Integer>();
                   Integer RecordCount = request.get(0).RecordCount;
                   
                        for ( Integer count = 1; count<= RecordCount; count++) {
                           
                         things.add(count);  
                           
                       }
                                
        
        
        List<List<Integer>> results = new List<List<Integer>>();
        results.add(things);
        
        return results;
    }
    
    global class thingsList
    {
        @InvocableVariable
        global integer RecordCount;
    }
}