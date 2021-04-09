@isTest
public class clsServiceReport_Test {
    
    @isTest
    Static void MethodOne() {
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        clsUtility.testDataContentDoc(lstServiceRequest, 2);
        clsUtility.testDataFeedBack(lstServiceRequest);
		
        Test.startTest();
        clsServiceReport.wrapper objWrap = new clsServiceReport.wrapper();
        String strWrap = clsServiceReport.doInit(lstServiceRequest[0].Id);
        clsServiceReport.Submit(strWrap);
        Test.stopTest();
    }

}