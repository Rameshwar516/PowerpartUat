@isTest
public class clsSendEmail_Test {
    
    @isTest
    static void MethodOne() {
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        
        List<Id> lstId = new List<Id>();
        for(Service_Request__c objSR : lstServiceRequest) {
            lstId.add(objSR.Id);
        }
        
        Test.startTest();
        clsSendEmail.sendEmailToStoreManager(lstId);
        Test.stopTest();
        
    }

}