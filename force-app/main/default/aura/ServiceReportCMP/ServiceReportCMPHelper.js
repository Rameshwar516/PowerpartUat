({
	initHelper : function(component, event) {
		component.set("v.spinnerIsVisibile",true);
		var action = component.get("c.doInit");
		action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            
            component.set("v.spinnerIsVisibile",false);
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {
                component.set("v.mainWrap",JSON.parse(response.getReturnValue()));
                component.set("v.lstContentDoc",JSON.parse(response.getReturnValue()).lstContentDoc);
                component.set("v.showServiceReqCMP",JSON.parse(response.getReturnValue()).objSR.showServiceReqCMP__c);
                component.set("v.showFeedBackForm",JSON.parse(response.getReturnValue()).showFeedBackForm);
                component.set("v.strCustomerCom",JSON.parse(response.getReturnValue()).objSR.Customer_Comments__c);
                
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
    
    /*submitHelper : function(component, event) {
        component.set("v.spinnerIsVisibile",true);
        var action = component.get("c.Submit");
        action.setParams({
            strmainWrap : JSON.stringify(component.get("v.mainWrap"))
        });
        action.setCallback(this, function(response) {
            
            component.set("v.spinnerIsVisibile",false);
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {
                component.set("v.mainWrap",JSON.parse(response.getReturnValue()));
                component.set("v.lstContentDoc",JSON.parse(response.getReturnValue()).lstContentDoc);
                component.set("v.showServiceReqCMP",JSON.parse(response.getReturnValue()).objSR.showServiceReqCMP__c);
                component.set("v.showFeedBackForm",JSON.parse(response.getReturnValue()).showFeedBackForm);
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
    }*/
    
})