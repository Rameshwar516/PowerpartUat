public class ClassOnPIEmailSend {
    
    public static wrappercl wrap;
    
    @AuraEnabled
    public static string intid(String opprecid){
        try{
           wrap=new wrappercl();
            wrap.islineItemAvailable=true;
            wrap.success=true;
            wrap.successMessage='';
            wrap.errorMessage='';
            wrap.emailbody='';
            
            if(opprecid!=null){
                list<opportunity__c> opp=[select id,Contact_Person__r.Email ,Contact_Person__r.name,OwnerId from opportunity__c where id=:opprecid limit 1];
                list<user> OwnerUser =[SELECT ID,Name,Mobilephone From User WHERE ID =: opp[0].Ownerid];
                
                user owner = OwnerUser[0];
            if(opp.size()>0){
         list<Line_item__c> litm=[select id from line_item__c where opportunity__c=:opp[0].id];
                if(litm.size()<=0){
                     wrap.islineItemAvailable=false;
                }
               wrap.objquote=opp[0];
                wrap.Subject ='Proforma Invoice';
                if(wrap.objquote.Contact_Person__r.name!=null){
                  wrap.emailbody='Hello Mr.'+' '+wrap.objquote.Contact_Person__r.name +',';
                  wrap.emailbody= wrap.emailbody+' \n'+'\nPlease Find the attached Proforma Invoice.\n'+'Thank you.';
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
    public static void send(String opprecid,String sub,String Bodyy , String mailAdd , string ccAdd){
        system.debug('class calling...');
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     

        list<opportunity__c> Qtt=[select id,name,Contact_Person__r.name from opportunity__c where id=:opprecid limit 1];
        
        for(opportunity__c at:Qtt){
            system.debug('at+id'+at.id);
               
            PageReference defaultPage = page.Proforma_Invoice_pdf; 
            
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
            attachdoc.Name = at.name + ' ' + 'PI' + '.pdf';
            attachdoc.ParentId = at.Id;
            attachdoc.IsPrivate=false;
            insert attachdoc;*/
              // content document
                
                String yourFilesContent = 'Proforma_Invoice_pdf.pdf';
 
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'Proforma_Invoice_pdf.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = 'Proforma Invoice'; // Display name of the files
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
    public class wrappercl{
        public string errorMessage;
        public string successMessage;
        public boolean success;
        public  opportunity__c objquote;
        public string emailbody;
        public string subject;
        public boolean islineItemAvailable;
    }


}