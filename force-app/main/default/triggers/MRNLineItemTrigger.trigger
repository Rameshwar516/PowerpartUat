trigger MRNLineItemTrigger on MRN_Line_Item__c (after insert) {
     if(trigger.isinsert && trigger.isafter) 
    {
        MRNLineItemHelper.createStockLandedAmount(Trigger.new,Trigger.OldMap);
    }
}