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
                list<Quote__c> Qtt=[select id,Email__c ,Contact_Name__r.name from Quote__c where id=:QuotRecId limit 1];
                
                if(Qtt.size()>0){
                    list<Line_item__c> litm=[select id from line_item__c where Quote__c=:Qtt[0].id];
                    if(litm.size()<=0){
                        wrap.islineItemAvailable=false;
                    }
                    wrap.objquote=Qtt[0];
                    if(wrap.objquote.Contact_Name__r.name!=null){
                        wrap.emailbody='Hello Mr.'+' '+wrap.objquote.Contact_Name__r.name +',';
                        wrap.emailbody= wrap.emailbody+' \n'+'\nPlease Find the attached Quotation.\n'+'Thank you.';
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
        
        list<Quote__c> Qtt=[select id,name,Contact_Name__r.name from Quote__c where id=:QuotRecId limit 1];
        
        for(Quote__c at:Qtt){
            system.debug('at+id'+at.id);
            
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
            
            attachdoc.Body=pageData;   
            attachdoc.Name = at.name + ' ' + 'Quote' + '.pdf';
            attachdoc.ParentId = at.Id;
            attachdoc.IsPrivate=false;
            insert attachdoc;
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
        public boolean islineItemAvailable;
    }
}