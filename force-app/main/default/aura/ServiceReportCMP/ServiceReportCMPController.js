({
    doInitJS : function(component, event, helper) {
        helper.initHelper(component, event);
    },
    handleHideErrorDisplayModal : function(component, event, helper)
    {
        component.set("v.SuccessMessage","");
        component.set("v.ErrorMessage","");
    },
    submitJS : function(component, event, helper) {
        component.set("v.boolFeedBackForm", true);
        var customerCom = component.get("v.strCustomerCom");
        if(customerCom)
        {
            //helper.submitHelper(component, event);
            component.set("v.showServiceReqCMP" ,true); 
        }
        	
        else
        {
            if((customerCom == '' || customerCom == null))
                component.set("v.ErrorMessage" ,'Please Enter Customer Comment. '); 
        }
    },
    /*submitFeedBackJS : function(component, event, helper) {
        var getSelectRecord = component.get("v.recordId");
        var evtFire = component.getEvent("callChildSave");
        evtFire.setParams({"recordIdByEvent" : getSelectRecord });  
        evtFire.fire();
    },*/
    
})