@isTest
public class SendEmailCtrl_Test {
    
    @isTest
    static void MethodOne() {
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        lstServiceRequest[0].Status__c = 'Closed';
        lstServiceRequest[0].Customer_Comments__c = 'Test Customer comments';
        update lstServiceRequest[0];
        
        Test.startTest();
        String str = SendEmailCtrl.sendEMail(lstServiceRequest[0].Id);
        Test.stopTest();
    }
    
    @isTest
    static void MethodTwo() {
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        /*List<Contact> lstCon = [Select id, LastName, Email, AccountId from Contact where AccountId =: lstAsset[0].End_Customer__c];
        lstServiceRequest[0].Customer__c = lstCon[0].AccountId;
        lstServiceRequest[0].Contact_Person_Name__c = lstCon[0].Id;*/
        lstServiceRequest[0].Status__c = 'Closed';
        
        update lstServiceRequest[0];
        
        Test.startTest();
        String str = SendEmailCtrl.sendEMail(lstServiceRequest[0].Id);
        Test.stopTest();
    }
    
    @isTest
    static void MethodThree() {
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        
        update lstServiceRequest[0];
        
        Test.startTest();
        String str = SendEmailCtrl.sendEMail(lstServiceRequest[0].Id);
        Test.stopTest();
    }
    
    @isTest
    static void MethodFour() {
        
        Test.startTest();
        String str = SendEmailCtrl.sendEMail(null);
        Test.stopTest();
    }
    
}