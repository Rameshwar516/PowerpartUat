global class CheckOutcls
{
    public static string strResponse = '';
    
    @AuraEnabled
    public static string updateCheckOut(String strRecordId) 
    {
        ResponseWrapper objWrap = new ResponseWrapper();
        objWrap.success = true;
        objWrap.errorMessage = '';
        list<Service_Request__c> lstSRequest = new list<Service_Request__c>();
        try
        {
            if(strRecordId != null && strRecordId != '')
            { 
                List<Powerparts_Service_Request_Team__c> lstUpdatePSRT = new List<Powerparts_Service_Request_Team__c>();
                Id strCurrentUserId = UserInfo.getUserId() ;
                
                List<Service_Request__c> lstSR = [Select Id,Primary_Engineer_Check_Out__c  , Status__c,Date_Time_Attended__c,Closed_Date_Time__c from Service_Request__c where Id =: strRecordId Limit 1];
                if(lstSR.size() > 0)
                {
                    List<Powerparts_Service_Request_Team__c> lstPSRT = [SELECT Id,Name,Engineer1_Check_In__c,Engineer1_Check_Out__c,Engineer1__c,Engineer2_Check_In__c,Engineer2_Check_Out__c,Engineer2__c,Engineer3_Check_In__c,Engineer3_Check_Out__c,Engineer3__c,Engineer4_Check_In__c,Engineer4_Check_Out__c,Engineer4__c,Service_Request__c,Service_Request__r.Primary_Engineer_Check_Out__c 
                                                                        FROM Powerparts_Service_Request_Team__c
                                                                        Where Service_Request__c =: lstSR[0].Id Limit 1];
                    if(lstPSRT.size() > 0)
                    {
                        
                        if(lstSR[0].Status__c != 'On Hold')
                        {
                            if(lstSR[0].Closed_Date_Time__c == null && lstSR[0].Status__c != 'Closed')
                            {
                                if(strCurrentUserId != null)
                                {
                                    if(strCurrentUserId == lstPSRT[0].Engineer1__c)
                                    {
                                        if(lstPSRT[0].Engineer1_Check_In__c != null )
                                        {
                                            if(lstPSRT[0].Engineer1_Check_Out__c == null || lstPSRT[0].Engineer1_Check_Out__c.Date() != System.today())
                                            {
                                                lstPSRT[0].Engineer1_Check_Out__c = system.now();
                                                Service_Request__c objSR = new Service_Request__c();
                                                objSR.Id = lstPSRT[0].Service_Request__c;
                                                objSR.Primary_Engineer_Check_Out__c  = system.now();
                                                lstSRequest.add(objSR);
                                                system.debug('...objSR...'+objSR);
                                                lstUpdatePSRT.add(lstPSRT[0]);
                                            }
                                            else
                                            {
                                                objWrap.success = false;
                                                objWrap.errorMessage = system.label.Check_Out;
                                            }
                                        }
                                        else
                                        {
                                                objWrap.success = false;
                                                objWrap.errorMessage = 'Please Check In First.';
                                        }
                                    }
                                    else if(strCurrentUserId == lstPSRT[0].Engineer2__c)
                                    {
                                        if(lstPSRT[0].Engineer2_Check_In__c != null )
                                        {
                                            if(lstPSRT[0].Engineer2_Check_Out__c == null || lstPSRT[0].Engineer2_Check_Out__c.Date() != System.today())
                                            {
                                                lstPSRT[0].Engineer2_Check_Out__c = system.now();
                                                lstUpdatePSRT.add(lstPSRT[0]);
                                            }
                                            else
                                            {
                                                objWrap.success = false;
                                                objWrap.errorMessage = system.label.Check_Out;
                                            }
                                        }
                                        else
                                        {
                                                objWrap.success = false;
                                                objWrap.errorMessage = 'Please Check In First.';
                                        }
                                        
                                    }
                                    else if(strCurrentUserId == lstPSRT[0].Engineer3__c)
                                    {
                                        if(lstPSRT[0].Engineer3_Check_In__c != null )
                                        {
                                            if(lstPSRT[0].Engineer3_Check_Out__c == null || lstPSRT[0].Engineer3_Check_Out__c.Date() != System.today())
                                            {
                                                lstPSRT[0].Engineer3_Check_Out__c = system.now();
                                                lstUpdatePSRT.add(lstPSRT[0]);
                                            }
                                            else
                                            {
                                                objWrap.success = false;
                                                objWrap.errorMessage = system.label.Check_Out;
                                            }
                                        }
                                        else
                                        {
                                                objWrap.success = false;
                                                objWrap.errorMessage = 'Please Check In First.';
                                        }
                                        
                                    }
                                    else if(strCurrentUserId == lstPSRT[0].Engineer4__c)
                                    {
                                        if(lstPSRT[0].Engineer4_Check_In__c != null )
                                        {
                                            if(lstPSRT[0].Engineer4_Check_Out__c == null || lstPSRT[0].Engineer4_Check_Out__c.Date() != System.today())
                                            {
                                                lstPSRT[0].Engineer4_Check_Out__c = system.now();
                                                lstUpdatePSRT.add(lstPSRT[0]);
                                            }
                                            else
                                            {
                                                objWrap.success = false;
                                                objWrap.errorMessage = system.label.Check_Out;
                                            }
                                        }
                                        else
                                        {
                                                objWrap.success = false;
                                                objWrap.errorMessage = 'Please Check In First.';
                                        }
                                    }
                                    else
                                    {
                                        objWrap.success = false;
                                        objWrap.errorMessage = 'This Service Request is not assign you.';
                                    }
                                }
                            }
                            else
                            {
                                objWrap.success = false;
                                objWrap.errorMessage = 'Service Request has been closed.'; 
                            }
                        }
                        else
                        {
                            objWrap.success = false;
                            objWrap.errorMessage = 'You Can not update record.Status is On Hold.';   
                        }
                    }
                    else
                    {
                        objWrap.success = false;
                        objWrap.errorMessage = 'The team is not created.';   
                    }
                }
                if(lstUpdatePSRT.size()>0)
                    update lstUpdatePSRT;
                
                if(lstSRequest.size()>0)
                    update lstSRequest;
                    
                system.debug('.........'+lstUpdatePSRT.size());  
                 system.debug('..lstSRequest.......'+lstSRequest.size());   
                
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