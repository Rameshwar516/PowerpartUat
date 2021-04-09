// ===============================================================================================
// 1. This Tracker class is used for class ServiceRequestTrigger. Parent Service Request need to 
// autopopulate if the new Customer Asset getting issue under 6 month.
// 2. Populate End Customer and its Primary Contact which is related to Asset which is going 
// to insert or update on Service Request.
// ===============================================================================================
//      Version      Date                Author                 Description
// ===============================================================================================
//      1.0        Nov.22, 2019         Anurag Kumar            Initial Version
// ===============================================================================================

public class ServiceRequestHandler {
    
    public static void ServiceRequestTriggerExecute(list<Service_Request__c> triggerNew,Map<Id,Service_Request__c> triggerNewMap,list<Service_Request__c> triggerOld,Map<Id,Service_Request__c> triggeroldMap,boolean isAfter,boolean isBefore,boolean isInsert,boolean isUpdate,boolean isDelete)
    {
        if(isInsert && isBefore)
        {
            OnBeforeInsert(triggerNew);
        }
        
        if(isInsert && isAfter)
        {
            OnAfterInsert(triggerNew);
        }
        
        if(isUpdate && isBefore)
        {
            OnBeforeUpdate(triggerNew, triggeroldMap);
        }
        
        if(isUpdate && isafter)
        {
            OnAfterUpdate(triggerNew, triggeroldMap);
            OnAfterChangeRunningHours(triggerNew, triggeroldMap);
        }
    }
    
    public static void OnAfterUpdate( List<Service_Request__c> triggerNew, Map<Id,Service_Request__c> triggeroldMap)
    {
        set<Id> setOfSR = new set<Id>();
        list<Service_Request__Share> lstServiceReqShare = new list<Service_Request__Share>();
        for(Service_Request__c objSR : triggerNew)
        {
            if(objSR.OwnerId != null && objSR.OwnerId != triggeroldMap.get(objSR.Id).OwnerId)
            {
                setOfSR.add(objSR.Id);
            }
        }
        if(setOfSR.size()>0)
        {
            for(Powerparts_Service_Request_Team__c objSRT : [Select Id, Name, Service_Request__c, Engineer1__c, Engineer2__c, Engineer3__c, Engineer4__c from Powerparts_Service_Request_Team__c where Service_Request__c IN: setOfSR])
            {
                 if(objSRT.Engineer1__c != null)
                { 
                    Service_Request__Share objSRTNew = new Service_Request__Share();
                    objSRTNew.AccessLevel = 'edit';
                    if(objSRT.Service_Request__c != null)
                        objSRTNew.ParentId = objSRT.Service_Request__c;
                    objSRTNew.UserOrGroupId = objSRT.Engineer1__c;
                    objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                    //lstServiceReqShare.add(objSRTNew);
                    system.debug('...objSRTNew...'+objSRTNew);
                }
                if(objSRT.Engineer2__c != null)
                {
                    Service_Request__Share objSRTNew = new Service_Request__Share();
                    objSRTNew.AccessLevel = 'edit';
                    if(objSRT.Service_Request__c != null)
                        objSRTNew.ParentId = objSRT.Service_Request__c;
                    objSRTNew.UserOrGroupId = objSRT.Engineer2__c;
                    objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                    lstServiceReqShare.add(objSRTNew);
                }       
                if(objSRT.Engineer3__c != null)
                {
                    Service_Request__Share objSRTNew = new Service_Request__Share();
                    objSRTNew.AccessLevel = 'edit';
                    if(objSRT.Service_Request__c != null)
                        objSRTNew.ParentId = objSRT.Service_Request__c;
                    objSRTNew.UserOrGroupId = objSRT.Engineer3__c;
                    objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                    lstServiceReqShare.add(objSRTNew);
                }   
                if(objSRT.Engineer4__c != null)
                {
                    Service_Request__Share objSRTNew = new Service_Request__Share();
                    objSRTNew.AccessLevel = 'edit';
                    if(objSRT.Service_Request__c != null)
                        objSRTNew.ParentId = objSRT.Service_Request__c;
                    objSRTNew.UserOrGroupId = objSRT.Engineer4__c;
                    objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                    lstServiceReqShare.add(objSRTNew);
                }
            }   
            if(lstServiceReqShare.size()>0)
                insert lstServiceReqShare;  
        }
    }
    
