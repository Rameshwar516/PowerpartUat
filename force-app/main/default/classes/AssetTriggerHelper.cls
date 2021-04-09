/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          18-Oct-2019                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
public class AssetTriggerHelper
{
    public static void assetTriggerExecute(list<Asset__c> triggerNew,Map<Id,Asset__c> triggerNewMap,list<Asset__c> triggerOld,Map<Id,Asset__c> triggeroldMap,boolean isAfter,boolean isBefore,boolean isInsert,boolean isUpdate,boolean isDelete)
    {
        //Call Methods
        if(isinsert && isBefore)
        {
            assetOEMCustomerAssignment(triggerNew);
        }
        if(isupdate && isbefore)
        {
            assetOEMCustomerAssignmentOnUpdate(triggerNew,triggeroldMap);
        }
    }
    static void assetOEMCustomerAssignment(list<Asset__c> triggerNew)
    {
        set<integer> setOfAccountNumber = new set<integer>();
        for(Asset__c objAssets : triggerNew)
        {
            if(objAssets.Account_Number__c != null && objAssets.Account_Number__c >0)
            {
                setOfAccountNumber.add(integer.valueof(objAssets.Account_Number__c));
            }
        }
        list<Account> lstAcc = new list<Account>();
        if(setOfAccountNumber.size() > 0)
        {
            map<Integer, Account> mapAccountNumberRespectedId = new map<Integer, Account>();
            for(Account objAcc : [Select Id, Name, Account_Number__c,Type from Account where Account_Number__c IN: setOfAccountNumber])
            {
                mapAccountNumberRespectedId.put(integer.valueof(objAcc.Account_Number__c),objAcc);
            }
            
            if(mapAccountNumberRespectedId.size()>0)
            {
                for(Asset__c objAsset : triggerNew)
                {
                    system.debug('...mapAccountNumberRespectedId.get(integer.valueof(objAsset.Account_Number__c))...'+mapAccountNumberRespectedId.get(integer.valueof(objAsset.Account_Number__c)));
                    if(mapAccountNumberRespectedId.containskey(integer.valueof(objAsset.Account_Number__c)) && mapAccountNumberRespectedId.get(integer.valueof(objAsset.Account_Number__c)) != null  && mapAccountNumberRespectedId.get(integer.valueof(objAsset.Account_Number__c)).Type != 'Customer')
                    {
                        objAsset.OEM__c = mapAccountNumberRespectedId.get(integer.valueof(objAsset.Account_Number__c)).Id;
                    }   
                    else if(mapAccountNumberRespectedId.containskey(integer.valueof(objAsset.Account_Number__c)) && mapAccountNumberRespectedId.get(integer.valueof(objAsset.Account_Number__c)) != null && mapAccountNumberRespectedId.get(integer.valueof(objAsset.Account_Number__c)).Type == 'Customer')
                    {
                        objAsset.End_Customer__c = mapAccountNumberRespectedId.get(integer.valueof(objAsset.Account_Number__c)).Id;
                    }                   
                }
            }
        }
    }
   
    
    static void assetOEMCustomerAssignmentOnUpdate(list<Asset__c> triggerNew,map<Id,Asset__c> triggeroldMap)
    {
        set<integer> setOfAccountNumber = new set<integer>();
        set<string> setofESN = new set<string>();
        set<string> setofAccountName = new set<string>();
        for(Asset__c objAssets : triggerNew)
        {       
            if(objAssets.Account_Number__c != null)
            {
                setofESN.add(objAssets.Name);
                setOfAccountNumber.add(integer.valueof(objAssets.Account_Number__c));
                if(objAssets.Company__c != null && objAssets.Company__c != '')
                    setofAccountName.add(objAssets.Company__c.toLowercase());
            }
        }
        system.debug('...setOfAccountNumber..'+setOfAccountNumber);
        system.debug('...setofESN..'+setofESN);
        map<string,Asset__c> mapNameRelatedAsset = new map<string,Asset__c>();
        if(setofESN.size()>0)
        {
            for(Asset__c objAsst : [select Id, Name,End_Customer__c from Asset__c where Name =: setofESN])
            {
                mapNameRelatedAsset.put(objAsst.Name,objAsst);
            }
            system.debug('...mapNameRelatedAsset..'+mapNameRelatedAsset);
            set<string> setOfString = new set<string>();
            list<Account> lstAcc = new list<Account>();
            if(setOfAccountNumber.size() > 0)
            {
                map<string,integer> mapESNumberRespectedId = new map<string,integer>();
                map<Integer, string> mapAccountNumberRespectedId = new map<Integer, string>();
                for(Account objAcc : [Select Id, Name, Account_Number__c from Account where /*Account_Number__c IN: setOfAccountNumber OR*/ Name IN: setofAccountName])
                {
                    setOfString.add(objAcc.Name.toLowercase());
                    mapAccountNumberRespectedId.put(integer.valueof(objAcc.Account_Number__c),objAcc.Id);
                    mapESNumberRespectedId.put(objAcc.Name.toLowercase(),integer.valueof(objAcc.Account_Number__c));
                }
                
                system.debug('...mapAccountNumberRespectedId..'+mapAccountNumberRespectedId+'...setOfString.'+setOfString);
                
                Generating_Account_Number__c accountNumber = Generating_Account_Number__c.getValues('Unique Number');
                integer intCountAccountNumber = integer.valueof(accountNumber.Unique_Number__c);
                
                
                //Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('OEM’s Customer').getRecordTypeId();
                set<string> setOfCompanyName = new set<string>();
                map<string,Id> mapCompanyNameId = new map<string,Id>();
                map<string,Account> mapAccountNameRelatedValue = new map<string,Account>();
                for(Asset__c objAssets : triggerNew)
                {
                    if(mapNameRelatedAsset.containskey(objAssets.Name) && mapNameRelatedAsset.get(objAssets.Name).End_Customer__c == null)
                    {
                        if(objAssets.Company__c != null && !setOfString.contains(objAssets.Company__c.toLowercase()) && !setOfCompanyName.contains(objAssets.Company__c.toLowercase()))
                        {
                            if(objAssets.Company__c != null)
                            {
                                system.debug('...objAssets.Company__c..'+objAssets.Company__c);
                                Account objAcc = new Account();
                                if(objAssets.Email__c != null)
                                    objAcc.Email__c = objAssets.Email__c;
                                objAcc.Name = objAssets.Company__c;
                                intCountAccountNumber++;
                                objAcc.Is_Upload_From_Excel__c = true;
                                objAcc.Account_Number__c = intCountAccountNumber;
                                system.debug('...objAssets.Customer_Type__c..'+objAssets.Customer_Type__c);
                                if(objAssets.Customer_Type__c != null && objAssets.Customer_Type__c != '')
                                {
                                    if(Schema.SObjectType.Account.getRecordTypeInfosByName().get(objAssets.Customer_Type__c).getRecordTypeId() != null)
                                        objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(objAssets.Customer_Type__c).getRecordTypeId();
                                    else 
                                         objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('OEM\'s Customer').getRecordTypeId();
                                }
                                objAcc.Address__C = objAssets.Address__C;
                                objAcc.BillingCity = objAssets.City__c;
                                objAcc.BillingState = objAssets.State__c;
                                objAcc.Region__c = objAssets.Region__c  ;
                                objAcc.Powerparts_Service_Branch__c= objAssets.Powerparts_Service_Branch__c;
                                //lstAcc.add(objAcc);
                                mapAccountNameRelatedValue.put(objAcc.Name,objAcc);
                                setOfCompanyName.add(objAssets.Company__c.toLowercase());
                                setOfString.add(objAssets.Company__c.toLowercase());
                                system.debug('.......setOfCompanyName...'+setOfCompanyName);
                                system.debug('....Account..'+objAcc);
                            }   
                        }
                    }
                }
                
                if(mapAccountNameRelatedValue.size()>0)
                    insert mapAccountNameRelatedValue.values();
                
                system.debug('...lstAcc.....'+lstAcc.size());
                for(Account objAcc : mapAccountNameRelatedValue.values())
                {            
                    mapESNumberRespectedId.put(objAcc.Name.toLowercase(),integer.valueof(objAcc.Account_Number__c));
                    mapAccountNumberRespectedId.put(integer.valueof(objAcc.Account_Number__c),objAcc.Id);
                    mapCompanyNameId.put(objAcc.Name.toLowercase(), objAcc.Id);
                }
                
                list<Contact> lstContact = new list<Contact>();
                if(mapCompanyNameId.size()>0)
                {
                    set<string> setOfContactName = new set<string>();
                    for(Asset__c objAsset : triggerNew)
                    {
                        system.debug('....objAsset...'+objAsset);
                        if(objAsset.Company__c != null && objAsset.Company__c != '' && mapCompanyNameId.containskey(objAsset.Company__c.toLowercase()) && mapCompanyNameId.get(objAsset.Company__c.toLowercase()) != null)
                        {
                            string strName = '';
                            if(objAsset.Salutation__c != null && objAsset.Salutation__c != '')
                                strName = objAsset.Salutation__c;
                            if(objAsset.First_Name__c != null && objAsset.First_Name__c != '')
                                strName = strName+objAsset.First_Name__c;
                            if(objAsset.Last_Name__c != null && objAsset.Last_Name__c != '')
                                strName = strName+objAsset.Last_Name__c;
                                
                            If(!setOfContactName.contains(strName.toLowercase()))
                            {
                                Contact objContact = new Contact();
                                
                                if(objAsset.Salutation__c != null && objAsset.Salutation__c != '')
                                {
                                    objContact.Salutation = objAsset.Salutation__c;
                                }
                                objContact.FirstName = objAsset.First_Name__c;
                                objContact.isPrimary__c = true;
                                objContact.LastName = objAsset.Last_Name__c;
                                if(objAsset.Contact_Number__c != null)
                                    objContact.MobilePhone = objAsset.Contact_Number__c;
                                objContact.AccountId = mapCompanyNameId.get(objAsset.Company__c.toLowercase());
                                
                                if(objAsset.Last_Name__c != null && objAsset.Last_Name__c != '')
                                {
                                    setOfContactName.add(strName.toLowercase());
                                    lstContact.add(objContact);
                                }
                            }
                        }
                    }
                }
                if(lstContact.size()>0)
                    insert lstContact;
                if(intCountAccountNumber > 0)
                {
                    accountNumber.Unique_Number__c = intCountAccountNumber;
                    update accountNumber;
                }
                list<Asset__c> lstAsset = new list<Asset__c>();
                if(mapAccountNumberRespectedId.size()>0)
                {
                    for(Asset__c objAsset : triggerNew)
                    {
                        if(mapNameRelatedAsset.containskey(objAsset.Name) && mapNameRelatedAsset.get(objAsset.Name).End_Customer__c == null)
                        {
                            if(mapESNumberRespectedId.size()>0)
                            {
                                if(objAsset.Company__c != null && objAsset.Company__c != '' && mapESNumberRespectedId.containskey(objAsset.Company__c.toLowercase()) && mapESNumberRespectedId.get(objAsset.Company__c.toLowercase()) != null)
                                {
                                    if(mapAccountNumberRespectedId.containskey(mapESNumberRespectedId.get(objAsset.Company__c.toLowercase())) && mapAccountNumberRespectedId.get(mapESNumberRespectedId.get(objAsset.Company__c.toLowercase())) != null && mapAccountNumberRespectedId.get(mapESNumberRespectedId.get(objAsset.Company__c.toLowercase())) != '')
                                    objAsset.End_Customer__c = mapAccountNumberRespectedId.get(mapESNumberRespectedId.get(objAsset.Company__c.toLowercase()));
                                }
                            }   
                        }              
                    }
                }
            }
        }
    }
}