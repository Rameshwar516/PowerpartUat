/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          9-Dec-2019                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
public class WarrantyClaimTriggerHelper
{
    public static void warrantyClaimTriggerExecute(list<Warranty_Claim__c> triggerNew,Map<Id,Warranty_Claim__c> triggerNewMap,list<Warranty_Claim__c> triggerOld,Map<Id,Warranty_Claim__c> triggeroldMap,boolean isAfter,boolean isBefore,boolean isInsert,boolean isUpdate,boolean isDelete)
    {
        //Call Methods
        if(isinsert && isafter)
        {
            inserPartRequestOfEnadCustomer(triggerNew);
        }
    }
    static void inserPartRequestOfEnadCustomer(list<Warranty_Claim__c> triggerNew)
    {
        set<Id> setOfSR = new set<Id>();
        map<Id,Id> mapIdWCRelatedSR = new map<Id,Id>();
        for(Warranty_Claim__c objWC : triggerNew)
        {
            if(objWC.Service_Request__c != null)
            {
                mapIdWCRelatedSR.put(objWC.Service_Request__c, objWC.Id);
            }
        }
        if(mapIdWCRelatedSR.size()>0)
        {
            list<Part_Request__c> lstPR = new list<Part_Request__c>();
            map<Id, list<Part_Request__c>> mapServiceReqRelatedPR = new map<Id, list<Part_Request__c>>();
            for(Part_Request__c objPR : [Select Id, Name, Approval_Date_Time__c, Description__c, Free_of_charge__c, Material_costs__c, Part__c, Old_Part_Number__c, Part_Cost__c, Part_Request_Date_Time__c, Part_Request_Number__c , Part_Type__c, Quantity__c, Remark__c, Service_Request__c, SOA__c, Total_Cost__c, VOR__c, Warranty_Type__c,Warranty_Claim__c from Part_Request__c where Service_Request__c IN: mapIdWCRelatedSR.keyset()])
            {
                if(mapIdWCRelatedSR.containskey(objPR.Service_Request__c) && mapIdWCRelatedSR.get(objPR.Service_Request__c) != null)
                {
                    //Part_Request__c objPRNew = new Part_Request__c(); 
                    //objPRNew = objPR.clone();
                    objPR.Warranty_Claim__c = mapIdWCRelatedSR.get(objPR.Service_Request__c);
                    objPR.Service_Request__c = null;
                    lstPR.add(objPR);
                }
            }
            if(lstPR.size()>0)
                update lstPR;
        }
    }
}