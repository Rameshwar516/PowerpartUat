({
	doinit : function(component, event, helper) {
		var getrecId=component.get('v.recordId');
        helper.Onloadmethod(component, event, getrecId);
	},
    createDeliveryNote: function(component, event, helper) {
       helper.onSave(component, event, helper);
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
})