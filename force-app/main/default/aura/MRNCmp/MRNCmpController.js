({
	doinit : function(component, event, helper) {
		//alert('....'+component.get("v.recordId"));
        helper.pageLoad(component, event);
    },
	EditRecord: function(component,event,helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
        if(tmpMainWrapper[RecordIndexStr].IsEdit == false)
        {
            tmpMainWrapper[RecordIndexStr].IsEdit = true;
        }else{
			tmpMainWrapper[RecordIndexStr].IsEdit = false;
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
    },
	
	EditSalesOrderRecord: function(component,event,helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
        if(tmpMainWrapper[RecordIndexStr].IsEdit == false)
        {
            tmpMainWrapper[RecordIndexStr].IsEdit = true;
        }else{
			tmpMainWrapper[RecordIndexStr].IsEdit = false;
		}
        component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
    },
	
	UpdateRecord: function(component,event,helper)
    {
		helper.UpdateRecord(component, event);
	},
	EditMRNLI: function(component,event,helper)
    {
        var RecordIndexStr = event.getSource().get("v.value");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
        if(tmpMainWrapper[RecordIndexStr].IsEdit == false)
        {
            tmpMainWrapper[RecordIndexStr].IsEdit = true;
        }else{
			tmpMainWrapper[RecordIndexStr].IsEdit = false;
		}
        component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
    },
    
    DeleteRecord : function(component,event,helper){
        var tmpWrapper = [];
        var tmpDeletedId = [];
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
        var RecordIndexStr = event.getSource().get("v.value");
        var removeIndex=parseInt(RecordIndexStr);
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(removeIndex == i){
                if(tmpMainWrapper[i].objPOLI != null && tmpMainWrapper[i].objPOLI.Id != null){
                    tmpDeletedId.push(tmpMainWrapper[i]);
                } 
            }else{
                tmpWrapper.push(tmpMainWrapper[i]);
            } 
        }
		component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpWrapper);
    },
	
	DeleteSalesOrderLIRecord : function(component,event,helper){
        var tmpWrapper = [];
        var tmpDeletedId = [];
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
        var RecordIndexStr = event.getSource().get("v.value");
        var removeIndex=parseInt(RecordIndexStr);
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(removeIndex == i){
                if(tmpMainWrapper[i].objDNLI != null && tmpMainWrapper[i].objDNLI.Id != null){
                    tmpDeletedId.push(tmpMainWrapper[i]);
                } 
            }else{
                tmpWrapper.push(tmpMainWrapper[i]);
            } 
        }
		component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpWrapper);
    },
	
	
	ChangeType : function(component,event,helper){
		var emptylist = []; 
		var lstSalesReturn = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		var lstDeliveryNote = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		var strType = component.get("v.strType");
		//alert('lstSalesReturn.length...'+lstSalesReturn);
		component.set("v.TotalTax",null);
		component.set("v.selectedRecord",null);
		if(lstSalesReturn !=null){
			component.set("v.ObjDeliveryNoteLI.lstSubMain",emptylist);
			component.set("v.lstSelectedTax",emptylist);
			component.set("v.itemsPurchaseOrderLI",emptylist);
		}if(lstDeliveryNote !=null && strType !='Direct'){
			component.set("v.mainWrap.lstDeliveryNoteLIWrap",emptylist);
			component.set("v.lstSelectedTax",emptylist);
			component.set("v.itemsPurchaseOrderLI",emptylist);
		}
	},
	
	CalculateQuantity : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].objDNLI != null && tmpMainWrapper[i].objDNLI.Sales_Price__c != null){
					var BillQTY = event.target.value;
					var Amount = BillQTY* tmpMainWrapper[i].objDNLI.Sales_Price__c;
					if(tmpMainWrapper[i].objDNLI.Discount_Currency__c ==null || tmpMainWrapper[i].objDNLI.Discount_Currency__c == '')
						tmpMainWrapper[i].objDNLI.Discount_Currency__c =0;
					
					if(tmpMainWrapper[i].objDNLI.Discount__c != null && tmpMainWrapper[i].objDNLI.Discount__c !='' && tmpMainWrapper[i].objDNLI.Discount__c != 0)
						tmpMainWrapper[i].objDNLI.Discount_Currency__c = Amount*tmpMainWrapper[i].objDNLI.Discount__c/100;
					
					if(tmpMainWrapper[i].objDNLI.Discount_Currency__c != null && tmpMainWrapper[i].objDNLI.Discount_Currency__c != null !='' && tmpMainWrapper[i].objDNLI.Discount_Currency__c != 0)
						tmpMainWrapper[i].objDNLI.Discount__c = tmpMainWrapper[i].objDNLI.Discount_Currency__c /Amount*100;
					
					var IntDiscount = tmpMainWrapper[i].objDNLI.Discount_Currency__c;
					var TaxableAmount = Amount - IntDiscount;
					tmpMainWrapper[i].objDNLI.Quantity__c = BillQTY;
					tmpMainWrapper[i].objDNLI.Total_Amount__c = Amount;
					tmpMainWrapper[i].objDNLI.Taxable_Amount__c = TaxableAmount;
					
					
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].objDNLI.CGST__c !=null){
						IntCGST = TaxableAmount * tmpMainWrapper[i].objDNLI.CGST__c /100;
					}if(tmpMainWrapper[i].objDNLI.SGST__c !=null){
						IntSGST = TaxableAmount * tmpMainWrapper[i].objDNLI.SGST__c /100;
					}if(tmpMainWrapper[i].objDNLI.IGST__c !=null){
						IntIGST = TaxableAmount * tmpMainWrapper[i].objDNLI.IGST__c /100;
					}
					tmpMainWrapper[i].objDNLI.Gross_Amount__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
					
					//tmpMainWrapper[i].objDNLI.Discount__c = IntDiscount;
					
					component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
                } 
			}else{
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
				//tmpWrapper.push(tmpMainWrapper[i]);
			}
		}
        component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
    },
	
	CalculateRate : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].objDNLI != null && tmpMainWrapper[i].objDNLI.Quantity__c != null){
					var BillQTY = event.target.value;
					var Amount = BillQTY* tmpMainWrapper[i].objDNLI.Quantity__c;
					if(tmpMainWrapper[i].objDNLI.Discount_Currency__c ==null || tmpMainWrapper[i].objDNLI.Discount_Currency__c == '')
						tmpMainWrapper[i].objDNLI.Discount_Currency__c =0;
					
					if(tmpMainWrapper[i].objDNLI.Discount__c != null && tmpMainWrapper[i].objDNLI.Discount__c !='' && tmpMainWrapper[i].objDNLI.Discount__c != 0)
						tmpMainWrapper[i].objDNLI.Discount_Currency__c = Amount*tmpMainWrapper[i].objDNLI.Discount__c/100;
					
					if(tmpMainWrapper[i].objDNLI.Discount_Currency__c != null && tmpMainWrapper[i].objDNLI.Discount_Currency__c != null !='' && tmpMainWrapper[i].objDNLI.Discount_Currency__c != 0)
						tmpMainWrapper[i].objDNLI.Discount__c = tmpMainWrapper[i].objDNLI.Discount_Currency__c /Amount*100;
					
					var IntDiscount = tmpMainWrapper[i].objDNLI.Discount_Currency__c;
					var TaxableAmount = Amount - IntDiscount;
					tmpMainWrapper[i].objDNLI.Sales_Price__c = BillQTY;
					tmpMainWrapper[i].objDNLI.Total_Amount__c = Amount;
					tmpMainWrapper[i].objDNLI.Taxable_Amount__c = TaxableAmount;
					
					
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].objDNLI.CGST__c !=null){
						IntCGST = TaxableAmount * tmpMainWrapper[i].objDNLI.CGST__c /100;
					}if(tmpMainWrapper[i].objDNLI.SGST__c !=null){
						IntSGST = TaxableAmount * tmpMainWrapper[i].objDNLI.SGST__c /100;
					}if(tmpMainWrapper[i].objDNLI.IGST__c !=null){
						IntIGST = TaxableAmount * tmpMainWrapper[i].objDNLI.IGST__c /100;
					}
					tmpMainWrapper[i].objDNLI.Gross_Amount__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
					component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
					
                } 
			}else{
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
			}
		}
        component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
    },
	
	CalculateDiscount : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].objDNLI != null && tmpMainWrapper[i].objDNLI.Quantity__c != null && tmpMainWrapper[i].objDNLI.Sales_Price__c != null){
					var BillQTY = event.target.value;
					
					tmpMainWrapper[i].objDNLI.Discount_Currency__c = BillQTY;
					var Amount = tmpMainWrapper[i].objDNLI.Total_Amount__c;
					if(tmpMainWrapper[i].objDNLI.Discount_Currency__c ==null || tmpMainWrapper[i].objDNLI.Discount_Currency__c == '')
						tmpMainWrapper[i].objDNLI.Discount_Currency__c =0;
					
					if(tmpMainWrapper[i].objDNLI.Discount_Currency__c != null && tmpMainWrapper[i].objDNLI.Discount_Currency__c != null !='' && tmpMainWrapper[i].objDNLI.Discount_Currency__c != 0)
						tmpMainWrapper[i].objDNLI.Discount__c = tmpMainWrapper[i].objDNLI.Discount_Currency__c /Amount*100;
					
					if(tmpMainWrapper[i].objDNLI.Discount__c != null && tmpMainWrapper[i].objDNLI.Discount__c !='' && tmpMainWrapper[i].objDNLI.Discount__c != 0)
						tmpMainWrapper[i].objDNLI.Discount_Currency__c = Amount*tmpMainWrapper[i].objDNLI.Discount__c/100;
					
					var IntDiscount = tmpMainWrapper[i].objDNLI.Discount_Currency__c;
					var TaxableAmount = Amount - IntDiscount;
					
					tmpMainWrapper[i].objDNLI.Taxable_Amount__c = TaxableAmount;
					
					
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].objDNLI.CGST__c !=null){
						IntCGST = TaxableAmount * tmpMainWrapper[i].objDNLI.CGST__c /100;
					}if(tmpMainWrapper[i].objDNLI.SGST__c !=null){
						IntSGST = TaxableAmount * tmpMainWrapper[i].objDNLI.SGST__c /100;
					}if(tmpMainWrapper[i].objDNLI.IGST__c !=null){
						IntIGST = TaxableAmount * tmpMainWrapper[i].objDNLI.IGST__c /100;
					}
					tmpMainWrapper[i].objDNLI.Gross_Amount__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
					component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
                } 
			}else{
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
			}
		}
        component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
    },
	
	CalculateDiscountRate : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		var isdiscount =  component.get('v.Isdiscount');
        if(isdiscount==true){
			if(rowIndex == 0){
				var BillQTY = event.target.value;
				tmpMainWrapper[0].objDNLI.Discount__c = BillQTY;
				if(tmpMainWrapper[0].objDNLI.Discount__c != null && tmpMainWrapper[0].objDNLI.Discount__c != ''){
					for(var i=0;i<tmpMainWrapper.length;i++)
					{	
						tmpMainWrapper[i].objDNLI.Discount__c = tmpMainWrapper[0].objDNLI.Discount__c;
						var Amount = tmpMainWrapper[i].objDNLI.Total_Amount__c;
						if(tmpMainWrapper[i].objDNLI.Discount_Currency__c ==null || tmpMainWrapper[i].objDNLI.Discount_Currency__c == '')
							tmpMainWrapper[i].objDNLI.Discount_Currency__c =0;
						
						if(tmpMainWrapper[i].objDNLI.Discount__c != null && tmpMainWrapper[i].objDNLI.Discount__c !='' && tmpMainWrapper[i].objDNLI.Discount__c != 0)
							tmpMainWrapper[i].objDNLI.Discount_Currency__c = Amount*tmpMainWrapper[i].objDNLI.Discount__c/100;
						
						if(tmpMainWrapper[i].objDNLI.Discount__c ==0){
							tmpMainWrapper[i].objDNLI.Discount_Currency__c =0;
						}else{
							if(tmpMainWrapper[i].objDNLI.Discount_Currency__c != null && tmpMainWrapper[i].objDNLI.Discount_Currency__c != null !='' && tmpMainWrapper[i].objDNLI.Discount_Currency__c != 0)
								tmpMainWrapper[i].objDNLI.Discount__c = tmpMainWrapper[i].objDNLI.Discount_Currency__c /Amount*100;
						}
						var IntDiscount = tmpMainWrapper[i].objDNLI.Discount_Currency__c;
						var TaxableAmount = Amount - IntDiscount;
						
						tmpMainWrapper[i].objDNLI.Taxable_Amount__c = TaxableAmount;
						
						
						var IntCGST =0;
						var IntSGST =0;
						var IntIGST =0;
						if(tmpMainWrapper[i].objDNLI.CGST__c !=null){
							IntCGST = TaxableAmount * tmpMainWrapper[i].objDNLI.CGST__c /100;
						}if(tmpMainWrapper[i].objDNLI.SGST__c !=null){
							IntSGST = TaxableAmount * tmpMainWrapper[i].objDNLI.SGST__c /100;
						}if(tmpMainWrapper[i].objDNLI.IGST__c !=null){
							IntIGST = TaxableAmount * tmpMainWrapper[i].objDNLI.IGST__c /100;
						}
						tmpMainWrapper[i].objDNLI.Gross_Amount__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
						component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
					} 
				}else{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"type":"error",
						"title": "Error!",
						"message": "Please input discount rate."
					});
					toastEvent.fire();
				}
			}else{
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type":"error",
					"title": "Error!",
					"message": "Please change the first-row discount rate."
				});
				toastEvent.fire();
			}
		}else{
		
			for(var i=0;i<tmpMainWrapper.length;i++)
			{
				if(rowIndex == i){
					if(tmpMainWrapper[i].objDNLI != null && tmpMainWrapper[i].objDNLI.Quantity__c != null && tmpMainWrapper[i].objDNLI.Sales_Price__c != null){
						var BillQTY = event.target.value;
						tmpMainWrapper[i].objDNLI.Discount__c = BillQTY;
						var Amount = tmpMainWrapper[i].objDNLI.Total_Amount__c;
						if(tmpMainWrapper[i].objDNLI.Discount_Currency__c ==null || tmpMainWrapper[i].objDNLI.Discount_Currency__c == '')
							tmpMainWrapper[i].objDNLI.Discount_Currency__c =0;
						
						if(tmpMainWrapper[i].objDNLI.Discount__c != null && tmpMainWrapper[i].objDNLI.Discount__c !='' && tmpMainWrapper[i].objDNLI.Discount__c != 0)
							tmpMainWrapper[i].objDNLI.Discount_Currency__c = Amount*tmpMainWrapper[i].objDNLI.Discount__c/100;
						
						if(tmpMainWrapper[i].objDNLI.Discount__c ==0){
							tmpMainWrapper[i].objDNLI.Discount_Currency__c =0;
						}else{
							if(tmpMainWrapper[i].objDNLI.Discount_Currency__c != null && tmpMainWrapper[i].objDNLI.Discount_Currency__c != null !='' && tmpMainWrapper[i].objDNLI.Discount_Currency__c != 0)
								tmpMainWrapper[i].objDNLI.Discount__c = tmpMainWrapper[i].objDNLI.Discount_Currency__c /Amount*100;
						}
						var IntDiscount = tmpMainWrapper[i].objDNLI.Discount_Currency__c;
						var TaxableAmount = Amount - IntDiscount;
						
						tmpMainWrapper[i].objDNLI.Taxable_Amount__c = TaxableAmount;
						
						
						var IntCGST =0;
						var IntSGST =0;
						var IntIGST =0;
						if(tmpMainWrapper[i].objDNLI.CGST__c !=null){
							IntCGST = TaxableAmount * tmpMainWrapper[i].objDNLI.CGST__c /100;
						}if(tmpMainWrapper[i].objDNLI.SGST__c !=null){
							IntSGST = TaxableAmount * tmpMainWrapper[i].objDNLI.SGST__c /100;
						}if(tmpMainWrapper[i].objDNLI.IGST__c !=null){
							IntIGST = TaxableAmount * tmpMainWrapper[i].objDNLI.IGST__c /100;
						}
						tmpMainWrapper[i].objDNLI.Gross_Amount__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
						component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
					} 
				}else{
					component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
				}
			}
			component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
		}
    },
	
	
	Checkboxdiscountaction : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		var isdiscount =  component.get('v.Isdiscount');
        if(isdiscount==true){
			if(tmpMainWrapper[0].objDNLI.Discount__c != null && tmpMainWrapper[0].objDNLI.Discount__c != ''){
				for(var i=0;i<tmpMainWrapper.length;i++)
				{	
					tmpMainWrapper[i].objDNLI.Discount__c = tmpMainWrapper[0].objDNLI.Discount__c;
					var Amount = tmpMainWrapper[i].objDNLI.Total_Amount__c;
					if(tmpMainWrapper[i].objDNLI.Discount_Currency__c ==null || tmpMainWrapper[i].objDNLI.Discount_Currency__c == '')
						tmpMainWrapper[i].objDNLI.Discount_Currency__c =0;
					
					if(tmpMainWrapper[i].objDNLI.Discount__c != null && tmpMainWrapper[i].objDNLI.Discount__c !='' && tmpMainWrapper[i].objDNLI.Discount__c != 0)
						tmpMainWrapper[i].objDNLI.Discount_Currency__c = Amount*tmpMainWrapper[i].objDNLI.Discount__c/100;
					
					if(tmpMainWrapper[i].objDNLI.Discount_Currency__c != null && tmpMainWrapper[i].objDNLI.Discount_Currency__c != null !='' && tmpMainWrapper[i].objDNLI.Discount_Currency__c != 0)
						tmpMainWrapper[i].objDNLI.Discount__c = tmpMainWrapper[i].objDNLI.Discount_Currency__c /Amount*100;
					
					var IntDiscount = tmpMainWrapper[i].objDNLI.Discount_Currency__c;
					var TaxableAmount = Amount - IntDiscount;
					
					tmpMainWrapper[i].objDNLI.Taxable_Amount__c = TaxableAmount;
					
					
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].objDNLI.CGST__c !=null){
						IntCGST = TaxableAmount * tmpMainWrapper[i].objDNLI.CGST__c /100;
					}if(tmpMainWrapper[i].objDNLI.SGST__c !=null){
						IntSGST = TaxableAmount * tmpMainWrapper[i].objDNLI.SGST__c /100;
					}if(tmpMainWrapper[i].objDNLI.IGST__c !=null){
						IntIGST = TaxableAmount * tmpMainWrapper[i].objDNLI.IGST__c /100;
					}
					tmpMainWrapper[i].objDNLI.Gross_Amount__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
					component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
				} 
			}else{
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type":"error",
					"title": "Error!",
					"message": "Please input discount rate."
				});
				toastEvent.fire();
			}
		}
    },
	
	
	CalculateSalesCGST: function (component, event) {
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				var IntGST = event.target.value;
				var IntCGST =0;
				var IntSGST =0;
				var IntIGST =0;
				if(IntCGST !=null){
					tmpMainWrapper[i].objDNLI.CGST__c = IntGST;
					IntCGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * IntGST /100;
				}if(tmpMainWrapper[i].objDNLI.SGST__c !=null){
					IntSGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * tmpMainWrapper[i].objDNLI.SGST__c /100;
				}if(tmpMainWrapper[i].objDNLI.IGST__c !=null){
					IntIGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * tmpMainWrapper[i].objDNLI.IGST__c /100;
				}
				tmpMainWrapper[i].objDNLI.Gross_Amount__c = tmpMainWrapper[i].objDNLI.Taxable_Amount__c+IntCGST+IntSGST+IntIGST;
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
			}else{
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
			}
		}
        component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
	},
	
	
	CalculateSalesSGST: function (component,event,helper) {
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				var IntGST = event.target.value;
				var IntCGST =0;
				var IntSGST =0;
				var IntIGST =0;
				if(tmpMainWrapper[i].objDNLI.CGST__c !=null){
					IntCGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * tmpMainWrapper[i].objDNLI.CGST__c /100;
				}if(IntGST !=null){
					tmpMainWrapper[i].objDNLI.SGST__c = IntGST;
					IntSGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * IntGST /100;
				}if(tmpMainWrapper[i].objDNLI.IGST__c !=null){
					IntIGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * tmpMainWrapper[i].objDNLI.IGST__c /100;
				}
				tmpMainWrapper[i].objDNLI.Gross_Amount__c = tmpMainWrapper[i].objDNLI.Taxable_Amount__c+IntCGST+IntSGST+IntIGST;
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
			}else{
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
			}
		}
        component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
	},
	
	
	CalculateSalesIGST: function (component,event,helper) {
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.ObjDeliveryNoteLI.lstSubMain");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				var IntGST = event.target.value;
				var IntCGST =0;
				var IntSGST =0;
				var IntIGST =0;
				if(tmpMainWrapper[i].objDNLI.CGST__c !=null){
					IntCGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * tmpMainWrapper[i].objDNLI.CGST__c /100;
				}if(tmpMainWrapper[i].objDNLI.SGST__c !=null){
					IntSGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * tmpMainWrapper[i].objDNLI.SGST__c /100;
				}if(IntGST !=null){
					tmpMainWrapper[i].objDNLI.IGST__c = IntGST;
					IntIGST = tmpMainWrapper[i].objDNLI.Taxable_Amount__c * IntGST /100;
				}
				tmpMainWrapper[i].objDNLI.Gross_Amount__c = tmpMainWrapper[i].objDNLI.Taxable_Amount__c+IntCGST+IntSGST+IntIGST;
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
			}else{
				component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
			}
		}
        component.set("v.ObjDeliveryNoteLI.lstSubMain",tmpMainWrapper);
	},
	
	
	PurchaseOrder: function (component, event) {
        //var isEnterKey = event.keyCode === 13;
		
		var strWareHouse = component.get("v.selectedRecord");
		var strSupplier =component.get("v.Supplier");
		var strDeliveryType =component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c");
		var strCurrency =component.get("v.mainWrap.objMRN.Currency__c");
		var strExchangeRate =component.get("v.mainWrap.objMRN.Exchange_Rate__c");
		var strExWorkValue =component.get("v.mainWrap.objMRN.Ex_Work_Value__c");
		var strSurcharge =component.get("v.mainWrap.objMRN.Surcharge__c");
		var strFreight =component.get("v.mainWrap.objMRN.Freight__c");
		var strInsuranceofBOE =component.get("v.mainWrap.objMRN.Insurance_of_BOE__c");
		var IsvalidatestrDeliveryType = false;
		var IsvalidateCurrency = false;
		var IsvalidateExWorkValue = false;
		var IsvalidateExchangeRate = false;
		var IsvalidateSurcharge = false;
		var IsvalidateFreight = false;
		var IsvalidateInsuranceofBOE = false;
		var strErrorMsg = '';
		
		var strMRNDeliveryType =component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c");
		var IsMRNDeliveryType = false;
		if(strMRNDeliveryType == 'Import'){
			if(strInsuranceofBOE !=null && strInsuranceofBOE !=''){
				IsvalidateInsuranceofBOE = true;
			}else{
				strErrorMsg ='Please fill the Insurance of BOE.';
			}
			
			if(strFreight !=null && strFreight !=''){
				IsvalidateFreight = true;
			}else{
				strErrorMsg ='Please fill the Freight.';
			}
			if(strSurcharge !=null && strSurcharge !=''){
				IsvalidateSurcharge = true;
			}else{
				strErrorMsg ='Please fill the Surcharge.';
			}
			if(strExWorkValue !=null && strExWorkValue !=''){
				IsvalidateExWorkValue = true;
			}else{
				strErrorMsg ='Please fill the Ex work value.';
			}
			if(strExchangeRate !=null && strExchangeRate !=''){
				IsvalidateExchangeRate = true;
			}else{
				strErrorMsg ='Please fill the Exchange Rate.';
			}
			if(strCurrency !=null && strCurrency !=''){
				IsvalidateCurrency = true;
			}else{
				strErrorMsg ='Please select Currency.';
			}
			if(strDeliveryType !=null && strDeliveryType !=''){
				IsvalidatestrDeliveryType = true;
			}else{
				strErrorMsg ='Please select Delivery Type.';
			}
		}else{
			IsMRNDeliveryType = true;
		}
		
		
		
		if((IsvalidateCurrency == true && IsvalidateExWorkValue == true && IsvalidateExchangeRate == true && IsvalidateSurcharge ==true && IsvalidateFreight == true && IsvalidateInsuranceofBOE == true && IsvalidatestrDeliveryType == true) || IsMRNDeliveryType == true){
		
			if(strWareHouse !=null && strWareHouse !='' && strSupplier !=null && strSupplier !=''){
				var queryTerm = component.find('enter-searchcc').get('v.value');
				
				if (queryTerm.length > 1) {
					//component.set('v.mainWrap.LstWrapperResult', component.get('v.mainWrap.LstWrapperResult'));
					component.set('v.issearchingPurchaseOrder', true);
					var action = component.get("c.fetchData");
					action.setParams({
						'strWrap' : JSON.stringify(component.get("v.mainWrap")),
						'searchKeyWord':queryTerm,
						'strWareHouseId' : strWareHouse.Id,
						'strSupplier' : strSupplier.Id
					});
					action.setCallback(this, function(response) {
					   
						var state = response.getState();
						//alert('...state....'+state);
						if (state === "SUCCESS") {
							var storeResponse = response.getReturnValue();
							//alert('...state.!!!!!...'+storeResponse);
							component.set("v.mainWrap", JSON.parse(storeResponse));
							component.set("v.lstPurchaseOrderLI", component.get("v.mainWrap.LstWrapperResult"));
						}
					});
					$A.enqueueAction(action);
					/*setTimeout(function() {
						component.set('v.issearchingPurchaseOrder', false);
						component.set("v.lstPurchaseOrderLI", null);
					}, 5000);*/
				   
				}else{
					if(queryTerm.length == 0){
					  component.set("v.lstPurchaseOrderLI", null);
					}
				}
			}else{
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title : 'Error Message',
					message:'Please select Ware House and Supplier.',
					messageTemplate: 'Please select Ware House and Supplier.',
					duration:' 50',
					key: 'info_alt',
					type: 'error',
					mode: 'pester'
				});
				toastEvent.fire();
			}
		}else{
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title : 'Error Message',
				message: strErrorMsg,
				messageTemplate: strErrorMsg,
				duration:' 50',
				key: 'info_alt',
				type: 'error',
				mode: 'pester'
			});
			toastEvent.fire();
		}
    },
	
	selectPurchaseOrder: function(component,event,helper){
         
         var indexrecordId = event.currentTarget.dataset.index;
		 //alert('..indexrecordId....'+indexrecordId);
         var recordname;
         var recordId;
		var varIconName;
         var varToAdd = component.get('v.lstPurchaseOrderLI');
         for(var i = 0; i < varToAdd.length; i++) {
			 //alert(indexrecordId+'...'+varToAdd[i].RecordId);
             if(indexrecordId === varToAdd[i].RecordId){
                 recordname = varToAdd[i].RecordName;
                 recordId = varToAdd[i].RecordId;
				 varIconName ='standard:avatar';
             }
         }      
         
        var pills = component.get('v.itemsPurchaseOrderLI');
		//alert('.!!!!!..'+pills.length);
        var AlreadyAdded='';
        for (var i = 0; i < pills.length; i++) {
			//alert(recordId+'......'+pills[i].id);
            if (recordId === pills[i].id) {
                AlreadyAdded='true';
                break;
            }
        }
       
        if(AlreadyAdded==''){
            pills.push({
                type: 'icon',
                id: recordId,
                label: recordname
            });
           //alert('pills....'+pills);
            component.set('v.itemsPurchaseOrderLI', pills);
           
        }else if(AlreadyAdded=='true'){
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
		var strPurchaseOrderId ='';
		var lstPurchaseOrderId = component.get('v.itemsPurchaseOrderLI');
		for (var i = 0; i < lstPurchaseOrderId.length; i++) {
			if(strPurchaseOrderId !=null && strPurchaseOrderId !='')
				strPurchaseOrderId = strPurchaseOrderId+','+pills[i].id;
			else
				strPurchaseOrderId = pills[i].id;
		}
		component.set('v.mainWrap.itemsPurchaseOrderLI', component.get('v.itemsPurchaseOrderLI'));
		helper.searchPurchaseOrderLineItems(component,event,strPurchaseOrderId)
        component.set("v.lstPurchaseOrderLI", null);
	},
	CalculateBillQty : function(component,event,helper){
        
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
        
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				var IntBillQty = event.target.value;
				tmpMainWrapper[i].IntBillQty = IntBillQty;
				
				tmpMainWrapper[i].IntAcceptQty =  IntBillQty - tmpMainWrapper[i].IntReceiptQty;
				tmpMainWrapper[i].IntTotalAmountGBP = tmpMainWrapper[i].IntPriceGBP*IntBillQty;
                var IntExWorkValue = component.get("v.mainWrap.objMRN.Ex_Work_Value__c");
					var IntSurcharge = component.get("v.mainWrap.objMRN.Surcharge__c");
					var IntFreight = component.get("v.mainWrap.objMRN.Freight__c");
					var IntExchangeRate = component.get("v.mainWrap.objMRN.Exchange_Rate__c	");
					var IntInsuranceOfBOE = component.get("v.mainWrap.objMRN.Insurance_of_BOE__c");
					
					var decInvSurcharge = IntSurcharge*100/IntExWorkValue;
					var FreightofInvoice = IntFreight*100/IntExWorkValue;
					//alert(tmpMainWrapper[i].IntTotalAmountGBP+'...'+decInvSurcharge +'..FreightofInvoice...'+FreightofInvoice);
					tmpMainWrapper[i].IntItemFreighGBP = tmpMainWrapper[i].IntTotalAmountGBP+(tmpMainWrapper[i].IntTotalAmountGBP*decInvSurcharge/100) +(tmpMainWrapper[i].IntTotalAmountGBP *FreightofInvoice/100);
					tmpMainWrapper[i].IntItemvalueINR =  tmpMainWrapper[i].IntItemFreighGBP *IntExchangeRate;
                if(strDeliveryType =='Import'){
                tmpMainWrapper[i].IntAssessableValueINR = tmpMainWrapper[i].IntItemvalueINR +(tmpMainWrapper[i].IntItemvalueINR *IntInsuranceOfBOE/100);
					tmpMainWrapper[i].IntCDutyAmountINR = tmpMainWrapper[i].IntAssessableValueINR * tmpMainWrapper[i].IntDutyRate /100+(tmpMainWrapper[i].IntAssessableValueINR * tmpMainWrapper[i].IntDutyRate /100 * tmpMainWrapper[i].IntSurRate /100);
                }
                else{
                    tmpMainWrapper[i].IntAssessableValueINR =0;
                    tmpMainWrapper[i].IntCDutyAmountINR=0;
                }
					//tmpMainWrapper[i].IntTotalLandedAmountINR =((tmpMainWrapper[i].IntItemvalueINR + tmpMainWrapper[i].IntCDutyAmountINR)+(tmpMainWrapper[i].IntTotalAmountGBP *IntExchangeRate));
					var strDeliveryType =component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c"); 
					if(strDeliveryType =='Import')
						tmpMainWrapper[i].IntTaxableValue = tmpMainWrapper[i].IntAssessableValueINR +tmpMainWrapper[i].IntCDutyAmountINR;
					else 
						tmpMainWrapper[i].IntTaxableValue = tmpMainWrapper[i].IntTotalAmountGBP;
					
					
					if(tmpMainWrapper[i].IntGSTRate !=null)
						tmpMainWrapper[i].IntGSTAmount = tmpMainWrapper[i].IntTaxableValue *tmpMainWrapper[i].IntGSTRate/100;
					
					if(strDeliveryType =='Import'){
						if(tmpMainWrapper[i].IntGSTAmount !=null && tmpMainWrapper[i].IntTaxableValue !=null)
							tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntTaxableValue +tmpMainWrapper[i].IntGSTAmount;
						
					}else{
						if(tmpMainWrapper[i].IntCGSTRate !=null)
							tmpMainWrapper[i].IntCGSTAmount = tmpMainWrapper[i].IntTaxableValue *tmpMainWrapper[i].IntCGSTRate/100;
						
						if(tmpMainWrapper[i].IntSGSTRate !=null)
							tmpMainWrapper[i].IntSGSTAmount = tmpMainWrapper[i].IntTaxableValue *tmpMainWrapper[i].IntSGSTRate/100;
						
						if(tmpMainWrapper[i].IntIGSTRate !=null)
							tmpMainWrapper[i].IntIGSTAmount = tmpMainWrapper[i].IntTaxableValue *tmpMainWrapper[i].IntIGSTRate/100;
						
						//alert(tmpMainWrapper[i].IntTaxableValue+'..'+tmpMainWrapper[i].IntCGSTAmount+'..'+tmpMainWrapper[i].IntSGSTAmount)
						tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntCGSTAmount+tmpMainWrapper[i].IntSGSTAmount+tmpMainWrapper[i].IntIGSTAmount +tmpMainWrapper[i].IntTaxableValue;
					}
                
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
    },
					
	CalculateDeliveryNoteQty : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IntBillQty != null){
					var IntBillQty = event.target.value;
					tmpMainWrapper[i].IntReceiptQty = IntBillQty;
					tmpMainWrapper[i].IntAcceptQty = tmpMainWrapper[i].IntBillQty - IntBillQty;
					/*var Amount = IntBillQty * tmpMainWrapper[i].objPOLI.Sales_Price__c;
					//var IntDiscount = Amount*IntBillQty / 100;
					var GrossAmount = tmpMainWrapper[i].objPOLI.Sales_Price__c * IntBillQty ;
					tmpMainWrapper[i].IntReceiptQty = IntBillQty;
					tmpMainWrapper[i].objPOLI.Amount_INR_GBP__c = Amount;
					//tmpMainWrapper[i].objPOLI.Discount__c = IntDiscount;
					tmpMainWrapper[i].decGrossAmount = GrossAmount;
					
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].objPOLI.CGST__c !=null){
						IntCGST = GrossAmount * tmpMainWrapper[i].objPOLI.CGST__c /100;
					}if(tmpMainWrapper[i].objPOLI.SGST__c !=null){
						IntSGST = GrossAmount * tmpMainWrapper[i].objPOLI.SGST__c /100;
					}if(tmpMainWrapper[i].objPOLI.IGST__c !=null){
						IntIGST = GrossAmount * tmpMainWrapper[i].objPOLI.IGST__c /100;
					}
					tmpMainWrapper[i].IntNetAmount = GrossAmount+IntCGST+IntSGST+IntIGST;*/
					
					component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
                } 
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
    },
	CalculateTotalPriceGBP : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IntBillQty !=null){
					var IntBillQty = event.target.value;
					tmpMainWrapper[i].IntPriceGBP = IntBillQty;
					tmpMainWrapper[i].IntTotalAmountGBP =  tmpMainWrapper[i].IntBillQty * IntBillQty;
					var IntExWorkValue = component.get("v.mainWrap.objMRN.Ex_Work_Value__c");
					var IntSurcharge = component.get("v.mainWrap.objMRN.Surcharge__c");
					var IntFreight = component.get("v.mainWrap.objMRN.Freight__c");
					var IntExchangeRate = component.get("v.mainWrap.objMRN.Exchange_Rate__c	");
					var IntInsuranceOfBOE = component.get("v.mainWrap.objMRN.Insurance_of_BOE__c");
					var decInvSurcharge = IntSurcharge*100/IntExWorkValue;
					var FreightofInvoice = IntFreight*100/IntExWorkValue;
                    var strDeliveryType =component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c"); 
					tmpMainWrapper[i].IntItemFreighGBP = tmpMainWrapper[i].IntTotalAmountGBP+(tmpMainWrapper[i].IntTotalAmountGBP*decInvSurcharge/100) +(tmpMainWrapper[i].IntTotalAmountGBP *FreightofInvoice/100);
					tmpMainWrapper[i].IntItemvalueINR =  tmpMainWrapper[i].IntItemFreighGBP *IntExchangeRate;
                   	console.log('strDeliveryType-- '+strDeliveryType);
                    if(strDeliveryType =='Import'){
                        tmpMainWrapper[i].IntAssessableValueINR = tmpMainWrapper[i].IntItemvalueINR +(tmpMainWrapper[i].IntItemvalueINR *IntInsuranceOfBOE/100);
                        tmpMainWrapper[i].IntCDutyAmountINR = tmpMainWrapper[i].IntAssessableValueINR * tmpMainWrapper[i].IntDutyRate /100+(tmpMainWrapper[i].IntAssessableValueINR * tmpMainWrapper[i].IntDutyRate /100 * tmpMainWrapper[i].IntSurRate /100);
                    }
                    else{
                        
                        tmpMainWrapper[i].IntAssessableValueINR=0;
                        tmpMainWrapper[i].IntCDutyAmountINR=0;
                    }
					//tmpMainWrapper[i].IntTotalLandedAmountINR =((tmpMainWrapper[i].IntItemvalueINR + tmpMainWrapper[i].IntCDutyAmountINR)+(tmpMainWrapper[i].IntTotalAmountGBP *IntExchangeRate));
					
					if(strDeliveryType =='Import')
						tmpMainWrapper[i].IntTaxableValue = tmpMainWrapper[i].IntAssessableValueINR +tmpMainWrapper[i].IntCDutyAmountINR;
					else 
						tmpMainWrapper[i].IntTaxableValue = tmpMainWrapper[i].IntTotalAmountGBP;
					
					
					if(tmpMainWrapper[i].IntGSTRate !=null)
						tmpMainWrapper[i].IntGSTAmount = tmpMainWrapper[i].IntTaxableValue *tmpMainWrapper[i].IntGSTRate/100;
					
					if(strDeliveryType =='Import'){
						if(tmpMainWrapper[i].IntGSTAmount !=null && tmpMainWrapper[i].IntTaxableValue !=null)
							tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntTaxableValue +tmpMainWrapper[i].IntGSTAmount;
						
					}else{
						if(tmpMainWrapper[i].IntCGSTRate !=null)
							tmpMainWrapper[i].IntCGSTAmount = tmpMainWrapper[i].IntTaxableValue *tmpMainWrapper[i].IntCGSTRate/100;
						
						if(tmpMainWrapper[i].IntSGSTRate !=null)
							tmpMainWrapper[i].IntSGSTAmount = tmpMainWrapper[i].IntTaxableValue *tmpMainWrapper[i].IntSGSTRate/100;
						
						if(tmpMainWrapper[i].IntIGSTRate !=null)
							tmpMainWrapper[i].IntIGSTAmount = tmpMainWrapper[i].IntTaxableValue *tmpMainWrapper[i].IntIGSTRate/100;
						
						//alert(tmpMainWrapper[i].IntTaxableValue+'..'+tmpMainWrapper[i].IntCGSTAmount+'..'+tmpMainWrapper[i].IntSGSTAmount)
						tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntCGSTAmount+tmpMainWrapper[i].IntSGSTAmount+tmpMainWrapper[i].IntIGSTAmount +tmpMainWrapper[i].IntTaxableValue;
					}
					
					component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
					
				}
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
    },
	
	
	
	CalculateCGSTAmount : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IntTaxableValue !=null){
					var IntBillQty = event.target.value;
					tmpMainWrapper[i].IntCGSTRate = IntBillQty;
					tmpMainWrapper[i].IntCGSTAmount =  tmpMainWrapper[i].IntTaxableValue * IntBillQty/100;
					//tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntCGSTAmount + tmpMainWrapper[i].IntSGSTAmount + tmpMainWrapper[i].IntIGSTAmount;
					tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntCGSTAmount+tmpMainWrapper[i].IntSGSTAmount+tmpMainWrapper[i].IntIGSTAmount +tmpMainWrapper[i].IntTaxableValue;
					component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
				}
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
	},
	CalculateSGSTAmount : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IntTaxableValue !=null){
					var IntBillQty = event.target.value;
					tmpMainWrapper[i].IntSGSTRate = IntBillQty;
					tmpMainWrapper[i].IntSGSTAmount =  tmpMainWrapper[i].IntTaxableValue * IntBillQty/100;
					//tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntCGSTAmount + tmpMainWrapper[i].IntSGSTAmount + tmpMainWrapper[i].IntIGSTAmount;
					tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntCGSTAmount+tmpMainWrapper[i].IntSGSTAmount+tmpMainWrapper[i].IntIGSTAmount +tmpMainWrapper[i].IntTaxableValue;
					component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
				}
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
	},
	
	CalculateIGSTAmount : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IntTaxableValue !=null){
					var IntBillQty = event.target.value;
					tmpMainWrapper[i].IntIGSTRate = IntBillQty;
					tmpMainWrapper[i].IntIGSTAmount =  tmpMainWrapper[i].IntTaxableValue * IntBillQty/100;
					tmpMainWrapper[i].IntTotalInsuranceCost =tmpMainWrapper[i].IntTaxableValue+ tmpMainWrapper[i].IntCGSTAmount + tmpMainWrapper[i].IntSGSTAmount + tmpMainWrapper[i].IntIGSTAmount;
					
                    component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
				}
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
	},
	
	CalculateDutyRate : function(component,event,helper){
		var target = event.target;
        var rowIndex = event.getSource().get("v.name");
        var stateSelected = event.getSource().get("v.value");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		console.log(rowIndex);
        console.log(stateSelected);
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IntAssessableValueINR !=null){
					
					tmpMainWrapper[i].IntDutyRate = stateSelected;
                    
					tmpMainWrapper[i].IntCDutyAmountINR = tmpMainWrapper[i].IntAssessableValueINR *stateSelected/100+(tmpMainWrapper[i].IntAssessableValueINR *stateSelected/100 * tmpMainWrapper[i].IntSurRate/100);
					tmpMainWrapper[i].IntTaxableValue = tmpMainWrapper[i].IntCDutyAmountINR + tmpMainWrapper[i].IntAssessableValueINR;
					
					tmpMainWrapper[i].IntGSTAmount = tmpMainWrapper[i].IntTaxableValue * tmpMainWrapper[i].IntGSTRate /100;
					component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
					tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntTaxableValue+tmpMainWrapper[i].IntGSTAmount;
				}
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
    },
	
	CalculateSurRate : function(component,event,helper){
		var target = event.target;
         var rowIndex = event.getSource().get("v.name");
        var stateSelected = event.getSource().get("v.value");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IntAssessableValueINR !=null){
					
					tmpMainWrapper[i].IntSurRate = stateSelected;
					tmpMainWrapper[i].IntCDutyAmountINR = tmpMainWrapper[i].IntAssessableValueINR *tmpMainWrapper[i].IntDutyRate/100+(tmpMainWrapper[i].IntAssessableValueINR *tmpMainWrapper[i].IntDutyRate/100 * stateSelected/100);
					tmpMainWrapper[i].IntTaxableValue = tmpMainWrapper[i].IntCDutyAmountINR + tmpMainWrapper[i].IntAssessableValueINR;
					tmpMainWrapper[i].IntGSTAmount = tmpMainWrapper[i].IntTaxableValue * tmpMainWrapper[i].IntGSTRate /100;
					component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
					tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntTaxableValue+tmpMainWrapper[i].IntGSTAmount;
				}
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
    },
	
	CalculateGSTRate : function(component,event,helper){
		var target = event.target;
        var rowIndex = event.getSource().get("v.name");
        var stateSelected = event.getSource().get("v.value");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IntAssessableValueINR !=null){
					
					tmpMainWrapper[i].IntGSTRate = stateSelected;
					tmpMainWrapper[i].IntGSTAmount = tmpMainWrapper[i].IntTaxableValue *stateSelected/100;
					tmpMainWrapper[i].IntTotalInsuranceCost = tmpMainWrapper[i].IntTaxableValue + tmpMainWrapper[i].IntGSTAmount;
					
					component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
					
				}
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
    },
    
   
	
	CalculateDeliveryNoteRate : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].objPOLI != null && tmpMainWrapper[i].IntReceiptQty != null){
					var IntBillRate = event.target.value;
					var Amount = IntBillRate * tmpMainWrapper[i].IntReceiptQty;
					//var IntDiscount = Amount*IntBillQty / 100;
					var GrossAmount = tmpMainWrapper[i].IntReceiptQty * IntBillRate ;
					tmpMainWrapper[i].objPOLI.Sales_Price__c = IntBillRate;
					tmpMainWrapper[i].objPOLI.Amount_INR_GBP__c = Amount;
					//tmpMainWrapper[i].objPOLI.Discount__c = IntDiscount;
					tmpMainWrapper[i].decGrossAmount = GrossAmount;
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].objPOLI.CGST__c !=null){
						IntCGST = GrossAmount * tmpMainWrapper[i].objPOLI.CGST__c /100;
					}if(tmpMainWrapper[i].objPOLI.SGST__c !=null){
						IntSGST = GrossAmount * tmpMainWrapper[i].objPOLI.SGST__c /100;
					}if(tmpMainWrapper[i].objPOLI.IGST__c !=null){
						IntIGST = GrossAmount * tmpMainWrapper[i].objPOLI.IGST__c /100;
					}
					tmpMainWrapper[i].IntNetAmount = GrossAmount+IntCGST+IntSGST+IntIGST;
					component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
                } 
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
    },
	
	CalculatePurchaseCGST: function (component, event) {
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				var IntGST = event.target.value;
				var IntCGST =0;
				var IntSGST =0;
				var IntIGST =0;
				if(IntGST !=null){
					tmpMainWrapper[i].objPOLI.CGST__c = IntGST;
					IntCGST = tmpMainWrapper[i].decGrossAmount * IntGST /100;
				}if(tmpMainWrapper[i].objPOLI.SGST__c !=null){
					IntSGST = tmpMainWrapper[i].decGrossAmount * tmpMainWrapper[i].objPOLI.SGST__c /100;
				}if(tmpMainWrapper[i].objPOLI.IGST__c !=null){
					IntIGST = tmpMainWrapper[i].decGrossAmount * tmpMainWrapper[i].objPOLI.IGST__c /100;
				}
				tmpMainWrapper[i].IntNetAmount = tmpMainWrapper[i].decGrossAmount+IntCGST+IntSGST+IntIGST;
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
	},
	
	
	CalculatePurchaseSGST: function (component,event,helper) {
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				var IntGST = event.target.value;
				var IntCGST =0;
				var IntSGST =0;
				var IntIGST =0;
				if(tmpMainWrapper[i].objPOLI.CGST__c !=null){
					IntCGST = tmpMainWrapper[i].decGrossAmount * tmpMainWrapper[i].objPOLI.CGST__c /100;
				}if(IntGST !=null){
					tmpMainWrapper[i].objPOLI.SGST__c = IntGST;
					IntSGST = tmpMainWrapper[i].decGrossAmount * IntGST /100;
				}if(tmpMainWrapper[i].objPOLI.IGST__c !=null){
					IntIGST = tmpMainWrapper[i].decGrossAmount * tmpMainWrapper[i].objPOLI.IGST__c /100;
				}
				tmpMainWrapper[i].IntNetAmount = tmpMainWrapper[i].decGrossAmount+IntCGST+IntSGST+IntIGST;
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
	},
	
	CalculatePurchaseIGST: function (component,event,helper) {
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				var IntGST = event.target.value;
				var IntCGST =0;
				var IntSGST =0;
				var IntIGST =0;
				if(tmpMainWrapper[i].objPOLI.CGST__c !=null){
					IntCGST = tmpMainWrapper[i].decGrossAmount * tmpMainWrapper[i].objPOLI.CGST__c /100;
				}if(tmpMainWrapper[i].objPOLI.SGST__c !=null){
					IntSGST = tmpMainWrapper[i].decGrossAmount * tmpMainWrapper[i].objPOLI.SGST__c /100;
				}if(IntGST !=null){
					tmpMainWrapper[i].objPOLI.IGST__c = IntGST;
					IntIGST = tmpMainWrapper[i].decGrossAmount * IntGST /100;
				}
				tmpMainWrapper[i].IntNetAmount = tmpMainWrapper[i].decGrossAmount+IntCGST+IntSGST+IntIGST;
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}else{
				component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstDeliveryNoteLIWrap",tmpMainWrapper);
	},
	
	selectTaxType: function(component,event,helper){
        var strType = component.get("v.strType");
		var TotalAmount =0;
		//alert('...'+strType);
		if(strType =='Sales Return'){
			var lstSalesReturn =lstSalesReturn = component.get("v.ObjDeliveryNoteLI.lstSubMain");
			var lstOldSalesReturn =component.get("v.ObjDeliveryNoteLI.lstMRNLineItems");
			
			for(var i = 0; i < lstOldSalesReturn.length; i++) {
				alert('..lstOldSalesReturn[i].ObjMRNLI.Total_Amount__c..'+lstOldSalesReturn[i].ObjMRNLI.Total_Amount__c);
				if(lstOldSalesReturn[i].ObjMRNLI.Total_Amount__c !=null && lstOldSalesReturn[i].ObjMRNLI.Total_Amount__c !='')
					TotalAmount = TotalAmount+lstOldSalesReturn[i].ObjMRNLI.Total_Amount__c;
			}
			component.set("v.decTotalAmount",TotalAmount);
			
			for(var i = 0; i < lstSalesReturn.length; i++) {
				//alert('.....'+lstSalesReturn[i].objDNLI.Gross_Amount__c);
				if(lstSalesReturn[i].objDNLI.Gross_Amount__c !=null && lstSalesReturn[i].objDNLI.Gross_Amount__c !='')
					TotalAmount = TotalAmount+lstSalesReturn[i].objDNLI.Gross_Amount__c;
			}
			component.set("v.decTotalAmount",TotalAmount);
		}
		if(strType =='Purchase Order'){
			var lstPurchaseOrder = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
			for(var i = 0; i < lstPurchaseOrder.length; i++) {
				if(lstPurchaseOrder[i].decGrossAmount !=null && lstPurchaseOrder[i].decGrossAmount !='')
					TotalAmount = TotalAmount+lstPurchaseOrder[i].decGrossAmount;
			}
			component.set("v.decTotalAmount",TotalAmount);
		}
		var StrRecordId = component.get("v.recordId");
		if(StrRecordId !=null && StrRecordId !='' && strType =='Purchase Order'){
			var lstPurchaseOrder = component.get("v.mainWrap.lstMRNLineItems");
			for(var i = 0; i < lstPurchaseOrder.length; i++) {
				if(lstPurchaseOrder[i].decGrossAmount !=null && lstPurchaseOrder[i].decGrossAmount !='')
					TotalAmount = TotalAmount+lstPurchaseOrder[i].decGrossAmount;
			}
			component.set("v.decTotalAmount",TotalAmount);
		}
		
		
		var TotalAmount = component.get("v.decTotalAmount");
		//alert('..TotalAmount...'+TotalAmount);
        var StrSelectedTax = component.get("v.strTaxType");
        var lstTaxDetails = component.get("v.mainWrap.lstTaxDetails");
		var lstSelectedTax = component.get("v.lstSelectedTax");
		var AlreadyAdded='';
		for(var i = 0; i < lstSelectedTax.length; i++){
			if (StrSelectedTax === lstSelectedTax[i].strTaxId) {
				AlreadyAdded='true';
                break;
			}
		}
		if(AlreadyAdded != 'true'){
			
			for(var i = 0; i < lstTaxDetails.length; i++) {
				
				if(StrSelectedTax === lstTaxDetails[i].strTaxId){
					//alert(StrSelectedTax+'...length......'+lstTaxDetails[i].strTaxId);
					lstSelectedTax.push({
						strTaxId: lstTaxDetails[i].strTaxId,
						strTaxName: lstTaxDetails[i].strTaxName,
						TaxPercentage: lstTaxDetails[i].TaxPercentage,
						//decTaxAmount: TotalAmount*lstTaxDetails[i].TaxPercentage/100,
						decTaxAmount: TotalAmount,
						GST: lstTaxDetails[i].GST,
						CGST: lstTaxDetails[i].CGST,
						SGST: lstTaxDetails[i].SGST,
						IGST: lstTaxDetails[i].IGST,
						NetAmount: Number(TotalAmount)*lstTaxDetails[i].TaxPercentage/100
					});	 
				}
			}
		}else{
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
        component.set('v.lstSelectedTax', lstSelectedTax);
		
		var lstTotalSelectedTax = component.get("v.lstSelectedTax");
		var TotalTaxAmount = 0;
		for(var i = 0; i < lstTotalSelectedTax.length; i++) {
			TotalTaxAmount =Number(TotalTaxAmount)+Number(lstTotalSelectedTax[i].decTaxAmount);
		}
		component.set('v.TotalTax', TotalTaxAmount);
	},
    
     
    
	CalculateAmount : function(component,event,helper){
		var target = event.getSource();
        var rowIndex = event.getSource().get("v.name");
        var tmpMainWrapper = component.get("v.lstSelectedTax");
		var strDeliveryType = component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c");
        var totaltax =0;
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].decTaxAmount != null && tmpMainWrapper[i].decTaxAmount != null){
					var NetAmounts = Number(tmpMainWrapper[i].decTaxAmount);
					var IntDiscountRate = event.getSource().get("v.value");
					tmpMainWrapper[i].decTaxAmount = IntDiscountRate;
					NetAmounts = NetAmounts+(IntDiscountRate*tmpMainWrapper[i].GST / 100);
					tmpMainWrapper[i].NetAmount = NetAmounts;
					component.set("v.lstSelectedTax",tmpMainWrapper);
				}						
			}else{
				component.set("v.lstSelectedTax",tmpMainWrapper);
			}
            totaltax =totaltax+tmpMainWrapper[i].NetAmount;
		}
        component.set("v.TotalTax",totaltax);
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
    
	CalculateGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.lstSelectedTax");
		var strDeliveryType = component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c");
        var totaltax =0;
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].decTaxAmount != null && tmpMainWrapper[i].decTaxAmount != null){
					var NetAmounts = Number(tmpMainWrapper[i].decTaxAmount);
					var IntDiscountRate = event.target.value;
					tmpMainWrapper[i].GST = IntDiscountRate;
					NetAmounts = NetAmounts+(tmpMainWrapper[i].decTaxAmount*IntDiscountRate / 100);
					tmpMainWrapper[i].NetAmount = NetAmounts;
					component.set("v.lstSelectedTax",tmpMainWrapper);
				}						
			}else{
				component.set("v.lstSelectedTax",tmpMainWrapper);
			}
		    totaltax =totaltax+tmpMainWrapper[i].NetAmount;
		}
        component.set("v.TotalTax",totaltax);
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
	CalculateCGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.lstSelectedTax");
		var strDeliveryType = component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].CGST != null && tmpMainWrapper[i].CGST != null){
					var NetAmounts = Number(tmpMainWrapper[i].decTaxAmount);
					var IntDiscountRate = event.target.value;
					tmpMainWrapper[i].CGST = IntDiscountRate;
					var CGST = tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100;
					//alert(NetAmounts+'......'+CGST+'!@#'+(NetAmounts+Number(CGST)));
					NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100);
					if(tmpMainWrapper[i].SGST !=0)
						NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].SGST / 100);
					
					if(tmpMainWrapper[i].IGST !=0)
						NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].IGST / 100);
					
					tmpMainWrapper[i].NetAmount = NetAmounts;
					component.set("v.lstSelectedTax",tmpMainWrapper);
				}						
			}else{
				component.set("v.lstSelectedTax",tmpMainWrapper);
			}
		}
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
	
	CalculateSGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.lstSelectedTax");
		var strDeliveryType = component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				
				if(strDeliveryType !='Import'){
					if(tmpMainWrapper[i].SGST != null && tmpMainWrapper[i].SGST != null){
						var NetAmounts = Number(tmpMainWrapper[i].decTaxAmount);
						var IntDiscountRate = event.target.value;
						//alert('...'+IntDiscountRate);
						tmpMainWrapper[i].SGST = IntDiscountRate;
						NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100);
						if(tmpMainWrapper[i].CGST !=null && tmpMainWrapper[i].CGST !='')
							NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].CGST / 100);
						
						if(tmpMainWrapper[i].IGST !=null && tmpMainWrapper[i].IGST !='')
							NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].IGST / 100);
						
						tmpMainWrapper[i].NetAmount = NetAmounts;
						component.set("v.lstSelectedTax",tmpMainWrapper);
					}
				}				
			}else{
				component.set("v.lstSelectedTax",tmpMainWrapper);
			}
		}
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
	
	
	CalculateIGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.lstSelectedTax");
		var strDeliveryType = component.get("v.mainWrap.objMRN.MRN_Delivery_Type__c");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(strDeliveryType !='Import'){
					
					if(tmpMainWrapper[i].IGST != null && tmpMainWrapper[i].IGST != null){
						var NetAmounts = Number(tmpMainWrapper[i].decTaxAmount);
						var IntDiscountRate = event.target.value;
						tmpMainWrapper[i].IGST = IntDiscountRate;
						NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100);
						if(tmpMainWrapper[i].CGST !=null && tmpMainWrapper[i].CGST !='')
							NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].CGST / 100);
						
						if(tmpMainWrapper[i].SGST !=null && tmpMainWrapper[i].SGST !='')
							NetAmounts = NetAmounts+ (tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].SGST / 100);
						
						tmpMainWrapper[i].NetAmount = NetAmounts;
						component.set("v.lstSelectedTax",tmpMainWrapper);
					} 
				}
			}else{
				component.set("v.lstSelectedTax",tmpMainWrapper);
			}
		}
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
	
	CalculateMRNQty : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].ObjMRNLI != null && tmpMainWrapper[i].ObjMRNLI.Sales_Price__c != null){
					var IntBillQty = event.target.value;
					var Amount = IntBillQty * tmpMainWrapper[i].ObjMRNLI.Sales_Price__c;
					tmpMainWrapper[i].ObjMRNLI.Received_QTY__c = IntBillQty;
					tmpMainWrapper[i].ObjMRNLI.Total_Amount__c = Amount;
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c ==null || tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c == '')
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
					
					if(tmpMainWrapper[i].ObjMRNLI.Discount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount__c !='' && tmpMainWrapper[i].ObjMRNLI.Discount__c != 0)
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c = Amount*tmpMainWrapper[i].ObjMRNLI.Discount__c/100;
					
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null !='' && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != 0)
						tmpMainWrapper[i].ObjMRNLI.Discount__c = tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c /Amount*100;
					
					var TaxableAmount =0;
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c !=null){
						TaxableAmount = Amount - tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c;
					}else{
						TaxableAmount = Amount;
					}
					tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c = TaxableAmount;
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].ObjMRNLI.CGST__c !=null){
						IntCGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.CGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.SGST__c !=null){
						IntSGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.SGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.IGST__c !=null){
						IntIGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.IGST__c /100;
					}
					tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
					component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
                } 
			}else{
				component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
    },
	
	
	CalculateMRNRate : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].ObjMRNLI != null && tmpMainWrapper[i].ObjMRNLI.Received_QTY__c != null){
					var IntBillQty = event.target.value;
					var Amount = IntBillQty * tmpMainWrapper[i].ObjMRNLI.Received_QTY__c;
					tmpMainWrapper[i].ObjMRNLI.Sales_Price__c = IntBillQty;
					tmpMainWrapper[i].ObjMRNLI.Total_Amount__c = Amount;
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c ==null || tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c == '')
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
					
					if(tmpMainWrapper[i].ObjMRNLI.Discount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount__c !='' && tmpMainWrapper[i].ObjMRNLI.Discount__c != 0)
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c = Amount*tmpMainWrapper[i].ObjMRNLI.Discount__c/100;
					
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null !='' && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != 0)
						tmpMainWrapper[i].ObjMRNLI.Discount__c = tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c /Amount*100;
					
					var TaxableAmount =0;
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c !=null){
						TaxableAmount = Amount - tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c;
					}else{
						TaxableAmount = Amount;
					}
					tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c = TaxableAmount;
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].ObjMRNLI.CGST__c !=null){
						IntCGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.CGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.SGST__c !=null){
						IntSGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.SGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.IGST__c !=null){
						IntIGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.IGST__c /100;
					}
					tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
					component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
                } 
			}else{
				component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
    },
	
	
	CalculateMRNDisRate : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
		var IsdiscountCheckbox =  component.get('v.Isdiscount');
		//alert(rowIndex+'...IsdiscountCheckbox'+IsdiscountCheckbox);
		if(IsdiscountCheckbox==true)
		{
			if(rowIndex == 0){
				var IntBillQty = event.target.value;
				tmpMainWrapper[0].ObjMRNLI.Discount__c = IntBillQty;
				if(tmpMainWrapper[0].ObjMRNLI.Discount__c != null && tmpMainWrapper[0].ObjMRNLI.Discount__c != ''){
					for(var i=0;i<tmpMainWrapper.length;i++)
					{			
						tmpMainWrapper[i].ObjMRNLI.Discount__c = tmpMainWrapper[0].ObjMRNLI.Discount__c;
						var Amount = tmpMainWrapper[i].ObjMRNLI.Total_Amount__c;
						
						tmpMainWrapper[i].ObjMRNLI.Total_Amount__c = Amount;
						if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c ==null || tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c == '')
							tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
						
						if(tmpMainWrapper[i].ObjMRNLI.Discount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount__c !='' && tmpMainWrapper[i].ObjMRNLI.Discount__c != 0)
							tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c = Amount*tmpMainWrapper[i].ObjMRNLI.Discount__c/100;
						
						if(tmpMainWrapper[i].ObjMRNLI.Discount__c == 0){
							tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
						}else{
							if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null !='' && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != 0)
								tmpMainWrapper[i].ObjMRNLI.Discount__c = tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c /Amount*100;
						}
						
						var TaxableAmount =0;
						if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c !=null){
							TaxableAmount = Amount - tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c;
						}else{
							TaxableAmount = Amount;
						}
						tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c = TaxableAmount;
						var IntCGST =0;
						var IntSGST =0;
						var IntIGST =0;
						if(tmpMainWrapper[i].ObjMRNLI.CGST__c !=null){
							IntCGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.CGST__c /100;
						}if(tmpMainWrapper[i].ObjMRNLI.SGST__c !=null){
							IntSGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.SGST__c /100;
						}if(tmpMainWrapper[i].ObjMRNLI.IGST__c !=null){
							IntIGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.IGST__c /100;
						}
						tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
						component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
						 
					}
				}else{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"type":"error",
						"title": "Error!",
						"message": "Please input discount rate."
					});
					toastEvent.fire();
				}
			}else{
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type":"error",
					"title": "Error!",
					"message": "Please change the first-row discount rate."
				});
				toastEvent.fire();
			}
		}else{
			for(var i=0;i<tmpMainWrapper.length;i++)
			{
				if(rowIndex == i){
					if(tmpMainWrapper[i].ObjMRNLI != null && tmpMainWrapper[i].ObjMRNLI.Received_QTY__c != null){
						var IntBillQty = event.target.value;
						tmpMainWrapper[i].ObjMRNLI.Discount__c = IntBillQty;
						//alert('..IntBillQty..'+IntBillQty);
						var Amount = tmpMainWrapper[i].ObjMRNLI.Total_Amount__c;
						
						tmpMainWrapper[i].ObjMRNLI.Total_Amount__c = Amount;
						if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c ==null || tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c == '')
							tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
						
						if(tmpMainWrapper[i].ObjMRNLI.Discount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount__c !='' && tmpMainWrapper[i].ObjMRNLI.Discount__c != 0)
							tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c = Amount*tmpMainWrapper[i].ObjMRNLI.Discount__c/100;
						
						if(tmpMainWrapper[i].ObjMRNLI.Discount__c == 0){
							tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
						}else{
							if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null !='' && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != 0)
								tmpMainWrapper[i].ObjMRNLI.Discount__c = tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c /Amount*100;
						}
						
						var TaxableAmount =0;
						if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c !=null){
							TaxableAmount = Amount - tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c;
						}else{
							TaxableAmount = Amount;
						}
						tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c = TaxableAmount;
						var IntCGST =0;
						var IntSGST =0;
						var IntIGST =0;
						if(tmpMainWrapper[i].ObjMRNLI.CGST__c !=null){
							IntCGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.CGST__c /100;
						}if(tmpMainWrapper[i].ObjMRNLI.SGST__c !=null){
							IntSGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.SGST__c /100;
						}if(tmpMainWrapper[i].ObjMRNLI.IGST__c !=null){
							IntIGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.IGST__c /100;
						}
						tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
						component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
					} 
				}else{
					component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
				}
			}
			component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
		}
    },
	
	discountactionCheckbox : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
		var isdiscount =  component.get('v.Isdiscount');
        if(isdiscount==true){
			if(tmpMainWrapper[0].ObjMRNLI.Discount__c != null && tmpMainWrapper[0].ObjMRNLI.Discount__c != ''){
				for(var i=0;i<tmpMainWrapper.length;i++)
				{			
					tmpMainWrapper[i].ObjMRNLI.Discount__c = tmpMainWrapper[0].ObjMRNLI.Discount__c;
					var Amount = tmpMainWrapper[i].ObjMRNLI.Total_Amount__c;
					
					tmpMainWrapper[i].ObjMRNLI.Total_Amount__c = Amount;
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c ==null || tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c == '')
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
					
					if(tmpMainWrapper[i].ObjMRNLI.Discount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount__c !='' && tmpMainWrapper[i].ObjMRNLI.Discount__c != 0)
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c = Amount*tmpMainWrapper[i].ObjMRNLI.Discount__c/100;
					
					if(tmpMainWrapper[i].ObjMRNLI.Discount__c == 0){
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
					}else{
						if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null !='' && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != 0)
							tmpMainWrapper[i].ObjMRNLI.Discount__c = tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c /Amount*100;
					}
					
					var TaxableAmount =0;
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c !=null){
						TaxableAmount = Amount - tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c;
					}else{
						TaxableAmount = Amount;
					}
					tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c = TaxableAmount;
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].ObjMRNLI.CGST__c !=null){
						IntCGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.CGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.SGST__c !=null){
						IntSGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.SGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.IGST__c !=null){
						IntIGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.IGST__c /100;
					}
					tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
					component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
					 
				}
			}else{
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type":"error",
					"title": "Error!",
					"message": "Please input discount rate."
				});
				toastEvent.fire();
			}
		}
    },
	
	
	CalculateMRNDisAmount : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].ObjMRNLI != null && tmpMainWrapper[i].ObjMRNLI.Total_Amount__c != null){
					var IntBillQty = event.target.value;
					var Amount = tmpMainWrapper[i].ObjMRNLI.Total_Amount__c;
					tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c = IntBillQty;
					tmpMainWrapper[i].ObjMRNLI.Total_Amount__c = Amount;
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c ==null || tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c == '')
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c =0;
					
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != null !='' && tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c != 0)
						tmpMainWrapper[i].ObjMRNLI.Discount__c = tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c /Amount*100;
					
					if(tmpMainWrapper[i].ObjMRNLI.Discount__c != null && tmpMainWrapper[i].ObjMRNLI.Discount__c !='' && tmpMainWrapper[i].ObjMRNLI.Discount__c != 0)
						tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c = Amount*tmpMainWrapper[i].ObjMRNLI.Discount__c/100;
					
					
					
					var TaxableAmount =0;
					if(tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c !=null){
						TaxableAmount = Amount - tmpMainWrapper[i].ObjMRNLI.Discount_Amount__c;
					}else{
						TaxableAmount = Amount;
					}
					tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c = TaxableAmount;
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					if(tmpMainWrapper[i].ObjMRNLI.CGST__c !=null){
						IntCGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.CGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.SGST__c !=null){
						IntSGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.SGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.IGST__c !=null){
						IntIGST = TaxableAmount * tmpMainWrapper[i].ObjMRNLI.IGST__c /100;
					}
					tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = TaxableAmount+IntCGST+IntSGST+IntIGST;
					component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
                } 
			}else{
				component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
    },
	
	
	CalculateMRNCGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].ObjMRNLI != null){
					var IntGST = event.target.value;
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					tmpMainWrapper[i].ObjMRNLI.CGST__c = IntGST;
					if(IntGST !=null){
						IntCGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * IntGST /100;
					}if(tmpMainWrapper[i].ObjMRNLI.SGST__c !=null){
						IntSGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * tmpMainWrapper[i].ObjMRNLI.SGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.IGST__c !=null){
						IntIGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * tmpMainWrapper[i].ObjMRNLI.IGST__c /100;
					}
					tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c+IntCGST+IntSGST+IntIGST;
					component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
                } 
			}else{
				component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
    },
	
	CalculateMRNSGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].ObjMRNLI != null && tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c != null){
					var IntGST = event.target.value;
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					tmpMainWrapper[i].ObjMRNLI.SGST__c = IntGST;
					if(tmpMainWrapper[i].ObjMRNLI.CGST__c !=null){
						IntCGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * tmpMainWrapper[i].ObjMRNLI.CGST__c /100;
					}if(IntGST !=null){
						IntSGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * IntGST /100;
					}if(tmpMainWrapper[i].ObjMRNLI.IGST__c !=null){
						IntIGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * tmpMainWrapper[i].ObjMRNLI.IGST__c /100;
					}
					tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c+IntCGST+IntSGST+IntIGST;
					component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
                } 
			}else{
				component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
    },
	
	CalculateMRNIGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.mainWrap.lstMRNLineItems");
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].ObjMRNLI != null && tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c != null){
					var IntGST = event.target.value;
					var IntCGST =0;
					var IntSGST =0;
					var IntIGST =0;
					tmpMainWrapper[i].ObjMRNLI.IGST__c = IntGST;
					if(tmpMainWrapper[i].ObjMRNLI.CGST__c !=null){
						IntCGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * tmpMainWrapper[i].ObjMRNLI.CGST__c /100;
					}if(tmpMainWrapper[i].ObjMRNLI.SGST__c !=null){
						IntSGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * tmpMainWrapper[i].ObjMRNLI.SGST__c /100;
					}if(IntGST !=null){
						IntIGST = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c * IntGST /100;
					}
					tmpMainWrapper[i].ObjMRNLI.Net_Amount_Formula__c = tmpMainWrapper[i].ObjMRNLI.Taxable_Amount_Formula__c+IntCGST+IntSGST+IntIGST;
					component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
                } 
			}else{
				component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
			}
		}
        component.set("v.mainWrap.lstMRNLineItems",tmpMainWrapper);
    },
	
	RemoveRow : function(component,event,helper){
        var tmpWrapper = [];
        var tmpDeletedId = [];
        var tmpMainWrapper = component.get("v.lstSelectedTax");
        var RecordIndexStr = event.getSource().get("v.value");
        var TotalTax = component.get("v.TotalTax");
        
        //var removeIndex=parseInt(RecordIndexStr);
        var countint=0;
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
			//alert(RecordIndexStr+'.....'+removeIndex+'.....'+tmpMainWrapper[i].strTaxId);
            if(RecordIndexStr == countint){
                TotalTax =TotalTax-tmpMainWrapper[i].NetAmount;
				tmpDeletedId.push(tmpMainWrapper[i]);
            }else{
                
                tmpWrapper.push(tmpMainWrapper[i]);
            } 
            countint++;
        }
		component.set("v.TotalTax",TotalTax);
		component.set("v.lstSelectedTax",tmpWrapper);
    },
	
	onRemovePill:function(component,event,helper){
        var pillId = event.getParam('item').id;
        var myJSON = JSON.stringify(pillId);
        var pills = component.get('v.itemsPurchaseOrderLI');
        //alert(pillId);
        for (var i = 0; i < pills.length; i++) {
           
            if (pillId === pills[i].id) {
                pills.splice(i, 1);
                break;
           }
        }
		component.set('v.itemsPurchaseOrderLI', pills);
		var strPurchaseOrderId ='';
		var lstPurchaseOrderId = component.get('v.itemsPurchaseOrderLI');
		for (var i = 0; i < lstPurchaseOrderId.length; i++) {
			if(strPurchaseOrderId !=null && strPurchaseOrderId !='')
				strPurchaseOrderId = strPurchaseOrderId+','+pills[i].id;
			else
				strPurchaseOrderId = pills[i].id;
		}
		component.set('v.mainWrap.itemsPurchaseOrderLI', component.get('v.itemsPurchaseOrderLI'));
		helper.searchPurchaseOrderLineItems(component,event,strPurchaseOrderId);
    },
	
    submitJS : function(component,event,helper){
		helper.CreateMRN(component, event);
	},
	Cancel : function(component,event,helper){
		var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
			 'url': '/lightning/o/MRN__c/list?filterName=Recent'
		});
		urlEvent.fire();
	},
	onCheck : function(component,event,helper){
		var IsTrue = component.get('v.Isdisabled');
		if(IsTrue){
			component.set('v.Isdisabled',true);
		}else{
			component.set('v.Isdisabled',false);
		}
	},
	addRow : function(component, event, helper){
       // var DeliveryNoteLIWrap = component.get("v.mainWrap.lstDeliveryNoteLIWrap");
        //var RecordIndexStr = event.getSource().get("v.value");
        //var Index=parseInt(RecordIndexStr);
        //helper.checkError(component, event, PIIWrapper, RecordIndexStr)
        //if(!component.get('v.Error')){
            //DeliveryNoteLIWrap[RecordIndexStr].isEdit = false;
           // alert('1st');
            helper.addRowHelper(component, event);
        //}
    },
})