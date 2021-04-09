({
    initHelper : function(component,event, Helper) {
        var action = component.get("c.doInit");
        action.setParams({
            "strRecordId" : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                
                var result = JSON.parse(response.getReturnValue());
                component.set('v.mainWrapper', result);
                component.set('v.PurchaseIndentItems', result.lstIIW);
                component.set('v.IndentBy', result.objIBUser);
                if(component.get('v.recordId')){
                    if(result.objPurchaseIndent.Ware_House__c){
                        var objWareHouse ={
                            "attributes":{"type":"Ware_house__c"},
                            "Id" : result.objPurchaseIndent.Ware_House__c,
                            "Name" : result.objPurchaseIndent.Ware_House__r.Name
                        }
                        component.set('v.wareHouse', objWareHouse);
                    }
                    if(result.objPurchaseIndent.Sales_Officer__c){
                        var objSalesOfficer ={
                            "attributes":{"type":"User"},
                            "Id" : result.objPurchaseIndent.Sales_Officer__c,
                            "Name" : result.objPurchaseIndent.Sales_Officer__r.Name
                        }
                        component.set('v.SalesOfficer', objSalesOfficer);
                    }
                    if(result.lstSalesOrder.length > 0){
                        var soList = component.get("v.SelectedSalesOrder");
                        for(var i= 0; i < result.lstSalesOrder.length; i++){
                            soList.push({
                                type: 'icon',
                                href: '',
                                label: result.lstSalesOrder[i].label,
                                name: result.lstSalesOrder[i].value,
                                iconName: 'standard:orders',
                                alternativeText: 'Sales Order',
                            });
                        }
                        component.set("v.SelectedSalesOrder",soList);
                    }
                    component.set('v.Against', result.objPurchaseIndent.Against__c);
                    component.set('v.isDirect', result.isDirect);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getSalesOrderItem : function(component,event, soId, SalesOrderItems) {
        if(soId){
            var action = component.get('c.getSalesOrderItems');
            action.setParams({
                "recordId": soId,
                'lstId' : SalesOrderItems
            })
            action.setCallback(this, function(response){
                if(response.getState() === "SUCCESS"){
                    var result = JSON.parse(response.getReturnValue());
                    if(result.length > 0){
                        component.set('v.showModal', true);
                        component.set('v.SalesOrderItems', result);
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": 'No SOA Line Items are available.',
                            "type" : 'error'
                        });
                        toastEvent.fire();
                    }
                    
                }
                else if(response.getState() === "ERROR"){
                    var errors = response.getError();
                    if(errors)
                        console.log('Error :'+errors[0].message);
                }
                    else 
                        console.log('Unknown error');
            });
            
        }
        $A.enqueueAction(action);
    },
    submitHelper : function(component,event) {
        var action = component.get('c.SavePurchaseIndent');
        action.setParams({
            "strMainWrapper": JSON.stringify(component.get('v.mainWrapper'))
        })
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = JSON.parse(response.getReturnValue());
                if(result.success && result.objPurchaseIndent.Id){
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result.objPurchaseIndent.Id,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result.strErrorMessage,
                        "type" : 'error'
                    });
                    toastEvent.fire();
                }
            }
            else if(response.getState() === "ERROR"){
                var errors = response.getError();
                if(errors)
                    console.log('Error :'+errors[0].message);
            }
                else 
                    console.log('Unknown error');
        });
        
        $A.enqueueAction(action);
    },
    addRowHelper : function(component,event, PIIWrapper) {
        var strExpectedDate = null;
        if(PIIWrapper.length > 0 && component.get('v.isExpectedDate')){
            strExpectedDate = PIIWrapper[0].expectedDate; 
        }
        var tmpLineItemWrap ={
            "stockActual":0,
            "specification":"",
            "strSalesOrderItemId":"",
            "remarks":"",
            "quantity":0,
            "pendingPOQty":0,
            "objPart":{"attributes":{"type":"Part__c"}},
            "expectedDate":strExpectedDate,
            "application":"",
            "isEdit":true
        };
        PIIWrapper.push(tmpLineItemWrap);
        component.set("v.PurchaseIndentItems", PIIWrapper);
    },
    checkError : function(component, event, tmpWrapper, RecordIndexStr) {
        var strerror= '';
        var checkall = false;
        tmpWrapper[RecordIndexStr].strPartErr ='';
        tmpWrapper[RecordIndexStr].strQuantityErr = '';
        tmpWrapper[RecordIndexStr].strExpectedDateErr = '';
        tmpWrapper[RecordIndexStr].strApplicationErr ='';
        tmpWrapper[RecordIndexStr].boolShowError = false;
        
        if(!tmpWrapper[RecordIndexStr].objPart.Name)
        { 
            
            strerror = "Please select Part Type";
            tmpWrapper[RecordIndexStr].strPartErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].quantity)
        {
            strerror = "Please Enter Quantity";
            tmpWrapper[RecordIndexStr].strQuantityErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].expectedDate)
        { 
            strerror = "Please select Expected Date.";
            tmpWrapper[RecordIndexStr].strExpectedDateErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].application && component.get('v.isDirect'))
        { 
            strerror = "Please Select Application.";
            tmpWrapper[RecordIndexStr].strApplicationErr = strerror;
            checkall = true;
        }
        
        if(checkall)
        {
            component.set("v.Error", true);
            tmpWrapper[RecordIndexStr].boolShowError = true;
            tmpWrapper[RecordIndexStr].isEdit = true;
            component.set("v.PurchaseIndentItems",tmpWrapper);
        }  
        else
            component.set("v.Error", false);
    },
    AddSalesOrderHelper : function(component, event, PIItems, SOItems){
        for(var i=0 ; i< SOItems.length; i++){
            if(SOItems[i].isSelected){
                var tmpLineItemWrap = {
                    "stockActual":SOItems[i].objStock.Total_Quantity__c,
                    "specification":"",
                    "remarks":"",
                    "strSalesOrderItemId" : SOItems[i].objSOLI.Id,
                    "quantity":SOItems[i].objSOLI.Quantity__c,
                    "pendingPOQty":0,
                    "objPart":{"attributes":{"type":"Part__c"},"Id":SOItems[i].objSOLI.Product_Part__c,"Name":SOItems[i].objSOLI.Product_Part__r.Name,"Part_Name__c":SOItems[i].objSOLI.Product_Part__r.Part_Name__c,"Usage__c":SOItems[i].objSOLI.Product_Part__r.Usage__c,"UOM__c":SOItems[i].objSOLI.Product_Part__r.UOM__c},
                    "expectedDate":null,
                    "application":SOItems[i].objSOLI.Sales_Order__r.Application__c,
                    "isEdit":true
                };
                PIItems.push(tmpLineItemWrap);
            }
        }
        component.set("v.PurchaseIndentItems",PIItems);
        component.set('v.showModal',false); 
    },
    getSalesOrderItemsIdHelper :function(component, event, SalesOrderId){
        var action = component.get("c.getSalesOrderItemsId");
        action.setParams({
            'strSalesOrderId' : SalesOrderId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                var PIIWrapper = component.get("v.PurchaseIndentItems");
                var PIIWrapperNew = [];
                var itemsID =JSON.parse(response.getReturnValue());
                var matched = false;
                for(var i= 0 ; i< PIIWrapper.length ; i++){
                    matched = false;
                    for(var j= 0 ; j< itemsID.length ; j++){
                        //console.log(PIIWrapper[i].strIndentItemId +'====='+ itemsID[j]);
                        if(PIIWrapper[i].strSalesOrderItemId == itemsID[j]){
                            matched = true;
                            break;
                        }
                    }
                    if(!matched)
                        PIIWrapperNew.push(PIIWrapper[i]);
                }
                component.set("v.PurchaseIndentItems",PIIWrapperNew);
            }
        });
        $A.enqueueAction(action);
    },
    ExpectedDateActionCheckbox :function(component, event, ExpectedDate){
        var PIIWrapper = component.get("v.PurchaseIndentItems");
        var isExpectedDate =  component.get('v.isExpectedDate');
        if(isExpectedDate == true){
            if(PIIWrapper.length >= 2){
                
                if(ExpectedDate){
                    for(var i=0 ;i<PIIWrapper.length;i++){
                        PIIWrapper[i].expectedDate = ExpectedDate;
                    } 
                }
            }
        }
        component.set("v.PurchaseIndentItems",PIIWrapper);
    },
})