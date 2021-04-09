trigger SalesOrder on Sales_Order__c (before update) {
SalesOrderHelper helperObj = new SalesOrderHelper();
    if(trigger.isUpdate){
         if(trigger.isBefore)
            helperObj.onBeforeUpdate(trigger.new,trigger.oldMap); 
    }
}