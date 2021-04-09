({
    initCheckOut : function(component) {
        var action = component.get("c.updateCheckOut");
        action.setParams({
			strRecordId : component.get("v.recordId")
		});
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {
				this.showToast(component,'Success!','You have checked Out.','success');
                 $A.get('e.force:refreshView').fire();
				$A.get("e.force:closeQuickAction").fire();
			}else if(response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.ErrorMessage",errors[0].message);
						component.set("v.spinnerLoaded",false);
                    }
                } else {
					component.set("v.ErrorMessage","Unknown error");
					component.set("v.spinnerLoaded",false);
                }
            }else if (!JSON.parse(response.getReturnValue()).success) {
				component.set("v.ErrorMessage",JSON.parse(response.getReturnValue()).errorMessage);
				component.set("v.spinnerLoaded",false);
            }
        });
        $A.enqueueAction(action);
        
    },
    showToast : function(component,title,message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: type,
            title: title,
            message: message,
            duration:'4000'
        });
        toastEvent.fire();
    },
    handleHideErrorDisplayModalHelper : function(component) {
        component.set("v.SuccessMessage",'');
        component.set("v.ErrorMessage",'');
        $A.get('e.force:refreshView').fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire(); 
    },
    
})