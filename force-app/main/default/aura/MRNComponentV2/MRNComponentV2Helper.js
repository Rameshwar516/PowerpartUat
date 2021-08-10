({
	pageLoad : function(component, event,strPurchaseOrderId) {
		var action = component.get('c.doInit');
        
        
		component.set('v.spinnerIsVisibile', true);
		action.setParams({
			'strRecordId' : component.get("v.recordId")
        });
		action.setCallback(this, function(res){
			if(res.getState() === "SUCCESS") 
			{
				component.set("v.mainWrap", JSON.parse(res.getReturnValue()));
				component.set("v.lstSelectedTax",component.get("v.mainWrap.lstOldCharges"));
				//alert('...!!!'+component.get("v.mainWrap.lstDeliveryNoteLIWrap").length);
				//component.set("v.mainWrap.lstDeliveryNoteLIWrap", component.get("v.mainWrap.lstDeliveryNoteLIWrap"));
				component.set("v.TotalTax",component.get("v.mainWrap.TotalTaxAmount"));
                
                console.log('id '+component.get("v.mainWrap.objMRN.Id"));

                if( typeof component.get("v.mainWrap.objMRN.Id") === 'undefined'){  
                    component.set("v.strType",component.get("v.strType")); 
                }
                else{
                    component.set("v.strType", component.get("v.mainWrap.objMRN.MRN_Type__c")); 
                    console.log('helper else '+component.get("v.mainWrap.objMRN.MRN_Type__c"));
                    
                }
                
				component.set('v.spinnerIsVisibile', false);
			}
		});
		$A.enqueueAction(action);
    },
	
	UpdateRecord : function(component, event,strPurchaseOrderId) {
		var action = component.get('c.UpdateMRNLI');
		component.set('v.spinnerIsVisibile', true);
		action.setParams({
			'lstMRNLineItems' : JSON.stringify(component.get("v.mainWrap.lstMRNLineItems")),
			'strRecordId' : component.get("v.recordId"),
			lstCharges :JSON.stringify(component.get("v.lstSelectedTax")),
			IntTotalAmount : component.get("v.decTotalAmount"),
			strWrap : JSON.stringify(component.get("v.mainWrap")),
            TotalTax: component.get("v.TotalTax"),
		});
		
		action.setCallback(this, function(res){
			if(res.getState() === "SUCCESS") 
			{
				/*var listPurchaseOrder = res.getReturnValue();
				component.set("v.mainWrap", JSON.parse(listPurchaseOrder));*/
				var RecordId = res.getReturnValue();
				var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                    'url': '/lightning/r/MRN__c/'+RecordId+'/view'
                  });
                  urlEvent.fire();
				component.set('v.spinnerIsVisibile', false);
			}
		});
		$A.enqueueAction(action);
    },
	
	CreateMRN : function(component, event) {
		var action = component.get("c.CreateMRNandLineItems");
        component.set('v.spinnerIsVisibile', true);
		//alert('.....'+JSON.stringify(component.get("v.ObjDeliveryNoteLI.lstSubMain")));
		var strType = component.get("v.strType");
		var strOrderLineItems ='';
		if(strType == 'Sales Return'){
			strOrderLineItems = component.get("v.ObjDeliveryNoteLI.lstSubMain");
			
		}if(strType == 'Purchase Order' || strType =='Direct'){
			//alert('!@#$...'+strType);
			strOrderLineItems = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		}
		var strWareHouse =component.get("v.selectedRecord");
		//alert(JSON.stringify(strOrderLineItems)+'....selectedRecord.'+component.get("v.selectedRecord.Name"));
        action.setParams({ 
			strMRNName : component.get("v.selectedRecord.Name"),
			strType : strType,
            lstDeliveryNoteLI : JSON.stringify(strOrderLineItems),
			lstCharges :JSON.stringify(component.get("v.lstSelectedTax")),
			IntTotalAmount : component.get("v.decTotalAmount"),
			strWareHouse : strWareHouse.Id,
			strWrap : JSON.stringify(component.get("v.mainWrap")),
            TotalTax: component.get("v.TotalTax"),
            supplier: component.get("v.Supplier")
        });
        action.setCallback(this, function(res){
            //alert(res.getReturnValue()+'...res.getState()...'+res.getState());
           if(res.getState() === "SUCCESS") 
           {
               	var RecordId = res.getReturnValue();
				var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                    'url': '/lightning/r/MRN__c/'+RecordId+'/view'
                  });
                  urlEvent.fire();
           }
           component.set('v.spinnerIsVisibile', false);
        });
        $A.enqueueAction(action);
	},
	searchPurchaseOrderLineItems : function(component, event,strPurchaseOrderId) {
		var action = component.get('c.SearchPurchaseOrderLI');
		component.set('v.spinnerIsVisibile', true);
		var strWareHouseId =component.get("v.selectedRecord");
		//alert(component.get("v.mainWrap.itemsPurchaseOrderLI")+'......'+JSON.stringify(component.get("v.mainWrap")));
		action.setParams({
			
			'strWrap' : JSON.stringify(component.get("v.mainWrap")),
			'objectName' : 'Purchase_Order_Line_Item__c',
			'strPurchaseOrderId' : strPurchaseOrderId,
			'strWareHouseId' : strWareHouseId.Id,
		});
		
		action.setCallback(this, function(res){
			//alert('...res.getState...'+res.getState());
			if(res.getState() === "SUCCESS") 
			{
				var listPurchaseOrder = res.getReturnValue();
				component.set("v.mainWrap", JSON.parse(listPurchaseOrder));
				component.set('v.spinnerIsVisibile', false);
			}
		});
		$A.enqueueAction(action);
    },
	addRowHelper : function(component, event) {
        console.log("1");
        var action = component.get('c.addRowMethod');
        console.log("2");
		component.set('v.spinnerIsVisibile', true);
		//'strWrap' : JSON.stringify(component.get("v.mainWrap"))
		action.setParams({
            "strWrap" : JSON.stringify(component.get("v.mainWrap"))
                                       
        });
        console.log("3");
		action.setCallback(this, function(res){
			if(res.getState() === "SUCCESS") 
			{
                 console.log("4");
				component.set("v.mainWrap", JSON.parse(res.getReturnValue()));
				//component.set("v.lstSelectedTax",component.get("v.mainWrap.lstOldCharges"));
				//alert('...!!!'+component.get("v.mainWrap.lstDeliveryNoteLIWrap").length);
				//component.set("v.mainWrap.lstDeliveryNoteLIWrap", component.get("v.mainWrap.lstDeliveryNoteLIWrap"));
				//component.set("v.TotalTax",component.get("v.mainWrap.TotalTaxAmount"));
				//component.set("v.strType", component.get("v.mainWrap.objMRN.MRN_Type__c"));
				component.set('v.spinnerIsVisibile', false);
			}
		});
        $A.enqueueAction(action);
    },
    
	RecalculateCharges : function(component,event,helper){
        var tmpMainWrapper = component.get("v.lstSelectedTax");
		var strDeliveryType = component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c");
        var totaltax =0;
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(tmpMainWrapper[i].decTaxAmount != null && tmpMainWrapper[i].decTaxAmount != null){
                var NetAmounts = Number(tmpMainWrapper[i].decTaxAmount);
                var IntDiscountRate = tmpMainWrapper[i].decTaxAmount;
                NetAmounts = NetAmounts+(IntDiscountRate*tmpMainWrapper[i].GST / 100);
                tmpMainWrapper[i].NetAmount = NetAmounts;
                component.set("v.lstSelectedTax",tmpMainWrapper);
            }						
            
            totaltax =totaltax+tmpMainWrapper[i].NetAmount;
        }
        component.set("v.TotalTax",totaltax);
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
    deliverydateactionCheckbox : function(component, event, DeliveryDate) {
        if(component.get("v.ObjDeliveryNoteLI.lstSubMain") != null){
             var POIWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
            var isdeliverydate =  component.get('v.isdeliverydate');
            if(isdeliverydate == true){
                if(POIWrapper.length >= 2){
                   if(DeliveryDate){
                        for(var i=0 ;i<POIWrapper.length;i++){
                            POIWrapper[i].objDNLI.Delivery_Date__c = DeliveryDate;
                        } 
                    }
                }
            }
            component.set("v.ObjDeliveryNoteLI.lstSubMain",POIWrapper);
        }
        else{
            var POIWrapper = component.get("v.mainWrap.lstMRNLineItems"); 
            var isdeliverydate =  component.get('v.isdeliverydate');
            if(isdeliverydate == true){
                if(POIWrapper.length >= 2){
                     if(DeliveryDate){
                        for(var i=0 ;i<POIWrapper.length;i++){
                            POIWrapper[i].ObjMRNLI.Delivery_Date__c = DeliveryDate;
                        } 
                    }
                }
            }
            component.set("v.mainWrap.lstMRNLineItems",POIWrapper);
        }  
    },
    
})