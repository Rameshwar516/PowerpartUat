trigger triggerdeliveryNote on Sales_Order_Dispatch_Delivery_Note__c (before  delete) {
DeliveryNoteHelper.delLineItems(trigger.old);
}