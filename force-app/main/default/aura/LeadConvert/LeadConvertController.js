({
	doInIt : function(component, event, helper) {
		helper.onLoad(component, event, helper);
	},
    
    handleHideErrorDisplayModal : function(component, event, helper){
        component.set('v.errorMessage', '');
    },
    redirectAccountId : function(component, event, helper){
        var accId = component.get("v.wrapmain.objAcc.Id");
        window.location.replace('/lightning/r/Account/'+accId+'/view');
    },
    redirectContactId : function(component, event, helper){
        var conId = component.get("v.wrapmain.objCon.Id");
        window.location.replace('/lightning/r/Contact/'+conId+'/view');
    },
    cancel : function(component){
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
	},
    
    hideSpinner : function(component,event,helper){ 
       component.set("v.Spinner", false);
    }
})