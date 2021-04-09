public without sharing class clsSurvey {
    
    @AuraEnabled
    public static string doInit(string strParentRecId)
    {
        wrapper objWrap = new wrapper();
        objWrap.objFeedback = new Feedback__c();
        objWrap.objContact = new contact();
        objWrap.objCmpName = '';
        objWrap.strCustomerCom ='';
        objWrap.DateofSurvey = System.today();
        objWrap.strError ='';
        objWrap.strSuccess ='';
        objWrap.success = false;
        if(strParentRecId != '' && strParentRecId != null)
        {
           objWrap.success = true;
           List<Service_Request__c>  lstSR = [Select id, Contact_Person_Name__c,Customer_Name__c from Service_Request__c where id =: strParentRecId];
            if(lstSR.size() > 0)
            {
                objWrap.objCmpName = lstSR[0].Customer_Name__c;
                List<Contact> lstCon = [Select id, Name,Email,AccountId, MobilePhone, OtherPhone from Contact where Id =: lstSR[0].Contact_Person_Name__c];
                if(lstCon.size() > 0)
                {
                    objWrap.objContact = lstCon[0];
                }
                
            }
        }
        return JSON.serialize(objWrap);
    }
    
    @AuraEnabled
    public static string invoke(string strmainWrap, string strSRId, String clientIP)
    {
        wrapper objWrap = (wrapper)JSON.deserialize(strmainWrap, wrapper.class);
        try
        {
            List<Service_Request__c>  lstSR = [Select id, Contact_Person_Name__c,Customer_Name__c,Customer_Comments__c, showServiceReqCMP__c, Customer_Email__c  from Service_Request__c where id =: strSRId];
            if(lstSR.size() > 0)
            {
                lstSR[0].Customer_Comments__c = objWrap.strCustomerCom;
                lstSR[0].showServiceReqCMP__c = true;
                update lstSR[0];
                
                objWrap.objFeedback.Service_Request__c = strSRId;
                objWrap.objFeedback.showFeedBackCMP__c = true;
                objWrap.objFeedback.User_Public_IP_Address__c = clientIP;
                insert objWrap.objFeedback;
                
                EmailMessage objEM = new EmailMessage();
                objEM.RelatedToId = strSRId;
                objEM.Status = '3';
                objEM.Subject = 'Submitted Feedback Form.';
                if(lstSR[0].Customer_Email__c != null)
                    objEM.toAddress = lstSR[0].Customer_Email__c;
                insert objEM;
                
                objWrap.success = true;
                objWrap.strSuccess = 'Thank you for submitting our feedback form';
                
            }
        }
        catch(DMLException de)
        {
           objWrap.success = false;
           objWrap.strError =de.getDmlMessage(0);
        }
        return JSON.serialize(objWrap);
    }  
    
    public class wrapper
    {
        public Feedback__c objFeedback;
        public contact objContact;
        public string objCmpName ;
        public string strCustomerCom;
        public date DateofSurvey ;
        public string strError;
        public string strSuccess;
        public boolean success;
    }
}