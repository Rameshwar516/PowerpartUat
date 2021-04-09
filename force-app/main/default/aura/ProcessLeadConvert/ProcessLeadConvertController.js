({
    doInIt : function(component, event, helper) {
        helper.onLoad(component, event, helper);
    },
    
    convertmethod : function(component, event, helper) {
        helper.saveconvertedrec(component, event, helper);
    },
    
    handleHideErrorDisplayModal : function(component, event, helper){
        component.set('v.errorMessage', '');
    },
    
    handleHideSuccessDisplayModal : function(component, event, helper){
        var accid = component.get('v.wrapmain.AccName.Id');
        window.location.replace('/lightning/r/Account/'+accid+'/view');
    },
    redirectAccountId : function(component, event, helper){
        var accId = component.get("v.wrapmain.objlead.ConvertedAcconutId__c");
        window.location.replace('/lightning/r/Account/'+accId+'/view');
    },
    redirectContactId : function(component, event, helper){
        var conId = component.get("v.wrapmain.objlead.ConvertedContactId__c");
        window.location.replace('/lightning/r/Contact/'+conId+'/view');
    },
    redirectOpportunityId : function(component, event, helper){
        var oppId = component.get("v.wrapmain.objlead.ConvertedOpportunityId__c");
        window.location.replace('/lightning/r/Opportunity__c/'+oppId+'/view');
    },
    cancel : function(component){
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    }


})