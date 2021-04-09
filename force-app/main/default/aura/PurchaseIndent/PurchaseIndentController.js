({
	initJS : function(component, event, helper) {
        helper.initHelper(component, event, helper);
	},
    onChangeSalesOrder : function(component, event, helper){
        var salesOrder = component.get('v.SalesOrder');
        var SalesOrderItems =[];
        var PIItems = component.get("v.PurchaseIndentItems");
        for(var i= 0; i< PIItems.length; i++)
            SalesOrderItems.push(PIItems[i].strSalesOrderItemId);
        if(salesOrder.Name){
            helper.getSalesOrderItem(component, event, salesOrder.Id, SalesOrderItems);
        }
        
    },
    SelectedSORemove : function(component, event, helper){
        var items = component.get('v.SelectedSalesOrder');
        var item = event.getParam("index");
        var removeItem = items.splice(item, 1);
        component.set('v.SelectedSalesOrder', items);
        helper.getSalesOrderItemsIdHelper(component, event, removeItem[0].name);
    },
    onChangeSelect : function(component, event, helper){
        var selectedValue = component.find("IdSelect").get("v.value");
        component.set("v.PurchaseIndentItems", []);
        component.set("v.SelectedSalesOrder", []);
        if(selectedValue == 'Direct'){
            component.set('v.isDirect', true);
            helper.addRowHelper(component, event,component.get('v.PurchaseIndentItems'));
        }
        else if(selectedValue == 'Sales Order'){
            component.set('v.isDirect', false);
        } 
    },
    onChangeExpectedDateJS  :function(component, event, helper){
        var checked = component.get('v.isExpectedDate');
        var ExpectedDate = event.getSource().get('v.value');
        if(checked){
            if(ExpectedDate)
            	helper.ExpectedDateActionCheckbox(component, event, ExpectedDate);
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"info",
                    "title": "info!",
                    "message": "Please change any expected date which you want to be the same for all."
                });
                toastEvent.fire();
            }
        }
    },
    addRow : function(component, event, helper){
        var PIIWrapper = component.get("v.PurchaseIndentItems");
        var RecordIndexStr = event.getSource().get("v.value");
        var Index=parseInt(RecordIndexStr);
        helper.checkError(component, event, PIIWrapper, RecordIndexStr)
        if(!component.get('v.Error')){
            PIIWrapper[RecordIndexStr].isEdit = false;
            helper.addRowHelper(component, event,PIIWrapper);
        }
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
    AddSalesOrder : function(component,event,helper){
        var PIItems = component.get("v.PurchaseIndentItems");
        var SOItems = component.get("v.SalesOrderItems");
        if(SOItems.length > 0){
            var SalesOrder = component.get('v.SalesOrder');
            var soList = component.get("v.SelectedSalesOrder");
            var isExist = false;
            for(var i= 0; i< soList.length; i++)
                if(soList[i].name == SalesOrder.Id)
                    isExist = true;
            if(!isExist){
                soList.push({
                    type: 'icon',
                    href: '',
                    name : SalesOrder.Id,
                    label: SalesOrder.Sales_Order_Acknowledge_Number__c,
                    iconName: 'standard:orders',
                    alternativeText: 'Sales Order',
                });
            }
            component.set("v.SelectedSalesOrder", soList);
            helper.AddSalesOrderHelper(component,event,PIItems,SOItems );
        }
    },
    CancelModal : function(component,event,helper){
       component.set('v.showModal',false); 
    },
    submitJS : function(component,event,helper){
        var mainWrap = component.get('v.mainWrapper');
        var items = component.get('v.PurchaseIndentItems');
        
        if(component.get('v.IndentBy.Id'))
        	mainWrap.objPurchaseIndent.Indent_By__c = component.get('v.IndentBy.Id');
        if(component.get('v.SalesOfficer.Id'))
        	mainWrap.objPurchaseIndent.Sales_Officer__c = component.get('v.SalesOfficer.Id');
        if(component.get('v.Against'))
            mainWrap.objPurchaseIndent.Against__c = component.get('v.Against');
        if(component.get('v.wareHouse.Id'))
            mainWrap.objPurchaseIndent.Ware_House__c = component.get('v.wareHouse.Id');
        
        var validSoFor = false;
        for(var i = 0; i <items.length; i++){
            helper.checkError(component, event, items, i)
            validSoFor = validSoFor || component.get('v.Error');
        }
        if(!validSoFor){
            var items = component.get('v.PurchaseIndentItems');
            for(var i = 0; i< items.length; i++){
                if(items[i].objPart.Stocks__r){
                    for(var j =0 ; j< items[i].objPart.Stocks__r.length ; j++){
                        if(items[i].objPart.Stocks__r[j].Ware_House__c == component.get('v.wareHouse.Id'))
                            items[i].stockActual = items[i].objPart.Stocks__r[j].Total_Quantity__c;
                        //console.log(items[i].objPart.Stocks__r[j].Total_Quantity__c);
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
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Purchase_Indent__c"
        });
        homeEvent.fire();
    },
    AddTandCJS :function(component,event,helper){
        component.set('v.showTAndC', true);
    },
    closeTAndC :function(component,event,helper){
        component.set('v.showTAndC', false);
    }
})