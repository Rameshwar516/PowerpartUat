({
    doInit: function(component, event, helper) {
        helper.inithelper(component, event, helper);
    },
    doSend : function(component, event, helper) {
        // alert(component.find('Subject').get('v.value'));
        if(component.get('v.wrappr.islineItemAvailable')){
            
            if(component.find('Subject').get('v.value')!=''){
                helper.sendmessage(component, event, helper);
                $A.get("e.force:closeQuickAction").fire();  
                $A.get('e.force:refreshView').fire();
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Subject should not be null",
                "type" : "error"
            });
            toastEvent.fire();
            }
            
        }
        else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please Add Line Item/Items",
                "type" : "error"
            });
            toastEvent.fire();
        }
    },
    closeModel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();  
        $A.get('e.force:refreshView').fire(); 
    },
})