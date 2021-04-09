({
	initHelper : function(component, event) {
		component.set("v.spinnerIsVisibile",true);
		var action = component.get("c.doInit");
		action.setParams({
            strParentRecId : component.get("v.ParentRecordId")
        });
        action.setCallback(this, function(response) {
            
            component.set("v.spinnerIsVisibile",false);
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {
                component.set("v.mainWrap",JSON.parse(response.getReturnValue()));
                
            }else if(response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.ErrorMessage",errors[0].message);
                    }
                } else {
					component.set("v.ErrorMessage","Unknown error");
                }
            }else if (!JSON.parse(response.getReturnValue()).success) {
				component.set("v.ErrorMessage",JSON.parse(response.getReturnValue()).strError);
            }
        });
        $A.enqueueAction(action);
	},
    involeHelper : function(component, event) {
		component.set("v.spinnerIsVisibile",true);
		var action = component.get("c.invoke");
		action.setParams({
           "strmainWrap" : JSON.stringify(component.get("v.mainWrap")),
            "strSRId" : component.get("v.ParentRecordId"),
            "clientIP":component.get("v.UserIp")
        });
        action.setCallback(this, function(response) {
            
            component.set("v.spinnerIsVisibile",false);
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {
                component.set("v.mainWrap",JSON.parse(response.getReturnValue()));
                component.set("v.SuccessMessage",JSON.parse(response.getReturnValue()).strSuccess);
                location.reload();
                
            }else if(response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.ErrorMessage",errors[0].message);
                    }
                } else {
					component.set("v.ErrorMessage","Unknown error");
                }
            }else if (!JSON.parse(response.getReturnValue()).success) {
				component.set("v.ErrorMessage",JSON.parse(response.getReturnValue()).strError);
            }
        });
        $A.enqueueAction(action);
	},
})