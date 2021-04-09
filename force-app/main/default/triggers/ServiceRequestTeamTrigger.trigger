trigger ServiceRequestTeamTrigger on Powerparts_Service_Request_Team__c (after insert,after update,before insert, before update) {
    Trigger_Setting__c objCS = Trigger_Setting__c.getInstance('Service Request Team');
    if(objCS.Active__c)
    {
        ServiceRequestTeamHandler.serviceRequestTeamTriggerExecute(trigger.New,trigger.Newmap,trigger.Old,trigger.Oldmap,trigger.isAfter,trigger.isBefore,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
    }
}