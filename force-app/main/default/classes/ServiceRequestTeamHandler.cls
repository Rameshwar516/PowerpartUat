// ===============================================================================================
// ===============================================================================================
//      Version      Date                Author                 Description
// ===============================================================================================
//      1.0        11-Dec-2019         Deepak Pandey            Initial Version
// ===============================================================================================

public class ServiceRequestTeamHandler {
    
    public static void serviceRequestTeamTriggerExecute(list<Powerparts_Service_Request_Team__c> triggerNew,Map<Id,Powerparts_Service_Request_Team__c> triggerNewMap,list<Powerparts_Service_Request_Team__c> triggerOld,Map<Id,Powerparts_Service_Request_Team__c> triggeroldMap,boolean isAfter,boolean isBefore,boolean isInsert,boolean isUpdate,boolean isDelete)
    {
        if(isInsert && isafter)
        {
            onafterInsert(triggerNew);
        }
        if(isUpdate && isafter)
        {
            onAfterupdate(triggerNew,triggeroldMap);
        }
        if(isbefore && isinsert)
            onBeforeInsert(triggerNew);
    }
    
    public static void onafterInsert( List<Powerparts_Service_Request_Team__c> triggerNew)
    {
        set<string> setOfSR = new set<string>();
        for(Powerparts_Service_Request_Team__c objSRT : triggerNew) 
        {
            if(objSRT.Service_Request__c != null)
                setOfSR.add(objSRT.Service_Request__c);
        }
        
        if(setOfSR.size()>0)
        {
            map<string,set<string>> mapSRRespectedUserOrGroup = new map<string,set<string>>();
            for(Service_Request__Share obj : [Select Id, ParentId, UserOrGroupId from Service_Request__Share where ParentId IN: setOfSR])
            {
                if(mapSRRespectedUserOrGroup.containskey(obj.ParentId) && mapSRRespectedUserOrGroup.get(obj.ParentId) != null)
                {
                    set<string> setOfSRNew = mapSRRespectedUserOrGroup.get(obj.ParentId);
                    setOfSRNew.add(obj.UserOrGroupId);
                    mapSRRespectedUserOrGroup.put(obj.ParentId,setOfSRNew);
                }
                else{
                    set<string> setOfSRNew = new set<string>();
                    setOfSRNew.add(obj.UserOrGroupId);
                    mapSRRespectedUserOrGroup.put(obj.ParentId,setOfSRNew);
                }
            }
            
            list<Service_Request__Share> lstServiceReqShare = new list<Service_Request__Share>();
            for(Powerparts_Service_Request_Team__c objSRT : triggerNew) 
            {
                set<string> setOfSRUSer = new set<string>();
                if(mapSRRespectedUserOrGroup.containskey(objSRT.Service_Request__c) && mapSRRespectedUserOrGroup.get(objSRT.Service_Request__c) != null)
                {
                    setOfSRUSer = mapSRRespectedUserOrGroup.get(objSRT.Service_Request__c);
                }
                if(objSRT.Engineer1__c != null && !setOfSRUSer.contains(objSRT.Engineer1__c))
                { 
                    Service_Request__Share objSRTNew = new Service_Request__Share();
                    objSRTNew.AccessLevel = 'edit';
                    if(objSRT.Service_Request__c != null)
                        objSRTNew.ParentId = objSRT.Service_Request__c;
                    objSRTNew.UserOrGroupId = objSRT.Engineer1__c;
                    objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                    lstServiceReqShare.add(objSRTNew);
                    system.debug('...objSRTNew...'+objSRTNew);
                }
                if(objSRT.Engineer2__c != null && !setOfSRUSer.contains(objSRT.Engineer2__c))
                {
                    Service_Request__Share objSRTNew = new Service_Request__Share();
                    objSRTNew.AccessLevel = 'edit';
                    if(objSRT.Service_Request__c != null)
                        objSRTNew.ParentId = objSRT.Service_Request__c;
                    objSRTNew.UserOrGroupId = objSRT.Engineer2__c;
                    objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                    lstServiceReqShare.add(objSRTNew);
                }       
                if(objSRT.Engineer3__c != null && !setOfSRUSer.contains(objSRT.Engineer3__c))
                {
                    Service_Request__Share objSRTNew = new Service_Request__Share();
                    objSRTNew.AccessLevel = 'edit';
                    if(objSRT.Service_Request__c != null)
                        objSRTNew.ParentId = objSRT.Service_Request__c;
                    objSRTNew.UserOrGroupId = objSRT.Engineer3__c;
                    objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                    lstServiceReqShare.add(objSRTNew);
                }   
                if(objSRT.Engineer4__c != null && !setOfSRUSer.contains(objSRT.Engineer4__c))
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
            //Database.SaveResult[] jobShareInsertResult = Database.insert(lstServiceReqShare,false);

    }
    
    public static void onAfterupdate( List<Powerparts_Service_Request_Team__c> triggerNew, map<id, Powerparts_Service_Request_Team__c> oldMap)
    {
        map<Id,set<string>> mapSRResLstUser = new map<Id,set<string>>();
        list<Service_Request__Share> lstServiceReqShare = new list<Service_Request__Share>();
        for(Powerparts_Service_Request_Team__c objSRT : triggerNew) 
        {
            set<string> lststring = new set<string>();
            if(objSRT.Engineer1__c != null && oldMap.get(objSRT.Id).Engineer1__c != objSRT.Engineer1__c)
            {
                Service_Request__Share objSRTNew = new Service_Request__Share();
                objSRTNew.AccessLevel = 'edit';
                if(objSRT.Service_Request__c != null)
                    objSRTNew.ParentId = objSRT.Service_Request__c;
                objSRTNew.UserOrGroupId = objSRT.Engineer1__c;
                objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                //lstServiceReqShare.add(objSRTNew);
                //lststring.add(oldMap.get(objSRT.Id).Engineer1__c);
            }
            if(objSRT.Engineer2__c != null && oldMap.get(objSRT.Id).Engineer2__c != objSRT.Engineer2__c)
            {
                Service_Request__Share objSRTNew = new Service_Request__Share();
                objSRTNew.AccessLevel = 'edit';
                if(objSRT.Service_Request__c != null)
                    objSRTNew.ParentId = objSRT.Service_Request__c;
                objSRTNew.UserOrGroupId = objSRT.Engineer2__c;
                objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                lstServiceReqShare.add(objSRTNew);
                lststring.add(oldMap.get(objSRT.Id).Engineer2__c);
            }       
            if(objSRT.Engineer3__c != null && oldMap.get(objSRT.Id).Engineer3__c != objSRT.Engineer3__c)
            {
                Service_Request__Share objSRTNew = new Service_Request__Share();
                objSRTNew.AccessLevel = 'edit';
                if(objSRT.Service_Request__c != null)
                    objSRTNew.ParentId = objSRT.Service_Request__c;
                objSRTNew.UserOrGroupId = objSRT.Engineer3__c;
                objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                lstServiceReqShare.add(objSRTNew);
                lststring.add(oldMap.get(objSRT.Id).Engineer3__c);
            }   
            if(objSRT.Engineer4__c != null && oldMap.get(objSRT.Id).Engineer4__c != objSRT.Engineer4__c)
            {
                Service_Request__Share objSRTNew = new Service_Request__Share();
                objSRTNew.AccessLevel = 'edit';
                if(objSRT.Service_Request__c != null)
                    objSRTNew.ParentId = objSRT.Service_Request__c;
                objSRTNew.UserOrGroupId = objSRT.Engineer4__c;
                objSRTNew.RowCause = Schema.Service_Request__Share.RowCause.Manual;
                lstServiceReqShare.add(objSRTNew);
                lststring.add(oldMap.get(objSRT.Id).Engineer4__c);
            }
            mapSRResLstUser.put(objSRT.Service_Request__c,lststring);
        }
        if(lstServiceReqShare.size()>0)
             Database.SaveResult[] jobShareInsertResult = Database.insert(lstServiceReqShare,false);

        list<Service_Request__Share> lstForDeleteShareList = new list<Service_Request__Share>();
        for(Service_Request__Share objSRS : [select Id, ParentId,UserOrGroupId from Service_Request__Share where ParentId IN: mapSRResLstUser.keyset()])
        {
            if(mapSRResLstUser.get(objSRS.ParentId) != null && mapSRResLstUser.get(objSRS.ParentId).size()>0)
            {
                set<string> setOfUser = mapSRResLstUser.get(objSRS.ParentId);
                if(setOfUser.size()>0 && setOfUser.contains(objSRS.UserOrGroupId))
                {
                    lstForDeleteShareList.add(objSRS);
                }                   
            }   
        }
        if(lstForDeleteShareList.size()>0)
            delete lstForDeleteShareList;
    }
    
    public static void onBeforeInsert( List<Powerparts_Service_Request_Team__c> triggerNew)
    {
        set<id> setOfSRID = new set<Id>();
        for(Powerparts_Service_Request_Team__c objSRT : triggerNew)
        {
            if(objSRT.Service_Request__c != null)
                setOfSRID.add(objSRT.Service_Request__c);
        }
        system.debug('...setOfSRID...'+setOfSRID);
        map<string, integer> mapIdResSR = new map<string, integer>();
        for(Service_Request__c objSR : [select Id, Name,(select Id,Service_Request__c from Powerparts_Service_Request_Team__r) from Service_Request__c where Id IN: setOfSRID])
        {
            mapIdResSR.put(objSR.Id,objSR.Powerparts_Service_Request_Team__r.size());
        }
        system.debug('...mapIdResSR...'+mapIdResSR);
        if(setOfSRID.size()>0)
        {
            for(Powerparts_Service_Request_Team__c objSRT : triggerNew)
            {
                if(objSRT.Service_Request__c != null)
                    if(mapIdResSR.size()>0  && mapIdResSR.containskey(objSRT.Service_Request__c) && mapIdResSR.get(objSRT.Service_Request__c)>= 1)
                        objSRT.adderror(system.label.Only_one_team_member); 
            }
        }
    }
}