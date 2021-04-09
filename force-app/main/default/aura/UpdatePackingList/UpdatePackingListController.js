({
    doinit : function(component, event, helper) {
        var id = component.get("v.recordId");
        helper.pageLoadClassMethod(component, event, id);
    },
    checkJs :function(component, event, helper) {
        var tmpWrapper = [];
        var tmpMainWrapper = component.get("v.wrapMain.inrWrap");
        var Istrue = false; 
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(tmpMainWrapper[i].isSelected){
                Istrue = true;
            }
        }
        if(Istrue){
            var objWrap = component.get("v.wrapMain");
            //helper.AddRecordOnCheck(component, event, objWrap);
        }else{
            var msg = $A.get("$Label.c.Product_Selection");
            component.set("v.wrapMain.strMessage", msg);
            component.set("v.wrapMain.success", false);
        }
        
    },
	
	SaveJS  :function(component, event, helper) {
        var tmpWrapper = [];
        var tmpMainWrapper = component.get("v.wrapMain.inrWrap");
        var Istrue = false; 
		var IsBlank = false; 
       // alert('.....');
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(tmpMainWrapper[i].isSelected){
				if(tmpMainWrapper[i].strBoxType != null && tmpMainWrapper[i].strBoxType != '' && tmpMainWrapper[i].decLength != null && tmpMainWrapper[i].decLength != '' && tmpMainWrapper[i].decWidth != null && tmpMainWrapper[i].decWidth != ''  && tmpMainWrapper[i].decHeight != null && tmpMainWrapper[i].decHeight != '')
				{
					 //alert('.....'+tmpMainWrapper[i].strBoxType);
                    //alert('.....'+tmpMainWrapper[i].decLength);
                    
				}
				else{
					IsBlank = true;
                    tmpMainWrapper[i].rowError = 'Error on this row!!';
				}
                Istrue = true;
            }
        }
        //alert(Istrue+'...'+IsBlank);
        if(Istrue && !IsBlank){
            var objWrap = component.get("v.wrapMain");
            helper.AddRecordOnCheck(component, event, objWrap);
        }else if(!Istrue){
            
            var msg = $A.get("$Label.c.Product_Selection");
            
            component.set("v.wrapMain.strMessage", msg);
            component.set("v.wrapMain.success", false);
        }
		else{
            component.set("v.isErrorRow",true );
            component.set("v.wrapMain.inrWrap",tmpMainWrapper );
            console.log(component.get("v.isErrorRow"));
            component.set("v.wrapMain.strMessage", 'Please fill the box details.');
            component.set("v.wrapMain.success", false);
        }
        
    },
	
    cancel : function(component){
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    hideSpinner : function(component,event,helper){ 
        component.set("v.Spinner", false);
    },
    handleHideErrorDisplayModal : function(component,event, helper) {
        component.set("v.wrapMain.strMessage",'');
    }
    
})