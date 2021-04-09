({
    doinit : function(component, event, helper) {
        var id = component.get("v.recordId");
        helper.pageLoadClassMethod(component, event, id);
    },
    
    
    QuantityPriceChange:function(component, event, helper) {
        var tmpIndex = event.getSource().get("v.name");
        var tmpWrapper = component.get("v.wrapMain.lstWrappTwo");
        for(var i=0;i<tmpWrapper.length;i++)
        {
            if(i == tmpIndex)
            {
                var child = tmpWrapper[i].objProdchild;
                if(event.getSource().get("v.id") == "quantity"){ 
                    tmpWrapper[i].totalAmount = event.getSource().get("v.value") * child.Unit_Price__c;
                    tmpWrapper[i].DiscountAmount =  (child.Discount__c * tmpWrapper[i].totalAmount)/100;
                    tmpWrapper[i].TotalAfterDiscount = tmpWrapper[i].totalAmount - tmpWrapper[i].DiscountAmount;
                    tmpWrapper[i].CGSTAmount= (child.CGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].SGSTAmount= (child.SGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].IGSTAmount= (child.IGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].NetTotalAmount = tmpWrapper[i].TotalAfterDiscount+tmpWrapper[i].CGSTAmount+tmpWrapper[i].SGSTAmount+tmpWrapper[i].IGSTAmount;
                    
                }
                else{
                    tmpWrapper[i].totalAmount = event.getSource().get("v.value") * child.Quantity__c;
                    tmpWrapper[i].DiscountAmount =  (child.Discount__c * tmpWrapper[i].totalAmount)/100;
                    tmpWrapper[i].TotalAfterDiscount = tmpWrapper[i].totalAmount - tmpWrapper[i].DiscountAmount;
                    tmpWrapper[i].CGSTAmount= (child.CGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].SGSTAmount= (child.SGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].IGSTAmount= (child.IGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].NetTotalAmount = tmpWrapper[i].TotalAfterDiscount+tmpWrapper[i].CGSTAmount+tmpWrapper[i].SGSTAmount+tmpWrapper[i].IGSTAmount;       
                }
            }
        }     
        component.set("v.wrapMain.lstWrappTwo", tmpWrapper); 
        helper.totalamount(component,event,helper);
    },
    
    dischange:function(component, event, helper) {
        var tmpIndex = event.getSource().get("v.name");
        var tmpWrapper = component.get("v.wrapMain.lstWrappTwo");
        var isdiscount =  component.get('v.isdiscount');
        var index =  event.getSource().get("v.name");
        if(isdiscount==true){
            helper.discountactionhelper(component, event, helper);
        }
        else{
        for(var i=0;i<tmpWrapper.length;i++)
        {
            if(i == tmpIndex)
            {
                var child = tmpWrapper[i].objProdchild;
                if(event.getSource().get("v.id") == "discountpercent"){  
                    tmpWrapper[i].DiscountAmount = (event.getSource().get("v.value") * tmpWrapper[i].totalAmount)/100;
                    tmpWrapper[i].TotalAfterDiscount = tmpWrapper[i].totalAmount - tmpWrapper[i].DiscountAmount;
                    tmpWrapper[i].CGSTAmount= (child.CGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].SGSTAmount= (child.SGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].IGSTAmount= (child.IGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].NetTotalAmount = tmpWrapper[i].TotalAfterDiscount+tmpWrapper[i].CGSTAmount+tmpWrapper[i].SGSTAmount+tmpWrapper[i].IGSTAmount;  
                }
                else{
                    
                    child.Discount__c = (event.getSource().get("v.value")*100 )/ tmpWrapper[i].totalAmount;
                    tmpWrapper[i].TotalAfterDiscount = tmpWrapper[i].totalAmount - event.getSource().get("v.value");
                    tmpWrapper[i].CGSTAmount= (child.CGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].SGSTAmount= (child.SGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].IGSTAmount= (child.IGST__c * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].NetTotalAmount = tmpWrapper[i].TotalAfterDiscount+tmpWrapper[i].CGSTAmount+tmpWrapper[i].SGSTAmount+tmpWrapper[i].IGSTAmount;  
                }
                
            }
        }   
        }
        component.set("v.wrapMain.lstWrappTwo", tmpWrapper); 
        helper.totalamount(component,event,helper);
    },
    AllGSTChange:function(component, event, helper) {
        console.log('fire');
        var tmpIndex = event.getSource().get("v.name");
        var tmpWrapper = component.get("v.wrapMain.lstWrappTwo");
        for(var i=0;i<tmpWrapper.length;i++)
        {
            if(i == tmpIndex)
            {
                var child = tmpWrapper[i].objProdchild;
                if(event.getSource().get("v.id") == "CGSTPercentage"){
                    tmpWrapper[i].CGSTAmount= (event.getSource().get("v.value") * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].NetTotalAmount = tmpWrapper[i].TotalAfterDiscount+tmpWrapper[i].CGSTAmount+tmpWrapper[i].SGSTAmount+tmpWrapper[i].IGSTAmount;
                }
                else if(event.getSource().get("v.id") == "SGSTPercentage"){
                    tmpWrapper[i].SGSTAmount= (event.getSource().get("v.value") * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].NetTotalAmount = tmpWrapper[i].TotalAfterDiscount+tmpWrapper[i].CGSTAmount+tmpWrapper[i].SGSTAmount+tmpWrapper[i].IGSTAmount;
                }
                else if(event.getSource().get("v.id") == "IGSTPercentage"){
                    tmpWrapper[i].IGSTAmount= (event.getSource().get("v.value") * tmpWrapper[i].TotalAfterDiscount)/100;
                    tmpWrapper[i].NetTotalAmount = tmpWrapper[i].TotalAfterDiscount+tmpWrapper[i].CGSTAmount+tmpWrapper[i].SGSTAmount+tmpWrapper[i].IGSTAmount;
                }
                else{
                }
            }
        }     
        component.set("v.wrapMain.lstWrappTwo", tmpWrapper);  
    },
    nextJs :function(component, event, helper) {
        var tmpWrapper = [];
        var tmpMainWrapper = component.get("v.wrapMain.lstWrappTwo");
        var Istrue = false; 
        console.log("length  "+tmpMainWrapper.length);
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(tmpMainWrapper[i].isSelected){
                Istrue = true;
            }
        }
        console.log(Istrue);
        console.log(tmpMainWrapper.length);
        console.log(tmpMainWrapper);
        
        if(Istrue == true ){
            component.set("v.showSection",  true);
            component.set("v.IsselectProduct", false);
            
        }else{
            var msg = $A.get("$Label.c.Product_Selection");
            component.set("v.wrapMain.strMessage", msg);
            component.set("v.wrapMain.success", false);
        }
        
    },
    
    checkJs :function(component, event, helper) {
        var tmpWrapper = [];
        var index = event.getSource().get('v.name');
        var tmpMainWrapper = component.get("v.wrapMain.lstWrapp");
        var Istrue = false; 
        
            if(tmpMainWrapper[index].isSelected){
                Istrue = true;
            }
       
        if(Istrue){
            console.log('Check true '+tmpMainWrapper[index].isSelected);
            component.set('v.IsselectProduct',true);
            component.set("v.showSection",  false);
            var objWrap = component.get("v.wrapMain");
            helper.AddRecordOnCheck(component, event, objWrap);
        }
        else if(!Istrue)
        {
            console.log('Check false '+tmpMainWrapper[index].isSelected);
             var prodwrapper =  tmpMainWrapper[index];
            var objWrap = component.get("v.wrapMain");
            console.log('Check false '+tmpMainWrapper[index]);
             helper.RemoveRecordOnCheck(component, event, objWrap ,prodwrapper);
        }
        else if(tmpMainWrapper.length = 0)
        {
             console.log('Check tmpMainWrapper.length '+tmpMainWrapper[index].isSelected);
            var msg = $A.get("$Label.c.Product_Selection");
            component.set("v.wrapMain.strMessage", msg);
            component.set("v.wrapMain.success", false);
        }
        
        
    },
     removeselectedpart :function(component, event, helper) {
        var index = event.getSource().get('v.value');
        var tmpMainWrapper = component.get("v.wrapMain.lstWrapp");
        var prodwrapper =  tmpMainWrapper[index];
        var objWrap = component.get("v.wrapMain");
        console.log('Check false '+tmpMainWrapper[index]);
        helper.RemoveRecordOnCheck(component, event, objWrap ,prodwrapper); 
    },
    
    Productselect :function(component, event, helper) {
        var tmpWrapper = [];
        var tmpMainWrapper = component.get("v.wrapMain.lstWrapp");
        
        var Istrue = false; 
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(tmpMainWrapper[i].isSelected){
                Istrue = true;
            }
        }
        if(Istrue){
            component.set("v.showSection",  true);
            var objWrap = component.get("v.wrapMain");
            helper.AddRecord(component, event, objWrap);
        }else{
            console.log();
            var msg = $A.get("$Label.c.Product_Selection");
            component.set("v.wrapMain.strMessage", msg);
            component.set("v.wrapMain.success", false);
        }
        
    },
    
    cancelJS : function(component, event, helper)
    {
        window.location.assign('/'+component.get("v.relatedrecordId"));
    },
    
    BackJs : function(component, event, helper)
    {
        component.set("v.showSection", !component.get("v.showSection"));
        component.set("v.IsselectProduct",true);
    },
    
    SaveJS : function(component, event, helper)
    {
        var tmpWrapper = [];
        var wrapMain = component.get("v.wrapMain");
        var tmpMainWrapper = component.get("v.wrapMain.lstWrappTwo");
        var tmplstSelectedTax = component.get("v.lstSelectedTax");
        var Istrue = false; 
        var Ischarges = false;
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(tmpMainWrapper[i].objProdchild.Quantity__c ==null ||
               tmpMainWrapper[i].objProdchild.Quantity__c ==''||
               tmpMainWrapper[i].objProdchild.Quantity__c < 1 ||
               tmpMainWrapper[i].objProdchild.Unit_Price__c ==null ||
               tmpMainWrapper[i].objProdchild.Unit_Price__c ==''||
               tmpMainWrapper[i].objProdchild.Unit_Price__c < 1 ||
               tmpMainWrapper[i].objProdchild.Discount__c ==null ||
               tmpMainWrapper[i].objProdchild.Discount__c < 0 ||
               tmpMainWrapper[i].DiscountAmount ==null ||
               tmpMainWrapper[i].DiscountAmount < 0 ||
               tmpMainWrapper[i].objProdchild.CGST__c == null ||
               tmpMainWrapper[i].objProdchild.CGST__c < 0 ||
               tmpMainWrapper[i].objProdchild.SGST__c == null ||
               tmpMainWrapper[i].objProdchild.SGST__c < 0 ||
               tmpMainWrapper[i].objProdchild.IGST__c == null ||
               tmpMainWrapper[i].objProdchild.IGST__c < 0){
                Istrue = true;
            }
        }
        
       if(wrapMain.igstvalue){
            console.log(wrapMain.igstvalue);
            for(var i=0;i<tmplstSelectedTax.length;i++)
            {
                console.log(tmplstSelectedTax[i].IGST);
                if(
                   tmplstSelectedTax[i].IGST == null ||
                    tmplstSelectedTax[i].IGST < 0
                   
                  ){
                    Ischarges = true;
                }
                
            }
        }    
        else{
            for(var i=0;i<tmplstSelectedTax.length;i++)
            {
                console.log(tmplstSelectedTax[i].CGST);
                console.log(tmplstSelectedTax[i].SGST);
                if(tmplstSelectedTax[i].CGST ==null ||
                   tmplstSelectedTax[i].CGST < 0 ||
                   tmplstSelectedTax[i].SGST ==null ||
                   tmplstSelectedTax[i].SGST < 0 
                  ){
                    Ischarges = true;
                }
                
            }  
        }
        console.log(Ischarges);
         if(!Istrue){
            if(!Ischarges){
                console.log('savehelper');
                var id = component.get("v.recordId");
                helper.SaveHelper(component, event, id);
            }else{
                component.set("v.wrapMain.strMessage", 'Please check all value in Charges section !!! Value less than 0 is not valid or Blank not valid.');
                component.set("v.wrapMain.success", false);
            }
            
            
        }else{
            component.set("v.wrapMain.strMessage", 'Please check all value in add parts section!!!  Value less than 0 is not valid or Blank not valid.');
            component.set("v.wrapMain.success", false);
        }
    },
    onSelectChange : function(component, event, helper)
    {
        var strPriceBookId = component.get("v.strPriceBookId");
        helper.onSelectChangeHelper(component, event, strPriceBookId);
    },
    cancel : function(component){
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    hideSpinner : function(component,event,helper){ 
        component.set("v.Spinner", false);
    },
    handleHideErrorDisplayModal : function(component,event, helper) {
        component.set("v.wrapMain.strMessage",'');
    },
    
    findProduct : function(component, event, helper) {
        var queryTxt = component.find('txtField').get('v.value');
         queryTxt =queryTxt.trim();
        if(queryTxt != null && queryTxt != ''){
            var action = component.get('c.getSearchProduct');
            var oldwrapmain = component.get('v.wrapMain');
            var isSelectedProduct = component.get('v.wrapMain.isSelectedProduct');
            if(isSelectedProduct == false){
                action.setParams({
                    'objectName' : 'Part__c',
                    'queryText' : queryTxt,
                    'objwrap': JSON.stringify(oldwrapmain),
                    'recordId': component.get('v.recordId')
                });
            }
            else{
                action.setParams({
                    'objectName' : 'Part__c',
                    'queryText' : queryTxt,
                    'objwrap': JSON.stringify(oldwrapmain),
                    'recordId': component.get('v.recordId')
                });
            }
            action.setCallback(this, function(res){
                var listOfProduct = res.getReturnValue();
                var temprodList = [];
                for(var i=0; i<listOfProduct.length; i++){ 
                    temprodList.push({isSelected: false,objProd:listOfProduct[i]});
                }
                component.set('v.wrapMain.lstWrapp', JSON.parse(res.getReturnValue()).lstWrapp);

                if(listOfProduct != null && listOfProduct != ''){
                    component.set('v.isDisplay', true);
                }
                else{
                    component.set('v.isDisplay', false);
                } 
            });
            $A.enqueueAction(action);
        }
        else{
            component.set('v.isDisplay', false);
        }
    },
    
    selectLookup : function(component, event, helper){
        var val = event.currentTarget.dataset.variablename;
        //alert(val);
        var prodList = component.get('v.DigValue');
        var temprodList = [];
        for(var i=0; i<prodList.length; i++){
            if(prodList[i].objProd.Name === val){
                prodList[i].isSelected = true;
                //alert(prodList[i].isSelected);
            }
            temprodList.push(prodList[i]);
        }
        component.set('v.DigValue', temprodList);
    },
    
    holdList : function(component, event, helper){
        event.stopPropagation();
        component.set('v.resultList', null);
    },
    
    closeAll : function(component, event, helper){
        component.set('v.isDisplay', false);
        component.set('v.resultList', null);
        //alert(component.get('v.isDisplay'));
    },
    
    handleHideErrorDisplayModal2 : function(component, event, helper){
        component.set('v.warning', '');
    },
    
    
    
    selectTaxType: function(component,event,helper){
        
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
        var AlreadyAdded='';
        for(var i = 0; i < lstSelectedTax.length; i++) {
            console.log(lstSelectedTax);
            if (StrSelectedTax === lstSelectedTax[i].strTaxId) {
                console.log(lstSelectedTax[i].strTaxId);
                AlreadyAdded='true';
                break;
            }
        }
        var igstvalue = component.get('v.wrapMain.igstvalue');
        if(AlreadyAdded != 'true'){
            for(var i = 0; i < lstTaxDetails.length; i++) {
                //alert(lstTaxDetails[i].objTax.id+'...'+StrSelectedTax+'....'+lstTaxDetails[i].NetAmount);
                
                
                
                if(StrSelectedTax === lstTaxDetails[i].strTaxId){
                    
                    var NetAmountval=0;
                if(igstvalue){
                    NetAmountval =  (lstTaxDetails[i].IGST * ((TotalAmount*lstTaxDetails[i].TaxPercentage)/100))/100 +((TotalAmount*lstTaxDetails[i].TaxPercentage)/100);
                }
                else{
                    NetAmountval = ((lstTaxDetails[i].CGST + lstTaxDetails[i].SGST)*((TotalAmount*lstTaxDetails[i].TaxPercentage)/100))/100 +((TotalAmount*lstTaxDetails[i].TaxPercentage)/100);
                }
                    lstSelectedTax.push({
                        strTaxId: lstTaxDetails[i].strTaxId,
                        strTaxName: lstTaxDetails[i].strTaxName,
                        TaxPercentage: lstTaxDetails[i].TaxPercentage,
                        decTaxAmount: (TotalAmount*lstTaxDetails[i].TaxPercentage/100).toFixed(2),
                        CGST: lstTaxDetails[i].CGST,
                        SGST: lstTaxDetails[i].SGST,
                        IGST: lstTaxDetails[i].IGST,
                        NetAmount: NetAmountval.toFixed(2), 
                        ischargeItem :false,
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
        //alert('...!@#..'+lstTotalSelectedTax.length);
        for(var i = 0; i < lstTotalSelectedTax.length; i++) {
            //alert('...'+lstTotalSelectedTax[i].decTaxAmount);
            TotalTaxAmount =TotalTaxAmount+parseInt(lstTotalSelectedTax[i].decTaxAmount);
        }
        component.set('v.TotalTax', TotalTaxAmount);
    },
    
    
    RemoveRow : function(component,event,helper){
        console.log("Delete");
        var tmpWrapper = [];
        var tmpDeletedId = [];
        var tmpMainWrapper = component.get("v.lstSelectedTax");
        var RecordIndexStr = event.getSource().get("v.value");
        console.log(tmpMainWrapper[RecordIndexStr].ischargeItem);
        
        if(tmpMainWrapper[RecordIndexStr].ischargeItem == true){
            var action = component.get('c.deltecharges');
            action.setParams({
                "strWrap" : JSON.stringify(tmpMainWrapper[RecordIndexStr])
            });   
            action.setCallback(this, function(res){
                if(res.getState() === "SUCCESS"){
                    tmpMainWrapper.splice(RecordIndexStr,1);
                    component.set("v.lstSelectedTax",tmpMainWrapper);
                    helper.refreshCharge(component,event,helper);
                    helper.totalamount(component,event,helper);
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
        }else{
            tmpMainWrapper.splice(RecordIndexStr,1);
            component.set("v.lstSelectedTax",tmpMainWrapper);
            helper.refreshCharge(component,event,helper);
            helper.totalamount(component,event,helper);
        }
        
    },
    
    Deletelineitem : function(component,event,helper){
        console.log("Deletelineitem");
        var tmpMainWrapper =  component.get('v.wrapMain.lstWrappTwo');
        var RecordIndexStr = event.getSource().get("v.value");
        var action = component.get('c.deleteRecord');
        var lineitem = tmpMainWrapper[RecordIndexStr];
        action.setParams({
            "strWrap" : JSON.stringify(lineitem)
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                console.log(event.getSource().get("v.value"));
                tmpMainWrapper.splice(RecordIndexStr,1);
                component.set("v.wrapMain.lstWrappTwo",tmpMainWrapper);
                helper.refreshCharge(component,event,helper);
                helper.totalamount(component,event,helper);
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
    
	CalculateCGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.lstSelectedTax");
		//alert('.....tmpMainWrapper....'+tmpMainWrapper.length);
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].CGST != null && tmpMainWrapper[i].CGST != null){
					var NetAmounts = tmpMainWrapper[i].decTaxAmount;
					var IntDiscountRate = event.target.value;
					tmpMainWrapper[i].CGST = IntDiscountRate;
					NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100;
					if(tmpMainWrapper[i].SGST !=null && tmpMainWrapper[i].SGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].SGST / 100;
					
					if(tmpMainWrapper[i].IGST !=null && tmpMainWrapper[i].IGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].IGST / 100;
					
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
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].SGST != null && tmpMainWrapper[i].SGST != null){
					var NetAmounts = tmpMainWrapper[i].decTaxAmount;
					var IntDiscountRate = event.target.value;
					tmpMainWrapper[i].SGST = IntDiscountRate;
					NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100;
					if(tmpMainWrapper[i].CGST !=null && tmpMainWrapper[i].CGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].CGST / 100;
					
					if(tmpMainWrapper[i].IGST !=null && tmpMainWrapper[i].IGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].IGST / 100;
					
					tmpMainWrapper[i].NetAmount = NetAmounts;
					component.set("v.lstSelectedTax",tmpMainWrapper);
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
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IGST != null && tmpMainWrapper[i].IGST != null){
					var NetAmounts = tmpMainWrapper[i].decTaxAmount;
					var IntDiscountRate = event.target.value;
					tmpMainWrapper[i].IGST = IntDiscountRate;
					NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100;
					if(tmpMainWrapper[i].CGST !=null && tmpMainWrapper[i].CGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].CGST / 100;
					
					if(tmpMainWrapper[i].SGST !=null && tmpMainWrapper[i].SGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].SGST / 100;
					
					tmpMainWrapper[i].NetAmount = NetAmounts;
					component.set("v.lstSelectedTax",tmpMainWrapper);
                } 
			}else{
				component.set("v.lstSelectedTax",tmpMainWrapper);
			}
		}
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
	
    
    selectTaxType: function(component,event,helper){
        
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
        var AlreadyAdded='';
        for(var i = 0; i < lstSelectedTax.length; i++) {
            console.log(lstSelectedTax);
            if (StrSelectedTax === lstSelectedTax[i].strTaxId) {
                console.log(lstSelectedTax[i].strTaxId);
                AlreadyAdded='true';
                break;
            }
        }
        if(AlreadyAdded != 'true'){
            for(var i = 0; i < lstTaxDetails.length; i++) {
                //alert(lstTaxDetails[i].objTax.id+'...'+StrSelectedTax+'....'+lstTaxDetails[i].NetAmount);
                if(StrSelectedTax === lstTaxDetails[i].strTaxId){
                    lstSelectedTax.push({
                        strTaxId: lstTaxDetails[i].strTaxId,
                        strTaxName: lstTaxDetails[i].strTaxName,
                        TaxPercentage: lstTaxDetails[i].TaxPercentage,
                        decTaxAmount: TotalAmount*lstTaxDetails[i].TaxPercentage/100,
                        CGST: lstTaxDetails[i].CGST,
                        SGST: lstTaxDetails[i].SGST,
                        IGST: lstTaxDetails[i].IGST,
                        NetAmount: TotalAmount*lstTaxDetails[i].TaxPercentage/100, 
                        ischargeItem :false,
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
        //alert('...!@#..'+lstTotalSelectedTax.length);
        for(var i = 0; i < lstTotalSelectedTax.length; i++) {
            //alert('...'+lstTotalSelectedTax[i].decTaxAmount);
            TotalTaxAmount =TotalTaxAmount+lstTotalSelectedTax[i].decTaxAmount;
        }
        component.set('v.TotalTax', TotalTaxAmount);
    },
    
    
    RemoveRow : function(component,event,helper){
        console.log("Delete");
        var tmpWrapper = [];
        var tmpDeletedId = [];
        var tmpMainWrapper = component.get("v.lstSelectedTax");
        var RecordIndexStr = event.getSource().get("v.value");
        console.log(tmpMainWrapper[RecordIndexStr].ischargeItem);
        
        if(tmpMainWrapper[RecordIndexStr].ischargeItem == true){
            var action = component.get('c.deltecharges');
            action.setParams({
                "strWrap" : JSON.stringify(tmpMainWrapper[RecordIndexStr])
            });   
            action.setCallback(this, function(res){
                if(res.getState() === "SUCCESS"){
                    tmpMainWrapper.splice(RecordIndexStr,1);
                    component.set("v.lstSelectedTax",tmpMainWrapper);
                    helper.refreshCharge(component,event,helper);
                    helper.totalamount(component,event,helper);
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
        }else{
            tmpMainWrapper.splice(RecordIndexStr,1);
            component.set("v.lstSelectedTax",tmpMainWrapper);
            helper.refreshCharge(component,event,helper);
            helper.totalamount(component,event,helper);
        }
        
    },
    
    Deletelineitem : function(component,event,helper){
        console.log("Deletelineitem");
        var tmpMainWrapper =  component.get('v.wrapMain.lstWrappTwo');
        var RecordIndexStr = event.getSource().get("v.value");
        var action = component.get('c.deleteRecord');
        var lineitem = tmpMainWrapper[RecordIndexStr];
        action.setParams({
            "strWrap" : JSON.stringify(lineitem)
        });
        
        action.setCallback(this, function(res){
            if(res.getState() === "SUCCESS"){
                console.log(event.getSource().get("v.value"));
                tmpMainWrapper.splice(RecordIndexStr,1);
                component.set("v.wrapMain.lstWrappTwo",tmpMainWrapper);
                helper.refreshCharge(component,event,helper);
                helper.totalamount(component,event,helper);
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
    
	CalculateCGST : function(component,event,helper){
		var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        var tmpMainWrapper = component.get("v.lstSelectedTax");
		//alert('.....tmpMainWrapper....'+tmpMainWrapper.length);
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].CGST != null && tmpMainWrapper[i].CGST != null){
					var NetAmounts = tmpMainWrapper[i].decTaxAmount;
					var IntDiscountRate = event.target.value;
					tmpMainWrapper[i].CGST = IntDiscountRate;
                    NetAmounts = parseInt(NetAmounts) + parseInt(NetAmounts * IntDiscountRate / 100);
					//NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100;
					if(tmpMainWrapper[i].SGST !=null && tmpMainWrapper[i].SGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].SGST / 100;
					
					if(tmpMainWrapper[i].IGST !=null && tmpMainWrapper[i].IGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].IGST / 100;
					
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
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].SGST != null && tmpMainWrapper[i].SGST != null){
					var NetAmounts = tmpMainWrapper[i].decTaxAmount;
					var IntDiscountRate = event.target.value;
					tmpMainWrapper[i].SGST = IntDiscountRate;
                    NetAmounts = parseInt(NetAmounts) + parseInt(NetAmounts * IntDiscountRate / 100);
					//NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100;
					if(tmpMainWrapper[i].CGST !=null && tmpMainWrapper[i].CGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].CGST / 100;
					
					if(tmpMainWrapper[i].IGST !=null && tmpMainWrapper[i].IGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].IGST / 100;
					
					tmpMainWrapper[i].NetAmount = NetAmounts;
					component.set("v.lstSelectedTax",tmpMainWrapper);
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
		for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(rowIndex == i){
				if(tmpMainWrapper[i].IGST != null && tmpMainWrapper[i].IGST != null){
					var NetAmounts = tmpMainWrapper[i].decTaxAmount;
					var IntDiscountRate = event.target.value;
					tmpMainWrapper[i].IGST = IntDiscountRate;
                    NetAmounts = parseInt(NetAmounts) + parseInt(NetAmounts * IntDiscountRate / 100);
					//NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * IntDiscountRate / 100;
					if(tmpMainWrapper[i].CGST !=null && tmpMainWrapper[i].CGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].CGST / 100;
					
					if(tmpMainWrapper[i].SGST !=null && tmpMainWrapper[i].SGST !='')
						NetAmounts = NetAmounts+ tmpMainWrapper[i].decTaxAmount * tmpMainWrapper[i].SGST / 100;
					
					tmpMainWrapper[i].NetAmount = NetAmounts;
					component.set("v.lstSelectedTax",tmpMainWrapper);
                } 
			}else{
				component.set("v.lstSelectedTax",tmpMainWrapper);
			}
		}
        component.set("v.lstSelectedTax",tmpMainWrapper);
    },
	
    
    deliverydateactionCheckbox : function(component, event, helper) {
        var tmpMainWrapper =  component.get('v.wrapMain.lstWrappTwo');
        var isdeliverydate =  component.get('v.isdeliverydate');
        if(isdeliverydate==true){
        if(tmpMainWrapper.length>=2){
            console.log(tmpMainWrapper[0].objProdchild.Expected_Date__c);
            if(tmpMainWrapper[0].objProdchild.Expected_Date__c != null && tmpMainWrapper[0].objProdchild.Expected_Date__c != ' '){
                for(var i=1;i<tmpMainWrapper.length;i++){
                    tmpMainWrapper[i].objProdchild.Expected_Date__c = tmpMainWrapper[0].objProdchild.Expected_Date__c;
                } 
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": "Delivery date at first part have to be filled."
                });
                toastEvent.fire();
            }
        }
        }
        component.set("v.wrapMain.lstWrappTwo",tmpMainWrapper);
    },
    
    deliverydateaction : function(component, event, helper) {
        helper.deliverydateactionhelper(component, event, helper);
       
    },
    
    
    discountactionCheckbox : function(component, event, helper) {
        var tmpMainWrapper =  component.get('v.wrapMain.lstWrappTwo');
        var isdiscount =  component.get('v.isdiscount');
        if(isdiscount==true){
            if(tmpMainWrapper.length>=2){
                console.log(tmpMainWrapper[0].objProdchild.Discount__c);
                if(tmpMainWrapper[0].objProdchild.Discount__c != null && tmpMainWrapper[0].objProdchild.Discount__c != ' '){
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
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Delivery date at first part have to be filled."
                    });
                    toastEvent.fire();
                }
            }
        }
        component.set("v.wrapMain.lstWrappTwo",tmpMainWrapper);
    },
    
    ChargesPercentageOnOhange:function(component, event, helper) {
        var tmpIndex = event.getSource().get("v.name");
        var templstcharge = component.get('v.lstSelectedTax');
        var TotalAmount = component.get('v.decTotalAmount');
        var igstvalue = component.get('v.wrapMain.igstvalue');
        var damo = (templstcharge[tmpIndex].TaxPercentage * TotalAmount)/100;
        templstcharge[tmpIndex].decTaxAmount = damo.toFixed(2);
        //templstcharge[tmpIndex].decTaxAmount = (templstcharge[tmpIndex].TaxPercentage * TotalAmount)/100;
        if(igstvalue){
         templstcharge[tmpIndex].NetAmount =  (templstcharge[tmpIndex].IGST * templstcharge[tmpIndex].decTaxAmount)/100 +templstcharge[tmpIndex].decTaxAmount;
        }
        else{
           templstcharge[tmpIndex].NetAmount = ((templstcharge[tmpIndex].CGST + templstcharge[tmpIndex].SGST)*templstcharge[tmpIndex].decTaxAmount)/100 +templstcharge[tmpIndex].decTaxAmount;
        }
         component.set("v.lstSelectedTax",templstcharge);
        var lstTotalSelectedTax = component.get("v.lstSelectedTax");
        var TotalTaxAmount = 0;
        //alert('...!@#..'+lstTotalSelectedTax.length);
        for(var i = 0; i < lstTotalSelectedTax.length; i++) {
            //alert('...'+lstTotalSelectedTax[i].decTaxAmount);
            TotalTaxAmount =TotalTaxAmount+parseInt(lstTotalSelectedTax[i].decTaxAmount);
        }
        component.set('v.TotalTax', TotalTaxAmount);
        
    },
     ChargesAmountOnOhange:function(component, event, helper) {
        var tmpIndex = event.getSource().get("v.name");
        var templstcharge = component.get('v.lstSelectedTax');
        var TotalAmount = component.get('v.decTotalAmount');
        var igstvalue = component.get('v.wrapMain.igstvalue');
         var tper = (templstcharge[tmpIndex].decTaxAmount * 100)/TotalAmount;
        templstcharge[tmpIndex].TaxPercentage =tper.toFixed(2);
       // templstcharge[tmpIndex].TaxPercentage = (templstcharge[tmpIndex].decTaxAmount * 100)/TotalAmount;
         console.log(templstcharge[tmpIndex].decTaxAmount);
        if(igstvalue){
         //templstcharge[tmpIndex].NetAmount =  (templstcharge[tmpIndex].IGST * templstcharge[tmpIndex].decTaxAmount)/100 +templstcharge[tmpIndex].decTaxAmount;
        var gst = templstcharge[tmpIndex].IGST;
            console.log(gst);
            var taxsamount = (gst*templstcharge[tmpIndex].decTaxAmount)/100;
            console.log(taxsamount);
            var amount = templstcharge[tmpIndex].decTaxAmount;
            templstcharge[tmpIndex].NetAmount =  parseInt(taxsamount) + parseInt(amount);
            console.log(templstcharge[tmpIndex].NetAmount);
        }
        else{
             //   templstcharge[tmpIndex].NetAmount = ((templstcharge[tmpIndex].CGST + templstcharge[tmpIndex].SGST)*templstcharge[tmpIndex].decTaxAmount)/100 +templstcharge[tmpIndex].decTaxAmount;
        
            var gst = templstcharge[tmpIndex].CGST + templstcharge[tmpIndex].SGST;
            console.log(gst);
            var taxsamount = (gst*templstcharge[tmpIndex].decTaxAmount)/100;
            console.log(taxsamount);
            var amount = templstcharge[tmpIndex].decTaxAmount;
            templstcharge[tmpIndex].NetAmount =  parseInt(taxsamount) + parseInt(amount);
            console.log(templstcharge[tmpIndex].NetAmount);
        }
         component.set("v.lstSelectedTax",templstcharge);
         var lstTotalSelectedTax = component.get("v.lstSelectedTax");
        var TotalTaxAmount = 0;
        //alert('...!@#..'+lstTotalSelectedTax.length);
        for(var i = 0; i < lstTotalSelectedTax.length; i++) {
            //alert('...'+lstTotalSelectedTax[i].decTaxAmount);
            TotalTaxAmount =TotalTaxAmount+parseInt(lstTotalSelectedTax[i].decTaxAmount);
        }
        component.set('v.TotalTax', TotalTaxAmount);
        
    }
    
})