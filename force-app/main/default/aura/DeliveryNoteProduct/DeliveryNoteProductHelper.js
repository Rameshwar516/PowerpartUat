({
    pageLoadClassMethod : function(component, event, id) {
        var action = component.get('c.productOnLoad');
        action.setParams({
            "RecordId" : id
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                component.set('v.wrapMain', JSON.parse(res.getReturnValue()));
                
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
                        "message": "Please add Billing State Code on the Account before adding parts."
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
                window.location.assign('/lightning/r/Quote__c/'+component.get("v.recordId")+'/view');
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
            "strWrap" : JSON.stringify(objWrap)
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
                decTaxAmount: TotalAmount*lstSelectedTax[i].TaxPercentage/100,
                CGST: lstSelectedTax[i].CGST,
                SGST: lstSelectedTax[i].SGST,
                IGST: lstSelectedTax[i].IGST,
                NetAmount: TotalAmount*lstSelectedTax[i].TaxPercentage/100,
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
            TotalTaxAmount =TotalTaxAmount+lstTotalSelectedTax[i].decTaxAmount;
        }
        component.set('v.TotalTax', TotalTaxAmount);
    },	
    
})