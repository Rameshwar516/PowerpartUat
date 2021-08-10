({
	initJS : function(component, event, helper) {
        helper.initHelper(component, event, helper);
	},
    onChangeSelect : function(component, event, helper) {
        //alert('...debug test');
        var selectedValue = component.find("IdSelectPO").get("v.value");
        component.set("v.OrderItemWapper", []);
        component.set("v.SelectedPurchaseIndent", []);
        if(selectedValue == 'Direct' ){
            component.set('v.isDirect', true);
            if(component.get('v.OrderItemWapper').length == 0)
            	helper.addRowHelper(component, event,component.get('v.OrderItemWapper'));
        }
        else if(selectedValue == 'Purchase Indent'){
            component.set('v.isDirect', false);
        } 
    },
    onChangePurchaseIndent : function(component, event, helper){
        var PurchaseIndent = component.get('v.PurchaseIndent');
        //alert(PurchaseIndent.Name);
        var PurchaseIndentItems =[];
        var POItems = component.get("v.OrderItemWapper");
        for(var i= 0; i< POItems.length; i++)
            PurchaseIndentItems.push(POItems[i].strIndentItemId);
        if(PurchaseIndent.Name){
            helper.getPurchaseIndentItem(component, event, PurchaseIndent.Id, PurchaseIndentItems);
        }
    },
    onChangeSupplier : function(component, event, helper){
        helper.findGSTHelper(component, event, helper);
    },
    onChangewareHouse : function(component, event, helper){
        helper.findGSTHelper(component, event, helper);
    },
    onChangeDeliveryJS : function(component, event, helper){
        var checked = component.get('v.isdeliverydate');
        var deliveryDate = event.getSource().get('v.value');
        if(checked){
            if(deliveryDate)
            	helper.deliverydateactionCheckbox(component, event, deliveryDate);
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"info",
                    "title": "info!",
                    "message": "Please change any delivery date which you want to be the same for all."
                });
                toastEvent.fire();
            }
        }
    },
    SelectedPIRemove : function(component, event, helper){
        var items = component.get('v.SelectedPurchaseIndent');        
        var item = event.getParam("index");
        var removeItem = items.splice(item, 1);
        component.set('v.SelectedPurchaseIndent', items);
        //Get Indent Item Ids 
        helper.getIndentItemsIdHelper(component, event, removeItem[0].name);
        
        
    },
    addRow : function(component, event, helper){
        var POIWrapper = component.get("v.OrderItemWapper");
        var RecordIndexStr = event.getSource().get("v.value");
        var Index=parseInt(RecordIndexStr);
        helper.checkError(component, event, POIWrapper, RecordIndexStr)
        if(!component.get('v.Error')){
            POIWrapper[RecordIndexStr].isEdit = false;
            helper.addRowHelper(component, event,POIWrapper);
        }
    },
    DeleteRow : function(component, event, helper){
        
        var RecordIndexStr = event.getSource().get("v.value");
        var removeIndex=parseInt(RecordIndexStr);
        var Items = component.get("v.OrderItemWapper");
        Items.splice(removeIndex, 1);
        component.set('v.OrderItemWapper', Items);
        if(Items.length == 0 && component.get('v.isDirect')){
            helper.addRowHelper(component, event,Items);
        }
        
    },
    EditRecord: function(component,event,helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var POIWrapper = component.get("v.OrderItemWapper");
        
        if(POIWrapper[RecordIndexStr].isEdit == false)
        {
            POIWrapper[RecordIndexStr].isEdit = true;
        }
        component.set("v.OrderItemWapper",POIWrapper);
    },
    ModifyRecord : function(component,event,helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var POIWrapper = component.get("v.OrderItemWapper");
        
        if(POIWrapper[RecordIndexStr].isEdit == true)
        {
            helper.checkError(component, event, POIWrapper, RecordIndexStr)
            if(!component.get('v.Error')){
                POIWrapper[RecordIndexStr].isEdit = false;
                component.set("v.OrderItemWapper",POIWrapper);
            }
        }
    },
    cancelJS : function(component,event,helper){
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Purchase_Order__c"
        });
        homeEvent.fire();
    },
    submitJS : function(component,event,helper){
        var mainWrap = component.get('v.mainWrapper');
        var items = component.get('v.OrderItemWapper');
        
        if(component.get('v.Supplier.Id'))
        	mainWrap.objPurchaseOrder.Supplier__c = component.get('v.Supplier.Id');
        if(component.get('v.wareHouse.Id'))
            mainWrap.objPurchaseOrder.Ware_House__c = component.get('v.wareHouse.Id');
        if(component.get('v.Against'))
        	mainWrap.objPurchaseOrder.Against__c = component.get('v.Against');
        if(component.get('v.currency'))
        	mainWrap.objPurchaseOrder.Currency__c = component.get('v.currency');
        
        var validSoFor = false;
        for(var i = 0; i <items.length; i++){
            helper.checkError(component, event, items, i)
            validSoFor = validSoFor || component.get('v.Error');
        }
        if(!validSoFor){
            var items = component.get('v.OrderItemWapper');
            for(var i = 0; i< items.length; i++){
                if(items[i].objPart.Stocks__r){
                    for(var j =0 ; j< items[i].objPart.Stocks__r.length ; j++){
                        if(items[i].objPart.Stocks__r[j].Ware_House__c == component.get('v.wareHouse.Id'))
                            items[i].stockActual = items[i].objPart.Stocks__r[j].Total_Quantity__c;
                        //console.log(items[i].objPart.Stocks__r[j].Total_Quantity__c);
                    }
                    items[i].objPart.Stocks__r = null;
                }
                if(! items[i].HSNCode)
                    items[i].HSNCode = items[i].objPart.HSN_CODE__c;
            }
            mainWrap.lstOIW = items;
            mainWrap.lstTaxDetails = component.get('v.lstSelectedTax');
            component.set('v.mainWrapper', mainWrap);
            
            helper.submitHelper(component,event);
        }
        else
            alert('Please fill all required Fields before submit.');
    },
    AddPurchaseOrder: function(component,event,helper){
        var POItems = component.get("v.OrderItemWapper");
        var PIItems = component.get("v.PurchaseIndentItems");
        if(PIItems.length > 0){
            var PurchaseIndent = component.get('v.PurchaseIndent');
            var soList = component.get("v.SelectedPurchaseIndent");
            var isExist = false;
            for(var i= 0; i< soList.length; i++)
                if(soList[i].name == PurchaseIndent.Id)
                    isExist = true;
            if(!isExist){
                soList.push({
                    type: 'icon',
                    href: '',
                    label: PurchaseIndent.Purchase_Indent_Number__c,
                    name: PurchaseIndent.Id,
                    iconName: 'standard:orders',
                    alternativeText: 'Purchase Indent',
                });
            }
            component.set("v.SelectedPurchaseIndent", soList);
            helper.AddPurchaseOrderItemsHelper(component, event, POItems, PIItems);
        }
            
    },
    onActiveTabTwo:function(component,event,helper){
        var POItems = component.get("v.OrderItemWapper");
        var totalAmountAfterDisc = 0;
        for(var i =0; i < POItems.length; i++){
            if(POItems[i].Amount){
                if(POItems[i].DiscAmount)
                    totalAmountAfterDisc += (POItems[i].Amount - POItems[i].DiscAmount);
                else
                    totalAmountAfterDisc += POItems[i].Amount;
            }
        }
        component.set('v.decTotalAmount',totalAmountAfterDisc);
    },
    selectTaxType: function(component,event,helper){
        var TotalAmount = component.get("v.decTotalAmount");
        var StrSelectedTax = component.get("v.strTaxType");
        var lstTax = component.get("v.mainWrapper.lstTax");
        var lstSelectedTax = component.get("v.lstSelectedTax");
        var AlreadyAdded=false;
        if(lstTax.length > 0){
            if(lstSelectedTax.length > 0){
                for(var i= 0; i< lstSelectedTax.length; i++){
                    if(StrSelectedTax === lstSelectedTax[i].strTaxId)
                        AlreadyAdded = true;
                }
            }
            
            if(! AlreadyAdded){
                for(var i= 0; i< lstTax.length; i++){
                    if(StrSelectedTax === lstTax[i].Id){
                        lstSelectedTax.push({
                            strTaxId: lstTax[i].Id,
                            strTaxName: lstTax[i].Name,
                            TaxPercentage: lstTax[i].Tax_Percentage__c,
                            decTaxAmount: (TotalAmount*lstTax[i].Tax_Percentage__c)/100,
                            CGST: 0.00,
                            SGST: 0.00,
                            IGST: 0.00,
                            NetAmount: (TotalAmount*lstTax[i].Tax_Percentage__c)/100, 
                            TotalAmountAfterDisc : TotalAmount,
                            ischargeItem :false,
                        });	 
                    }
                }
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message',
                    message:'Already added.',
                    messageTemplate: 'Already added.',
                    duration:' 50',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        }
        component.set('v.lstSelectedTax', lstSelectedTax);
    },
    CalculateJS : function(component, event, helper){
        var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.lstSelectedTax");
        var NetAmounts = tmpMainWrapper[rowIndex].decTaxAmount;
        var IntDiscountRate = target.value;
        var TotalDisountRate = 0;
        if(target.name == 'CGST'){
            tmpMainWrapper[rowIndex].CGST = IntDiscountRate;
            TotalDisountRate = IntDiscountRate;
            if(tmpMainWrapper[rowIndex].SGST)
                TotalDisountRate += tmpMainWrapper[rowIndex].SGST;
            if(tmpMainWrapper[rowIndex].IGST)
                TotalDisountRate += tmpMainWrapper[rowIndex].IGST;
        }
        if(target.name == 'SGST'){
            tmpMainWrapper[rowIndex].SGST = IntDiscountRate;
            TotalDisountRate = IntDiscountRate;
            if(tmpMainWrapper[rowIndex].CGST)
                TotalDisountRate += tmpMainWrapper[rowIndex].CGST;
            if(tmpMainWrapper[rowIndex].IGST)
                TotalDisountRate += tmpMainWrapper[rowIndex].IGST;
        }
        if(target.name == 'IGST'){
            tmpMainWrapper[rowIndex].IGST = IntDiscountRate;
            TotalDisountRate = IntDiscountRate;
            if(tmpMainWrapper[rowIndex].CGST)
                TotalDisountRate += tmpMainWrapper[rowIndex].CGST;
            if(tmpMainWrapper[rowIndex].SGST)
                TotalDisountRate += tmpMainWrapper[rowIndex].SGST;
        }
        NetAmounts = NetAmounts+ tmpMainWrapper[rowIndex].decTaxAmount * TotalDisountRate / 100;
        tmpMainWrapper[rowIndex].NetAmount = NetAmounts;
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
    RemoveRow : function(component,event,helper){
        var removeIndex = event.getSource().get("v.value");
        var Items = component.get("v.lstSelectedTax");
        Items.splice(removeIndex, 1);
        component.set('v.lstSelectedTax', Items);
    },
    calAmount:function(component,event,helper){
        helper.calAmountHelper(component,event);
    },
    onCheckDiscount:function(component,event,helper){
        helper.discountonCheck(component,event);
    },
    onChangeCurency :function(component,event,helper){
        var currency = component.find("IdSelectCurrency").get("v.value").
        console.log(currency);
        component.set('v.currency', currency);
    },
    /*onchangeAddress :function(component,event,helper){
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
        else 
            helper.onchangeAddressHelper(component,event);
        
    },*/
    CancelModal :function(component,event,helper){
        component.set('v.showModal',false); 
    },
    AddTandCJS :function(component,event,helper){
        component.set('v.showTAndC', true);
    },
    closeTAndC :function(component,event,helper){
        component.set('v.showTAndC', false);
    },
})