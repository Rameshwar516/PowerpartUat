({
    inithelper: function(component, event, helper) {
        var action = component.get('c.intid');
        
        //alert(component.find('bodyy').get('v.value'));
        
        action.setParams({
            QuotRecId:component.get('v.recordId'),
            //Bodyy:component.find('bodyy').get('v.value')
        });
        action.setCallback(this, function(res){
            var state=res.getState();
            if(state==="SUCCESS" && JSON.parse(res.getReturnValue()).success){
                //  component.set('v.toaddress', JSON.parse(res.getReturnValue()).objquote.Email__c);
                component.set('v.wrappr', JSON.parse(res.getReturnValue()));
            }
            else{
                alert('method not working');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    sendmessage : function(component, event, helper) {
        var action = component.get('c.send');
        //  alert(component.find('Subject').get('v.value'));
        //  alert(component.find('CC').get('v.value'));
        
        //  alert(component.get('v.recordId'));
        //    alert(component.find('EmailAddress').get('v.value'));
        //   alert(component.find('bodyid').get('v.value'));
        
        var sub1=component.find('Subject');
        var sub11=sub1.get('v.value');
        var Bodyy1=component.find('bodyid');
        var Bodyy11=Bodyy1.get('v.value');
        var mailAdd1=component.find('EmailAddress');
        var mailAdd11=mailAdd1.get('v.value');
        var ccAdd1=component.find('CC');
        var ccAdd11=ccAdd1.get('v.value');
        
        
        action.setParams({
            QuotRecId:component.get('v.recordId'),
            sub:sub11,
            Bodyy:Bodyy11,
            mailAdd:mailAdd11,
            ccAdd:ccAdd11,
            
        });
        
        action.setCallback(this, function(res){
            var state=res.getState(); 
            if(state==="SUCCESS"){
               
            }else{
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },
})