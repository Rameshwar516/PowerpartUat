public class ClassOnQuoteEmailSend {
    
    public static wrappercl wrap;
    
    @AuraEnabled
    public static string intid(String QuotRecId){
        try{
            wrap=new wrappercl();
            wrap.islineItemAvailable=true;
            wrap.success=true;
            wrap.successMessage='';
            wrap.errorMessage='';
            wrap.emailbody='';
            
            if(QuotRecId!=null){
                list<Quote__c> Qtt=[select id,Email__c ,Contact_Name__r.name, OwnerId from Quote__c where id=:QuotRecId limit 1];
                list<user> OwnerUser =[SELECT ID,Name,Mobilephone From User WHERE ID =: Qtt[0].Ownerid];
                
                user owner = OwnerUser[0];
                if(Qtt.size()>0){ 
                    list<Line_item__c> litm=[select id from line_item__c where Quote__c=:Qtt[0].id];
                    if(litm.size()<=0){
                        wrap.islineItemAvailable=false;
                    }
                    wrap.objquote=Qtt[0];
                    wrap.Subject ='Quotation';
                    if(wrap.objquote.Contact_Name__r.name!=null){
                        wrap.emailbody='Hello Mr.'+' '+wrap.objquote.Contact_Name__r.name +',';
                        wrap.emailbody= wrap.emailbody+' \n'+'\nPlease Find the attached Quotation.\n'+'Thank you.';
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
    public static void send(String QuotRecId,String sub,String Bodyy , String mailAdd , string ccAdd){
        system.debug('class calling...');
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
         
        list<Quote__c> Qtt=[select id,name,RecordType.DeveloperName,Contact_Name__r.name from Quote__c where id=:QuotRecId limit 1];
        
        for(Quote__c at:Qtt)
        {
            system.debug('at+id'+at.id);
            if(at.RecordType.DeveloperName=='Sales')
            {
            PageReference defaultPage = page.QuotePdf; 
            
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
            
            // List<String> sendTo = new List<String>();
            //sendTo.add(mailAdd);
            List < String > sendTo = mailAdd.split(',');
            
            mail.setToAddresses(sendTo);
            system.debug('');
            
            if(ccAdd!=null && ccAdd!=''){
                //List<String> ccsendTo = new List<String>();
                //ccsendTo.add(ccAdd); 
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
            
           /* attachdoc.Body=pageData;   
            attachdoc.Name = at.name + ' ' + 'Quote' + '.pdf';
            attachdoc.ParentId = at.Id;
            attachdoc.IsPrivate=false;
            insert attachdoc;*/
                 // content document
                
                String yourFilesContent = 'QuotePdf.pdf';
 
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'QuotePdf.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = 'Sales Quotation'; // Display name of the files
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
            //////////////////////////////////
            else if(at.RecordType.DeveloperName=='AMC')
            {
            PageReference defaultPage = page.AMCQuote; 
            
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
            
            // List<String> sendTo = new List<String>();
            //sendTo.add(mailAdd);
            List < String > sendTo = mailAdd.split(',');
            
            mail.setToAddresses(sendTo);
            system.debug('');
            
            if(ccAdd!=null && ccAdd!=''){
                //List<String> ccsendTo = new List<String>();
                //ccsendTo.add(ccAdd); 
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
            attachdoc.Name = at.name + ' ' + 'Quote' + '.pdf';
            attachdoc.ParentId = at.Id;
            attachdoc.IsPrivate=false;
            insert attachdoc;*/
                    // content document
                
                String yourFilesContent = 'AMCQuote.pdf';
 
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'AMCQuote.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = 'AMC Quotation'; // Display name of the files
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
            /////////////////////////////////
            else if(at.RecordType.DeveloperName=='Service')
            {
            PageReference defaultPage = page.ServiceQuote; 
            
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
            
            // List<String> sendTo = new List<String>();
            //sendTo.add(mailAdd);
            List < String > sendTo = mailAdd.split(',');
            
            mail.setToAddresses(sendTo);
            system.debug('');
            
            if(ccAdd!=null && ccAdd!=''){
                //List<String> ccsendTo = new List<String>();
                //ccsendTo.add(ccAdd); 
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
            attachdoc.Name = at.name + ' ' + 'Quote' + '.pdf';
            attachdoc.ParentId = at.Id;
            attachdoc.IsPrivate=false;
            insert attachdoc;*/
                  // content document
                
                String yourFilesContent = 'ServiceQuote.pdf';
 
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'ServiceQuote.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = 'Service Quotation'; // Display name of the files
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
        }   
        if(mails.size()>0){
            Messaging.sendEmail(mails);
        }
        
        
    }
    public class wrappercl{
        public string errorMessage;
        public string successMessage;
        public boolean success;
        public  quote__c objquote;
        public string emailbody;
        public string Subject;
        public boolean islineItemAvailable;
    }
}