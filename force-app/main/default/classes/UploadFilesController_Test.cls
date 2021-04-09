@isTest
public class UploadFilesController_Test {
    
    @isTest
    Static void MethodOne(){
    Test.startTest();
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        clsUtility.testDataContentDoc(lstServiceRequest, 5);
        
        UploadFilesController.wrapper obj = new UploadFilesController.wrapper();
        
        String str = UploadFilesController.InitValue(lstServiceRequest[0].Id);
        List<ContentDocument>  lstCD = [SELECT Id, Title, LatestPublishedVersionId, FileExtension FROM ContentDocument Limit 3];
        String strCD ='';
        for(ContentDocument objCD : lstCD) {
            if(strCD == '' )
                strCD = objCD.Id;
            else
                strCD =  strCD+','+objCD.Id;
        }
        str = UploadFilesController.UpdateFiles(strCD,lstServiceRequest[0].Id,str);
        str = UploadFilesController.RenameFiles(str);
        Test.stopTest();
        
        
        
    }

}