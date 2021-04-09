({
	submitHelper : function(component,event) {
        var action = component.get('c.SavePurchaseIndent');
        action.setParams({
            "strMainWrapper": JSON.stringify(component.get('v.mainWrapper'))
        })
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = JSON.parse(response.getReturnValue());
                if(result.success && result.objPurchaseIndent.Id){
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result.objPurchaseIndent.Id,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.strErrorMessage,
                        "type" : 'error'
                    });
                    toastEvent.fire();
                }
            }
            else if(response.getState() === "ERROR"){
                var errors = response.getError();
                if(errors)
                    console.log('Error :'+errors[0].message);
            }
                else 
                    console.log('Unknown error');
        });
        
        $A.enqueueAction(action);
    },
    addRowHelper : function(component,event, PIIWrapper) {
        var tmpLineItemWrap = {"stockActual":0,"specification":"","remarks":"","quantity":0,"pandingPOQty":0,"objPart":{"attributes":{"type":"Part__c"}},"expectedDate":null,"application":"","isEdit":true};
        PIIWrapper.push(tmpLineItemWrap);
        component.set("v.PurchaseIndentItems", PIIWrapper);
    },
    checkError : function(component, event, tmpWrapper, RecordIndexStr) {
        var strerror= '';
        var checkall = false;
        tmpWrapper[RecordIndexStr].strPartErr ='';
        tmpWrapper[RecordIndexStr].strQuantityErr = '';
        tmpWrapper[RecordIndexStr].strExpectedDateErr = '';
        tmpWrapper[RecordIndexStr].strApplicationErr ='';
        tmpWrapper[RecordIndexStr].boolShowError = false;
        
        if(!tmpWrapper[RecordIndexStr].objPart.Name)
        { 
            
            strerror = "Please select Part Type";
            tmpWrapper[RecordIndexStr].strPartErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].objPILI.QTY__c)
        {
            strerror = "Please Enter Quantity";
            tmpWrapper[RecordIndexStr].strQuantityErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].objPILI.Expected_date__c)
        { 
            strerror = "Please select Expected Date.";
            tmpWrapper[RecordIndexStr].strExpectedDateErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].objPILI.Application__c )
        { 
            strerror = "Please Select Application.";
            tmpWrapper[RecordIndexStr].strApplicationErr = strerror;
            checkall = true;
        }
        
        if(checkall)
        {
            component.set("v.Error", true);
            tmpWrapper[RecordIndexStr].boolShowError = true;
            tmpWrapper[RecordIndexStr].isEdit = true;
            component.set("v.PurchaseIndentItems",tmpWrapper);
        }  
        else
            component.set("v.Error", false);
    }
})