    public static void OnAfterInsert( List<Service_Request__c> triggerNew)
    {
        map<string,Service_Request__c> mapSRRespectedHours = new map<string,Service_Request__c>();
        set<string> containsString = new set<string>();
        
        set<string> setOfSRCreatedBy = new set<string>();
        set<string> setOfRecordId = new set<string>();
        
        for(Service_Request__c objSR : triggerNew)
        {
            setOfSRCreatedBy.add(objSR.OwnerId);
            setOfRecordId.add(objSR.Id);
            if(objSR.ESN__c != null && objSR.Engine_Run_Hours__c != null && objSR.Engine_Run_Hours__c >0)
            {
                if(!containsString.contains(objSR.ESN__c))
                {
                    mapSRRespectedHours.put(objSR.ESN__c,objSR);
                    containsString.add(objSR.ESN__c);
                }
            }
        }
        
        map<string, Service_Request__c> mapOwnerRespectedSR = new map<string,Service_Request__c>();
        if(setOfSRCreatedBy.size()>0)
        {
            for(Service_Request__c objSR : [select Id, OwnerId,Owner.Name, CreatedDate from Service_Request__c where Id NOT IN: setOfRecordId and OwnerId IN: setOfSRCreatedBy order by createddate asc])
            {
                mapOwnerRespectedSR.put(objSR.OwnerId,objSR);
            }
        }
        
        if(mapSRRespectedHours.size()>0)
        {
            
            list<Asset__c> lstAsset = new list<Asset__c>();
            for(Asset__c objAss : [select Id,Name,CreatedDate,Current_Running_Hours__c,Running_Hours_Captured_Date__c,Last_Service_Date__c,Last_Service_By_Engineer__c from Asset__c where Id IN: mapSRRespectedHours.keyset() ORDER BY CreatedDate DESC])
            {
                if(mapSRRespectedHours.containskey(objAss.Id) && mapSRRespectedHours.get(objAss.Id) != null)
                {
                    objAss.Current_Running_Hours__c = mapSRRespectedHours.get(objAss.Id).Engine_Run_Hours__c;
                    objAss.Running_Hours_Captured_Date__c = system.today();
                    if(mapOwnerRespectedSR.containskey(mapSRRespectedHours.get(objAss.Id).OwnerId))
                    {
                        Service_Request__c objSR = mapOwnerRespectedSR.get(mapSRRespectedHours.get(objAss.Id).Owner.Name);
                        objAss.Last_Service_Date__c= date.valueof(objSR.CreatedDate);
                        objAss.Last_Service_By_Engineer__c= objSR.OwnerId;
                    }
                    lstAsset.add(objAss);
                }
            }
            if(lstAsset.size()>0)
                update lstAsset;
        }
    }
    
    public static void OnAfterChangeRunningHours( List<Service_Request__c> triggerNew,map<Id,Service_Request__c> oldmap)
    {
        map<string,Service_Request__c> mapSRRespectedHours = new map<string,Service_Request__c>();
        set<string> containsString = new set<string>();
        
        set<string> setOfSRCreatedBy = new set<string>();
        set<string> setOfRecordId = new set<string>();
        
        for(Service_Request__c objSR : triggerNew)
        {
            if(objSR.ESN__c != null && objSR.Engine_Run_Hours__c != null && objSR.Engine_Run_Hours__c >0 && oldmap.get(objSR.Id).Engine_Run_Hours__c !=  objSR.Engine_Run_Hours__c)
            {
                setOfSRCreatedBy.add(objSR.OwnerId);
                setOfRecordId.add(objSR.Id);
                if(!containsString.contains(objSR.ESN__c))
                {
                    mapSRRespectedHours.put(objSR.ESN__c,objSR);
                    containsString.add(objSR.ESN__c);
                }
            }
        }
        
        map<string, Service_Request__c> mapOwnerRespectedSR = new map<string,Service_Request__c>();
        if(setOfSRCreatedBy.size()>0)
        {
            for(Service_Request__c objSR : [select Id, OwnerId,Owner.Name, CreatedDate from Service_Request__c where Id NOT IN: setOfRecordId and OwnerId IN: setOfSRCreatedBy order by createddate asc])
            {
                mapOwnerRespectedSR.put(objSR.OwnerId,objSR);
            }
        }
        
        if(mapSRRespectedHours.size()>0)
        {
            
            list<Asset__c> lstAsset = new list<Asset__c>();
            for(Asset__c objAss : [select Id,Name,CreatedDate,Current_Running_Hours__c,Running_Hours_Captured_Date__c,Last_Service_Date__c,Last_Service_By_Engineer__c from Asset__c where Id IN: mapSRRespectedHours.keyset() ORDER BY CreatedDate DESC])
            {
                if(mapSRRespectedHours.containskey(objAss.Id) && mapSRRespectedHours.get(objAss.Id) != null)
                {
                    objAss.Current_Running_Hours__c = mapSRRespectedHours.get(objAss.Id).Engine_Run_Hours__c;
                    objAss.Running_Hours_Captured_Date__c = system.today();
                    if(mapOwnerRespectedSR.containskey(mapSRRespectedHours.get(objAss.Id).OwnerId))
                    {
                        Service_Request__c objSR = mapOwnerRespectedSR.get(mapSRRespectedHours.get(objAss.Id).OwnerId);
                        objAss.Last_Service_Date__c= date.valueof(objSR.CreatedDate);
                        objAss.Last_Service_By_Engineer__c= objSR.Owner.Name;
                    }
                    lstAsset.add(objAss);
                }
            }
            if(lstAsset.size()>0)
                update lstAsset;
        }
    }
    
