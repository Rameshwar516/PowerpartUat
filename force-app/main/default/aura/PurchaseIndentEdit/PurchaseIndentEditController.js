({
	initJS : function(component, event, helper) {
        var action = component.get("c.doInit");
        action.setParams({
            'recordId' : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                //alert('Success');
                var result = JSON.parse(response.getReturnValue());
                component.set('v.mainWrapper', result);
                component.set('v.PurchaseIndentItems', result.lstIIW);
                component.set('v.IndentBy', result.objIBUser);
                component.set('v.SalesOfficer', result.objSOUser);
            }
        });
        $A.enqueueAction(action);
	},
    DeleteRow : function(component, event, helper){
        
        var RecordIndexStr = event.getSource().get("v.value");
        var removeIndex=parseInt(RecordIndexStr);
        var Items = component.get("v.PurchaseIndentItems");
        Items.splice(removeIndex, 1);
        component.set('v.PurchaseIndentItems', Items);
        if(Items.length == 0 && component.get('v.isDirect')){
            helper.addRowHelper(component, event,Items);
        }
        
    },
    EditRecord: function(component,event,helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var PIIWrapper = component.get("v.PurchaseIndentItems");
        
        if(PIIWrapper[RecordIndexStr].isEdit == false)
        {
            PIIWrapper[RecordIndexStr].isEdit = true;
        }
        component.set("v.PurchaseIndentItems",PIIWrapper);
    },
    ModifyRecord : function(component,event,helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var PIIWrapper = component.get("v.PurchaseIndentItems");
        
        if(PIIWrapper[RecordIndexStr].isEdit == true)
        {
            helper.checkError(component, event, PIIWrapper, RecordIndexStr)
            if(!component.get('v.Error')){
                PIIWrapper[RecordIndexStr].isEdit = false;
                component.set("v.PurchaseIndentItems",PIIWrapper);
            }
        }
    },
    submitJS : function(component,event,helper){
        var mainWrap = component.get('v.mainWrapper');
        if(component.get('v.IndentBy.Id'))
        	mainWrap.objPurchaseIndent.Indent_By__c = component.get('v.IndentBy.Id');
        if(component.get('v.SalesOfficer.Id'))
        	mainWrap.objPurchaseIndent.Sales_Officer__c = component.get('v.SalesOfficer.Id');
        
        var items = component.get('v.PurchaseIndentItems');
        var validSoFor = false;
        for(var i = 0; i <items.length; i++){
            helper.checkError(component, event, items, i)
            validSoFor = validSoFor || component.get('v.Error');
        }
        if(!validSoFor){
            var items = component.get('v.PurchaseIndentItems');
            for(var i = 0; i< items.length; i++){
                items[i].objPILI.Product_Part__c = items[i].objPart.Id;
                items[i].objPILI.Name = items[i].objPart.Part_Name__c;
                if(items[i].objPart.Stocks__r){
                    for(var j =0 ; j< items[i].objPart.Stocks__r.length ; j++){
                        if(items[i].objPart.Stocks__r[j].Ware_House__c == component.get('v.mainWrapper.objPurchaseIndent.Ware_House__c'))
                            items[i].objPILI.Stock_Actual__c = items[i].objPart.Stocks__r[j].Total_Quantity__c;
                    }
                    items[i].objPart.Stocks__r = null;
                }
            }
            mainWrap.lstIIW = items;
            component.set('v.mainWrapper', mainWrap);
            helper.submitHelper(component,event);
        }
        else
            alert('Please fill all required Fields before submit.');
    },
    cancelJS : function(component,event,helper){
        var result = component.get('v.mainWrapper');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": result.objPurchaseIndent.Id,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    AddTandCJS :function(component,event,helper){
        component.set('v.showTAndC', true);
    },
    closeTAndC :function(component,event,helper){
        component.set('v.showTAndC', false);
    }
})