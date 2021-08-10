({
    pageLoadClassMethod : function(component, event, id) {
        var action = component.get('c.productOnLoad');
        action.setParams({
            "RecordId" : id
        });  
		action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                if(JSON.parse(res.getReturnValue()).closed){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "This Invoice Already Approved."
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                if(JSON.parse(res.getReturnValue()).statecode){            
                    if(JSON.parse(res.getReturnValue()).isSelectedProduct){
                        component.set("v.lstSelectedTax",JSON.parse(res.getReturnValue()).lstTaxDetailsAvailable);
                        this.refreshCharge(component,event,helper);
                        this.totalamount(component,event,helper);
                        component.set('v.showPicklist',true);
                        
                    }else{
                        component.set("v.lstSelectedTax",JSON.parse(res.getReturnValue()).lstTaxDetailsAvailable);
                        this.refreshCharge(component,event,helper);
                        this.totalamount(component,event,helper);
                        component.set('v.showPicklist',false);
                        component.set("v.IsselectProduct",true);
                    }
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Please add Billing State Code on the Account And Sales from on the Sales Order before adding parts."
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                    
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
    AddRecord : function(component, event, objWrap) {
        var action = component.get('c.addRecord');
        action.setParams({
            "strWrap" : JSON.stringify(objWrap)
        });
		action.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success ) {
              component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                component.set("v.IsselectProduct",false);
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
	
	AddRecordOnCheck : function(component, event, objWrap) {
        var action = component.get('c.addRecord');
        action.setParams({
            "strWrap" : JSON.stringify(objWrap)
        });
		action.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success ) {
                console.log('run');
              component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                this.refreshCharge(component,event,helper);
                component.set("v.IsselectProduct",true);
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
    
    
	RemoveRecordOnCheck : function(component, event, objWrap, prodwrapper) {
        var action = component.get('c.removeRecord');
        
        action.setParams({
            
            "strWrap" : JSON.stringify(objWrap),
            "prodwrappstr" : JSON.stringify(prodwrapper)
        });
		action.setCallback(this, function(res) {
            
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success ) {
                   
              component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                this.refreshCharge(component,event,helper);
                component.set("v.IsselectProduct",true);
               
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
    
    SaveHelper: function(component, event, id) {
        console.log('helper run');
        var objWrap = component.get("v.wrapMain");
        var action = component.get("c.saveRecord");
        action.setParams({
            "strWrap" : JSON.stringify(objWrap),
            "RecordId" : id,
            "lstCharges" : JSON.stringify(component.get("v.lstSelectedTax")),
            "decTotalAmount" : component.get("v.decTotalAmount"),
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success){
                component.set('v.wrapMain.success', true);
                component.set('v.wrapMain.strMessage', JSON.parse(res.getReturnValue()).strMessage);
                console.log(res.getState());
                window.location.assign('/lightning/r/Invoice__c/'+component.get("v.recordId")+'/view');
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    onSelectChangeHelper : function(component, event, strPriceBookId) {
        var objWrap = component.get("v.wrapMain");
        var action = component.get("c.onselectPick");
        action.setParams({
            "strPriceBookId" : strPriceBookId,
            "strWrap" : JSON.stringify(objWrap),
            
        });
        
		action.setCallback(this, function(res) {
            if(res.getState() === "SUCCESS" && JSON.parse(res.getReturnValue()).success ) {
				component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                component.set("v.showPicklist",false);
                component.set("v.IsselectProduct",true);
                
            }else if(res.getState() === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set("v.wrapMain.strMessage",errors[0].message);
                    }
                } else {
					component.set("v.wrapMain.strMessage","Unknown error");
                }
            }else if (!JSON.parse(res.getReturnValue()).success) {
				component.set("v.wrapMain.strMessage",JSON.parse(res.getReturnValue()).errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
    
    totalamount: function(component,event,helper){
        
        var TotalAmount =0;
        
        var lstSalesReturn = component.get('v.wrapMain.lstWrappTwo');
        console.log(component.get('v.wrapMain.lstWrappTwo[0].TotalAfterDiscount'));
        console.log(lstSalesReturn);
        for(var i = 0; i < lstSalesReturn.length; i++) {
            if(lstSalesReturn[i].TotalAfterDiscount !=null && lstSalesReturn[i].TotalAfterDiscount !='')
                TotalAmount = TotalAmount+lstSalesReturn[i].TotalAfterDiscount;
            component.set("v.decTotalAmount",TotalAmount);
        }
        
    },
    refreshCharge: function(component,event,helper){
        
        var TotalAmount =0;
        
        var lstSalesReturn = component.get('v.wrapMain.lstWrappTwo');
        console.log(component.get('v.wrapMain.lstWrappTwo[0].TotalAfterDiscount'));
        console.log(lstSalesReturn);
        for(var i = 0; i < lstSalesReturn.length; i++) {
            if(lstSalesReturn[i].TotalAfterDiscount !=null && lstSalesReturn[i].TotalAfterDiscount !='')
                TotalAmount = TotalAmount+lstSalesReturn[i].TotalAfterDiscount;
            
            component.set("v.decTotalAmount",TotalAmount);
        }
        var TotalAmount = component.get("v.decTotalAmount");
        //alert('..TotalAmount...'+TotalAmount);
        var StrSelectedTax = component.get("v.strTaxType");
        var lstTaxDetails = component.get("v.wrapMain.lstTaxDetails");
        var lstSelectedTax = component.get("v.lstSelectedTax");
        var lstSelectedTaxRefresh = [];
        var AlreadyAdded='';
        
        for(var i = 0; i < lstSelectedTax.length; i++) {
            console.log(lstTaxDetails[i].objcharge);
            lstSelectedTaxRefresh.push({
                 strTaxId: lstSelectedTax[i].strTaxId,
                strTaxName: lstSelectedTax[i].strTaxName,
                TaxPercentage: lstSelectedTax[i].TaxPercentage,
                decTaxAmount: lstSelectedTax[i].decTaxAmount,
                CGST: lstSelectedTax[i].CGST,
                SGST: lstSelectedTax[i].SGST,
                IGST: lstSelectedTax[i].IGST,
                NetAmount: lstSelectedTax[i].NetAmount,
                ischargeItem:lstSelectedTax[i].ischargeItem,
                objcharge:lstSelectedTax[i].objcharge,
                
            });	
        }		
        component.set('v.lstSelectedTax', lstSelectedTaxRefresh);	
        var lstTotalSelectedTax = component.get("v.lstSelectedTax");
        var TotalTaxAmount = 0;
        //alert('...!@#..'+lstTotalSelectedTax.length);
        for(var i = 0; i < lstTotalSelectedTax.length; i++) {
            //alert('...'+lstTotalSelectedTax[i].decTaxAmount);
            TotalTaxAmount =TotalTaxAmount+lstTotalSelectedTax[i].NetAmount;
        }
        component.set('v.TotalTax', TotalTaxAmount);
    },	
    
    
    deliverydateactionhelper : function(component, event, helper) {
         var tmpMainWrapper =  component.get('v.wrapMain.lstWrappTwo');
        var isdeliverydate =  component.get('v.isdeliverydate');
        var index =  event.getSource().get("v.name");
        console.log(isdeliverydate);
        if(isdeliverydate==true){
            if(index==0){
                if(tmpMainWrapper.length>=2 ){
                    for(var i=1;i<tmpMainWrapper.length;i++){
                            tmpMainWrapper[i].objProdchild.Expected_Date__c = tmpMainWrapper[0].objProdchild.Expected_Date__c;
                        }  
                }
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": "Same date Selected!! Please change date from first row."
                });
                toastEvent.fire(); 
                for(var i=1;i<tmpMainWrapper.length;i++){
                            tmpMainWrapper[i].objProdchild.Expected_Date__c = tmpMainWrapper[0].objProdchild.Expected_Date__c;
                        } 
            }
        }
        component.set("v.wrapMain.lstWrappTwo",tmpMainWrapper);
        
    },
    
     deliverydateactionrefresh : function(component, event, helper) {
         var tmpMainWrapper =  component.get('v.wrapMain.lstWrappTwo');
        var isdeliverydate =  component.get('v.isdeliverydate');
        var index =  event.getSource().get("v.name");
        console.log(isdeliverydate);
        if(isdeliverydate==true){
            if(index==0){
                if(tmpMainWrapper.length>=2 ){
                    for(var i=1;i<tmpMainWrapper.length;i++){
                            tmpMainWrapper[i].objProdchild.Expected_Date__c = tmpMainWrapper[0].objProdchild.Expected_Date__c;
                        }  
                }
            }
            else{
                for(var i=1;i<tmpMainWrapper.length;i++){
                            tmpMainWrapper[i].objProdchild.Expected_Date__c = tmpMainWrapper[0].objProdchild.Expected_Date__c;
                        } 
            }
        }
        component.set("v.wrapMain.lstWrappTwo",tmpMainWrapper);
        
    },
    
    discountactionhelper : function(component, event, helper) {
         var tmpMainWrapper =  component.get('v.wrapMain.lstWrappTwo');
        var isdiscount =  component.get('v.isdiscount');
        var index =  event.getSource().get("v.name");
        console.log(isdiscount);
        if(isdiscount==true){
            if(index==0){
                if(event.getSource().get("v.id") == "discountpercent"){
                    if(event.getSource().get("v.value") < 0){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"error",
                            "title": "Error!",
                            "message": "Value should not be less than 1."
                        });
                        toastEvent.fire();
                    }
                    else{
                        if(tmpMainWrapper.length>=2 ){
                            for(var i=0;i<tmpMainWrapper.length;i++){
                                var child = tmpMainWrapper[i].objProdchild;
                                tmpMainWrapper[i].objProdchild.Discount__c = tmpMainWrapper[0].objProdchild.Discount__c;
                                tmpMainWrapper[i].DiscountAmount =(tmpMainWrapper[i].objProdchild.Discount__c * tmpMainWrapper[i].totalAmount)/100;
                                tmpMainWrapper[i].TotalAfterDiscount = tmpMainWrapper[i].totalAmount - tmpMainWrapper[i].DiscountAmount;
                                tmpMainWrapper[i].CGSTAmount= (child.CGST__c * tmpMainWrapper[i].TotalAfterDiscount)/100;
                                tmpMainWrapper[i].SGSTAmount= (child.SGST__c * tmpMainWrapper[i].TotalAfterDiscount)/100;
                                tmpMainWrapper[i].IGSTAmount= (child.IGST__c * tmpMainWrapper[i].TotalAfterDiscount)/100;
                                tmpMainWrapper[i].NetTotalAmount = tmpMainWrapper[i].TotalAfterDiscount+tmpMainWrapper[i].CGSTAmount+tmpMainWrapper[i].SGSTAmount+tmpMainWrapper[i].IGSTAmount;       
                            }  
                        }
                    }
                }
                else{
                        if(event.getSource().get("v.value") < 0){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"error",
                                "title": "Error!",
                                "message": "Value should not be less than 1."
                            });
                            toastEvent.fire();
                        }
                    else{
                        if(tmpMainWrapper.length>=2 ){
                            for(var i=0;i<tmpMainWrapper.length;i++){
                                var child = tmpMainWrapper[i].objProdchild;
                               
                                tmpMainWrapper[i].DiscountAmount =tmpMainWrapper[0].DiscountAmount;
                                child.Discount__c = (tmpMainWrapper[0].DiscountAmount*100 )/ tmpMainWrapper[i].totalAmount;
                                tmpMainWrapper[i].TotalAfterDiscount = tmpMainWrapper[i].totalAmount - tmpMainWrapper[0].DiscountAmount;
                                tmpMainWrapper[i].CGSTAmount= (child.CGST__c * tmpMainWrapper[i].TotalAfterDiscount)/100;
                                tmpMainWrapper[i].SGSTAmount= (child.SGST__c * tmpMainWrapper[i].TotalAfterDiscount)/100;
                                tmpMainWrapper[i].IGSTAmount= (child.IGST__c * tmpMainWrapper[i].TotalAfterDiscount)/100;
                                tmpMainWrapper[i].NetTotalAmount = tmpMainWrapper[i].TotalAfterDiscount+tmpMainWrapper[i].CGSTAmount+tmpMainWrapper[i].SGSTAmount+tmpMainWrapper[i].IGSTAmount;  
                            }
                        }
                    }
                    }
                
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": "Same Discount Selected!! Please change Discount from first row."
                });
                toastEvent.fire(); 
                for(var i=1;i<tmpMainWrapper.length;i++){
                            tmpMainWrapper[i].objProdchild.Discount__c = tmpMainWrapper[0].objProdchild.Discount__c;
                        } 
            }
        }
        component.set("v.wrapMain.lstWrappTwo",tmpMainWrapper);
        
    },
    
	
})