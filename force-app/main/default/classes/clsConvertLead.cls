public with sharing class clsConvertLead
{ 
    @AuraEnabled
    public static mainWrapper wrapmain {get;set;}
    @AuraEnabled
    public static string objcontactid{get;set;}
    @AuraEnabled
    
    public static string convertLead(string strleadrecordid) 
    {
        wrapmain = new mainWrapper();
        leadStatusValues();
        DescribeSObjectResult describeResult = Lead__c.getSObjectType().getDescribe();     
        List<String> LeadfieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query = 'SELECT ' + string.join(LeadfieldNames, ',') + ' FROM Lead__c Where Id =: strleadrecordid';
        System.debug('leadQuery--- '+query);
        wrapmain.objlead = Database.query(query);
        
        if(wrapmain.objlead.isconverted__c)
        {   
            System.debug('LeadConverted-----');
            string strName = '';
            wrapmain.errorMSG = system.label.Lead_Convert_Error_Message;
            if(wrapmain.objlead.ConvertedAcconutId__c != null)
            {
                list<Account> lstAcc = [select id,Name,Type,Phone,owner.Name from Account where id =: wrapmain.objlead.ConvertedAcconutId__c]; 
                if(!lstAcc.isEmpty())
                    wrapmain.AccName = lstAcc[0];
            }
            if(string.isNotEmpty(wrapmain.AccName.Name))
            {
                System.debug('AccountNameNotEmpty-----');
                strName = wrapmain.AccName.Name;
                if(wrapmain.AccName.Name.length() > 20)
                {
                    wrapmain.AccName.Name = wrapmain.AccName.Name.left(20) + '...';
                    strName = wrapmain.AccName.Name;
                }
            }   
            
            if(wrapmain.objlead.ConvertedContactId__c != null)
            {
                System.debug('ConvertedContactId__cNotNull-----'); 
                list<Contact> lstCon = [select id,Name,FirstName,LastName,Title,AccountId,Email,Account.Name from Contact where id =: wrapmain.objlead.ConvertedContactId__c];
                if(!lstCon.isEmpty())
                    wrapmain.ConName = lstCon[0];  
            }
            if(string.isNotEmpty(wrapmain.ConName.LastName))
            {
                // System.debug('conLastName----- '+wrapmain.ConName.LastName+' ==== '+wrapmain.ConName.FirstName.length());
                if(string.isNotEmpty(wrapmain.ConName.FirstName) && wrapmain.ConName.FirstName.length() > 10){
                    wrapmain.ConName.FirstName = wrapmain.ConName.FirstName.left(10) + '.';
                }
                if(wrapmain.ConName.LastName.length() > 10){
                    wrapmain.ConName.LastName = wrapmain.ConName.LastName.left(10) + '...';
                }
                wrapmain.ConName.Account.Name = strName;
                System.debug('wrapmainContactName------ '+wrapmain.ConName.Account.Name);
            }
            
            if(wrapmain.objlead.ConvertedOpportunityId__c != null)
            {
                System.debug('ConvertedOpportunityId__cNotNull-----');
                list<Opportunity__c> lstDeal = [select id,Name,OEM_Customer__r.Name,Opportunity_Close_Date__c from Opportunity__c where id =: wrapmain.objlead.ConvertedOpportunityId__c];
                if(!lstDeal.isEmpty())
                    wrapmain.OppName = lstDeal[0];
            }
            
            if(string.isNotEmpty(wrapmain.OppName.Name))
            {
                if(wrapmain.OppName.Name.length() > 20){
                  //  wrapmain.OppName.Name = wrapmain.OppName.Name.left(20) + ' ...';
                }
               // wrapmain.OppName.OEM_Customer__r.Name = strName;
            }    
        }else
        {
            if(wrapmain.objlead.ownerId != null)
                wrapmain.selectedRecord = [SELECT id,name from user where id =: wrapmain.objlead.ownerId];
            System.debug('succuess--');
            
        } 
        return Json.serialize(wrapmain); 
    }
    
    @AuraEnabled
    public static string saveconvertrecord(string strLeadid, string AccountId, string OpportunityId, string ContactId, boolean CreateOpp, boolean IsDeleteConverted,string AccountName ,string strRecordType)
    {
        
        wrapmain = new mainWrapper();
        Savepoint sp = Database.setSavepoint();
        try
        {
            string idRecordTypeId = '';
            if(strRecordType != null && strRecordType != '')
            {
                system.debug('...strRecordType ...'+strRecordType);
                idRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(strRecordType).getRecordTypeId();
                /*if(lstRecordTypeId.size()>0  && lstRecordTypeId[0] != null)
                idRecordTypeId = lstRecordTypeId[0].Id;
                else idRecordTypeId = [SELECT Id,DeveloperName,Name,SobjectType FROM RecordType WHERE SobjectType='Account' and DeveloperName = 'Customer'].Id;*/
            }
            system.debug('........idRecordTypeId ..'+idRecordTypeId );
            wrapmain.errorMSG = '';
            //Account Object Insert
            List<sObject> objAccount = new List<sObject>();
            if(string.isNotEmpty(AccountId))
            {
                objAccount = UpdateRecord('LeadAccountMap', strLeadid, 'Account', AccountId,null,null); 
                System.debug('UpdatedAccRecord----- '+objAccount);
                System.debug('updatedRecord----- '+!objAccount.isEmpty());
                if(!objAccount.isEmpty())
                    database.update(objAccount,false);
            }
            else
            {
                objAccount = insertRecord('LeadAccountMap', strLeadid, 'Account', null, AccountName,idRecordTypeId); 
                System.debug('insertedAccRecord----- '+objAccount);
                System.debug('insertedRecord----- '+!objAccount.isEmpty()); 
                if(!objAccount.isEmpty()){
                    insert objAccount;
                    // database.insert(objAccount,false); 
                } 
                
            }
            wrapmain.AccName = (Account)objAccount[0];
            System.debug('wrappingAccName----- '+wrapmain.AccName); 
            //Contact Object Update or Insert
            List<sObject> objContact = new List<sObject>();
            if(string.isNotEmpty(contactId))
            {
                objContact = UpdateRecord('LeadContactMap', strLeadid, 'Contact', contactId,AccountId,null);
                System.debug('UpdatedConRecord----- '+objContact);
                System.debug('updatedCRecord-----  '+!objContact.isEmpty());
                if(!objContact.isEmpty())
                    database.update(objContact,false); 
                objcontactid = contactId;
            }
            else
            {
                if(objAccount[0].Id != null)
                    objContact = insertRecord('LeadContactMap', strLeadid, 'Contact', objAccount[0].Id, null,null);
                
                if(!objContact.isEmpty())
                    insert objContact; 
                
                // system.debug('contactid '+objContact[0].id);
                
                if(string.isNotEmpty(objContact[0].id))
                    objcontactid = objContact[0].id;
                
                system.debug('contactid '+objcontactid); 
                
            }
            //Opportunity Object Insert
            List<sObject> objOpportunity = new List<sObject>();
            if(string.isNotEmpty(OpportunityId))
            {
                objOpportunity = UpdateRecord('LeadOpportunityMap', strLeadid, 'Opportunity__c', OpportunityId,AccountId,contactId);
                if(!objOpportunity.isEmpty())
                    database.update(objOpportunity,false);
            }
            else
            {
                System.debug('DefalultValBool--- '+!CreateOpp);
                if(!CreateOpp)
                {
                    if(string.isNotEmpty(objAccount[0].Id))
                        objOpportunity = insertRecord('LeadOpportunityMap', strLeadid, 'Opportunity__c', objAccount[0].Id, string.valueOf(objAccount[0].get('Name')),null);
                    System.debug('objOppInsert---- '+objOpportunity);
                    if(!objOpportunity.isEmpty())
                        database.insert(objOpportunity,false);
                }
            }  
            
            if(IsDeleteConverted)
            {   
                Lead__c enqToDelete;
                if(Schema.sObjectType.Lead__c.isAccessible())
                    enqToDelete = [SELECT Id FROM Lead__c WHERE Id= :strLeadid];
                
                if(Schema.SObjectType.Lead__c.isDeletable())    
                    Database.delete(enqToDelete,false);
            }
            else
            {
                System.debug('UpdatedAfterInserted----');
                if(Schema.sObjectType.Lead__c.fields.isconverted__c.isUpdateable() 
                   && Schema.sObjectType.Lead__c.fields.ConvertedAcconutId__c.isUpdateable() 
                   && Schema.sObjectType.Lead__c.fields.ConvertedContactId__c.isUpdateable()
                   && Schema.sObjectType.Lead__c.fields.ConvertedOpportunityId__c.isUpdateable())
                {   System.debug('NotEmptyOpp--- '+!objOpportunity.isEmpty());
                 if(!objOpportunity.isEmpty())
                 {
                     Lead__c objEnq = new Lead__c(id = strLeadid,isconverted__c = true,
                                                  ConvertedAcconutId__c = objAccount[0].Id,ConvertedContactId__c = objContact[0].Id,ConvertedOpportunityId__c = objOpportunity[0].Id,Lead_Status__c = 'Closed (Converted)');
                     
                     if(Schema.SObjectType.Lead__c.isUpdateable())
                         database.update(objEnq,false);
                 }
                 else
                 {
                     System.debug('-----OppEmpty----');
                     Lead__c objEnq = new Lead__c(id = strLeadid,isconverted__c = true,
                                                  ConvertedAcconutId__c = objAccount[0].Id,ConvertedContactId__c = objContact[0].Id,Lead_Status__c = 'Closed (Converted)');
                     
                     if(Schema.SObjectType.Lead__c.isUpdateable())
                         database.update(objEnq,false);   
                 } 
                }
            }
            
            //---------------------------------------------------------------//
            
            System.debug('successs--');
            list<event> objevent = new list<event>();
            list<Task>  objtask = new list<task>();
            objevent =[select id,  Subject, StartDateTime, OwnerId , Owner.Name, WhoId , what.Name  from event where WhatId =:strLeadid ]; 
            objtask =[select id,  Subject, ActivityDate ,Status, WhatId  ,OwnerId , Owner.Name, WhoId , what.Name  from Task where WhatId =:strLeadid ]; 
            //contact objcon =[select id , Name from contact  Limit 1];
            System.debug('objcon---'+objtask);
            //  System.debug('objContact[0].Id---'+objContact[0].Id);
            // System.debug('objevent--'+objevent[0].Owner.Name);
            // System.debug('objevent--'+objevent[0].WhoId);
            list<event> objupdateevent = new list<event>();
            if(!objevent.isEmpty())
            {
                
                if(string.isNotEmpty(objContact[0].Id) && string.isNotEmpty(objOpportunity[0].Id) )
                {
                    for(event obj : objevent)
                    {
                        obj.WhoId = objContact[0].Id;
                        obj.WhatId = objOpportunity[0].Id;
                        objupdateevent.add(obj); 
                        System.debug('objupdateevent--'+objupdateevent);
                    }
                    
                    update objupdateevent;
                }  
                
            }
            list<Task>  objupdatetask = new list<task>();
            if(!objtask.isEmpty())
            {
                
                
                if(string.isNotEmpty(objContact[0].Id) && string.isNotEmpty(objOpportunity[0].Id))
                {
                    for(Task obj : objtask)
                    {
                        obj.WhoId = objContact[0].Id;
                        obj.WhatId = objOpportunity[0].Id;   
                        objupdatetask.add(obj);   
                    }
                    update objupdatetask;
                }  
                
            }
            list<ContentDocumentLink> lstContentDocumentLink = new list<ContentDocumentLink>();
            for(ContentDocumentLink objConverted : [select Id, LinkedEntityId,ContentDocumentId,shareType from ContentDocumentLink where LinkedEntityId  =: strLeadid])
            {
                System.debug('objConverted--'+objConverted);
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.LinkedEntityId = objContact[0].Id;  
                cdl.ContentDocumentId = objConverted.ContentDocumentId;
                cdl.shareType = objConverted.shareType;
                lstContentDocumentLink.add(cdl);
                
                System.debug('lstContentDocumentLink--'+lstContentDocumentLink);   
            }
            insert lstContentDocumentLink; 
            
            list<ContentDocumentLink> lstDealDocumentLink = new list<ContentDocumentLink>();
            for(ContentDocumentLink objConverted : [select Id, LinkedEntityId,ContentDocumentId,shareType from ContentDocumentLink where LinkedEntityId  =: strLeadid])
            {
                System.debug('objConverted--'+objConverted);
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.LinkedEntityId = objOpportunity[0].Id;
                cdl.ContentDocumentId = objConverted.ContentDocumentId;
                cdl.shareType = objConverted.shareType;
                lstDealDocumentLink.add(cdl);
                
                System.debug('lstContentDocumentLink--'+lstDealDocumentLink);   
            }
            insert lstDealDocumentLink;  
            
            list<ContentDocumentLink> lstAccDocumentLink = new list<ContentDocumentLink>();
            for(ContentDocumentLink objConverted : [select Id, LinkedEntityId,ContentDocumentId,shareType from ContentDocumentLink where LinkedEntityId  =: strLeadid])
            {
                System.debug('objConverted--'+objConverted);
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.LinkedEntityId = objAccount[0].Id;
                cdl.ContentDocumentId = objConverted.ContentDocumentId;
                cdl.shareType = objConverted.shareType;
                lstAccDocumentLink.add(cdl);
                
                System.debug('lstContentDocumentLink--'+lstDealDocumentLink);   
            }
            insert lstAccDocumentLink; 
        } 
        
        Catch(Exception ex){
            wrapmain.errorMSG = ExceptionMessage.getExceptionMsg(ex); 
            System.debug('wrapmain.errorMSG--'+wrapmain.errorMSG);
            system.debug('........'+ex.getMessage());
            Database.rollback(sp);
        }   
        //---------------------------------------------------------------//
        
        return json.serialize(wrapmain);   
    }
    
    
    
    
    public static List<sObject> insertRecord(string recordName, string strLeadid, string objName, string objAccId, string accName,string idRecordTypeId)
    {
        if(string.isNotEmpty(strLeadid))
        {
            map<string, string> apiMap = new map<string, string>();
            list<Lead__c> lstEnq = new list<Lead__c>();
            apiMap = getFieldMap(recordName);
            System.debug('RecordNameOfLead----- '+recordName);
            DescribeSObjectResult describeResult = Lead__c.getSObjectType().getDescribe();    
            List<String> LstEnqFields = new List<String>( describeResult.fields.getMap().keySet() );
            if(!LstEnqFields.isEmpty())
            {
                String strQuery = 'SELECT ' + string.join(LstEnqFields, ',') + ' FROM Lead__c Where id =: strLeadid';
                lstEnq = Database.query(strQuery);
            }
            
            sObject sObj = Schema.getGlobalDescribe().get(objName).newSObject() ;
            List<sObject> lstSObject = new List<sObject>();
            
            if(!lstEnq.isEmpty())
            {
                Lead__c objEnq = lstEnq[0];
                // Convert Process starts here
                if(objName.equalsIgnoreCase('Account'))
                {
                    if(string.isNotEmpty(accName))
                        sObj.put('Name', accName); 
                    else
                        sObj.put('Name', objEnq.Company__c); 
                    
                    if(string.isNotEmpty(idRecordTypeId))
                        sObj.put('RecordTypeId', idRecordTypeId); 
                    
                    sObj.put('GSTIN_No__c', objEnq.GSTIN_No__c);
                    
                    sObj.put('Phone', objEnq.Phone__c);
                    sObj.put('Email__c', objEnq.Email__c);
                    sObj.put('Website', objEnq.Website__c);
                    sObj.put('Industry', objEnq.Industry__c);
                    sObj.put('Product_Interested_for__c', objEnq.Product_Interested_for__c); 
                    sObj.put('Lead_Source__c', objEnq.Lead_Source__c);
                    sObj.put('Lead_Type__c', objEnq.Lead_Type__c);
                    sObj.put('BillingStreet', objEnq.Street__c);
                    sObj.put('BillingCity', objEnq.City__c);
                    sObj.put('BillingPostalCode', objEnq.Zip_Postal_Code__c);
                    sObj.put('BillingState', objEnq.State_Province__c);
                    sObj.put('BillingCountry', objEnq.Country__c); 
                    
                    sObj.put('ShippingStreet', objEnq.Street__c);
                    sObj.put('ShippingCity', objEnq.City__c);
                    sObj.put('ShippingPostalCode', objEnq.Zip_Postal_Code__c);
                    sObj.put('ShippingState', objEnq.State_Province__c);
                    sObj.put('ShippingCountry', objEnq.Country__c); 
                }
                
                if(objName.equalsIgnoreCase('Contact'))
                {
                    
                    sObj.put('FirstName', objEnq.First_Name__c);
                    sObj.put('LastName', objEnq.name);
                    sObj.put('Phone', objEnq.Phone__c);
                    sObj.put('MobilePhone', objEnq.Mobile__c); 
                    sObj.put('isPrimary__c', true); 
                    if(string.isNotEmpty(objAccId))
                    {
                        sObj.put('AccountId', objAccId);
                        sObj.put('Email', objEnq.Email__c);
                    }
                }
                
                if(objName.equalsIgnoreCase('Opportunity__c'))
                {
                    system.debug('contactid'+objcontactid);
                    system.debug('Opportunity Created----');
                    sObj.put('Stage__c', 'New');
                    sObj.put('Opportunity_Close_Date__c', system.Today()); 
                    
                    if(string.isNotEmpty(objAccId))
                        sObj.put('OEM_Customer__c', objAccId);
                    
                    sObj.put('Contact_Person__c', objcontactid);
                    // system.debug('Opportunity Contact_Person---- '+ConName.Id); 

                    sObj.put('Shipping_Street__c', objEnq.Street__c);
                    sObj.put('Shipping_City__c', objEnq.City__c);
                    sObj.put('Shipping_Zip_Postal_Code__c', objEnq.Zip_Postal_Code__c);
                    sObj.put('Shipping_State_Province__c', objEnq.State_Province__c);
                    sObj.put('Shipping_Country__c', objEnq.Country__c); 
                    
                    sObj.put('Is_Converted__c', true); 
                }
                
                for(string fieldApi : apiMap.keySet())
                {
                    sObj.put(apiMap.get(fieldApi), objEnq.get(fieldApi));
                }
                lstSObject.add(sObj);
            }
            return lstSObject;
        }
        return null;
    }
    
    public static List<sObject> UpdateRecord(string recordName, string strLeadid, string objName, string objId, String ObjAccId, String ObjConId)
    {  
        map<string, string> apiMap = new map<string, string>();
        list<Lead__c> lstEnq = new list<Lead__c>();
        apiMap = getFieldMap(recordName);
        DescribeSObjectResult describeResult = Lead__c.getSObjectType().getDescribe();    
        List<String> LstEnqFields = new List<String>( describeResult.fields.getMap().keySet() );
        if(!LstEnqFields.isEmpty())
        {
            String strQuery = 'SELECT ' + string.join(LstEnqFields, ',') + ' FROM Lead__c Where id =: strLeadid';
            lstEnq = Database.query(strQuery);
        }
        
        sObject sObj = Schema.getGlobalDescribe().get(objName).newSObject();
        List<sObject> lstSObject = new List<sObject>();
        if(!lstEnq.isEmpty())
        {
            // Convert Process starts here
            sObj.put('Id', objId);
            Lead__c objEnq = lstEnq[0];
            if(objName.equalsIgnoreCase('Account'))
            {  
                sObj.put('GSTIN_No__c', objEnq.GSTIN_No__c);
                sObj.put('Phone', objEnq.Phone__c);
                sObj.put('Email__c', objEnq.Email__c);
                sObj.put('Website', objEnq.Website__c);
                sObj.put('Industry', objEnq.Industry__c);
                sObj.put('Product_Interested_for__c', objEnq.Product_Interested_for__c); 
                sObj.put('Lead_Source__c', objEnq.Lead_Source__c);
                sObj.put('Lead_Type__c', objEnq.Lead_Type__c);
                sObj.put('BillingStreet', objEnq.Street__c);
                sObj.put('BillingCity', objEnq.City__c);
                sObj.put('BillingPostalCode', objEnq.Zip_Postal_Code__c);
                sObj.put('BillingState', objEnq.State_Province__c);
                sObj.put('BillingCountry', objEnq.Country__c); 
            }
            
            if(objName.equalsIgnoreCase('Contact'))
            {
                
                sObj.put('FirstName', objEnq.First_Name__c);
                sObj.put('LastName', objEnq.name);
                sObj.put('Phone', objEnq.Phone__c);
                sObj.put('MobilePhone', objEnq.Mobile__c); 
                sObj.put('isPrimary__c', true); 
                if(string.isNotEmpty(objAccId))
                {
                    sObj.put('AccountId', objAccId);
                    sObj.put('Email', objEnq.Email__c);
                }
            }
            
            if(objName.equalsIgnoreCase('Opportunity__c'))
            {
                sObj.put('Stage__c', 'New');
                sObj.put('Opportunity_Close_Date__c', system.Today()); 
                if(string.isNotEmpty(objAccId))
                    sObj.put('OEM_Customer__c', objAccId);
                
                sObj.put('Shipping_Street__c', objEnq.Street__c);
                sObj.put('Shipping_City__c', objEnq.City__c);
                sObj.put('Shipping_Zip_Postal_Code__c', objEnq.Zip_Postal_Code__c);
                sObj.put('Shipping_State_Province__c', objEnq.State_Province__c);
                sObj.put('Shipping_Country__c', objEnq.Country__c); 
                
                sObj.put('Contact_Person__c', objcontactid);  
            }
            
            
            for(string fieldApi : apiMap.keySet())
            {
                try
                {
                    
                    sObj.put(apiMap.get(fieldApi), objEnq.get(fieldApi));
                    
                }
                catch(Exception ex)
                {
                    system.debug('Error----'+ex.getMessage());
                }
                
            }
            lstSObject.add(sObj);
        }
        return lstSObject;
    }
   
    
    public static Map<string,string> getFieldMap(string recordName)
    {
        System.debug('RecName----- '+recordName);
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get('Lead__c');
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        
        Map<string, string> fieldNames = new Map<string, string>();
        for (String fieldName: fieldMap.keySet()) 
        {  
            if(fieldMap.get(fieldName).getDescribe().isUpdateable())
                fieldNames.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
        }
        
        map<string, string> apiMap = new map<string, string>();
        for(Lead_Mapping__c objLeadMap : [select Id, Name, Object_API__c, Label_Name__c, Lead_API__c from Lead_Mapping__c where Name =: recordName])
        {
            if(string.isNotEmpty(objLeadMap.Object_API__c) && fieldNames.containsKey(objLeadMap.Lead_API__c))
            {
                apiMap.put(objLeadMap.Lead_API__c, objLeadMap.Object_API__c);
            }
        }   
        return apiMap;
    }
    
    public static list<string> leadStatusValues()
    {
        System.debug('Sucesslead--');
        List<String> optionsLeadStatus = new List<String>();
        Schema.DescribeFieldResult fieldResultLeadStatus = Lead__c.Lead_Status__c.getDescribe();
        List<Schema.PicklistEntry> pListLeadStatus = fieldResultLeadStatus.getPicklistValues();
        for (Schema.PicklistEntry p1: pListLeadStatus) {
            if(p1.getLabel() == 'Closed - Converted')
                optionsLeadStatus.add(p1.getLabel());
        }
        wrapmain.picklistLeadStatus = optionsLeadStatus;
        system.debug('wrapmain.picklistLeadStatus...'+wrapmain.picklistLeadStatus);
        
        return wrapmain.picklistLeadStatus;
    } 
    
    public class mainWrapper
    { 
        public List<Lead__c> lstLead {get;set;}
        public Lead__c objlead {get;set;}
        public User selectedRecord {get;set;}
        public string errorMSG {get;set;}
        public Account AccName {get;set;}
        public Contact ConName {get;set;}
        public List<string> picklistLeadStatus {get;set;}
        public Opportunity__c OppName {get;set;} 
        public Event objevent {get ;set;}
        public mainWrapper()
        {
            AccName = new Account();
            ConName = new contact();
            OppName = new Opportunity__c();
            lstLead = new List<Lead__c>();
            objlead = new Lead__c();
            selectedRecord = new User();
            objevent = new Event();
        }
    }  
}