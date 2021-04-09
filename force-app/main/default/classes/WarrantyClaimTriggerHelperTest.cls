@isTest
public class WarrantyClaimTriggerHelperTest {
    @isTest
    private static void inserPartRequestOfEnadCustomerTest()
    {
        clsUtility.testDataCustomSetting();
        list<Account> lstAcc = clsUtility.testDataAccountContact(5,5,false);
        Account acc = clsUtility.testDataEndCustomerAcc(10);
        list<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(lstAcc[0],acc,3);
        list<Service_Request__c> lstSR = clsUtility.testDataServiceRequest(3,false,lstAsset);
        
        List<Part__c> lstPart = new List<Part__c>();
        List<Part_Request__c> lstPartRequest = new List<Part_Request__c>();
        
        for(Integer i = 1; i<= 5 ; i++) {
            Part__c objPart = new Part__c(Part_Name__c = 'TestPart'+i,
                                          Name = 'TP'+i);
            lstPart.add(objPart);
        }
        insert lstPart;
        
        for(Service_Request__c objSR : lstSR) {
            for(Part__c objPart : lstPart) {
                for(integer i = 0;i<2;i++)
                {
                    Part_Request__c objPartReq = new Part_Request__c(Part__c = objPart.Id,Service_Request__c = objSR.Id);
                    lstPartRequest.add(objPartReq);
                }
            } 
        }
        insert lstPartRequest;  
        clsUtility.testInsertWarrantyCase(lstSR);
    }
}