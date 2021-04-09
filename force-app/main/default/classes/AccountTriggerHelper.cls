/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          18-Oct-2019                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
public class AccountTriggerHelper
{
    public static void accountTriggerExecute(list<Account> triggerNew,Map<Id,Account> triggerNewMap,list<Account> triggerOld,Map<Id,Account> triggeroldMap,boolean isAfter,boolean isBefore,boolean isInsert,boolean isUpdate,boolean isDelete)
    {
        //Call Methods
        if(isinsert && isBefore)
        {
            generateAccountNumber(triggerNew);
        }
       // if(isBefore && isUpdate)
         //   UpdateAccountNameWithRegion(triggerNew,triggeroldMap);
    }
    static void generateAccountNumber(list<Account> TriggerNew)
    {
        list<Account> lstAccount = new list<Account>();
        Generating_Account_Number__c accountNumber = Generating_Account_Number__c.getValues('Unique Number');
        integer intCountAccountNumber = integer.valueof(accountNumber.Unique_Number__c);
        for(Account objAcc : TriggerNew)
        {
            string strNameWithCityAndRegion = '';
            strNameWithCityAndRegion= objAcc.Name;
            if(objAcc.BillingCity != '' && objAcc.BillingCity != null)
                strNameWithCityAndRegion = strNameWithCityAndRegion+'-'+objAcc.BillingCity;
            if(objAcc.Region__c  != '' && objAcc.Region__c != null)
                strNameWithCityAndRegion = strNameWithCityAndRegion+'-'+objAcc.Region__c;
            
            objAcc.Company_With_Region__c = strNameWithCityAndRegion;
            
            if(!objAcc.Is_Upload_From_Excel__c)
            {
                if(objAcc.Type!= null)
                {
                    if(Schema.SObjectType.Account.getRecordTypeInfosByName().get(objAcc.Type).getRecordTypeId() != null){
                        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(objAcc.Type).getRecordTypeId();
                        objAcc.RecordTypeId = recTypeId;
                    }
                    else{
                        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('OEM\'s Customer').getRecordTypeId();
                        objAcc.RecordTypeId = recTypeId;
                    }
                }
                intCountAccountNumber++;
                objAcc.Account_Number__c = intCountAccountNumber;
            }
        }
        if(intCountAccountNumber > 0)
        {
            accountNumber.Unique_Number__c = intCountAccountNumber;
            update accountNumber;
        }
    }
    
   /* static void UpdateAccountNameWithRegion(list<Account> TriggerNew,Map<Id,Account> triggeroldMap)
    {
        for(Account objAcc : TriggerNew)
        {
            string strNameWithCityAndRegion = '';
            strNameWithCityAndRegion= objAcc.Name;
            if(objAcc.BillingCity != '' && objAcc.BillingCity != null)
                strNameWithCityAndRegion = strNameWithCityAndRegion+'-'+objAcc.BillingCity;
            if(objAcc.Region__c  != '' && objAcc.Region__c != null)
                strNameWithCityAndRegion = strNameWithCityAndRegion+'-'+objAcc.Region__c;
            
            objAcc.Company_With_Region__c = strNameWithCityAndRegion;
        }
    }*/
}