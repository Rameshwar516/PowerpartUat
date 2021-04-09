({
    helperMethodSave : function(component, event, helper) {
        var action = component.get('c.saveSafetyRules');
        action.setParams({
            'ids' :component.get('v.recordId'),
            'Radiobutton1':component.get('v.Radiobutton1'),
            'Radiobutton2':component.get('v.Radiobutton2'),
            'Radiobutton3':component.get('v.Radiobutton3'),
            'Radiobutton4':component.get('v.Radiobutton4'),
            'Radiobutton5':component.get('v.Radiobutton5'),
            'otherSafety':component.get('v.otherEquipment'),
        });
        action.setCallback(this,function(res){
            if(res.getState() === 'SUCCESS'){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: $A.get("$Label.c.successMessageForSafetyRule"),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();            }
        });
        $A.enqueueAction(action);
    }
})