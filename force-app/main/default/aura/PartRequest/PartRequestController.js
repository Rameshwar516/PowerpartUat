({
    initJS : function(component, event, helper) 
    {
        helper.initHelper(component, event);
    },
    
    EditRecord: function(component,event,helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var tmpMainWrapper = component.get("v.lstPartReqWrap");
        if(tmpMainWrapper[RecordIndexStr].isEdit == false)
        {
            tmpMainWrapper[RecordIndexStr].isEdit = true;
        }
        component.set("v.lstPartReqWrap",tmpMainWrapper);
    },
    
    ModifyRecord : function(component,event,helper){
        var RecordIndexStr = event.getSource().get("v.value");
        var tmpWrapper = component.get("v.lstPartReqWrap");
        
        helper.checkError(component, event, tmpWrapper, RecordIndexStr);
        if(!component.get("v.Error"))
        {
            tmpWrapper[RecordIndexStr].objPartReq.Part__c = tmpWrapper[RecordIndexStr].objPart.Id;
            tmpWrapper[RecordIndexStr].objPartReq.Name = tmpWrapper[RecordIndexStr].objPart.Name;
            tmpWrapper[RecordIndexStr].isEdit = false;
            component.set("v.lstPartReqWrap",tmpWrapper);
        }
        helper.checkFailedTypePick(component,event);
    },
    
    DeleteRecord : function(component,event,helper){
        var tmpWrapper = [];
        var tmpDeletedId = [];
        var tmpMainWrapper = component.get("v.lstPartReqWrap");
        var RecordIndexStr = event.getSource().get("v.value");
        var removeIndex=parseInt(RecordIndexStr);
        var recPartReq ='';
        if(tmpMainWrapper[removeIndex].isExist)
        	recPartReq = tmpMainWrapper[removeIndex].objPartReq.Id;
        
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(removeIndex == i)
            {
                if(tmpMainWrapper[i].objPartReq != null && tmpMainWrapper[i].objPartReq.Id != null)
                {
                    tmpDeletedId.push(tmpMainWrapper[i]);
                } 
            }
            else
            {
                tmpWrapper.push(tmpMainWrapper[i]);
            } 
        }
        if(tmpWrapper.length > 0)
        	component.set("v.lstPartReqWrap",tmpWrapper);
        else
        {
            var tmpLineItemWrap = {"objPart":{"attributes":{"type":"Part__c"}},"objPartReq":{"attributes":{"type":"Part_Request__c"}},"isEdit":true,"isExist":false};
            tmpWrapper.push(tmpLineItemWrap);
            component.set("v.lstPartReqWrap",tmpWrapper);
        }
        
        if(recPartReq)
            helper.deleteHelper(component,event, recPartReq);
        else
          component.set("v.SuccessMessage","Record Delete Successfully."); 
        
        helper.checkFailedTypePick(component,event);
          
    },
    
    addRow : function(component, event, helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var tmpWrapper = component.get("v.lstPartReqWrap");
        helper.checkError(component, event, tmpWrapper, RecordIndexStr);
        
        if(!component.get("v.Error"))
        {
            tmpWrapper[RecordIndexStr].isEdit = false;
            tmpWrapper[RecordIndexStr].objPartReq.Part__c = tmpWrapper[RecordIndexStr].objPart.Id;
            tmpWrapper[RecordIndexStr].objPartReq.Name = tmpWrapper[RecordIndexStr].objPart.Name;
            tmpWrapper[RecordIndexStr].objPartReq.Service_Request__c = component.get("v.recordId");
            var tmpLineItemWrap = {"objPart":{"attributes":{"type":"Part__c"}},"objPartReq":{"attributes":{"type":"Part_Request__c"}},"isEdit":true,"isExist":false};
            tmpWrapper.push(tmpLineItemWrap);
            component.set("v.lstPartReqWrap",tmpWrapper);
        }
        
        helper.checkFailedTypePick(component,event);
    },
    
    removeRow : function(component, event, helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var tmpWrapper = component.get("v.lstPartReqWrap");  
        if(tmpWrapper[RecordIndexStr].isEdit && tmpWrapper.length > 1)
        {
            tmpWrapper.pop();
            component.set("v.lstPartReqWrap",tmpWrapper);
        }
        helper.checkFailedTypePick(component,event);
    },
    submitJS : function(component, event, helper)
    {
        var tmpWrapper = component.get("v.lstPartReqWrap");
        var length = tmpWrapper.length;
        if(length > 0)
        {
            var checkall = false;
            var strerror ='Please fill all required Fields before submit.';
            for(var i= 0; i< length; i++)
            {
                if(tmpWrapper[i].objPartReq.Part_Type__c){ checkall = false;}
                else
                {
                    checkall = true;
                    break;
                }
                if(tmpWrapper[i].objPartReq.Warranty_Type__c){ checkall = false;}
                else
                {
                    checkall = true;
                    break;
                }
                if(tmpWrapper[i].objPart.Id){ checkall = false;}
                else
                {
                    checkall = true;
                    break;
                }
                if(tmpWrapper[i].objPartReq.Quantity__c){ checkall = false;}
                else
                {
                    checkall = true;
                    break;
                } 
            }
            if(checkall)
               component.set("v.ErrorMessage",strerror);
            else
            	helper.submitHelper(component, event);
        }
    },
    handleHideErrorDisplayModal : function(component, event, helper)
    {
        component.set("v.SuccessMessage","");
        component.set("v.ErrorMessage","");
    },
    closeJS : function(component, event, helper)
    {
        $A.get('e.force:refreshView').fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        
    },
    
})