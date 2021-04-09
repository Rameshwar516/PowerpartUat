({
    doInitJS : function(component, event, helper) {
        helper.initHelper(component, event);
    },
    submit : function(component, event, helper) 
    {
        var a=component.get("v.mainWrap.objFeedback.Mechanic_Available__c");
        var b=component.get("v.mainWrap.objFeedback.Repair_or_service__c");
        var c=component.get("v.mainWrap.objFeedback.Easy_to_Contact__c");
        var d=component.get("v.mainWrap.objFeedback.Parts_Availability__c");
        var e=component.get("v.mainWrap.objFeedback.Payment_Terms__c");
        var f=component.get("v.mainWrap.objFeedback.Product_Support__c");
        var g=component.get("v.mainWrap.objFeedback.Service_Report__c");
        var h=component.get("v.mainWrap.objFeedback.Technician_knowladge__c");
        var i=component.get("v.mainWrap.objFeedback.Technician_Manner_Attitude__c");
        var j=component.get("v.mainWrap.objFeedback.Completed_Service_one_Visit__c");
        var recId = component.get("v.ParentRecordId");
        component.set("v.mainWrap.strCustomerCom",component.get("v.strCustomerCom"));
        if(a && b && c && d && e && f && g && h && i && j)
        {
            helper.involeHelper(component, event)
        }
        else
        {
            var errorMessage="Please select All ratings";
            component.set("v.ErrorMessage",errorMessage);
        }    
    },
    
    handleHideErrorDisplayModal : function(component, event, helper) {
                
        component.set("v.SuccessMessage",null);
        component.set("v.ErrorMessage",null);
    },
    
})