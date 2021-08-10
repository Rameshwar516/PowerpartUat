@isTest
public class clsConvertLeadTest 
{
    public static testMethod void firstMethod(){
        
        //insert Lead
        List<Lead__c> ldLst = new List<Lead__c>();
        Lead__c ld = new Lead__c();
        ld.Salutation__c = 'Mr.';
        ld.Name = 'TestedContact0021';		//lastName
        ld.Lead_Type__c = 'Sales';
        ld.Mobile__c = '9485893345';
        ld.Email__c = 'test@gmail.com';
        ld.Company__c = 'Tested Account1 Pvt. Ltd.';
        
        insert ld;
        System.debug('leadId---- '+ld.Id);
        ldLst.add(ld);
        System.debug('insertedLeadId----- '+ld.Id);
        clsUtility.testDataCustomSetting();
        // clsUtility.testDataAccountContact(20,20,true);
        String strRecordTypeId = [SELECT Id,DeveloperName,Name,SobjectType FROM RecordType WHERE SobjectType='Account' and DeveloperName = 'Customer'].Id;
        System.debug('strRecordTypeId----- '+strRecordTypeId);
        Account acc = New Account();
        acc.RecordTypeId = strRecordTypeId;
        acc.Name = ld.Company__c;
        acc.PAN_NO__c = 'ghtid8739I';
        acc.Type = 'Customer';
        acc.Print_Name__c = ld.Company__c;
        
        insert acc;
        System.debug('accId--- '+acc.Id);
        
        //insert WareHouse
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Kolkata Warehouse';
        wHouse.Branch__c='Kolkata';
        insert wHouse; 
        
        // insert Contact
        Contact c = new Contact();
        c.AccountId= acc.id; 
        c.FirstName = 'TestedFirstName';
        c.LastName = 'TestedContact0021';
        insert c;
        
        // insert Opportunity
        Opportunity__c o = new Opportunity__c();
        o.Contact_Person__c = c.Id;
        o.OEM_Customer__c = acc.Id;
        o.Stage__c = 'New';
        o.Opportunity_Close_Date__c = date.today();
        o.Ware_House__c = wHouse.Id;
        insert o;
        ld.isconverted__c = true;
        ld.ConvertedAcconutId__c = acc.id;
        ld.ConvertedContactId__c = c.Id;
        ld.ConvertedOpportunityId__c = o.Id;
        update ld;
               
        //insert wrapper
        clsConvertLead.mainWrapper mw = new clsConvertLead.mainWrapper(); 
        mw.lstLead = ldLst;
        mw.AccName = acc;
        mw.ConName = c;
        mw.OppName = o; 
        
        clsConvertLead.convertLead(ld.Id);
        String objName = acc.Id.getSObjectType().getDescribe().getName();
        String recordName = 'LeadAccountMap';
        clsConvertLead.insertRecord(recordName, ld.Id, objName, acc.Id, acc.Name, strRecordTypeId);
        clsConvertLead.insertRecord(recordName, ld.Id, objName, null , acc.Name, strRecordTypeId);
        String objNameCon = c.Id.getSObjectType().getDescribe().getName();
        String recordNameCon = 'LeadContactMap';
        clsConvertLead.insertRecord(recordNameCon, ld.Id, objNameCon, c.Id, acc.Id, null);
        Boolean CreateOpp = true;
        Boolean IsDeleteConverted = true;
        String strRecordType = 'Customer';
        clsConvertLead.saveconvertrecord(ld.Id, acc.Id, o.Id, null, true , true, acc.name, strRecordType);
        clsConvertLead.insertRecord(recordNameCon, Ld.Id, 'Contact', null, acc.Id, null);
        clsConvertLead.saveconvertrecord(ld.Id, acc.Id, o.Id, c.Id, CreateOpp, IsDeleteConverted, acc.name, strRecordType);
    }
    
    @isTest public static void secondMethod(){
        Lead__c ldS = new Lead__c();
        ldS.Salutation__c = 'Mr.';
        ldS.Name = 'TestedContact0022';		//lastName
        ldS.Lead_Type__c = 'Sales';
        ldS.Mobile__c = '9485893346';
        ldS.Email__c = 'tests@gmail.com';
        ldS.Company__c = 'Tested Account1 Pvt. Ltd.'; 
        insert ldS;
        
        //insert WareHouse
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Kolkata Warehouse';
        wHouse.Branch__c='Kolkata';
        insert wHouse;
        
        clsUtility.testDataCustomSetting();
        String strRecordTypeId = [SELECT Id,DeveloperName,Name,SobjectType FROM RecordType WHERE SobjectType='Account' and DeveloperName = 'Customer'].Id;
        System.debug('strRecordTypeId----- '+strRecordTypeId);
        Account acc = New Account();
        acc.RecordTypeId = strRecordTypeId;
        acc.Name = ldS.Company__c;
        acc.PAN_NO__c = 'ghtid8739I';
        acc.Type = 'Customer';
        acc.Print_Name__c=ldS.Company__c;
        insert acc;
        System.debug('accId--- '+acc.Id);
        
        // insert Contact
        Contact c = new Contact();
        c.AccountId= acc.id; 
        c.FirstName = 'TestedFirstName';
        c.LastName = 'TestedContact0021';
        insert c;
        
        // insert Opportunity
        Opportunity__c o = new Opportunity__c();
        o.Contact_Person__c = c.Id;
        o.OEM_Customer__c = acc.Id;
        o.Stage__c = 'New';
        o.Opportunity_Close_Date__c = date.today();
        o.Ware_House__c = wHouse.Id;
        insert o;
        
        clsConvertLead.convertLead(ldS.Id);
        String recordNameCon = 'LeadContactMap';
        String strRecordType = 'Customer';
        clsConvertLead.saveconvertrecord(ldS.Id, acc.id, o.id, c.Id, true , false, acc.name, strRecordType);
        clsConvertLead.saveconvertrecord(ldS.Id, acc.id, null, c.Id, false , true, acc.name, strRecordType);
        clsConvertLead.saveconvertrecord(ldS.Id, null, o.Id, c.Id, true , true, acc.name, strRecordType);
        clsConvertLead.insertRecord(recordNameCon, LdS.Id, 'Account', null, acc.Name, strRecordType); 
    }
}