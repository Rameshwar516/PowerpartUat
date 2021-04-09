@isTest
public class AddproductControllerTest {
    @isTest static void productTest(){
        // insert trigger on/Off custom setting of toolingSheet
        list<Trigger_Setting__c> accOnOffTLst = new list<Trigger_Setting__c>();
        Trigger_Setting__c objTrigFiles = new Trigger_Setting__c();
        objTrigFiles.Name = 'Account';
        objTrigFiles.Active__c = true;
        accOnOffTLst.add(objTrigFiles);
        insert accOnOffTLst;
        
        Generating_Account_Number__c accountNumber = new Generating_Account_Number__c();
        accountNumber.Name = 'Unique Number';
        insert accountNumber;
        integer intCountAccountNumber = integer.valueof(accountNumber.Unique_Number__c);
        //intCountAccountNumber = intCountAccountNumber++;

      //  @istest
    //static void execute(){
     //   clsUtility.testDataCustomSetting();
       // clsUtility.testDataAccountContact(20,20,true);
    //}
        
        Account aO = new Account();
        aO.Name = 'Test Account';
        aO.BillingCity = 'Agra';
        aO.Region__c = 'East'; 
        aO.Account_Number__c = intCountAccountNumber;
        insert aO; 
        
        Contact cO = new Contact();
        cO.AccountId = aO.Id;
        cO.LastName = 'Bhatiya';
        cO.Email = 'test@outlook.com';
        cO.MobilePhone = '8348583457';
        insert cO;
        
        Opportunity__c oO = new Opportunity__c();
        //oO.Name = 'Test Opp';
        oO.OEM_Customer__c = aO.Id;
        oO.Stage__c = 'New';
        oO.Opportunity_Close_Date__c = Date.newInstance(2021, 1, 9);
        insert oO; 
        
        Quote__c qO = new Quote__c();
       	qO.Customer_Party__c = aO.Id;
        qO.Contact_Name__c = cO.Id;
        qO.Opportunity__c = oO.Id;
        insert qO;
    }
}