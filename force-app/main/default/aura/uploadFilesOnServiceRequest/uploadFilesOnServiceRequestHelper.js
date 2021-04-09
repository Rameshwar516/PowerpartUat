({
    doInitHelper : function(component, Id) { 
        var action = component.get("c.InitValue");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this,function(response)
        {  
            if(response.getState() === "SUCCESS"){ 
                component.set("v.mainWrap" , JSON.parse(response.getReturnValue()));
            }  
        });  
        $A.enqueueAction(action);  
    },  
	UpdateDocument : function(component, Id) { 
        component.set("v.spinnerLoaded" , true);
        var action = component.get("c.UpdateFiles");
        action.setParams({
            documentId : Id,
            recordId : component.get("v.recordId"),
            strwrap : JSON.stringify(component.get("v.mainWrap"))
        });
        action.setCallback(this,function(response)
        {  
            if(response.getState() === "SUCCESS"){ 
                component.set("v.spinnerLoaded" , false);
                component.set("v.mainWrap" , JSON.parse(response.getReturnValue()));
            }  
        });  
        $A.enqueueAction(action);  
    }, 
    handleRenameHelper : function(component, Id) {
        component.set("v.spinnerLoaded" , true);
        var action = component.get("c.RenameFiles");
        action.setParams({
            strwrap : JSON.stringify(component.get("v.mainWrap"))
        });
        action.setCallback(this,function(response)
        {  
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success){
                component.set("v.spinnerLoaded" , false);
              	component.set("v.mainWrap" , JSON.parse(response.getReturnValue())); 
                component.set("v.boolAllImage" , true); 
                component.set("v.SuccessMessage" , 'Files Name has been updated successfully.'); 
               
            } 
            else
            {
                component.set("v.spinnerLoaded" , false);
                component.set("v.ErrorMessage" , JSON.parse(response.getReturnValue()).strErrorMsg);
            }
        });  
        $A.enqueueAction(action);  
    }, 
})