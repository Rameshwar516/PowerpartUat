trigger PartRequestTrigger on Part_Request__c(before insert, before update, after Insert, After Update,After Undelete, After Delete) {
    
    Trigger_Setting__c objCS = Trigger_Setting__c.getInstance('Part Request');
    if(objCS.Active__c)
    {
        PartRequestHelper.partRequestTriggerExecute(trigger.New,trigger.Newmap,trigger.Old,trigger.Oldmap,trigger.isAfter,trigger.isBefore,trigger.isInsert,trigger.isUpdate,trigger.isDelete,trigger.isUndelete);
    }
}