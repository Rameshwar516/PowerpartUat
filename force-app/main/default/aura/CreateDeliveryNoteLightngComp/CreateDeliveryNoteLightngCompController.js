({
	doinit : function(component, event, helper) {
		var getrecId=component.get('v.recordId');
        helper.Onloadmethod(component, event, getrecId);
	},
    createDeliveryNote: function(component, event, helper) {
        
        var Childlst = component.get('v.wrapMains.wrapChildlst');
        console.log(Childlst);
        var selected = false;
        for(var i=0;i<Childlst.length;i++)
        {
            console.log(Childlst[i].isSelected);
            if(Childlst[i].isSelected == true)
                selected = true;
        }
        
        if(selected == true){
         helper.onSave(component, event, helper);   
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please select atleast one part',
                type: 'error',
            });
            toastEvent.fire();
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
		helper.onRemainQty(component, event, helper);
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
    
 
})