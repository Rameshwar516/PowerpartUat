@isTest
public class CreateServiceRequest_Test {
    
    @isTest
    static void MethodOne() {
        
        clsUtility.testDataCustomSetting();
        Account objAccOEM = clsUtility.testDataOEMAcc(5);
        Account objAccENDCustomer = clsUtility.testDataEndCustomerAcc(5);
        list<Asset__c> lstAssetAccountNumber = clsUtility.testDataCustomerAssetImportWard(objAccOEM,objAccENDCustomer,1);
        list<Service_Request__c> lstSR = clsUtility.testDataServiceRequest(1,true,lstAssetAccountNumber);
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.subject = 'TestSubject';
        email.plainTextBody = 'FromEmail';
        env.fromAddress = 'IlovemyIndia@gmail.com';
        
        
        // add an Text atatchment
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            
        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment Binary');
        attachment.fileName = 'binaryfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
         
        Test.startTest();    
        CreateServiceRequest  objSer = new CreateServiceRequest();
        objSer.handleInboundEmail(email, env);
        Test.stopTest();   
    }
}