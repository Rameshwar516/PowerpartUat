public class PurchaseIndent {
	
    @AuraEnabled
    public static string doInit(String strRecordId){
        mainWrapper objMainWrap = new mainWrapper();
        objMainWrap.objIBUser = [Select Id, Name from User where Id =: UserInfo.getUserId()];
        objMainWrap.procurementPickList = getPickVal(Purchase_Indent__c.Procurement__c.getDescribe());
        objMainWrap.applicationPickList = getPickVal(Opportunity__c.Application__c.getDescribe());
        objMainWrap.againstPickList = getPickVal(Purchase_Indent__c.Against__c.getDescribe());
        objMainWrap.departmentPickList = getPickVal(Purchase_Indent__c.Department__c.getDescribe());
        
        if(String.isBlank(strRecordId)){
            IndentItemWapper objIIW = new IndentItemWapper();
            objIIW.isEdit = true;
            objMainWrap.lstIIW.add(objIIW);
        }
        else{
            List<String> PIFields = getObjectFields('Purchase_Indent__c');
            string PIQuery = 'select ' + string.join(PIFields, ',') +',Ware_house__r.Name,Sales_Officer__r.Name from Purchase_Indent__c where Id =: strRecordId';
            List<Purchase_Indent__c> lstPI = Database.query(PIQuery);
            
            if(lstPI.size() > 0){
                objMainWrap.objPurchaseIndent = lstPI[0];
                if(objMainWrap.objPurchaseIndent.Against__c == 'Direct')
                    objMainWrap.isDirect = true;
                else
                    objMainWrap.isDirect = false;
                
                List<String> PIIFields = getObjectFields('Purchase_Indent_Line_Item__c');
                string PIIQuery = 'select ' + string.join(PIIFields, ',') +',Sales_Order_Line_Item__r.Sales_Order__c from Purchase_Indent_Line_Item__c where Purchase_Indent__c =: strRecordId';
                List<Purchase_Indent_Line_Item__c> lstPII = Database.query(PIIQuery);
                
                set<Id> setId = new set<Id>();
                set<Id> setSO = new set<Id>(); 
                map<Id, Part__c> mapIdVsPart = new map<Id, Part__c>();
                String strWareHouse = objMainWrap.objPurchaseIndent.Ware_house__c;
                if(lstPII.size()> 0){
                    for(Purchase_Indent_Line_Item__c objPII : lstPII){
                        setId.add(objPII.Product_Part__c);
                        setSO.add(objPII.Sales_Order_Line_Item__r.Sales_Order__c);
                    }
                    
                    if(setId.size() > 0){
                        for(Part__c objPart : [Select Id, Name,Part_Name__c,Usage__c,HSN_CODE__c,UOM__c,List_Price_Standard_price__c,
                                               (select id, Total_Quantity__c, Ware_House__c from Stocks__r where Ware_House__c =: strWareHouse) 
                                               from Part__c where Id =:setId])
                        {
                            mapIdVsPart.put(objPart.Id, objPart);
                        }
                    }
                    if(setSO.size() >0 ){
                        for(Sales_Order__c obj : [Select Id, Sales_Order_Acknowledge_Number__c 
                                                  from Sales_Order__c
                                                  where Id=: setSO])
                        {
                            option opt = new option();
                            opt.value = obj.Id;
                            opt.label = obj.Sales_Order_Acknowledge_Number__c;
                            objMainWrap.lstSalesOrder.add(opt);
                        }
                    }
                    
                    for(Purchase_Indent_Line_Item__c objPII : lstPII){
                        IndentItemWapper objIIW = new IndentItemWapper();
                        if(mapIdVsPart.containskey(objPII.Product_Part__c))
                            objIIW.objPart = mapIdVsPart.get(objPII.Product_Part__c);
                        objIIW.strId = objPII.Id;   
                        objIIW.specification = objPII.Specification__c;
                        objIIW.strSalesOrderItemId = objPII.Sales_Order_Line_Item__c;
                        objIIW.pendingPOQty = 0;
                        objIIW.stockActual = objPII.Stock_Actual__c;
                        objIIW.quantity = objPII.QTY__c;
                        //objIIW.Unit = '';
                        objIIW.expectedDate = objPII.Expected_date__c;
                        objIIW.application = objPII.Application__c;
                        objIIW.Remarks = objPII.Remark__c;
                        objIIW.isEdit = true;
                        objIIW.strPartErr ='';
                        objIIW.strExpectedDateErr ='';
                        objIIW.strQuantityErr ='';
                        objIIW.strApplicationErr ='';
                        objIIW.boolShowError = false;
                        objMainWrap.lstIIW.add(objIIW);
                    }
                }
            }
        }
        return JSON.serialize(objMainWrap);
    }
    
    @AuraEnabled
    public static String getSalesOrderItems(string recordId, List<Id> lstId){
        List<SalesOrderItemWrapper> lstSOI = new List<SalesOrderItemWrapper>();
        if(String.isNotBlank(recordId)){
            set<Id> setId = new set<Id>();
            map<Id, Stock__c> mapIdvsStock = new map<Id, Stock__c>();
            List<Sales_Order_Line_Item__c> lstFilterItem = new List<Sales_Order_Line_Item__c>();
            
            List<Sales_Order_Line_Item__c> lst = [Select Id, Name, Quantity__c, Product_Part__c, Product_Part__r.Name, Product_Part__r.Part_Name__c,Product_Part__r.Usage__c, 
                                                  Product_Part__r.UOM__c,HSN_Code__c, Sales_Order__c, Sales_Order__r.Opportunity__r.Ware_House__c,Sales_Order__r.Application__c
                                                  From Sales_Order_Line_Item__c
                                                  where Sales_Order__c =: recordId
                                                  AND Product_Part__c != NULL];
            if(lst.size() > 0){
                
                String strWareHouseId = lst[0].Sales_Order__r.Opportunity__r.Ware_House__c;
                
                if(lstId.size() > 0){
                    for(Sales_Order_Line_Item__c obj : lst){
                        if(!lstId.contains(obj.Id))
                            lstFilterItem.add(obj);
                    }
                }
                else
                   lstFilterItem.addAll(lst);
                
                for(Sales_Order_Line_Item__c obj : lstFilterItem)
                    setId.add(obj.Product_Part__c);
                
                for(Stock__c objStock : [Select Id, Product_In__c, Product_Out__c, Product_Part__c, Total_Quantity__c,Ware_House__c
                                         from Stock__c 
                                         where Product_Part__c =: setId
                                         And Ware_House__c =: strWareHouseId])
                {                    
                    mapIdvsStock.put(objStock.Product_Part__c, objStock);
                }
                
                for(Sales_Order_Line_Item__c obj : lstFilterItem){
                    if(mapIdvsStock.containsKey(obj.Product_Part__c)){
                        //check if SOA Line Item's quantity not available on selected warehouse total quantity than only those item will be shown as an Indent Line Items.
                        if(obj.Quantity__c > mapIdvsStock.get(obj.Product_Part__c).Total_Quantity__c){
                            SalesOrderItemWrapper objwrap = new SalesOrderItemWrapper();
                            objwrap.objSOLI = obj;
                            objwrap.objStock = mapIdvsStock.get(obj.Product_Part__c);
                            lstSOI.add(objwrap);
                        }
                    }
                }
            }
        }
        return JSON.serialize(lstSOI);
    }
    
    @AuraEnabled
    public static string getSalesOrderItemsId(string strSalesOrderId){
        List<Id> lstId = new List<Id>();
        if(String.isNotBlank(strSalesOrderId)){
            for(Sales_Order_Line_Item__c obj : [Select Id from Sales_Order_Line_Item__c where Sales_Order__c =: strSalesOrderId])
                lstId.add(obj.Id);
        }
        return JSON.serialize(lstId);
    }
    
    @AuraEnabled
    public static String SavePurchaseIndent(String strMainWrapper){
        
        mainWrapper objMainWrap = new mainWrapper();
        String PurchaseIntendId ='';
        List<Purchase_Indent_Line_Item__c> lstPLI = new List<Purchase_Indent_Line_Item__c>();
        try{
            system.debug('strMainWrapper--'+strMainWrapper);
            objMainWrap = (mainWrapper)Json.deserialize(strMainWrapper, mainWrapper.class);
            objMainWrap.success = true;
            if(objMainWrap.objPurchaseIndent != null){
                objMainWrap.objPurchaseIndent.Indent_Date__c = system.today();
                upsert objMainWrap.objPurchaseIndent;
                
                String strPurchaseIndentId =objMainWrap.objPurchaseIndent.Id;
                set<Id> setIdPILI = new set<Id>();
                List<Purchase_Indent_Line_Item__c> DeletePILIList = new List<Purchase_Indent_Line_Item__c>();
                List<Purchase_Indent_Line_Item__c> lstSavedPILI =[Select Id, Name from Purchase_Indent_Line_Item__c where Purchase_Indent__c =: strPurchaseIndentId];
                
                for(IndentItemWapper objIIW : objMainWrap.lstIIW){
                    Purchase_Indent_Line_Item__c obj = new Purchase_Indent_Line_Item__c();
                    if(String.isNotBlank(objIIW.strId)){
                        obj.Id = objIIW.strId;
                        setIdPILI.add(obj.Id);
                    }
                    obj.Purchase_Indent__c = objMainWrap.objPurchaseIndent.Id;
                    obj.Product_Part__c = objIIW.objPart.Id;
                    obj.Name = objIIW.objPart.Part_Name__c;
                    obj.Expected_date__c = objIIW.expectedDate;
                    obj.QTY__c = objIIW.quantity;
                    obj.Remark__c = objIIW.remarks;
                    obj.Specification__c = objIIW.specification;
                    if(String.isNotBlank(objIIW.strSalesOrderItemId))
                       obj.Sales_Order_Line_Item__c = objIIW.strSalesOrderItemId;
                    obj.Application__c = objIIW.application;
                    obj.Stock_Actual__c = objIIW.stockActual;
                    lstPLI.add(obj);
                }
                if(lstPLI.size() > 0)
                    upsert lstPLI;
                
                //delete Purchase Indent Item
                if(lstSavedPILI.size()>0){
                    if(setIdPILI.size() > 0){
                        for(Purchase_Indent_Line_Item__c obj : lstSavedPILI)
                            if(!setIdPILI.contains(obj.Id))
                            	DeletePILIList.add(obj);
                    }
                    else{
                        DeletePILIList.addAll(lstSavedPILI);
                    }
                    if(DeletePILIList.size() > 0)
                        delete DeletePILIList;
                }
                //End delete Logic    
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
    
    public static List<String> getObjectFields(string strObjectName){
        map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
        Schema.sObjectType sObjType = globalDescription.get(strObjectName);
        Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
        List<string> lstfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
        return lstfieldNames;
    }
    
    public class mainWrapper{
        public List<IndentItemWapper> lstIIW;
        public List<option> procurementPickList;
        public List<option> applicationPickList;
        public List<option> againstPickList;
        public List<option> departmentPickList;
        public List<option> lstSalesOrder; //This list hold the the sales order for Edit mode
        
        public Purchase_Indent__c objPurchaseIndent;
        public user objIBUser;
        public boolean isDirect;
        public boolean success;
        public string strErrorMessage;
        
        public mainWrapper(){
            lstIIW = new List<IndentItemWapper>();
            procurementPickList = new List<option>();
            applicationPickList = new List<option>();
            againstPickList = new List<option>();
            departmentPickList = new List<option>();
            lstSalesOrder = new List<option>();
            objPurchaseIndent = new Purchase_Indent__c();
            isDirect = false;
            success = false;
            strErrorMessage = '';
        }
    }
    public class IndentItemWapper{
        public Part__c objPart;
        public String strId;
        public String specification;
        public String strSalesOrderItemId;
        public Integer pendingPOQty;
        public decimal stockActual;
        public decimal quantity;
        //public String unit;
        public Date expectedDate;
        public String application;
       	public String remarks; 
        public boolean isEdit;
        
        public String strPartErr;
        public String strExpectedDateErr;
        public String strQuantityErr;
        public String strApplicationErr;
        public boolean boolShowError;
        
        public IndentItemWapper(){
            objPart = new Part__c();
            strId = '';
            specification = '';
            strSalesOrderItemId='';
            pendingPOQty = 0;
            stockActual = 0;
            quantity = 0;
            //unit = '';
            expectedDate = null;
            application = '';
            remarks = '';
            isEdit = false;
            
            strPartErr ='';
            strExpectedDateErr = '';
            strQuantityErr = '';
            strApplicationErr = '';
            boolShowError = false;
        }
    }
    
    public class SalesOrderItemWrapper{
        Sales_Order_Line_Item__c objSOLI;
        Stock__c objStock;
        boolean isSelected ;
        
        public SalesOrderItemWrapper(){
            objSOLI = new Sales_Order_Line_Item__c();
            objStock = new Stock__c();
            isSelected = true;
        }
    }
    
    public class option
    {
        public string value;
        public string label;
    }
}