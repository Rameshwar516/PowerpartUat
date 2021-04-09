/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          3-jan-2020                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
public class PartRequestHelper
{
    public static void partRequestTriggerExecute(list<Part_Request__c> triggerNew,Map<Id,Part_Request__c> triggerNewMap,list<Part_Request__c> triggerOld,Map<Id,Part_Request__c> triggeroldMap,boolean isAfter,boolean isBefore,boolean isInsert,boolean isUpdate,boolean isDelete,boolean isundelete)
    {
        //Call Methods
        if(isinsert && isafter)
        {
            countPartRequest(triggerNew,null);
        }
        
        if(isupdate && isafter)
        {
            countPartRequest(triggerNew,triggeroldMap);
        }
        
        if(isdelete && isafter)
        {
            countPartRequesOnDelete(triggerOld);
        }
        
        if(isUnDelete && isafter)
        {
            countPartRequest(triggerNew,null);
        }
    }
    static void countPartRequest(list<Part_Request__c> TriggerNew, map<Id,Part_Request__c> triggeroldMap)
    {
        set<Id> setOfSRId = new set<Id>();
        if(triggeroldMap == null)
        {
            for(Part_Request__c objPR : triggerNew)
            {
                if(objPR.Service_Request__c != null)
                    setOfSRId.add(objPR.Service_Request__c);
            }
        }
        else
        {
            for(Part_Request__c objPR : triggerNew)
            {
                if(objPR.Service_Request__c != null && objPR.Service_Request__c != triggeroldMap.get(objPR.Id).Service_Request__c)
                {
                    setOfSRId.add(objPR.Service_Request__c);
                    setOfSRId.add(triggeroldMap.get(objPR.Id).Service_Request__c);
                }
            }
        }
        if(setOfSRId.size()>0)
        {
            list<Service_Request__c> lstSR = new list<Service_Request__c>();
            for(Service_Request__c objSR : [Select Id, Part_Request_Count_Number__c,(select Id from Parts_Request__r) from Service_Request__c where Id IN: setOfSRId])
            {
                if(objSR.Parts_Request__r.size() >0){
                    objSR.Part_Request_Count_Number__c = objSR.Parts_Request__r.size();
                    system.debug('...Size....'+objSR.Parts_Request__r.size());
                    lstSR.add(objSR);
                }
                else{
                    objSR.Part_Request_Count_Number__c = 0;
                    lstSR.add(objSR);
                }
            }
            IF(lstSR.SIZE()>0)
                UPDATE lstSR;
        }
    }
    
    static void countPartRequesOnDelete(list<Part_Request__c> triggerOld)
    {
        set<Id> setOfSRId = new set<Id>();
        
        for(Part_Request__c objPR : triggerOld)
        {
            if(objPR.Service_Request__c != null)
                setOfSRId.add(objPR.Service_Request__c);
        }
        if(setOfSRId.size()>0)
        {
            list<Service_Request__c> lstSR = new list<Service_Request__c>();
            for(Service_Request__c objSR : [Select Id, Part_Request_Count_Number__c,(select Id from Parts_Request__r) from Service_Request__c where Id IN: setOfSRId])
            {
                if(objSR.Parts_Request__r.size() >0){
                    objSR.Part_Request_Count_Number__c = objSR.Parts_Request__r.size();
                    system.debug('...Size....'+objSR.Parts_Request__r.size());
                    lstSR.add(objSR);
                }
                else
                {
                    objSR.Part_Request_Count_Number__c = 0;
                    lstSR.add(objSR);
                }
            }
            IF(lstSR.SIZE()>0)
                UPDATE lstSR;
        }
    }
}