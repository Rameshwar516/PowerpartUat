@isTest
public class ServiceReportPDFController_Test {
    
    @isTest
    Static void MethodOne()
    {
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        clsUtility.testDataContentDoc(lstServiceRequest, 2);
        
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', lstServiceRequest[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(lstServiceRequest[0]);
        ServiceReportPDFController objSCReport = new ServiceReportPDFController(sc);
        Test.stopTest();
    }

}