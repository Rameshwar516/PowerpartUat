@isTest
public class ClassOnPIEmailSendTest {
    public static testMethod void firstMethod(){
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
        
        ClassOnPIEmailSend.intid(o.Id);
        String sub = 'It is Test';
        String Bodyy = 'Good Night';
        String mailAdd = 'testMail@gmail.com';
        String ccAdd = 'testcc@gmail.com';
        ClassOnPIEmailSend.send(o.Id, sub, Bodyy, mailAdd, ccAdd);
    }
}