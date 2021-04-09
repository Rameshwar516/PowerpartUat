({
    findProduct : function(component, event, helper) {
        //alert(component.find('M1011AD').get('v.value')+' ----Hello------ '+component.get('v.DigValue'));
        //component.find('M1011AD').set('v.value','Test Diagnosis2345');
        
        var queryTxt = component.find('txtField').get('v.value');
        //alert(queryTxt);
        if(queryTxt != null && queryTxt != ''){
            var action = component.get('c.getSearchProduct');
            action.setParams({
                'objectName' : 'Part__c',
                'queryText' : queryTxt,
                'listdata' : component.get('v.DigValue2')
            });
            
            action.setCallback(this, function(res){
                var listOfProduct = res.getReturnValue();
                //alert(listOfProduct);
                var temprodList = [];
                for(var i=0; i<listOfProduct.length; i++){
                    
                    temprodList.push({isSelected: false,objProd:listOfProduct[i]});
                }
                component.set('v.DigValue', temprodList);
                component.set('v.resultList', listOfProduct);
                if(listOfProduct != null && listOfProduct != ''){
                    component.set('v.isDisplay', true);
                }else{
                    component.set('v.isDisplay', false);
                }
                
            });
            $A.enqueueAction(action);
        }else{
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
        
        //alert(queryTxt);
        //var action = component.get('c.CopySearchProduct');
        /*
        action.setCallback(this, function(res){
            var listOfProduct = res.getReturnValue();
            //alert(listOfProduct);
            component.set('v.resultList', listOfProduct);
            if(listOfProduct != null && listOfProduct != ''){
                
                var ProductValue = component.get('v.Assessment');
                component.find('txtField').set('v.value', val);
            }else{
            component.set('v.resultList', null);
            component.set('v.isDisplay', false);
			}
        });
        $A.enqueueAction(action);
        */
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
    
    handleHideErrorDisplayModal : function(component, event, helper){
        component.set('v.warning', '');
    },
})