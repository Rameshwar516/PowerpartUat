({
    pageLoadClassMethod : function(component, event, id) {
        var action = component.get('c.productOnLoad');
        action.setParams({
            "RecordId" : id
        });
        
		action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                if(JSON.parse(res.getReturnValue()).isSelectedProduct){
                    component.set('v.showPicklist',true);
                    
                }else{
                    component.set('v.showPicklist',false);
                    component.set("v.IsselectProduct",true);
                }
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
    AddRecord : function(component, event, objWrap) {
        var action = component.get('c.addRecord');
        action.setParams({
            "strWrap" : JSON.stringify(objWrap)
        });
		action.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success ) {
              component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                component.set("v.IsselectProduct",false);
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
	
	AddRecordOnCheck : function(component, event, objWrap) {
        var action = component.get('c.addRecord');
        action.setParams({
            "strWrap" : JSON.stringify(objWrap)
        });
		action.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success ) {
              component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                component.set("v.IsselectProduct",true);
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
    
    SaveHelper: function(component, event, id) {
        var objWrap = component.get("v.wrapMain");
        var action = component.get("c.saveRecord");
        action.setParams({
            "strWrap" : JSON.stringify(objWrap),
            "RecordId" : id
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success){
                component.set('v.wrapMain.success', true);
                component.set('v.wrapMain.strMessage', JSON.parse(res.getReturnValue()).strMessage);
                window.location.assign('/lightning/r/Quote__c/'+component.get("v.recordId")+'/view');
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    onSelectChangeHelper : function(component, event, strPriceBookId) {
        var objWrap = component.get("v.wrapMain");
        var action = component.get("c.onselectPick");
        action.setParams({
            "strPriceBookId" : strPriceBookId,
            "strWrap" : JSON.stringify(objWrap)
        });
        
		action.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success ) {
				component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                component.set("v.showPicklist",false);
                component.set("v.IsselectProduct",true);
                
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
	
})