    public static void OnBeforeInsert( List<Service_Request__c> triggerNew)
    {
        set<Id> setOfESN = new set<Id>();
        Map<String, Id> mapESNVsIds = new Map<String, Id>();
        Map<String, Id> mapESNVsEndCustId = new Map<String, Id>();
        Map<String, Contact> mapEndCustIdVsCon = new Map<String, Contact>();
        for(Service_Request__c objSR : triggerNew)
        {
            if(objSR.ESN__c != null)
            {
                setOfESN.add(objSR.ESN__c);
            }
        }
        
        if(setOfESN.size()>0)
        {
            datetime dt6Month = system.now().addmonths(-6);  
            for(Service_Request__c objSR : [select Id,Name,CreatedDate,ESN__c,Customer__c,Contact_Person_Name__c from Service_Request__c where CreatedDate >: dt6Month AND ESN__c IN: setOfESN ORDER BY CreatedDate ASC])
            {
                mapESNVsIds.put(objSR.ESN__c, objSR.Id);
            }
            
            //Loop Through Asset to put all Asset Vs End Customer
            set<Id> idSetEndCustomer = new set<id>();
            for(Asset__c objAsset : [select Id, Name, End_Customer__c from Asset__c where Id IN: setOfESN ORDER BY CreatedDate ASC])
            {
                if(objAsset.End_Customer__c != null)
                {
                    idSetEndCustomer.add(objAsset.End_Customer__c);
                    mapESNVsEndCustId.put(objAsset.Id, objAsset.End_Customer__c);
                }
                
            }
            System.debug('----mapESNVsEndCustId---'+mapESNVsEndCustId);
            //Loop Through End Customer to put all End Customer Vs  Primary Contact
            if(idSetEndCustomer.size() > 0 )
                for(Contact objCon : [Select id , name , email, isPrimary__c, AccountId,MobilePhone from Contact where isPrimary__c = true AND AccountId IN : idSetEndCustomer])
            {
                mapEndCustIdVsCon.put(objCon.AccountId, objCon);
            }
            System.debug('----mapEndCustIdVsCon---'+mapEndCustIdVsCon);
            
            
            for(Service_Request__c objSR : triggerNew)
            {
                if(mapESNVsIds.size()>0 && objSR.ESN__c != null && mapESNVsIds.containsKey(objSR.ESN__c))
                {
                    objSR.Parent_Service_Request__c = mapESNVsIds.get(objSR.ESN__c);
                    //objSR.Is_Rework__c = true;
                }
                if(mapESNVsEndCustId.size() > 0 && mapESNVsEndCustId.containsKey(objSR.ESN__c) && mapESNVsEndCustId.get(objSR.ESN__c) != null)
                {
                    objSR.Customer__c = mapESNVsEndCustId.get(objSR.ESN__c);
                    // For contact papulation if contact is not selected and There is a primary contact 
                    if(mapEndCustIdVsCon.size() > 0 && mapEndCustIdVsCon.containsKey(mapESNVsEndCustId.get(objSR.ESN__c)))
                    {
                        objSR.Contact_Person_Name__c = mapEndCustIdVsCon.get(mapESNVsEndCustId.get(objSR.ESN__c)).Id;
                        objSR.Contact_Number__c = mapEndCustIdVsCon.get(mapESNVsEndCustId.get(objSR.ESN__c)).MobilePhone;   
                        objSR.Customer_Email__c = mapEndCustIdVsCon.get(mapESNVsEndCustId.get(objSR.ESN__c)).Email;   
                    }
                }
            }
        }
    }
    
