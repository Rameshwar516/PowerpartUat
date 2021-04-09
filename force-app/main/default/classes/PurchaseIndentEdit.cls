public class PurchaseIndentEdit {
    
     @AuraEnabled
    public static string doInit(String recordId){
        mainWrapper objMainWrap = new mainWrapper();
        if(String.isNotBlank(recordId)){
            objMainWrap.success =true;
            objMainWrap.objPurchaseIndent = [Select Id,Indent_By__c,Indent_Date__c,Procurement__c,Reference_Date__c,Reference_No__c,
                                             Remark__c,Sales_Officer__c,Terms_and_Conditions__c, Ware_House__c,Department__c
                                             From Purchase_Indent__c 
                                             where Id =: recordId];
            
            List<Purchase_Indent_Line_Item__c> lstPILI =[ Select Id, Application__c, Expected_date__c,Product_Part__c, Product_Part__r.Name, Product_Part__r.Part_Name__c,
                                                         Product_Part__r.Usage__c,Purchase_Indent__c,QTY__c,Remark__c,Specification__c,Stock_Actual__c
                                                         From Purchase_Indent_Line_Item__c
                                                         where Purchase_Indent__c =: recordId];
            
            for(Purchase_Indent_Line_Item__c obj : lstPILI){
                IndentItemWapper objIIW = new IndentItemWapper();
                objIIW.objPILI = obj;
                objIIW.objPart.Id = obj.Product_Part__c;
                objIIW.objPart.Name = obj.Product_Part__r.Name;
                objIIW.objPart.Part_Name__c = obj.Product_Part__r.Part_Name__c;
                objIIW.objPart.Usage__c = obj.Product_Part__r.Usage__c;
                objIIW.isEdit = false;
                objMainWrap.lstIIW.add(objIIW);
            }                    
            
            if(String.isNotEmpty(objMainWrap.objPurchaseIndent.Indent_By__c))
                objMainWrap.objIBUser = [Select Id, Name from User where Id =: objMainWrap.objPurchaseIndent.Indent_By__c];
            if(String.isNotEmpty(objMainWrap.objPurchaseIndent.Sales_Officer__c))
                objMainWrap.objSOUser = [Select Id, Name from User where Id =: objMainWrap.objPurchaseIndent.Sales_Officer__c];
            
            objMainWrap.procurementPickList = getPickVal(Purchase_Indent__c.Procurement__c.getDescribe());
            objMainWrap.applicationPickList = getPickVal(Opportunity__c.Application__c.getDescribe());
            
        }
        return JSON.serialize(objMainWrap);
    }
        
    @AuraEnabled
    public static String SavePurchaseIndent(String strMainWrapper){
        
        mainWrapper objMainWrap = new mainWrapper();
        List<Purchase_Indent_Line_Item__c> lstPLI = new List<Purchase_Indent_Line_Item__c>();
        try{
            system.debug('strMainWrapper--'+strMainWrapper);
            objMainWrap = (mainWrapper)Json.deserialize(strMainWrapper, mainWrapper.class);
            objMainWrap.success = true;
            if(objMainWrap.objPurchaseIndent != null){
                update objMainWrap.objPurchaseIndent;
                String recordId = objMainWrap.objPurchaseIndent.Id;
                
                List<Purchase_Indent_Line_Item__c> lstPILI =[ Select Id From Purchase_Indent_Line_Item__c where Purchase_Indent__c =: recordId];
              
                List<Purchase_Indent_Line_Item__c> deleteList = new List<Purchase_Indent_Line_Item__c>();
                List<Purchase_Indent_Line_Item__c> updateList = new List<Purchase_Indent_Line_Item__c>();
                Set<Id> updateSetId = new Set<Id>();
                if(objMainWrap.lstIIW.size() > 0){
                    for(IndentItemWapper objIIW : objMainWrap.lstIIW){
                        updateList.add(objIIW.objPILI);
                        updateSetId.add(objIIW.objPILI.Id);
                    }
                    for(Purchase_Indent_Line_Item__c obj : lstPILI){
                        if(!updateSetId.contains(obj.Id))
                            deleteList.add(obj);
                    }
                    
                }
                else{
                    if(lstPILI.size() > 0)
                        delete lstPILI;
                }
                
                if(updateList.size() > 0)
                    update  updateList;
                if(deleteList.size() > 0)
                    delete  deleteList;
            }
        }
        catch(DMLException dm){
            objMainWrap.success = false;
            objMainWrap.strErrorMessage = dm.getDmlMessage(0);
        }
        return JSON.serialize(objMainWrap);
    }
    
    public static List<option> getPickVal(Schema.DescribeFieldResult fieldResult){
        List<option> lstOption = new List<option>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            option objOption = new option();
            objOption.label = f.getLabel();
            objOption.value = f.getValue();
            lstOption.add(objOption);
        }
        return lstOption;
    }
    
    public class mainWrapper{
        public List<IndentItemWapper> lstIIW;
        public List<option> procurementPickList;
        public List<option> applicationPickList;
        public Purchase_Indent__c objPurchaseIndent;
        public user objIBUser;
        public user objSOUser;
        public boolean success;
        public string strErrorMessage;
        
        public mainWrapper(){
            lstIIW = new List<IndentItemWapper>();
            procurementPickList = new List<option>();
            applicationPickList = new List<option>();
            objPurchaseIndent = new Purchase_Indent__c();
            success = false;
            strErrorMessage = '';
        }
    }
    public class IndentItemWapper{
        public Part__c objPart;
        public Purchase_Indent_Line_Item__c objPILI;
        public Integer pandingPOQty;
        public Integer stockActual;
        public boolean isEdit;
        
        public String strPartErr;
        public String strExpectedDateErr;
        public String strQuantityErr;
        public String strApplicationErr;
        public boolean boolShowError;
        
        public IndentItemWapper(){
            objPart = new Part__c();
            objPILI = new Purchase_Indent_Line_Item__c();
            pandingPOQty = 0;
            stockActual = 0;
            isEdit = false;
            
            strPartErr ='';
            strExpectedDateErr = '';
            strQuantityErr = '';
            strApplicationErr = '';
            boolShowError = false;
        }
    }

    public class option
    {
        public string value;
        public string label;
    }
}