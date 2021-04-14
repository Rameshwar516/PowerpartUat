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
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        
        var error = false;
        for(var i=0; i< wrapperchild.length;i++){
            if(wrapperchild[i].reMaininQTY != null && wrapperchild[i].reMaininQTY > 0){
                
            }  
            else{
                error=true;
                break;
            }
        }
        
        if(!error){
        
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
        }
        else{
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Part Quantity can not be 0 or less than 0.Please Check before save.',
                type: 'error',
            });
            toastEvent.fire();
        }
        
        $A.enqueueAction(action);
    },
    onRemainQty: function(component, event, helper) {
        console.log('change helper');
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        var slctCheck = event.getSource().get("v.value");
        var rowindex = event.getSource().get("v.name");
         console.log('rowindex '+rowindex);
        wrapperchild[rowindex].reMaininQTY=slctCheck;
        wrapperchild[rowindex].totalprice = wrapperchild[rowindex].salesprice*wrapperchild[rowindex].reMaininQTY;
        wrapperchild[rowindex].discountamount = (wrapperchild[rowindex].totalprice*wrapperchild[rowindex].discount)/100;
        wrapperchild[rowindex].totalamount = wrapperchild[rowindex].totalprice - wrapperchild[rowindex].discountamount;
        wrapperchild[rowindex].cgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].cgst)/100;
        wrapperchild[rowindex].sgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].sgst)/100;
        wrapperchild[rowindex].igstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].igst)/100;
        wrapperchild[rowindex].nettotal = wrapperchild[rowindex].totalamount+wrapperchild[rowindex].igstamount+wrapperchild[rowindex].sgstamount+wrapperchild[rowindex].cgstamount;
        component.set("v.wrapMains.wrapChildlst",wrapperchild);
    },
    onSalesPrice: function(component, event, helper) {
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        var slctCheck = event.getSource().get("v.value");
        var rowindex = event.getSource().get("v.name");
        wrapperchild[rowindex].salesprice=slctCheck;
        wrapperchild[rowindex].totalprice = wrapperchild[rowindex].salesprice*wrapperchild[rowindex].reMaininQTY;
        wrapperchild[rowindex].discountamount = (wrapperchild[rowindex].totalprice*wrapperchild[rowindex].discount)/100;
        wrapperchild[rowindex].totalamount = wrapperchild[rowindex].totalprice - wrapperchild[rowindex].discountamount;
        wrapperchild[rowindex].cgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].cgst)/100;
        wrapperchild[rowindex].sgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].sgst)/100;
        wrapperchild[rowindex].igstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].igst)/100;
        wrapperchild[rowindex].nettotal = wrapperchild[rowindex].totalamount+wrapperchild[rowindex].igstamount+wrapperchild[rowindex].sgstamount+wrapperchild[rowindex].cgstamount;
        component.set("v.wrapMains.wrapChildlst",wrapperchild);
    },
    onDiscount: function(component, event, helper) {
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        var slctCheck = event.getSource().get("v.value");
        var rowindex = event.getSource().get("v.name");
        wrapperchild[rowindex].discount = slctCheck;
        wrapperchild[rowindex].discountamount = (wrapperchild[rowindex].totalprice*wrapperchild[rowindex].discount)/100;
        wrapperchild[rowindex].totalamount = wrapperchild[rowindex].totalprice - wrapperchild[rowindex].discountamount;
        wrapperchild[rowindex].cgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].cgst)/100;
        wrapperchild[rowindex].sgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].sgst)/100;
        wrapperchild[rowindex].igstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].igst)/100;
        wrapperchild[rowindex].nettotal = wrapperchild[rowindex].totalamount+wrapperchild[rowindex].igstamount+wrapperchild[rowindex].sgstamount+wrapperchild[rowindex].cgstamount;
        component.set("v.wrapMains.wrapChildlst",wrapperchild);
    },
    onDiscountamt: function(component, event, helper) {
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        var slctCheck = event.getSource().get("v.value");
        var rowindex = event.getSource().get("v.name");
        wrapperchild[rowindex].discountamount = slctCheck;
        wrapperchild[rowindex].discount = (wrapperchild[rowindex].discountamount/wrapperchild[rowindex].totalprice)*100;
        wrapperchild[rowindex].totalamount = wrapperchild[rowindex].totalprice - wrapperchild[rowindex].discountamount;
        wrapperchild[rowindex].cgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].cgst)/100;
        wrapperchild[rowindex].sgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].sgst)/100;
        wrapperchild[rowindex].igstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].igst)/100;
        wrapperchild[rowindex].nettotal = wrapperchild[rowindex].totalamount+wrapperchild[rowindex].igstamount+wrapperchild[rowindex].sgstamount+wrapperchild[rowindex].cgstamount;
        component.set("v.wrapMains.wrapChildlst",wrapperchild);
    },
    onCGST: function(component, event, helper) {
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        var slctCheck = event.getSource().get("v.value");
        var rowindex = event.getSource().get("v.name");
        wrapperchild[rowindex].cgst = slctCheck;
        wrapperchild[rowindex].cgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].cgst)/100;
        wrapperchild[rowindex].nettotal = wrapperchild[rowindex].totalamount+wrapperchild[rowindex].igstamount+wrapperchild[rowindex].sgstamount+wrapperchild[rowindex].cgstamount;
        component.set("v.wrapMains.wrapChildlst",wrapperchild);
    },
    onSGST: function(component, event, helper) {
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        var slctCheck = event.getSource().get("v.value");
        var rowindex = event.getSource().get("v.name");
        wrapperchild[rowindex].sgst = slctCheck;
        wrapperchild[rowindex].sgstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].sgst)/100;
        wrapperchild[rowindex].nettotal = wrapperchild[rowindex].totalamount+wrapperchild[rowindex].igstamount+wrapperchild[rowindex].sgstamount+wrapperchild[rowindex].cgstamount;
        component.set("v.wrapMains.wrapChildlst",wrapperchild);
    },
    onIGST: function(component, event, helper) {
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        var slctCheck = event.getSource().get("v.value");
        var rowindex = event.getSource().get("v.name");
        wrapperchild[rowindex].igst = slctCheck;
        wrapperchild[rowindex].igstamount = (wrapperchild[rowindex].totalamount*wrapperchild[rowindex].igst)/100;
        wrapperchild[rowindex].nettotal = wrapperchild[rowindex].totalamount+wrapperchild[rowindex].igstamount+wrapperchild[rowindex].sgstamount+wrapperchild[rowindex].cgstamount;
        component.set("v.wrapMains.wrapChildlst",wrapperchild);
    },
    
})