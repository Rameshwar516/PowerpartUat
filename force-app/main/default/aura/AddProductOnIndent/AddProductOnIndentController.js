({
    doinit : function(component, event, helper) {
        var id = component.get("v.recordId");
        helper.pageLoadClassMethod(component, event, id);
    },
    actionchange:function(component, event, helper) {
        console.log('fire');
        var tmpIndex = event.getSource().get("v.name");
        var tmpWrapper = component.get("v.wrapMain.lstWrappTwo");
        console.log('objProdchild--'+component.get("v.wrapMain.lstWrappTwo"));
        console.log('fire2');
        for(var i=0;i<tmpWrapper.length;i++)
        {
            console.log('index'+tmpIndex);
            if(i == tmpIndex)
            {
                console.log('index if'+tmpIndex);
                console.log('objProdchild'+tmpWrapper[i].objProdchild);
                var child = tmpWrapper[i].objProdchild;
                console.log('index if'+event.getSource().get("v.value")); 
                console.log('id '+event.getSource().get("v.id")); 
                console.log('child.Sales_Price__c '+child.Sales_Price__c);
                if(event.getSource().get("v.id") == "quantity"){ 
                    child.Total_Amount__c = event.getSource().get("v.value") * child.Sales_Price__c; 
                }
                else{
                       child.Total_Amount__c = event.getSource().get("v.value") * child.Quantity__c; 
                }
               console.log('Total '+child.Total_Amount__c);
            }
        }     
        component.set("v.wrapMain.lstWrappTwo", tmpWrapper);  
    },
    nextJs :function(component, event, helper) {
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
            
        }else{
            var msg = $A.get("$Label.c.Product_Selection");
            component.set("v.wrapMain.strMessage", msg);
            component.set("v.wrapMain.success", false);
        }
        
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
        var tmpMainWrapper = component.get("v.wrapMain.lstWrappTwo");
        var Istrue = false; 
        for(var i=0;i<tmpMainWrapper.length;i++)
        {
            if(tmpMainWrapper[i].objProdchild.Quantity__c ==null || tmpMainWrapper[i].objProdchild.Quantity__c =='' || tmpMainWrapper[i].objProdchild.Sales_Price__c ==null || tmpMainWrapper[i].objProdchild.Sales_Price__c ==''){
                Istrue = true;
            }
        }
        if(!Istrue){
            var id = component.get("v.recordId");
            helper.SaveHelper(component, event, id);
        }else{
            component.set("v.wrapMain.strMessage", $A.get("$Label.c.Add_Product_Error_Msg"));
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
    }
    
})