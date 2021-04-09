/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          19-Dec-2019                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
@istest
public class ServiceRequestHandlerTest{
    @istest
    static void execute(){
        clsUtility.testDataCustomSetting();
        Account objAccOEM = clsUtility.testDataOEMAcc(5);
        Account objAccENDCustomer = clsUtility.testDataEndCustomerAcc(5);
        list<Asset__c> lstAssetAccountNumber = clsUtility.testDataCustomerAsset(objAccOEM,objAccENDCustomer,1);
        list<Service_Request__c> lstSR = clsUtility.testDataServiceRequest(5,true,lstAssetAccountNumber);
        clsUtility.testDataAddServiceTeam(lstSR,true);
        Asset__c objAss = new Asset__c();
        objAss.Name ='uniqueName Data test';
        objAss.OEM__c  = objAccOEM.Id;
        objAss.End_Customer__C  = objAccENDCustomer.Id;
        Insert objAss;
        lstSR[0].ESN__c = objAss.Id;
        update lstSR[0];
    }
}