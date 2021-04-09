({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
        //alert('.....'+component.get("v.objectAPIName"))
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            //alert('...'+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    
    searchDeliveryNoteLineItems : function(component, event, strDeliveryNoteId) {
        if(strDeliveryNoteId != null && strDeliveryNoteId != ''){
            var action = component.get('c.getSearchDeliveryNoteLI');
            action.setParams({
                'strDeliveryNoteId' : strDeliveryNoteId,
                'objectName' : 'Delivery_Note_Line_Item__c'
            });
            
            action.setCallback(this, function(res){
                //alert('!@#'+res.getReturnValue());
                var listOfProduct = res.getReturnValue();
                //alert(listOfProduct);
               
                component.set("v.ObjDeliveryNoteLI", JSON.parse(listOfProduct));
                /*var temprodList = [];
                for(var i=0; i<listOfProduct.length; i++){
                    
                    temprodList.push({IsEdit: false,objDNLI:listOfProduct[i]});
                }
                component.set('v.DigValue', temprodList);
                component.set('v.lstDeliveryNoteLI', temprodList);*/
                
                /*if(listOfProduct != null && listOfProduct != ''){
                    component.set('v.isDisplay', true);
                }else{
                    component.set('v.isDisplay', false);
                }*/
                
            });
            $A.enqueueAction(action);
        }else{
            //component.set('v.isDisplay', false);
        }
    },
	
	
    searchPurchaseOrderLineItems : function(component, event, strPurchaseOrderId) {
        if(strPurchaseOrderId != null && strPurchaseOrderId != ''){
            var action = component.get('c.SearchPurchaseOrderLI');
            action.setParams({
                'strPurchaseOrderId' : strPurchaseOrderId,
                'objectName' : 'Purchase_Order_Line_Item__c'
            });
            
            action.setCallback(this, function(res){
                var listPurchaseOrder = res.getReturnValue();
                component.set("v.ObjDeliveryNoteLI", JSON.parse(listPurchaseOrder));
            });
            $A.enqueueAction(action);
        }
    },
    
})