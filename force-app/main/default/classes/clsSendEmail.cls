public class clsSendEmail
{
    @InvocableMethod
    public static void sendEmailToStoreManager(List<Id> Ids)
    {
        try
        {
            List<Service_Request__c > lstSR = new List<Service_Request__c>();
            lstSr = [Select Id, Name, Owner.Email, Owner.Name from Service_Request__c where Id IN: Ids];
            System.debug('List Service Request'+ lstSr);
            
            EmailTemplate etstoreMangerApproval = [SELECT Id,HtmlValue,subject,Body,DeveloperName FROM EmailTemplate where DeveloperName = 'Email_Alert_for_Store_Manager'];   
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            List<string> strContactsEmail= new List<string>();
            string strEmail = System.Label.Store_Manager_Email;
            if(strEmail.containsAny(','))
            {
                list<string> lstStr = strEmail.split(',');
                for(String str : lstStr)
                {
                    strContactsEmail.add(str);
                }
            }
            else
            {
            	strContactsEmail.add(strEmail);
            }
            if(lstSr.size()>0)
                for(Service_Request__c objSR : lstSr)
            {
                if(objSR.owner.Name != null && objSR.owner.Email != null)
                {   
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(strContactsEmail);
                    email.setSenderDisplayName(objSR.owner.Name);
                    email.setReplyTo(objSR.owner.email);
                    email.setTargetObjectId(objSR.owner.Id);
                    email.setTreatTargetObjectAsRecipient(false);
                    email.setWhatId(objSR.Id);
                    email.setSaveAsActivity(false);
                    email.setTemplateId(etstoreMangerApproval.Id);
                    mails.add(email);    
                }
            }
            
            if(mails.size()>0)
                Messaging.sendEmail(mails);
        }
        catch(Exception ex)
        {
            system.debug('Exception :'+ ex.getMessage());
            
        }
    }
}