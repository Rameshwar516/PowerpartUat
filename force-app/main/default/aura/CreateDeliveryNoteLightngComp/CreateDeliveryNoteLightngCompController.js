({
	doinit : function(component, event, helper) {
		var getrecId=component.get('v.recordId');
        helper.Onloadmethod(component, event, getrecId);
	},
    createDeliveryNote: function(component, event, helper) {
        if(component.get('v.isSave')==false){
            component.set("v.isSave",true);
            var Childlst = component.get('v.wrapMains.wrapChildlst');
            var selected = false;
            var QuantyError = false;
            var freezeError = false;
            var Alldone = false;
            for(var i=0;i<Childlst.length;i++)
            {
                if(Childlst[i].isSelected == true ){
                    selected = true;
                  /*  if(Childlst[i].reMaininQTY > Childlst[i].quantity ){
                        QuantyError = true; 
                    }*/
                }
                if(Childlst[i].isSelected == true ){
                    selected = true;
                    /*if(Childlst[i].reMaininQTY > Childlst[i].freezeQTY ){
                        freezeError = true; 
                    }*/
                }
            }
            for(var i=0;i<Childlst.length;i++)
            {   
                if(!Childlst[i].checkboxDisable){
                    Alldone = false; 
                    break;
                }
                else{
                    Alldone = true;
                } 
            }
            
            
            if(selected == true && Alldone == false){
                if(!QuantyError && !freezeError){ 
                    helper.onSave(component, event, helper); 
                    component.set("v.isSave",false);
                } 
                /*
                else if(freezeError){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Quantity Value can not be greater than Freeze Qty Value.',
                        type: 'error',
                    });
                    toastEvent.fire();  
                    component.set("v.isSave",false);
                }
                else if(QuantyError){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Quantity Value can not be greater than SO Qty Value.',
                        type: 'error',
                    });
                    toastEvent.fire();  
                    component.set("v.isSave",false);
                }*/
            }
            else if(selected == false && Alldone == false){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Please select at least one part',
                    type: 'error',
                });
                toastEvent.fire();
                component.set("v.isSave",false);
            }
        } 
        
    },
    selectAll: function(component, event, helper) {
       var wrapper=component.get("v.wrapMains");
                var slctCheck = event.getSource().get("v.value");
        for(var i=0;i<wrapper.wrapChildlst.length;i++){
            if(slctCheck==true && wrapper.wrapChildlst[i].checkboxDisable != true){
                wrapper.wrapChildlst[i].isSelected=true;
            }else{
                wrapper.wrapChildlst[i].isSelected=false;
            }
            
        }
        component.set("v.wrapMains",wrapper);
    },
    cancel : function(component){
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    onRemainQtyChange: function(component, event, helper) {
        console.log('change');
        
        var rowindex = event.getSource().get("v.name");
        var wrapperchild=component.get("v.wrapMains.wrapChildlst");
        if(event.getSource().get("v.value") != null && event.getSource().get("v.value") > 0){
            helper.onRemainQty(component, event, helper);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Quantity can not be 0 or less than 0.',
                type: 'error',
            });
            toastEvent.fire();
        }
		
        
        
    },
    onSalesPriceChange: function(component, event, helper) {
        helper.onSalesPrice(component, event, helper);
    },
    onDiscountChange: function(component, event, helper) {
        helper.onDiscount(component, event, helper);
    },
    onDiscountamtChange: function(component, event, helper) {
        helper.onDiscountamt(component, event, helper);
    },
    onCGSTChange: function(component, event, helper) {
        helper.onCGST(component, event, helper);
    },
    onSGSTChange: function(component, event, helper) {
        helper.onSGST(component, event, helper);
    },
    onIGSTChange: function(component, event, helper) {
        helper.onIGST(component, event, helper);
    },
    deliverydateactionCheckbox : function(component, event, helper) {
        var tmpMainWrapper =  component.get('v.wrapMains.wrapChildlst');
        var isdeliverydate =  component.get('v.isdeliverydate');
        if(isdeliverydate==true){
            if(tmpMainWrapper.length>=2){
                console.log(tmpMainWrapper[0].deliverydate);
                if(tmpMainWrapper[0].deliverydate != null && tmpMainWrapper[0].deliverydate != ''){
                    for(var i=1;i<tmpMainWrapper.length;i++){
                        tmpMainWrapper[i].deliverydate = tmpMainWrapper[0].deliverydate;
                    } 
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Delivery date at first part have to be filled."
                    });
                    toastEvent.fire();
                }
            }
        }
        component.set("v.wrapMains.wrapChildlst",tmpMainWrapper);
    },
    
})