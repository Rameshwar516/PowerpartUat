@isTest
public class ClassInvoiceSendOnEmailTest {
    
    Public static testMethod void firstMethod(){
        clsUtility.testDataCustomSetting();
        clsUtility.testDataAccountContact(20,20,true);
        
        //insert warehouse
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Kolkata Warehouse';
        insert wHouse;
        
        List<Account> accId = [Select id, Name from Account where Name = 'Test Account1'];
        System.debug('accId-- '+accId[0].Id);
        
        // insert Contact
        Contact c = new Contact();
        c.AccountId= accId[0].id; 
        c.LastName = 'Test0021';
        insert c;
        
        // insert Opportunity
        Opportunity__c o = new Opportunity__c();
        o.Contact_Person__c = c.Id;
        o.OEM_Customer__c = accId[0].Id;
        o.Stage__c = 'Negotiation';
        o.Opportunity_Close_Date__c = date.today()+1;
        o.Place_of_Supply__c = wHouse.Id;
        insert o;
        
        // insert Quote
        Id RecordTypeIdContact = Schema.SObjectType.Quote__c.getRecordTypeInfosByName().get('AMC').getRecordTypeId();
        
        Quote__c q =  new Quote__c();
        q.RecordTypeId = RecordTypeIdContact;
        q.Payment_Method__c = 'Cash';
        q.Customer_Party__c = accId[0].Id;
        q.Contact_Name__c = c.Id;
        q.Opportunity__c = o.Id;
        insert q; 
        
        // insert sales order
        Sales_Order__c so=new Sales_Order__c();
        
        so.Opportunity__c=o.id;
        so.Ware_House__c=wHouse.id;
        so.Status__c='Approved';
        
        insert so;
        
        //insert delivery note
        Sales_Order_Dispatch_Delivery_Note__c  sod = new Sales_Order_Dispatch_Delivery_Note__c();
        sod.Sales_Order__c=so.Id;
        sod.Customer_Party__c = accId[0].id;
        insert sod ;
       
        Id RecordTypeIdinvoice = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Tax_Invoice').getRecordTypeId();
        invoice__c inv = new invoice__c();
        inv.RecordTypeId=RecordTypeIdinvoice;
        insert inv;
        
        classInvoiceSendOnEmail.intid(inv.Id);
        String sub = 'It is Test';
        String Bodyy = 'Good Night';
        String mailAdd = 'testMail@gmail.com';
        String ccAdd = 'testcc@gmail.com';
        classInvoiceSendOnEmail.send(inv.Id, sub, Bodyy, mailAdd, ccAdd);
    }
    //////////////
    Public static testMethod void SecondMethod(){
        system.debug('second metod');
        clsUtility.testDataCustomSetting();
        clsUtility.testDataAccountContact(20,20,true);
        
        //insert warehouse
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Kolkata Warehouse';
        insert wHouse;
        
        List<Account> accId = [Select id, Name from Account where Name = 'Test Account1'];
        System.debug('accId-- '+accId[0].Id);
        
        // insert Contact
        Contact c = new Contact();
        c.AccountId= accId[0].id; 
        c.LastName = 'Test0021';
        insert c;
        
        // insert Opportunity
        Opportunity__c o = new Opportunity__c();
        o.Contact_Person__c = c.Id;
        o.OEM_Customer__c = accId[0].Id;
        o.Stage__c = 'Negotiation';
        o.Opportunity_Close_Date__c = date.today()+1;
        o.Place_of_Supply__c = wHouse.Id;
        insert o;
        
        // insert Quote
        Id RecordTypeIdContact = Schema.SObjectType.Quote__c.getRecordTypeInfosByName().get('AMC').getRecordTypeId();
        
        Quote__c q =  new Quote__c();
        q.RecordTypeId = RecordTypeIdContact;
        q.Payment_Method__c = 'Cash';
        q.Customer_Party__c = accId[0].Id;
        q.Contact_Name__c = c.Id;
        q.Opportunity__c = o.Id;
        insert q; 
        
        // insert sales order
        Sales_Order__c so=new Sales_Order__c();
        
        so.Opportunity__c=o.id;
        so.Ware_House__c=wHouse.id;
        so.Status__c='Approved';
        
        insert so;
        
        //insert delivery note
        Sales_Order_Dispatch_Delivery_Note__c  sod = new Sales_Order_Dispatch_Delivery_Note__c();
        sod.Sales_Order__c=so.Id;
        sod.Customer_Party__c = accId[0].id;
        insert sod ;
       
       
        Id RecordTypeIdserinvoice = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Service_Invoice').getRecordTypeId();
        system.debug('RecordTypeIdserinvoice '+RecordTypeIdserinvoice);
        invoice__c inv = new invoice__c();
        inv.RecordTypeId=RecordTypeIdserinvoice;
        insert inv;
        
        Invoice_Line_Item__c invli=new Invoice_Line_Item__c();
        invli.Invoice__c=inv.id;
        insert invli;
        
        classInvoiceSendOnEmail.intid(inv.Id);
        String sub = 'It is Test';
        String Bodyy = 'Good Night';
        String mailAdd = 'testMail@gmail.com';
        String ccAdd = 'testcc@gmail.com';
        classInvoiceSendOnEmail.send(inv.Id, sub, Bodyy, mailAdd, ccAdd);
    }
   
}