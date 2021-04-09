/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          17-Dec-2019                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
@istest
public class AssetTriggerHelperTest{
    @istest
    static void execute(){
        clsUtility.testDataCustomSetting();
        Account objAccOEM = clsUtility.testDataOEMAcc(5);
        Account objAccENDCustomer = clsUtility.testDataEndCustomerAcc(5);
        list<Asset__c> lstAssetAccountNumber = clsUtility.testDataCustomerAssetImportWard(objAccOEM,objAccENDCustomer,1);
    }
}