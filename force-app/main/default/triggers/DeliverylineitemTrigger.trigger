trigger DeliverylineitemTrigger on Delivery_Note_Line_Item__c (before insert,before update, after delete) {
     if(trigger.isinsert && trigger.isbefore){
        DeliverylineitemTriggerHelper.onInsertMethod(trigger.new);
    }
    if(trigger.isupdate && trigger.isbefore){
        DeliverylineitemTriggerHelper.onupdateMethod(trigger.new,trigger.newmap,trigger.oldmap);

    }
    if(trigger.isafter && trigger.isdelete ){
        DeliverylineitemTriggerHelper.onDeleteMethod(trigger.old);
    }
}