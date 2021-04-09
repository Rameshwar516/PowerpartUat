@istest
public class TestClassHandlerTotalCountofLineitem {
    public static testMethod void testOnInsertlineItemOnOpp(){
      
        Trigger_Setting__c ts=new Trigger_Setting__c();
        ts.Name = 'Account';
        ts.Active__c=true;
        insert ts;
        
        Generating_Account_Number__c gan=new Generating_Account_Number__c();
        gan.Name='Unique Number';
        gan.Unique_Number__c=458796;
        insert gan;
        
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
             
        Account a =new Account();

        a.Name='acc';
        a.RecordTypeId=RecordTypeIdContact;
        a.Type='Customer';
        a.PAN_NO__c='45656876';
        a.GSTIN_No__c='3976543';
        insert a;
        system.debug('account'+a);
        
        Opportunity__c o=new Opportunity__c();
        //o.Name='name';
        o.Stage__c='Negotiation';
        o.OEM_Customer__c=a.id;
        o.Opportunity_Close_Date__c=system.today()+10;
        insert o;
        
        system.debug('accountOpportunity'+o);
        
        line_item__c li=new line_item__c();
        li.Opportunity__c=o.id;
         system.debug('contact insertedx'+ li.Opportunity__c);
        li.Quantity__c=1;
        li.Discount__c=10;
        li.CGST__c=5;
        li.Sales_Price__c=1000;
        insert li;
        system.debug('accountOpportunityLineItem'+li);
        
        line_item__c lit=new line_item__c();
        lit.Id=li.Id;
        lit.Sales_Price__c=3000;
        update lit;   
        
        line_item__c litd=new line_item__c();
        litd.Id=lit.Id;
        
        delete litd;   
        
    }
}