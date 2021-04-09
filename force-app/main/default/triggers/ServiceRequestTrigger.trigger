trigger ServiceRequestTrigger on Service_Request__c (before insert, before update, after Insert, After Update) {
    
    Trigger_Setting__c objCS = Trigger_Setting__c.getInstance('Service Request');
    if(objCS.Active__c)
    {
        ServiceRequestHandler.ServiceRequestTriggerExecute(trigger.New,trigger.Newmap,trigger.Old,trigger.Oldmap,trigger.isAfter,trigger.isBefore,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
    }
}