global class CheckIncls
{
    public static string strResponse = '';
    
    @AuraEnabled
    public static string updateCheckIn(String strRecordId) 
    {
        ResponseWrapper objWrap = new ResponseWrapper();
        objWrap.success = true;
        objWrap.errorMessage = '';
        try
        {
            if(strRecordId != null && strRecordId != '')
            { 
                List<Powerparts_Service_Request_Team__c> lstUpdatePSRT = new List<Powerparts_Service_Request_Team__c>();
                list<Service_Request__c> lstupdateSr = new list<Service_Request__c>();
                Id strCurrentUserId = UserInfo.getUserId() ;
                
                List<Service_Request__c> lstSR = [Select Id,(SELECT Id, Name, Other_Safety_Hazard__c, Service_Request__c, Fire_Hazard__c FROM Safety_rules__r), Status__c,Date_Time_Attended__c,Work_Start_Time__c,Closed_Date_Time__c,Visit_ReportedTime__c from Service_Request__c where Id =: strRecordId Limit 1];
                if(lstSR.size() > 0)
                {
                    List<Powerparts_Service_Request_Team__c> lstPSRT = [SELECT Id,Name,Engineer1_Check_In__c,Engineer1_Check_Out__c,Engineer1__c,Engineer2_Check_In__c,Engineer2_Check_Out__c,Engineer2__c,Engineer3_Check_In__c,Engineer3_Check_Out__c,Engineer3__c,Engineer4_Check_In__c,Engineer4_Check_Out__c,Engineer4__c,Service_Request__r.Work_Start_Time__c,Service_Request__c 
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
                                        if(lstPSRT[0].Engineer1_Check_In__c == null || lstPSRT[0].Engineer1_Check_In__c.Date() != System.today())
                                        {
                                            lstPSRT[0].Engineer1_Check_In__c = system.now();
                                            lstUpdatePSRT.add(lstPSRT[0]);
                                        }
                                        else
                                        {
                                            objWrap.success = false;
                                            objWrap.errorMessage = system.label.Check_IN;
                                        }
                                        if(lstSR[0].Visit_ReportedTime__c == null )
                                        {
                                            if(lstSR[0].Work_Start_Time__c == null )
                                            {
                                                //lstSR[0].Work_Start_Time__c  = system.now();
                                            }
                                            lstSR[0].Visit_ReportedTime__c  = system.now();
                                            lstupdateSr.add(lstSR[0]);
                                            System.debug('lstSR[0].Visit_ReportedTime__c--'+lstSR[0].Visit_ReportedTime__c);
                                            
                                        }
                                        
                                    }
                                    else if(strCurrentUserId == lstPSRT[0].Engineer2__c)
                                    {
                                        if(lstPSRT[0].Engineer2_Check_In__c == null || lstPSRT[0].Engineer2_Check_In__c.Date() != System.today())
                                        {
                                            lstPSRT[0].Engineer2_Check_In__c = system.now();
                                            lstUpdatePSRT.add(lstPSRT[0]);
                                        }
                                        else
                                        {
                                            objWrap.success = false;
                                            objWrap.errorMessage = system.label.Check_IN;
                                        }
                                        
                                    }
                                    else if(strCurrentUserId == lstPSRT[0].Engineer3__c)
                                    {
                                        if(lstPSRT[0].Engineer3_Check_In__c == null || lstPSRT[0].Engineer3_Check_In__c.Date() != System.today())
                                        {
                                            lstPSRT[0].Engineer3_Check_In__c = system.now();
                                            lstUpdatePSRT.add(lstPSRT[0]);
                                        }
                                        else
                                        {
                                            objWrap.success = false;
                                            objWrap.errorMessage = system.label.Check_IN;
                                        }
                                        
                                    }
                                    else if(strCurrentUserId == lstPSRT[0].Engineer4__c)
                                    {
                                        if(lstPSRT[0].Engineer4_Check_In__c == null || lstPSRT[0].Engineer4_Check_In__c.Date() != System.today())
                                        {
                                            lstPSRT[0].Engineer4_Check_In__c = system.now();
                                            lstUpdatePSRT.add(lstPSRT[0]);
                                        }
                                        else
                                        {
                                            objWrap.success = false;
                                            objWrap.errorMessage = system.label.Check_IN;
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
                {
                 update lstUpdatePSRT;   
                }
                    
                if(lstupdateSr.size()>0)
                {
                  update lstupdateSr;
                }
                
            }
            else
            {
                objWrap.success = false;
                objWrap.errorMessage = 'Invalid record id.';
            }
        }
        catch(DMLException ex)
        {
            objWrap.success = false;
            objWrap.errorMessage = ex.getDmlMessage(0);
        } 
        return Json.serialize(objWrap);
    }
    
    public class ResponseWrapper{
        public boolean success;
        public string errorMessage;
    }
}