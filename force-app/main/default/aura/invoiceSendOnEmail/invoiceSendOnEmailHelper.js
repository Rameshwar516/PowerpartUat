({
	 inithelper: function(component, event, helper){
         //alert('helper calling');
         var action = component.get('c.intid');
        
       action.setParams({
            invRecId:component.get('v.recordId'),
            
        });
        action.setCallback(this, function(res){
            var state=res.getState();
            if(state==="SUCCESS" && JSON.parse(res.getReturnValue()).success){
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
        
        var sub1=component.find('Subject');
        var sub11=sub1.get('v.value');
        var Bodyy1=component.find('bodyid');
        var Bodyy11=Bodyy1.get('v.value');
        var mailAdd1=component.find('EmailAddress');
        var mailAdd11=mailAdd1.get('v.value');
        var ccAdd1=component.find('CC');
        var ccAdd11=ccAdd1.get('v.value');
        //alert( ' n/t'+ component.get('v.recordId'));
        
        action.setParams({
            invRecId:component.get('v.recordId'),
           
            sub:sub11,
            Bodyy:Bodyy11,
            mailAdd:mailAdd11,
            ccAdd:ccAdd11,
            
        });
         
        action.setCallback(this, function(res){
            var state=res.getState(); 
            if(state==="SUCCESS"){
          //alert('success helper');
            }else{
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },	
	
})