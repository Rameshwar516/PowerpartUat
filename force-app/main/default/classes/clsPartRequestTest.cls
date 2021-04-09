/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          19-Dec-2019                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
@istest
public class clsPartRequestTest{
    @istest
    static void execute(){
        clsUtility.testDataCustomSetting();
        Account objAccOEM = clsUtility.testDataOEMAcc(5);
        Account objAccENDCustomer = clsUtility.testDataEndCustomerAcc(5);
        list<Asset__c> lstAssetAccountNumber = clsUtility.testDataCustomerAssetImportWard(objAccOEM,objAccENDCustomer,1);
        list<Service_Request__c> lstSR = clsUtility.testDataServiceRequest(5,true,lstAssetAccountNumber);
        //clsUtility.testDataAddPartRequest(lstSR,3);
        clsPartRequest.doInit(lstSR[0].Id);
        
        clsPartRequest.wrapper objWrap = new clsPartRequest.wrapper();
        String strWrap = clsPartRequest.doInit(lstSR[0].Id);
        objWrap = (clsPartRequest.wrapper)Json.deserialize(strWrap, clsPartRequest.wrapper.class);
        List<clsPartRequest.partReqWrapper> lstPartWarp =  objWrap.lstPartReqWrap;
        string strPartReq = Json.serialize(lstPartWarp);
        clsPartRequest.Submit(strPartReq,lstSR[0].Id);
        clsPartRequest.deletePR(lstSR[0].Id,lstPartWarp[0].objPartReq.Id);
    }
    
    @istest
    static void executeElse(){
        clsUtility.testDataCustomSetting();
        Account objAccOEM = clsUtility.testDataOEMAcc(5);
        Account objAccENDCustomer = clsUtility.testDataEndCustomerAcc(5);
        list<Asset__c> lstAssetAccountNumber = clsUtility.testDataCustomerAssetImportWard(objAccOEM,objAccENDCustomer,1);
        list<Service_Request__c> lstSR = clsUtility.testDataServiceRequest(5,true,lstAssetAccountNumber);
        clsUtility.testDataAddPartRequest(lstSR,3);
        clsPartRequest.doInit(lstSR[0].Id);
        
        clsPartRequest.wrapper objWrap = new clsPartRequest.wrapper();
        String strWrap = clsPartRequest.doInit(lstSR[0].Id);
        objWrap = (clsPartRequest.wrapper)Json.deserialize(strWrap, clsPartRequest.wrapper.class);
        List<clsPartRequest.partReqWrapper> lstPartWarp =  objWrap.lstPartReqWrap;
        string strPartReq = Json.serialize(lstPartWarp);
        clsPartRequest.Submit(strPartReq,lstSR[0].Id);
        clsPartRequest.deletePR(lstSR[0].Id,lstPartWarp[0].objPartReq.Id);
    }
}