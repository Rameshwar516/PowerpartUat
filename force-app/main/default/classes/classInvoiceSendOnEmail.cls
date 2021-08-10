public class classInvoiceSendOnEmail 
{
    public static wrappercl wrap;
    
    @AuraEnabled
    public static string intid(String invRecId)
    {
        try{
            wrap=new wrappercl();
            wrap.islineItemAvailable=true;
            wrap.success=true;
            wrap.successMessage='';
            wrap.errorMessage='';
            wrap.emailbody='';
            
            if(invRecId!=null){
                list<Invoice__c> inv=[select id,Email__c ,Contact_Person__r.name, OwnerId from Invoice__c where id=:invRecId limit 1];
                list<user> OwnerUser =[SELECT ID,Name,Mobilephone From User WHERE ID =: inv[0].Ownerid];
                
                user owner = OwnerUser[0];
                if(inv.size()>0){ 
                    list<Invoice_Line_Item__c> litm=[select id from Invoice_Line_Item__c where Invoice__c=:inv[0].id];
                    if(litm.size()<=0){
                        wrap.islineItemAvailable=false;
                    }
                    wrap.objinvoice=inv[0];
                    wrap.Subject ='Invoice';
                    if(wrap.objinvoice.Contact_Person__r.name!=null){
                        wrap.emailbody='Hello Mr.'+' '+wrap.objinvoice.Contact_Person__r.name +',';
                        wrap.emailbody= wrap.emailbody+' \n'+'\nPlease Find the attached Invoice.\n'+'Thank you.';
                        wrap.emailbody= wrap.emailbody+' \n \n'+owner.name;
                        if(String.isNotEmpty(owner.Mobilephone))
                            wrap.emailbody= wrap.emailbody+' \n'+owner.Mobilephone;
                    }
                }
            }
        }
        catch(exception ex){
            wrap.success=false;
            wrap.errorMessage=ex.getMessage();            
        }
        return json.serialize(wrap);
    }
    @AuraEnabled
    public static void send(String invRecId,String sub,String Bodyy , String mailAdd , string ccAdd)
    {
        system.debug('class calling...' + invRecId + ' email '+mailAdd  );
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        list<Invoice__c> inv=[select id,name,RecordType.DeveloperName,Contact_Person__r.name from Invoice__c where id=:invRecId limit 1];
        system.debug('class calling inv a' + inv.size());
        for(Invoice__c at:inv)
        {
            system.debug('at+id'+at.id);
            if(at.RecordType.DeveloperName=='Tax_Invoice')
            {
                PageReference defaultPage = page.TaxInvoicePDF; 
                
               // Attachment attachdoc = new Attachment();
                
                defaultPage.getParameters().put('id',at.Id); //passing in id for specific record
                Blob pageData; //variable to hold binary PDF data.
                
                if(!Test.isRunningTest())
                    pageData = defaultPage.getContentAsPDF();
                else 
                    pageData = Blob.valueOf('This is a test.');
                
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setBody(pageData);
                attach.setContentType('application/pdf');
                attach.setFileName(at.Name+'.pdf');
                
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
                
                List < String > sendTo = mailAdd.split(',');
                
                mail.setToAddresses(sendTo);
                system.debug('address');
                
                if(ccAdd!=null && ccAdd!=''){
                    List < String > ccsendTo = ccAdd.split(',');
                    
                    mail.setCcAddresses(ccsendTo);
                }
                mail.setReplyTo(UserInfo.getUserEmail()); 
                mail.setSenderDisplayName(UserInfo.getName());  
                mail.setSaveAsActivity(true);
                mail.setWhatId(at.id);
                mail.setSubject(sub);
                mail.setPlainTextBody(Bodyy);
                mails.add(mail);
                
                /*attachdoc.Body=pageData;   
                attachdoc.Name = at.name + ' ' + 'Tax Invoice' + '.pdf';
                attachdoc.ParentId = at.Id;
                attachdoc.IsPrivate=false;
                insert attachdoc;*/
                system.debug('method end');
                
                // content document
                String yourFilesContent = 'TaxInvoicePDF.pdf';
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'TaxInvoicePDF.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = 'Tax Invoice'; // Display name of the files
                conVer.VersionData = pageData; // converting your binary string to Blog
                insert conVer;    //Insert ContentVersion
                
                
                // First get the Content Document Id from ContentVersion Object
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                //create ContentDocumentLink  record 
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = at.id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                system.debug('LinkedEntityId   '+ conDocLink.LinkedEntityId);
                conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
                conDocLink.shareType = 'I';
                insert conDocLink;
            }
            ///////
            else if(at.RecordType.DeveloperName=='Service_Invoice')
            {
                PageReference defaultPage = page.ServiceInvoicePDF; 
                
                Attachment attachdoc = new Attachment();
                
                defaultPage.getParameters().put('id',at.Id); //passing in id for specific record
                Blob pageData; //variable to hold binary PDF data.
                
                if(!Test.isRunningTest())
                    pageData = defaultPage.getContentAsPDF();
                else 
                    pageData = Blob.valueOf('This is a test.');
                
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setBody(pageData);
                attach.setContentType('application/pdf');
                attach.setFileName(at.Name+'.pdf');
                
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
                
                List < String > sendTo = mailAdd.split(',');
                
                mail.setToAddresses(sendTo);
                system.debug('address');
                
                if(ccAdd!=null && ccAdd!=''){
                    List < String > ccsendTo = ccAdd.split(',');
                    
                    mail.setCcAddresses(ccsendTo);
                }
                mail.setReplyTo(UserInfo.getUserEmail()); 
                mail.setSenderDisplayName(UserInfo.getName());  
                mail.setSaveAsActivity(true);
                mail.setWhatId(at.id);
                mail.setSubject(sub);
                mail.setPlainTextBody(Bodyy);
                mails.add(mail);
                
                /*attachdoc.Body=pageData;   
                attachdoc.Name = at.name + ' ' + 'Service Invoice' + '.pdf';
                attachdoc.ParentId = at.Id;
                attachdoc.IsPrivate=false;
                insert attachdoc;*/
                system.debug('method end');
                  // content document
                
                String yourFilesContent = 'ServiceInvoicePDF';
 
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'ServiceInvoicePDF.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = 'Service Invoice'; // Display name of the files
                conVer.VersionData = pageData; // converting your binary string to Blog
                insert conVer;    //Insert ContentVersion
                
                
                // First get the Content Document Id from ContentVersion Object
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                //create ContentDocumentLink  record 
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = at.id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
                conDocLink.shareType = 'I';
                insert conDocLink;
            }
            if(mails.size()>0){
                Messaging.sendEmail(mails);
            }
        }
    }
    public class wrappercl
    {
        public string errorMessage;
        public string successMessage;
        public boolean success;
        public  Invoice__c objinvoice;
        public string emailbody;
        public string Subject;
        public boolean islineItemAvailable;
    }
}