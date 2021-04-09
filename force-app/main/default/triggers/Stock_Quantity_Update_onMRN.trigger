trigger Stock_Quantity_Update_onMRN on MRN__c (after update) {
    if(trigger.isupdate && trigger.isafter) Stock_Quantity_Update_onMRN_Handler.updatestock(Trigger.new,Trigger.OldMap);
}