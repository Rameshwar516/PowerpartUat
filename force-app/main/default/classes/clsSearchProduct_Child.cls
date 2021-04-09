public with sharing class clsSearchProduct_Child 
{   
    @AuraEnabled
    public static SObject[] getSearchProduct(string objectName, string queryText,list<Part__c> DigValue)
    {
        System.debug('list '+DigValue);
        try
        {
            string filter = '';
            set<Id> setProductId = new set<Id>(); 
            if(queryText != null && queryText.trim() !='')
                filter = ' \''+ string.escapeSingleQuotes(queryText) + '%\'';
            map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
            Schema.sObjectType sObjType = globalDescription.get(objectName);
            Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
            List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
            
            for(Part__c prdObj :  [select id, name, List_Price_Standard_price__c, Product_Family__c from Part__c limit 10])
            {
                setProductId.add(prdObj.id);
            }
            System.debug('setProductId---- '+setProductId);
            /* Adding the object and filter by name to the soql */
            string soql = 'select ' + string.join(leadfieldNames, ',') +' from ' + objectName ; 
            system.debug('......'+soql);
            if(filter.trim() != '')     
                soql += ' where id IN: setProductId and ( name Like ' + filter + ' or Part_Name__c LIKE ' + filter + ')';
            system.debug('====='+soql);
            soql += 'order by Name limit 10';
            return Database.query(soql);
        }
        catch(Exception ex)
        {
            system.debug('Exception---- '+ex.getMessage());
            return null;
        }
    }
    
}