({
	initHelper : function(component, event) 
    {
        //alert(component.get("v.recordId"));
        component.set("v.spinnerIsVisibile",true);
		var action = component.get("c.doInit");
		action.setParams({
            strParentRecId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.spinnerIsVisibile",false);
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {
                
                component.set("v.mainWrap",JSON.parse(response.getReturnValue()));
                component.set("v.lstPartReqWrap",JSON.parse(response.getReturnValue()).lstPartReqWrap);
            }else if(response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.ErrorMessage",errors[0].message);
                    }
                } else {
					component.set("v.ErrorMessage","Unknown error");
                }
            }else if (!JSON.parse(response.getReturnValue()).success) {
				component.set("v.ErrorMessage",JSON.parse(response.getReturnValue()).strError);
            }
        });
        $A.enqueueAction(action);
	},
    
    submitHelper : function(component, event) 
    {
        component.set("v.spinnerIsVisibile",true);
        var part = [];
        for (var i = 0; i < component.get("v.lstPartReqWrap").length; i++) {
           if(!component.get("v.lstPartReqWrap").isEdit)
           {
               part.push(component.get("v.lstPartReqWrap").objPartReq);
           }
        }
		var action = component.get("c.submit");
		action.setParams({
            "strPartReqWrap" : JSON.stringify(component.get("v.lstPartReqWrap")),
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.spinnerIsVisibile",false);
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) {
                component.set("v.mainWrap",JSON.parse(response.getReturnValue()));
                component.set("v.lstPartReqWrap",JSON.parse(response.getReturnValue()).lstPartReqWrap);
                component.set("v.SuccessMessage",JSON.parse(response.getReturnValue()).strSuccess);
            }else if(response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.ErrorMessage",errors[0].message);
                    }
                } else {
					component.set("v.ErrorMessage","Unknown error");
                }
            }else if (!JSON.parse(response.getReturnValue()).success) {
				component.set("v.ErrorMessage",JSON.parse(response.getReturnValue()).strError);
            }
        });
        $A.enqueueAction(action);
	},
    deleteHelper : function(component, event, recPartReq) 
    {
        component.set("v.spinnerIsVisibile",true); 
		var action = component.get("c.deletePR");
		action.setParams({
            "recordId" : component.get("v.recordId"),
            "partReqRecordId":recPartReq
        });
        action.setCallback(this, function(response) {
            component.set("v.spinnerIsVisibile",false);
            if(response.getState() === "SUCCESS" && JSON.parse(response.getReturnValue()).success ) 
            {
                component.set("v.mainWrap",JSON.parse(response.getReturnValue()));
                component.set("v.lstPartReqWrap",JSON.parse(response.getReturnValue()).lstPartReqWrap);
                component.set("v.SuccessMessage",JSON.parse(response.getReturnValue()).strSuccess);
            }
            else if(response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.ErrorMessage",errors[0].message);
                    }
                } else {
					component.set("v.ErrorMessage","Unknown error");
                }
            }else if (!JSON.parse(response.getReturnValue()).success) {
				component.set("v.ErrorMessage",JSON.parse(response.getReturnValue()).strError);
            }
        });
        $A.enqueueAction(action);
	},
    
    checkFailedTypePick : function(component, event)
    {
        var partType = component.get("v.mainWrap.partTypePick");
        var tmpPartWrapper = component.get("v.lstPartReqWrap");
        var check = false;
        for(var i=0; i<tmpPartWrapper.length;i++)
        {
            if(tmpPartWrapper[i].objPartReq.Part_Type__c == 'Failed')
                check = true;
        }
        
        if(check)
        {
            for(var i=0;i<partType.length;i++)
            {
                if(partType[i].value == 'Failed')
                    partType[i].isDisable = true;
            }
        }
        else
        {
            for(var i=0;i<partType.length;i++)
            {
                if(partType[i].value == 'Failed')
                    partType[i].isDisable = false;
            }
        }
        component.set("v.mainWrap.partTypePick" , partType);
    },
    
    checkError : function(component, event, tmpWrapper, RecordIndexStr) {
        var strerror= '';
        var checkall = false;
        tmpWrapper[RecordIndexStr].strPartTypeErr ='';
        tmpWrapper[RecordIndexStr].strWarrentyTypeErr = '';
        tmpWrapper[RecordIndexStr].strPartErr = '';
        tmpWrapper[RecordIndexStr].strQuantityErr ='';
        tmpWrapper[RecordIndexStr].boolShowError = false;
        if(!tmpWrapper[RecordIndexStr].objPartReq.Part_Type__c)
        { 
            
            strerror = "Please select Part Type";
            tmpWrapper[RecordIndexStr].strPartTypeErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].objPartReq.Warranty_Type__c)
        {
            strerror = "Please select Warranty Type";
            tmpWrapper[RecordIndexStr].strWarrentyTypeErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].objPart.Id)
        { 
            strerror = "Please select Part No.";
            tmpWrapper[RecordIndexStr].strPartErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].objPartReq.Quantity__c)
        { 
            strerror = "Please Enter Quantity";
            tmpWrapper[RecordIndexStr].strQuantityErr = strerror;
            checkall = true;
        }
        
        if(checkall)
        {
            component.set("v.Error", true);
            tmpWrapper[RecordIndexStr].boolShowError = true;
            component.set("v.lstPartReqWrap",tmpWrapper);
        }  
        else
            component.set("v.Error", false);
    }
})