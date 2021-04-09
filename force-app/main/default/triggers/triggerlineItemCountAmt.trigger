trigger triggerlineItemCountAmt on Line_Item__c (after insert,after update, after delete) {
    if(trigger.isinsert && trigger.isafter){
        ClassHandlerTotalCountofLineitem.onInsertCheckNoOfLineItem(trigger.new);
        ClassHandlerTotalCountofLineitem.onInsertQuoteLineItem(trigger.new);
    }
    if(trigger.isupdate && trigger.isafter){
        ClassHandlerTotalCountofLineitem.onUpdateCheckNoOfLineItem(trigger.new,trigger.oldmap);
        ClassHandlerTotalCountofLineitem.onUpdateQuoteLineItem(trigger.new,trigger.oldmap);
    }
    if(trigger.isafter && trigger.isdelete ){
        ClassHandlerTotalCountofLineitem.onDeleteCheckNoOfLineItem(trigger.old);
        ClassHandlerTotalCountofLineitem.onDeleteQuoteLineItem(trigger.old);
    }
}