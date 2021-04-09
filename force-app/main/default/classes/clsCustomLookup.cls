public class clsCustomLookup {

    @AuraEnabled
    public static List < Part__c > searchLookupValue(string queryText, String objectName) {
        system.debug('----queryText--- ' + queryText);
        
        String searchKey = queryText + '%';
        String sQuery = '';
        
        List < Part__c > returnList = new List < Part__c > ();
        
        if(queryText == null || queryText == '')
            sQuery = 'select Id, Name,Part_Name__c  from ' +objectName + ' order by LastViewedDate DESC limit 5';
        else        
            sQuery = 'select Id, Name,Part_Name__c from ' +objectName + ' where Name LIKE: searchKey order by LastViewedDate DESC limit 5';
        
        
        if(sQuery != null && sQuery != ''){
            List < Part__c > lstOfRecords = Database.query(sQuery);
            if(lstOfRecords.size() > 0){
                for (Part__c obj: lstOfRecords) {
                    returnList.add(obj);
                }
            }
        }
        
        return returnList;
    }
    
}