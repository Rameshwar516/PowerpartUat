global class CreateServiceRequest implements Messaging.InboundEmailHandler 
{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) 
    {
        System.debug('result#########'+email);
        System.debug('envelope#######'+envelope);
        
        List<Group> lstgroup = [select id, name, type from group where type = 'queue' AND name = 'Service Request Queue'];
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        System.debug('############'+result);
        Service_Request__c objServReq = new Service_Request__c();
        objServReq.Status__c = 'New';
        objServReq.isServiceReqCreatedByEmail__c = true;
        objServReq.Issue_Reported__c = email.subject;
        objServReq.Complaint_Description__c = email.plainTextBody;
        objServReq.OwnerId = lstgroup[0].Id;
        insert objServReq;
        
        // Save attachments, if any
        if(email.textAttachments != null)
            for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                Attachment attachment = new Attachment();
                
                attachment.Name = tAttachment.fileName;
                attachment.Body = Blob.valueOf(tAttachment.body);
                attachment.ParentId = objServReq.Id;
                insert attachment;
            }
        
        //Save any Binary Attachment
        if(email.binaryAttachments != null)
            for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                Attachment attachment = new Attachment();
                
                attachment.Name = bAttachment.fileName;
                attachment.Body = bAttachment.body;
                attachment.ParentId = objServReq.Id;
                insert attachment;
            }

    result.success = true;
        return result;
    }
}