    public static void OnBeforeUpdate(List<Service_Request__c> triggerNew, Map<Id,Service_Request__c> triggeroldMap)
    {
        set<Id> setOfESN = new set<Id>();
        Map<String, Id> mapESNVsIds = new Map<String, Id>();
        Map<String, Id> mapESNVsEndCustId = new Map<String, Id>();
        Map<String, Contact> mapEndCustIdVsCon = new Map<String, Contact>();
        for(Service_Request__c objSR : triggerNew)
        {
            if(objSR.ESN__c != null )
            {
                Service_Request__c oldObjSR = triggeroldMap.get(objSR.ID);
                if(oldObjSR.ESN__c != objSR.ESN__c && oldObjSR.Customer__c == objSR.Customer__c && oldObjSR.Contact_Person_Name__c == objSR.Contact_Person_Name__c)
                    setOfESN.add(objSR.ESN__c);
            }
        }
        
        if(setOfESN.size()>0)
        {
            datetime dt6Month = system.now().addmonths(-6);  
            for(Service_Request__c objSR : [select Id,Name,CreatedDate,ESN__c,Customer__c,Contact_Person_Name__c from Service_Request__c where CreatedDate >: dt6Month AND ESN__c IN: setOfESN ORDER BY CreatedDate ASC])
            {
                mapESNVsIds.put(objSR.ESN__c, objSR.Id);
            }
            
            //Loop Through Asset to put all Asset Vs End Customer
            set<Id> idSetEndCustomer = new set<id>();
            for(Asset__c objAsset : [select Id, Name, End_Customer__c from Asset__c where Id IN: setOfESN ORDER BY CreatedDate ASC])
            {
                if(objAsset.End_Customer__c != null)
                {
                    idSetEndCustomer.add(objAsset.End_Customer__c);
                    mapESNVsEndCustId.put(objAsset.Id, objAsset.End_Customer__c);
                }
                
            }
            
            //Loop Through End Customer to put all End Customer Vs  Primary Contact
            if(idSetEndCustomer.size() > 0 )
                for(contact objCon : [Select id , name , email, isPrimary__c, AccountId,MobilePhone from contact where isPrimary__c = true AND AccountId IN: idSetEndCustomer])
            {
                mapEndCustIdVsCon.put(objCon.AccountId, objCon);
            }
            
            for(Service_Request__c objSR : triggerNew)
            {
                if(mapESNVsIds.size()>0 && objSR.ESN__c != null && mapESNVsIds.containsKey(objSR.ESN__c))
                {
                    objSR.Parent_Service_Request__c = mapESNVsIds.get(objSR.ESN__c);
                    //objSR.Is_Rework__c = true;
                }
                else
                {
                    objSR.Parent_Service_Request__c = null;
                    //objSR.Is_Rework__c = false;
                }
                if(mapESNVsEndCustId.size() > 0 && mapESNVsEndCustId.containsKey(objSR.ESN__c))
                {
                    objSR.Customer__c = mapESNVsEndCustId.get(objSR.ESN__c);
                    System.debug('--Customer'+mapESNVsEndCustId.get(objSR.ESN__c));
                    // For contact papulation if contact is not selected and There is a primary contact 
                    if(mapEndCustIdVsCon.size() > 0 && mapEndCustIdVsCon.containsKey(mapESNVsEndCustId.get(objSR.ESN__c)))
                    {
                        objSR.Contact_Person_Name__c = mapEndCustIdVsCon.get(mapESNVsEndCustId.get(objSR.ESN__c)).Id;
                        objSR.Contact_Number__c = mapEndCustIdVsCon.get(mapESNVsEndCustId.get(objSR.ESN__c)).MobilePhone;   
                        objSR.Customer_Email__c = mapEndCustIdVsCon.get(mapESNVsEndCustId.get(objSR.ESN__c)).Email;  
                        System.debug('--Contact_Person_Name'+mapEndCustIdVsCon.get(mapESNVsEndCustId.get(objSR.ESN__c)).Id);
                    }
                    else
                    {
                        objSR.Contact_Person_Name__c = null;
                        objSR.Contact_Number__c = null;
                        objSR.Customer_Email__c = null;
                    }
                }
                else
                {
                    objSR.Customer__c = null;
                    objSR.Contact_Person_Name__c = null;
                    objSR.Contact_Number__c = null;
                    objSR.Customer_Email__c = null;
                }
            }
        } 
    }
}