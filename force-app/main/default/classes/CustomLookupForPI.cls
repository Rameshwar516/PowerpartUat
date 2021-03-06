public class CustomLookupForPI {
    
    @AuraEnabled
    public static List <sObject> searchLookupValue(string queryText, String objectName, string wareHouse) {
        
        system.debug('queryText --- ' + queryText +'Object Name --- '+objectName +'wareHouse ---'+wareHouse);        
        String searchKey = queryText + '%';
        String sQuery = '';
		String strFields = '';
        if(String.isNotBlank(objectName)){
            if(objectName == 'Part__c')
                strFields = 'Id, Name,Part_Name__c,Usage__c,HSN_CODE__c,List_Price_Standard_price__c,UOM__c,UOI__c,(select id, Total_Quantity__c, Ware_House__c from Stocks__r where Ware_House__c =: wareHouse)';
            else if(objectName == 'User')
                strFields = 'Id, Name';
            else if(objectName == 'Sales_Order__c')
				strFields = 'Id, Name, Bill_To__c, SOA_No__c, Sales_Order_Acknowledge_Number__c';
            else if(objectName == 'Purchase_Indent__c')
				strFields = 'Id, Name, Purchase_Indent_Number__c, Reference_No__c';
            else if(objectName == 'Ware_House__c')
                strFields = 'Id, Name, State_Code__c ';
            else 
                strFields = 'Id, Name';
        }
        if(queryText == null || queryText == ''){
            if(String.isNotBlank(wareHouse) && (objectName == 'Sales_Order__c' || objectName == 'Purchase_Indent__c'))
                sQuery = 'select '+strFields+' from ' +objectName + ' where Ware_House__c =: wareHouse order by LastViewedDate DESC limit 5';
            else if(objectName == 'Account')
                sQuery = 'select '+strFields+' ,RecordType.Name, Billing_State_Code__c, Shipping_State_Code__c from ' +objectName + ' where RecordType.Name = \'Supplier\' order by LastViewedDate DESC limit 5';
            else    
                sQuery = 'select '+strFields+' from ' +objectName + ' order by LastViewedDate DESC limit 5';
        }
        else {
            if(String.isNotBlank(wareHouse) && objectName == 'Sales_Order__c')
                sQuery = 'select '+strFields+' from ' +objectName + ' where Ware_House__c =: wareHouse AND Sales_Order_Acknowledge_Number__c LIKE: searchKey order by LastViewedDate DESC limit 5';
            else if(String.isNotBlank(wareHouse) && objectName == 'Purchase_Indent__c')
                sQuery = 'select '+strFields+' from ' +objectName + ' where Ware_House__c =: wareHouse AND Purchase_Indent_Number__c LIKE: searchKey order by LastViewedDate DESC limit 5';
            else if(objectName == 'Account')
                sQuery = 'select '+strFields+' ,RecordType.Name, Billing_State_Code__c, Shipping_State_Code__c from ' +objectName + ' where RecordType.Name = \'Supplier\' AND Name LIKE: searchKey order by LastViewedDate DESC limit 5';
            else   
                sQuery = 'select '+strFields+' from ' +objectName + ' where Name LIKE: searchKey order by LastViewedDate DESC limit 5';
        }       
            
        System.debug(sQuery);
        List <sObject> lstOfRecords = Database.query(sQuery);
        
        /*if(sQuery != null && sQuery != ''){
            List < Part__c > lstOfRecords = Database.query(sQuery);
            if(lstOfRecords.size() > 0){
                for (Part__c obj: lstOfRecords) {
                    returnList.add(obj);
                }
            }
        }*/
        
        return lstOfRecords;
    }
}