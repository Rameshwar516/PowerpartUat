@istest
public class TestClassOnQuoteEmailSend {
    public static testmethod void testemail(){
        Trigger_Setting__c ts=new Trigger_Setting__c();
        ts.Name = 'Account';
        ts.Active__c=true;
        
        insert ts;
        Generating_Account_Number__c gan=new Generating_Account_Number__c();
        gan.Name='Unique Number';
        gan.Unique_Number__c=458796;
        insert gan;
        
        Account a=new Account();
        a.name='AccName';
        a.GSTIN_No__c='5387393';
        a.Type='Customer';
        a.PAN_NO__c='4865979';
        a.BillingCity='city';
        a.Region__c='East';
        insert a;
        system.debug('Account insertedx'+a);
        
        contact c=new contact();
        c.Accountid=a.Id;
        c.LastName=a.Name;
        
        c.Email='krishan@cccinfotech.com';
        c.MobilePhone='6979780';
        insert c;
        system.debug('contact insertedx'+c);
        
        Quote__c qt=new Quote__c();
        qt.Contact_Name__c=c.Id;
        qt.Customer_Party__c=a.Id;
        insert qt;
         system.debug('Quote insertedx'+qt);
        
        ClassOnQuoteEmailSend.intid(qt.id);
        ClassOnQuoteEmailSend.send(qt.id ,'subject','String Bodyy' , 'krishan@cccinfotech.com' , 'krishanaggarwal750@gmail.com');
    }
}