trigger AccountTrigger on Account (after insert,after update,before insert, before update) {
    Trigger_Setting__c objCS = Trigger_Setting__c.getInstance('Account');
    if(objCS.Active__c)
    {
        AccountTriggerHelper.accountTriggerExecute(trigger.New,trigger.Newmap,trigger.Old,trigger.Oldmap,trigger.isAfter,trigger.isBefore,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
    }
}