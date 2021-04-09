({
    clickRadio1 : function(component, event, helper) {
        
        var rb1=event.currentTarget.id;
        component.set('v.Radiobutton1',rb1);
        
    },
    clickRadio2: function(component, event, helper) {
        
        var rb2=event.currentTarget.id;
        component.set('v.Radiobutton2',rb2);
        
    },
    clickRadio3: function(component, event, helper) {
        
        var rb3=event.currentTarget.id;
        component.set('v.Radiobutton3',rb3);
        
    },
    clickRadio4: function(component, event, helper) {
        
        var rb4=event.currentTarget.id;
        component.set('v.Radiobutton4',rb4);
        
    },
    clickRadio5: function(component, event, helper) {
        
        var rb5=event.currentTarget.id;
        component.set('v.Radiobutton5',rb5);
        
    },
    saveHandler: function(component, event, helper) {
        if(component.get('v.Radiobutton1') !=undefined && component.get('v.Radiobutton2')!=undefined && component.get('v.Radiobutton3')!=undefined && component.get('v.Radiobutton4')!=undefined && component.get('v.Radiobutton5')!=undefined)
        {
            helper.helperMethodSave(component, event, helper);
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please Select All Radio button.',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
    }
})