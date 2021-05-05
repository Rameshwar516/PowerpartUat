({
    initHelper : function(component, event, helper) {
        var action = component.get("c.doInit");
        action.setParams({
            'strRecordID' : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                //alert('Success');
                var result = JSON.parse(response.getReturnValue());
                component.set('v.mainWrapper', result);
                component.set('v.OrderItemWapper', result.lstOIW);
                
                if(component.get('v.recordId')){
                    component.set('v.lstSelectedTax', result.lstTaxDetails);
                    if(result.objPurchaseOrder.Ware_House__c){
                        var objWareHouse ={
                            "attributes":{"type":"Ware_house__c"},
                            "Id" : result.objPurchaseOrder.Ware_House__c,
                            "Name" : result.objPurchaseOrder.Ware_House__r.Name,
                            "State_Code__c" : result.objPurchaseOrder.Ware_House__r.State_Code__c
                        }
                        component.set('v.wareHouse', objWareHouse);
                    }
                    if(result.objPurchaseOrder.Supplier__c){
                        var objSupplier ={
                            "attributes":{"type":"Account"},
                            "Id" : result.objPurchaseOrder.Supplier__c,
                            "Name" : result.objPurchaseOrder.Supplier__r.Name,
                            "Billing_State_Code__c" : result.objPurchaseOrder.Supplier__r.Billing_State_Code__c,
                            "Shipping_State_Code__c" : result.objPurchaseOrder.Supplier__r.Shipping_State_Code__c
                        }
                        component.set('v.Supplier', objSupplier);
                    }
                    if(result.lstPurchaseIndent.length > 0){
                        var soList = component.get("v.SelectedPurchaseIndent");
                        for(var i= 0; i < result.lstPurchaseIndent.length; i++){
                            soList.push({
                                type: 'icon',
                                href: '',
                                label: result.lstPurchaseIndent[i].label,
                                name: result.lstPurchaseIndent[i].value,
                                iconName: 'standard:orders',
                                alternativeText: 'Purchase Indent',
                            });
                        }
                        component.set("v.SelectedPurchaseIndent",soList);
                    }
                    component.set('v.Against', result.objPurchaseOrder.Against__c);
                    component.set('v.isDirect', result.isDirect);
                    component.set('v.currency', result.objPurchaseOrder.Currency__c);
                }
            }
        });
        $A.enqueueAction(action);
    },
	getPurchaseIndentItem : function(component,event, piId, PurchaseIndentItems) {
        if(piId){
            var action = component.get('c.getPurchaseIndentItems');
            action.setParams({
                "recordId": piId,
                'itemsId' : PurchaseIndentItems
            })
            action.setCallback(this, function(response){
                if(response.getState() === "SUCCESS"){
                    var result = JSON.parse(response.getReturnValue());
                    component.set('v.showModal', true);
                    component.set('v.PurchaseIndentItems', result);
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
    checkError : function(component, event, tmpWrapper, RecordIndexStr) {
        var strerror= '';
        var checkall = false;
        tmpWrapper[RecordIndexStr].strPartErr ='';
        tmpWrapper[RecordIndexStr].strQuantityErr = '';
        tmpWrapper[RecordIndexStr].strDeliveryDateErr = '';
        tmpWrapper[RecordIndexStr].strRateErr ='';
        tmpWrapper[RecordIndexStr].boolShowError = false;
        
        if(!tmpWrapper[RecordIndexStr].objPart.Name)
        { 
            
            strerror = "Please select Part Type";
            tmpWrapper[RecordIndexStr].strPartErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].Quantity)
        {
            strerror = "Please Enter Quantity";
            tmpWrapper[RecordIndexStr].strQuantityErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].DeliveryDate)
        { 
            strerror = "Please select Delivery Date.";
            tmpWrapper[RecordIndexStr].strDeliveryDateErr = strerror;
            checkall = true;
        }
        if(!tmpWrapper[RecordIndexStr].Rate && component.get('v.isDirect'))
        { 
            strerror = "Please Enter Rate.";
            tmpWrapper[RecordIndexStr].strRateErr = strerror;
            checkall = true;
        }
        
        if(checkall)
        {
            component.set("v.Error", true);
            tmpWrapper[RecordIndexStr].boolShowError = true;
            tmpWrapper[RecordIndexStr].isEdit = true;
            component.set("v.OrderItemWapper",tmpWrapper);
        }  
        else
            component.set("v.Error", false);
    },
    addRowHelper :function(component, event,POIWrapper){
        
        //For same Delivery date 
        var strDeliveryDate = null;
        if(POIWrapper.length > 0 && component.get('v.isdeliverydate')){
           strDeliveryDate = POIWrapper[0].DeliveryDate; 
        }
        
        console.log('addrowhelper');
        console.log(component.get("v.mainWrapper"));
        var tmpLineItemWrap = {
            "objPart" : {"attributes":{"type":"Part__c"}},
            "strId" : '',
            "DocNo" : '',
            "DocDate" : null,    
            "specification" : '',
            "strIndentItemId": '',
            "pandingMRNQty" : 0,
            "stockActual" : 0,
            "IndentQty" : 0,
            "Quantity" : 0,
            "Unit" : '',
            "Rate" : 0,
            "Amount" : 0,
            "DiscRate" : 0,
            "DiscAmount" : 0,
            "GrossAmount" : 0,
            "HSNCode" : '',
            "CGSTRate" : 0,
            "CGSTAmount" : 0,
            "SGSTRate" : 0,
            "SGSTAmount" : 0,
            "IGSTRate" : 0,
            "IGSTAmount" : 0,
            "NetAmount" : 0,
            "DeliveryDate" : '',
            "application" : '',
            "Remarks" : '',
            "isEdit" : true
        };
    	POIWrapper.push(tmpLineItemWrap);
        component.set("v.OrderItemWapper", POIWrapper);
    },
    AddPurchaseOrderItemsHelper : function(component, event, POItems, PIItems){
        alert('test');
        for(var i=0 ; i< PIItems.length; i++){
            if(PIItems[i].isSelected){
                var tmpLineItemWrap = {
                    "objPart" : {"attributes":{"type":"Part__c"},"Id":PIItems[i].objPILI.Product_Part__c,"Name":PIItems[i].objPILI.Product_Part__r.Name,"Part_Name__c":PIItems[i].objPILI.Product_Part__r.Part_Name__c,"Usage__c":PIItems[i].objPILI.Product_Part__r.Usage__c,"HSN_CODE__c":PIItems[i].objPILI.Product_Part__r.HSN_CODE__c,"UOM__c":PIItems[i].objPILI.Product_Part__r.UOM__c,"UOI__c":PIItems[i].objPILI.Product_Part__r.UOI__c},
                    "strId" :'',
                    "DocNo" : PIItems[i].objPILI.Purchase_Indent__r.Purchase_Indent_Number__c,
                    "DocDate" : PIItems[i].objPILI.Purchase_Indent__r.CreatedDate,    
                    "specification": '',
                    "strIndentItemId": PIItems[i].objPILI.Id,
                    "pandingMRNQty" : 0,
                    "stockActual" : PIItems[i].objStock.Total_Quantity__c,
                    "IndentQty" : PIItems[i].objPILI.QTY__c,
                    "Quantity" : PIItems[i].objPILI.QTY__c,
                    "Unit" : '',
                    "UOI" : PIItems[i].objPILI.UOI_Text__c,
                    "Rate" : 0,
                    "Amount" : 0,
                    "DiscRate" : 0,
                    "DiscAmount" : 0,
                    "GrossAmount" : 0,
                    "HSNCode" : PIItems[i].objPILI.Product_Part__r.HSN_CODE__c,
                    "CGSTRate" : 0,
                    "CGSTAmount" : 0,
                    "SGSTRate" : 0,
                    "SGSTAmount" : 0,
                    "IGSTRate" : 0,
                    "IGSTAmount" : 0,
                    "NetAmount" : 0,
                    "DeliveryDate" : null,
                    "application" : PIItems[i].objPILI.Application__c,
                    "Remarks" : PIItems[i].objPILI.Remark__c,
                    "isEdit" : true
                };
                POItems.push(tmpLineItemWrap);
            }
        }
        component.set("v.OrderItemWapper",POItems);
        component.set('v.showModal',false); 
    },
    submitHelper: function(component,event){
      var action = component.get('c.SavePurchaseOrder');
        action.setParams({
            "strMainWrapper": JSON.stringify(component.get('v.mainWrapper'))
        })
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = JSON.parse(response.getReturnValue());
                if(result.success && result.objPurchaseOrder.Id){
                    $A.get('e.force:refreshView').fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result.objPurchaseOrder.Id,
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
    calAmountHelper :function(component, event){
        var cmp = event.getSource();
        //console.log(cmp.get('v.value')+'---'+cmp.get('v.name')+'---'+cmp.get('v.label'));
        //01---0---Quantity
        var index = cmp.get('v.name');
        var value = cmp.get('v.value');
        var POItems = component.get("v.OrderItemWapper");
        
        if(cmp.get('v.label') == 'Quantity')
            POItems[index].Quantity = value;
        if(cmp.get('v.label') == 'Rate')
            POItems[index].Rate = value;
        if(cmp.get('v.label') == 'Disc Rate'){
            if(component.get("v.isdiscount")==true){
                this.discountonCheck(component,event);
            }else{
                POItems[index].DiscRate = value; 
            } 
        }
            
        if(cmp.get('v.label') == 'CGST')
            POItems[index].CGSTRate = value;
        if(cmp.get('v.label') == 'SGST')
            POItems[index].SGSTRate = value;
        if(cmp.get('v.label') == 'IGST')
            POItems[index].IGSTRate = value;
        
        //Calculation
        if(POItems[index].Quantity && POItems[index].Rate)
            POItems[index].Amount = POItems[index].Quantity * POItems[index].Rate;
        if(POItems[index].Amount){
            
            POItems[index].GrossAmount = POItems[index].Amount;
            POItems[index].NetAmount = POItems[index].Amount;
            
            if(POItems[index].DiscRate){
                POItems[index].DiscAmount = (POItems[index].Amount * POItems[index].DiscRate)/100;
                POItems[index].NetAmount = POItems[index].NetAmount - POItems[index].DiscAmount;
            }    
            if(POItems[index].CGSTRate || POItems[index].DiscAmount){
                if(POItems[index].DiscAmount)
                    POItems[index].CGSTAmount = ((POItems[index].Amount - POItems[index].DiscAmount) * POItems[index].CGSTRate)/100;
                else
                    POItems[index].CGSTAmount = (POItems[index].Amount * POItems[index].CGSTRate)/100;
                POItems[index].NetAmount += POItems[index].CGSTAmount;
            }
            if(POItems[index].SGSTRate || POItems[index].DiscAmount){
                if(POItems[index].DiscAmount)
                    POItems[index].SGSTAmount = ((POItems[index].Amount - POItems[index].DiscAmount) * POItems[index].SGSTRate)/100;
                else
                    POItems[index].SGSTAmount = (POItems[index].Amount * POItems[index].SGSTRate)/100;
                POItems[index].NetAmount += POItems[index].SGSTAmount;
            }
            if(POItems[index].IGSTRate || POItems[index].DiscAmount){
                if(POItems[index].DiscAmount)
                    POItems[index].IGSTAmount = ((POItems[index].Amount - POItems[index].DiscAmount) * POItems[index].IGSTRate)/100;
                else
                    POItems[index].IGSTAmount = (POItems[index].Amount * POItems[index].IGSTRate)/100;
                POItems[index].NetAmount += POItems[index].IGSTAmount;
            } 
        }
        component.set("v.OrderItemWapper",POItems);
    },
 
    discountonCheck :function(component, event){
        console.log('run');
        var POItems = component.get("v.OrderItemWapper");
        console.log('.... '+POItems.length);
        if(POItems.length>=2 && component.get("v.isdiscount")==true)
            for(var i=0;POItems.length>i;i++){
                if(POItems[0].DiscRate == null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Discount at first row have to be filled."
                    });
                    toastEvent.fire();
                }else{
                    
                    POItems[i].DiscRate = POItems[0].DiscRate;
                    //     POItems[index].DiscRate = value;
                    if(POItems[i].Quantity && POItems[i].Rate)
                        POItems[i].Amount = POItems[i].Quantity * POItems[i].Rate;
                    if(POItems[i].Amount){
                        
                        POItems[i].GrossAmount = POItems[i].Amount;
                        POItems[i].NetAmount = POItems[i].Amount;
                        
                        if(POItems[i].DiscRate){
                            POItems[i].DiscAmount = (POItems[i].Amount * POItems[i].DiscRate)/100;
                            POItems[i].NetAmount = POItems[i].NetAmount - POItems[i].DiscAmount;
                        }    
                        if(POItems[i].CGSTRate || POItems[i].DiscAmount){
                            if(POItems[i].DiscAmount)
                                POItems[i].CGSTAmount = ((POItems[i].Amount - POItems[i].DiscAmount) * POItems[i].CGSTRate)/100;
                            else
                                POItems[i].CGSTAmount = (POItems[i].Amount * POItems[i].CGSTRate)/100;
                            POItems[i].NetAmount += POItems[i].CGSTAmount;
                        }
                        if(POItems[i].SGSTRate || POItems[i].DiscAmount){
                            if(POItems[i].DiscAmount)
                                POItems[i].SGSTAmount = ((POItems[i].Amount - POItems[i].DiscAmount) * POItems[i].SGSTRate)/100;
                            else
                                POItems[i].SGSTAmount = (POItems[i].Amount * POItems[i].SGSTRate)/100;
                            POItems[i].NetAmount += POItems[i].SGSTAmount;
                        }
                        if(POItems[i].IGSTRate || POItems[i].DiscAmount){
                            if(POItems[i].DiscAmount)
                                POItems[i].IGSTAmount = ((POItems[i].Amount - POItems[i].DiscAmount) * POItems[i].IGSTRate)/100;
                            else
                                POItems[i].IGSTAmount = (POItems[i].Amount * POItems[i].IGSTRate)/100;
                            POItems[i].NetAmount += POItems[i].IGSTAmount;
                        } 
                    }
                    
                }
            }
        component.set("v.OrderItemWapper",POItems);
    },
    
    
    
    /*onchangeAddressHelper:function(component, event){
        var action = component.get("c.getWareHouseDetails");
        action.setParams({ });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                //alert('Success');
                var result = JSON.parse(response.getReturnValue());
                component.set('v.wareHouseAddress', result);
                var mainwarp = component.get('v.mainWrapper');
                var wareHouselst = component.get('v.wareHouseAddress');
                if(wareHouselst.length > 0){
                    for(var i =0 ; i < wareHouselst.length; i++){
                        if(wareHouselst[i].City__c  == mainwarp.objPurchaseOrder.Bill_To__c){
                            mainwarp.objPurchaseOrder.Billing_Street__c = wareHouselst[i].Street__c;
                            mainwarp.objPurchaseOrder.Billing_City__c = wareHouselst[i].City__c;
                            mainwarp.objPurchaseOrder.Billing_State__c = wareHouselst[i].State_Province__c;
                            mainwarp.objPurchaseOrder.Billing_Country__c = wareHouselst[i].Country__c;
                            mainwarp.objPurchaseOrder.Billing_Zip_Postal_Code__c = wareHouselst[i].Zip_Postal_Code__c;
                        }
                        if(wareHouselst[i].City__c  == mainwarp.objPurchaseOrder.Ship_To__c){
                            mainwarp.objPurchaseOrder.Shipping_Street__c = wareHouselst[i].Street__c;
                            mainwarp.objPurchaseOrder.Shipping_City__c = wareHouselst[i].City__c;
                            mainwarp.objPurchaseOrder.Shipping_State_Province__c = wareHouselst[i].State_Province__c;
                            mainwarp.objPurchaseOrder.Shipping_Country__c = wareHouselst[i].Country__c;
                            mainwarp.objPurchaseOrder.Shipping_Zip_Postal_Code__c = wareHouselst[i].Zip_Postal_Code__c;
                        }
                    }
                    component.set('v.mainWrapper', mainwarp);
                }
            }
        });
        $A.enqueueAction(action);
    },*/
    
    getIndentItemsIdHelper :function(component, event, IndentId){
        var action = component.get("c.getIndentItemsId");
        action.setParams({
            'strIndentId' : IndentId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                var POIWrapper = component.get("v.OrderItemWapper");
                var POIWrapperNew = [];
                var itemsID =JSON.parse(response.getReturnValue());
                var matched = false;
                for(var i= 0 ; i< POIWrapper.length ; i++){
                    matched = false;
                    for(var j= 0 ; j< itemsID.length ; j++){
                        //console.log(POIWrapper[i].strIndentItemId +'====='+ itemsID[j]);
                        if(POIWrapper[i].strIndentItemId == itemsID[j]){
                            matched = true;
                            break;
                        }
                    }
                    if(!matched)
                        POIWrapperNew.push(POIWrapper[i]);
                }
                component.set("v.OrderItemWapper",POIWrapperNew);
            }
        });
        $A.enqueueAction(action);
    },
    findGSTHelper :function(component, event, helper){
        var supplier = component.get('v.Supplier');
        var wareHouse = component.get('v.wareHouse');
        if(supplier && wareHouse){
            //alert(supplier.Shipping_State_Code__c +'  --- '+wareHouse.State_Code__c);
            if(supplier.Shipping_State_Code__c && wareHouse.State_Code__c){
                if(supplier.Shipping_State_Code__c == wareHouse.State_Code__c){
                    component.set('v.isIGST',false);
                    component.set('v.isCGST_SGST',true);
                }
                else{
                    component.set('v.isIGST',true);
                    component.set('v.isCGST_SGST',false);
                }
            }
            else{
                component.set('v.isIGST',true);
                component.set('v.isCGST_SGST',true);
            }
        }
        
    },
    
    deliverydateactionCheckbox : function(component, event, DeliveryDate) {
        var POIWrapper = component.get("v.OrderItemWapper");
        var isdeliverydate =  component.get('v.isdeliverydate');
        if(isdeliverydate == true){
            if(POIWrapper.length >= 2){
                
                if(DeliveryDate){
                    for(var i=0 ;i<POIWrapper.length;i++){
                        POIWrapper[i].DeliveryDate = DeliveryDate;
                    } 
                }
            }
        }
        component.set("v.OrderItemWapper",POIWrapper);
    },

})