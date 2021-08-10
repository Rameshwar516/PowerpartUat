trigger SalesOrderLineItemTrigger on Sales_Order_Line_Item__c (before insert,before update, after delete) {
    
    if(trigger.isinsert && trigger.isbefore){
        SalesOrderLineItemTriggerHelper.onInsertMethod(trigger.new);
    }
    if(trigger.isupdate && trigger.isbefore){
        SalesOrderLineItemTriggerHelper.onupdateMethod(trigger.new,trigger.newmap,trigger.oldmap);

    }
    if(trigger.isafter && trigger.isdelete ){
        SalesOrderLineItemTriggerHelper.onDeleteMethod(trigger.old);
    }
}