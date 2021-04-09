@isTest
public class clsSurvey_Test {

    @isTest
    static void MethodOne() {
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        
        Test.startTest();
        String strwrap = clsSurvey.doInit(lstServiceRequest[0].Id);
        string strIP = '245.245.245.245';
        strwrap = clsSurvey.invoke(strwrap, lstServiceRequest[0].Id, strIP);
        Test.stopTest();
        
    }
}