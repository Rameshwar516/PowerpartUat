({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component,event);
    },
	handleUploadFinished : function(component, event, helper) {
		
        //Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
		var intNumberofFile = uploadedFiles.length;
		var strDocumentIdList;
		
        for(var i =0; i < intNumberofFile; i++)
		{
			var documentId = uploadedFiles[i].documentId;
			var fileName = uploadedFiles[i].name;
			if(strDocumentIdList != null && strDocumentIdList != '')
				strDocumentIdList = strDocumentIdList + ','+documentId;
			else
				strDocumentIdList = documentId;
		}
        helper.UpdateDocument(component,strDocumentIdList);
        component.set("v.boolshowImage","false");
        //alert(strDocumentIdList);
        
	},
    
    handleRenameJS : function(component, event, helper)
    {
        helper.handleRenameHelper(component, event);
    },
    
    handleHideErrorDisplayModal : function(component, event, helper)
    {
        if(component.get("v.SuccessMessage") != null && component.get("v.SuccessMessage") != '')
        {
            component.set("v.SuccessMessage","");
            $A.get('e.force:refreshView').fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire(); 
        }
        component.set("v.ErrorMessage","");
    },
    removeDisable : function(component, event, helper)
    {
        component.set("v.boolRename", false);
    }
    
})