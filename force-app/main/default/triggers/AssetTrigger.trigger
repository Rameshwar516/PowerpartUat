/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          19-Oct-2019                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
trigger AssetTrigger on Asset__c(after insert,after update,after delete,before insert, before update,before delete) {
    Trigger_Setting__c objCS = Trigger_Setting__c.getInstance('Asset');
    if(objCS.Active__c)
    {
        AssetTriggerHelper.assetTriggerExecute(trigger.New,trigger.Newmap,trigger.Old,trigger.Oldmap,trigger.isAfter,trigger.isBefore,trigger.isInsert,trigger.isUpdate,trigger.isDelete);
    }
}