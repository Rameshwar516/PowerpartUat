trigger WarrantyClaimTrigger on Warranty_Claim__c (after insert,after update,before insert, before update) {
    Trigger_Setting__c objCS = Trigger_Setting__c.getInstance('WarrantyClaim');
    if(objCS.Active__c)
    {
        WarrantyClaimTriggerHelper.warrantyClaimTriggerExecute(trigger.New,trigger.Newmap,trigger.Old,trigger.Oldmap,trigger.isAfter,trigger.isBefore,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
    }
}