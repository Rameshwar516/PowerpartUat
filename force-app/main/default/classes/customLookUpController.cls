public with sharing class customLookUpController 
{
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) 
    {
        String searchKey = searchKeyWord + '%';
        String sQuery = '';
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5
        if(ObjectName =='Sales_Order_Dispatch_Delivery_Note__c'){
            sQuery =  'select id, Delivery_Note_Number__c from ' +ObjectName + ' where Delivery_Note_Number__c LIKE: searchKey order by createdDate DESC limit 5';
        } else{
            sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        }       
        
        return Database.query(sQuery);
    }
    
    @AuraEnabled 
    public static SObject[] getSearchDeliveryNoteLI1(string strDeliveryNoteId, string objectName)
    {
        try
        {
            string filter = '';
            if(strDeliveryNoteId != null && strDeliveryNoteId !=''){
                map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
                Schema.sObjectType sObjType = globalDescription.get(objectName);
                Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
                List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
                string soql = 'select ' + string.join(leadfieldNames, ',') +',Sales_Order_Dispatch_Delivery_Note__r.Name,Sales_Order_Dispatch_Delivery_Note__r.Date__c,Ware_House__r.Name,Stock__r.Total_Product__c,Product_Part__r.Name,Product_Part__r.CreatedDate from ' + objectName ; 
                system.debug('......'+soql);
                if(strDeliveryNoteId != '')     
                    soql += ' where Sales_Order_Dispatch_Delivery_Note__c =: strDeliveryNoteId';
                system.debug('====='+soql);
                //soql += 'order by Name limit 10';
                return Database.query(soql);
            }else{
                return null;
            }
        }
        catch(Exception ex)
        {
            system.debug('Exception---- '+ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static string getSearchDeliveryNoteLI(string strDeliveryNoteId, string objectName)
    {
        mainWrapper objmainWrap = new mainWrapper();
        objmainWrap.lstSubMain = new List<SubMainWraip>();
        objmainWrap.listPurchaseOrderLI = new List<SubMainWraip>();
        try
        {
            string filter = '';
            if(strDeliveryNoteId != null && strDeliveryNoteId !=''){
                map<string,Stock__c> mapNoOfStock = new map<string,Stock__c>();
                for(Stock__c objStock : [Select Id,Name,Ware_House__c,Ware_House__r.City__c,Product_Part__c,Quantity__c,Total_Quantity__c,(SELECT CreatedDate,Landed_Price__c FROM Stock_Landed_Amount__r Where Landed_Price__c > 0  ORDER BY CreatedDate DESC ) from Stock__c]){
                    mapNoOfStock.put(objStock.Product_Part__c+'-'+objStock.Ware_House__c,objStock);
                }
                map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
                Schema.sObjectType sObjType = globalDescription.get(objectName);
                Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
                List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
                
                /* Adding the object and filter by name to the soql */
                string soql = 'select ' + string.join(leadfieldNames, ',') +',Sales_Order_Dispatch_Delivery_Note__r.Shipping_Account__c,Sales_Order_Dispatch_Delivery_Note__r.Contact_Person_Name__c, Sales_Order_Dispatch_Delivery_Note__r.Customer_Party__c,Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Contact_Person__c,Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Ware_House__c,Sales_Order_Dispatch_Delivery_Note__r.Name,Sales_Order_Dispatch_Delivery_Note__r.Date__c,Ware_House__r.Name,Ware_House__r.City__c,Product_Part__r.Name,Product_Part__r.CreatedDate,Product_Part__r.Part_Name__c from ' + objectName ; 
                system.debug('......'+soql);
                if(strDeliveryNoteId != '')     
                    soql += ' where Sales_Order_Dispatch_Delivery_Note__c =: strDeliveryNoteId';
                system.debug('====='+soql);
                
                
                //soql += 'order by Name limit 10';
                List<Delivery_Note_Line_Item__c> lstSODN = Database.query(soql);
                system.debug('..lstSODN...'+lstSODN.size());
                for(Delivery_Note_Line_Item__c objSODN : lstSODN){
                    SubMainWraip objSMW = new SubMainWraip();
                    objSMW.objDNLI = objSODN;
                    objSMW.IsEdit = false;
                  
                    System.debug('Product_Part__c - '+objSODN.Product_Part__c );
                    System.debug('Warehouse - '+objSODN.Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Ware_House__c);
                    Integer IntQty =0;
                    if(objSODN.Product_Part__c !=null && objSODN.Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Ware_House__c !=null){
                       System.debug('Warehouse - '+objSODN.Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Ware_House__c);
                          
                        Stock__C stk = mapNoOfStock.get(objSODN.Product_Part__c+'-'+objSODN.Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Ware_House__c);
                       // IntQty = Integer.ValueOf(stk.Total_Quantity__c);
                        System.debug('stock landed - '+stk.Stock_Landed_Amount__r.isempty());
                         if(!stk.Stock_Landed_Amount__r.isempty()){
                            objSMW.objDNLI.Sales_Price__c = stk.Stock_Landed_Amount__r[0].Landed_Price__c;
                        }
                       // objSMW.StockId =mapNoOfStock.get(objSODN.Product_Part__c+'-'+objSODN.Ware_House__c).Id; 
                    }
                    
                    system.debug('..IntQty..'+IntQty);
                    if(IntQty !=null)
                        objSMW.StockTotalProduct =IntQty;
                    else
                        objSMW.StockTotalProduct =0;
                    
                    objmainWrap.lstSubMain.add(objSMW);
                }
                system.debug('..objmainWrap.lstSubMain...'+objmainWrap.lstSubMain.size());
                //return Database.query(soql);
            }
        }catch(Exception e)
        {
            objMainWrap.isSuccess= false;
            objMainWrap.strMessage = ExceptionMessage.getExceptionMsg(e);
        }
        return JSON.serialize(objmainWrap);
    }
    
    /*@AuraEnabled
    public static string SearchPurchaseOrderLI(string strPurchaseOrderId, string objectName)
    {
        mainWrapper objmainWrap = new mainWrapper();
        objmainWrap.lstSubMain = new List<SubMainWraip>();
        objmainWrap.listPurchaseOrderLI = new List<SubMainWraip>();
        try
        {
            string filter = '';
            if(strPurchaseOrderId != null && strPurchaseOrderId !=''){
                map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
                Schema.sObjectType sObjType = globalDescription.get(objectName);
                Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
                List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
                
                string soql = 'select ' + string.join(leadfieldNames, ',') +',Purchase_Order__r.Name,Purchase_Order__r.PO_Date__c from ' + objectName ; 
                system.debug('......'+soql);
                if(strPurchaseOrderId != '')     
                    soql += ' where Purchase_Order__c =: strPurchaseOrderId';
                system.debug('====='+soql);
                
                
                //soql += 'order by Name limit 10';
                List<Purchase_Order_Line_Item__c> lstPOLI = Database.query(soql);
                for(Purchase_Order_Line_Item__c objPOLI : lstPOLI){
                    SubMainWraip objSMW = new SubMainWraip();
                    objSMW.objPOLI = objPOLI;
                    objSMW.IsEdit = false;
                    objSMW.StockTotalProduct =5;
                    objmainWrap.listPurchaseOrderLI.add(objSMW);
                }
            }
        }catch(Exception e)
        {
            objMainWrap.isSuccess= false;
            objMainWrap.strMessage = ExceptionMessage.getExceptionMsg(e);
        }
        return JSON.serialize(objmainWrap);
    }
    */
    
    public Class mainWrapper
    {
        public boolean isSuccess;
        public string strMessage;
        public list<SubMainWraip> lstSubMain;
        public list<SubMainWraip> listPurchaseOrderLI;
    }
    public Class SubMainWraip
    {
        public Delivery_Note_Line_Item__c objDNLI;
        public Purchase_Order_Line_Item__c objPOLI;
        public boolean IsEdit;
        public Integer StockTotalProduct;
        public string StockId;
    }
}