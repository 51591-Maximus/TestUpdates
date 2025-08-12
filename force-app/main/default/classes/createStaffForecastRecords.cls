global class createStaffForecastRecords
{
   @InvocableMethod
    webservice static void createStaffRecords(List<CreateStaffForecasts> request)  
    {  
        
        String StaffRole = request.get(0).StaffRole;
        Integer RecordCount = request.get(0).RecordCount;
        Date EndDate = request.get(0).EndDate;
        Date IncrementDate = Date.today().toStartOfMonth();
        
        if(EndDate == null){
            EndDate = Date.newInstance(2999, 01, 01);
            }
                
        
        String PickYear = String.valueOf(IncrementDate.year());
        String PickMonth = String.valueOf(IncrementDate.month()).leftPad(2,'0');
        Integer MonthNumber = DateToInt(IncrementDate);  
        Staff_Forecast__c NSF;
        List<Staff_Forecast__c> NewStaffForecasts = New List<Staff_Forecast__c>();
        Decimal lastMonthForecast = 0;
        
        //For each month we need populated...
        for ( Integer count = 1; count<= RecordCount; count++) {
            
            //check if a Staff Forecast record exists for this Role with this Month Number
            Staff_Forecast__c[] checkMonth = [SELECT Id, Staff_Count_Forecasted_Total__c
                                              from Staff_Forecast__c
                                              WHERE Month_Number__c =: MonthNumber 
                                              AND Staff_Role__c =: StaffRole];
            if(!checkMonth.isEmpty()){                                  
            lastMonthForecast = checkMonth[0].Staff_Count_Forecasted_Total__c;
             
            }                                 
            //if no record is found then create a record for this month
            if(checkMonth.isEmpty() && IncrementDate <= EndDate){
            NSF = new Staff_Forecast__c(
                Staff_Role__c = StaffRole,
                PickYear__c = PickYear,
                PickMonth__c = PickMonth,
                Staff_Count_Forecasted_Total__c = lastMonthForecast,
                Facility_Spaces_Forecasted_Total__c=0);
                
                //add the record to the list of records to be created
                NewStaffForecasts.add(NSF); 
            }  
            
            //increment the date by adding a month, set Picklist values and Integer Month Number
            IncrementDate = IncrementDate.addMonths(1);
            PickYear = String.valueOf(IncrementDate.year());
            PickMonth = String.valueOf(IncrementDate.month()).leftPad(2,'0');
            MonthNumber = DateToInt(IncrementDate);      
               
                
        }
        Insert NewStaffForecasts;
       
    }
    
    static Integer DateToInt(Date InputDate)  
    { 
        Integer ReturnInteger = InputDate.year()*100 + InputDate.Month();
        return ReturnInteger;
        
    }
                         
    static Date IntToDate(Integer InputInteger)  
    { 
        Integer YearComponent = InputInteger/100;
        String DateString = String.valueOf(InputInteger);
        Integer MonthComponent = Integer.valueOf(DateString.right(2));
        
        Date ReturnDate = Date.newInstance(YearComponent,MonthComponent,1);
        return ReturnDate;
        
    }                    
                         
    global class CreateStaffForecasts
    {
        @InvocableVariable
        global String StaffRole;
        
        @InvocableVariable
        global Integer RecordCount;
        
        @InvocableVariable
        global Date EndDate;
    }
}