global class SendEmailCtrl
{
    public static string strResponse = '';
    
    @AuraEnabled
    public static string sendEMail(String strRecordId) 
    {
        ResponseWrapper objWrap = new ResponseWrapper();
        objWrap.success = true;
        objWrap.errorMessage = '';
        try
        {
            if(strRecordId != null && strRecordId != '')
            {
                list<EmailMessage> lstEM = new list<EmailMessage>();
                list<Service_Request__c> lstSR = new list<Service_Request__c>();
                lstSR = [Select Id, ESN__c, Contact_Person_Name__c, Customer_Email__c ,Contact_Person_Name__r.Name, Contact_Person_Name__r.Email,Customer_Comments__c,Status__c, showServiceReqCMP__c from Service_Request__c where Status__c ='Closed' AND Id =: strRecordId];
                if(lstSR.size()>0)
                {
                   EmailTemplate etFback = [SELECT Id,HtmlValue,subject,Body,DeveloperName FROM EmailTemplate where DeveloperName = 'FeedBack_Form'];
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    system.debug('...lstSR[0].Customer_Comments__c..'+lstSR[0].Customer_Comments__c);
                    If(lstSR[0].showServiceReqCMP__c )
                    {
                        objWrap.success = false;
                        objWrap.errorMessage = 'Customer comment already submitted.';
                    }
                    else
                    {
                        if(lstSR[0].Contact_Person_Name__c != null && lstSR[0].Contact_Person_Name__r.Email != null)
                        {
                            list<string> strContactsEmail= new list<string>();
                            strContactsEmail.add(lstSR[0].Contact_Person_Name__r.Email);
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                            string strBody = etFback.HtmlValue;
                            string strSubject = etFback.subject;
                            strBody = strBody.replace('#CustomerName', lstSR[0].Contact_Person_Name__r.Name);
                            strBody = strBody.replace('#ID', lstSR[0].Id);
                            email.setToAddresses(strContactsEmail);
                            email.setSubject(strSubject);
                            email.setHtmlBody(strBody);
                            mails.add(email);  
                            
                            EmailMessage objEM = new EmailMessage();
                            objEM.RelatedToId = lstSR[0].Id;
                            objEM.Status = '3';
                            objEM.Subject = 'Sent Feedback Form.';
                            if(lstSR[0].Customer_Email__c != null)
                                objEM.toAddress = lstSR[0].Contact_Person_Name__r.Email;
                            lstEM .add(objEM);
                        }
                        else
                        {
                            objWrap.success = false;
                            objWrap.errorMessage = 'Contact person not have an email.';
                        }
                    }
                    
                     if(mails.size()>0)
                        Messaging.sendEmail(mails);
                       
                     if(lstEM.size()>0)
                         insert lstEM;   
                }
                else
                {
                   objWrap.success = false;
                   objWrap.errorMessage = 'Service Request is not closed.'; 
                }
            }
            else
            {
                objWrap.success = false;
                objWrap.errorMessage = 'Invalid record id.';
            }
        }
        catch(Exception e)
        {
            objWrap.success = false;
            objWrap.errorMessage = ''+e.getMessage();
        } 
        return Json.serialize(objWrap);
    }
    
    public class ResponseWrapper{
        public boolean success;
        public string errorMessage;
    }
}