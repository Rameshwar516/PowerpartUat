({
	onLoad : function(component, event, helper){
        var action = component.get('c.convertLead');
        action.setParams({
            'strRecordid' : component.get('v.recordId')
        });
        action.setCallback(this, function (res) {
            if(res.getState() === 'SUCCESS'){
                
                var allval = res.getReturnValue();
                component.set("v.wrapmain", JSON.parse(allval));
                component.set("v.companyname", JSON.parse(allval).objlead.Name);
                var accountname = component.get("v.companyname");
               
                //alert(accountname);
                if(accountname !== "undefined")
                {
                    component.set("v.errorMessage", '');
                    component.set('v.isConvertedLead',false);
                    component.set('v.isNonConvertedLead',true);
                }
                else
                {
                    component.set("v.errorMessage", msg);
                    component.set('v.isConvertedLead',false);
                    component.set('v.isNonConvertedLead',true);
                }
                if(JSON.parse(allval).errorMSG != null){
                   /* component.set('v.convertedMessage', JSON.parse(allval).errorMSG);
					
                    component.set('v.isConvertedLead',true); 
                    component.set('v.isNonConvertedLead',false);
                    component.set('v.errorMessage', '');
                    component.set('v.successMessage', '')*/
                     $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire(); 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: JSON.parse(allval).errorMSG,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }else{
                    component.set('v.errorMessage', '');
                }
            }
        });
        
         $A.enqueueAction(action);
    },
    
    
})