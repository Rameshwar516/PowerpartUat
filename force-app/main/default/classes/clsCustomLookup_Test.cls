@isTest
public class clsCustomLookup_Test {
    
    @isTest
    Static void MethodOne() {
       
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddPartRequest(lstServiceRequest, 3);
        
        Test.startTest();
        List<Part__c> lstPart = clsCustomLookup.searchLookupValue('','Part__c');
        System.assertEquals(3, lstPart.size());
        Test.stopTest();
    }
    
    @isTest
    Static void MethodTwo() {
       
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddPartRequest(lstServiceRequest, 3);
        
        Test.startTest();
        List<Part__c> lstPart = clsCustomLookup.searchLookupValue('TP','Part__c');
        System.assertEquals(3, lstPart.size());
        Test.stopTest();
    }

}