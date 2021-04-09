({
    Onloadmethod : function(component, event, getrecId) {
        var getmethod=component.get('c.onloadSalesOrder');
            getmethod.setParams({
            recordid : getrecId,
        })
        getmethod.setCallback(this , function(resp){
            var state= resp.getState();
           // alert(JSON.parse(resp.getReturnValue()).success);
            if(state==='SUCCESS' && JSON.parse(resp.getReturnValue()).success){
                console.log(resp.getReturnValue());
                var retrnval =JSON.parse(resp.getReturnValue());
                component.set('v.wrapMains', retrnval);
            }
        })
        $A.enqueueAction(getmethod);
    },
    onSave: function(component, event, helper) {
        var action = component.get('c.createDeliveryNoteObjAndItems');
        var wrapper=component.get('v.wrapMains');
        //alert(wrapper);
        action.setParams({
            strMainWrapper:JSON.stringify(wrapper),
        });
        action.setCallback(this, function(res){
            var state=res.getState();
            if(state==="SUCCESS" && JSON.parse(res.getReturnValue()).success){
         var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Delivery Note created successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
               $A.get("e.force:closeQuickAction").fire();
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:JSON.parse(res.getReturnValue()).strErrorMessage,
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})