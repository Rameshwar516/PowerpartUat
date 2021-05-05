public without sharing class PurchaseOrderCMP {
    
    @AuraEnabled
    public static string doInit(String strRecordID){     
        mainWrapper objMainWrap = new mainWrapper();
        objMainWrap.againstPickList = getPickVal(Purchase_Order__c.Against__c.getDescribe());
        objMainWrap.applicationPickList = getPickVal(Opportunity__c.Application__c.getDescribe());
        objMainWrap.billToPickList = getPickVal(Purchase_Order__c.Bill_To__c.getDescribe());
        objMainWrap.shipToPickList = getPickVal(Purchase_Order__c.Ship_To__c.getDescribe());
        objMainWrap.currencyPickList = getPickVal(Purchase_Order__c.Currency__c.getDescribe());
       objMainWrap.UOIPickList = getPickVal(Part__c.UOI__c.getDescribe());
        
        List<tax__c> taxlist =[SELECT Basic_Percentage__c,Id,Name,Tax_Percentage__c FROM Tax__c];
        for(Tax__c objTax : taxlist){
            option objTaxT = new option();
            objTaxT.label = objTax.Name;
            objTaxT.value = objTax.id;
            objMainWrap.lstTaxType.add(objTaxT);
            objMainWrap.lstTax.add(objTax);
        }
        
        if(String.isBlank(strRecordID)){
            
            OrderItemWapper objOIW = new OrderItemWapper();
            objOIW.isEdit = true;
            objMainWrap.lstOIW.add(objOIW);
        }
        else{
            List<String> POFields = getObjectFields('Purchase_Order__c');
            string POQuery = 'select ' + string.join(POFields, ',') +',Ware_house__r.Name,Ware_house__r.State_Code__c ,Supplier__r.Name, Supplier__r.Shipping_State_Code__c, Supplier__r.Billing_State_Code__c from Purchase_Order__c where Id =: strRecordId';
            List<Purchase_Order__c> lstPO = Database.query(POQuery);
            
            if(lstPO.size()>0){
                objMainWrap.objPurchaseOrder = lstPO[0];
                if(objMainWrap.objPurchaseOrder.Against__c == 'Direct')
                     objMainWrap.isDirect = true;
                else
                    objMainWrap.isDirect = false;
            
                List<String> POIFields = getObjectFields('Purchase_Order_Line_Item__c');
                string POIQuery = 'select ' + string.join(POIFields, ',') +',Purchase_Indent_Line_Item__r.Purchase_Indent__c from Purchase_Order_Line_Item__c where Purchase_Order__c =: strRecordId';
                List<Purchase_Order_Line_Item__c> lstPOI = Database.query(POIQuery);
                
                set<Id> setId = new set<Id>();
                map<Id, Part__c> mapIdVsPart = new map<Id, Part__c>();
                set<Id> setPI = new set<Id>(); 
                String strWareHouse = objMainWrap.objPurchaseOrder.Ware_house__c;
                if(lstPOI.size()> 0){
                    for(Purchase_Order_Line_Item__c objPOI : lstPOI){
                        setId.add(objPOI.Product_Part__c);
                        setPI.add(objPOI.Purchase_Indent_Line_Item__r.Purchase_Indent__c);
                    }
                    
                    if(setId.size() > 0){
                        for(Part__c objPart : [Select Id, Name,Part_Name__c,Usage__c,HSN_CODE__c,List_Price_Standard_price__c,UOI__c,
                                               (select id, Total_Quantity__c, Ware_House__c from Stocks__r where Ware_House__c =: strWareHouse) 
                                               from Part__c where Id =:setId])
                        {
                            mapIdVsPart.put(objPart.Id, objPart);
                        }
                    }
                    if(setPI.size() >0 ){
                        for(Purchase_Indent__c obj : [Select Id, Purchase_Indent_Number__c 
                                                      from Purchase_Indent__c
                                                      where Id=: setPI])
                        {
                            System.debug('objId----- '+obj);
                            option opt = new option();
                            opt.value = obj.Id;
                            opt.label = obj.Purchase_Indent_Number__c;
                            objMainWrap.lstPurchaseIndent.add(opt);
                        }
                    }
                    
                    for(Purchase_Order_Line_Item__c objPOI : lstPOI){
                        OrderItemWapper objOIW = new OrderItemWapper();
                        if(mapIdVsPart.containskey(objPOI.Product_Part__c))
                            objOIW.objPart = mapIdVsPart.get(objPOI.Product_Part__c);
                        objOIW.strId = objPOI.Id;
                        objOIW.DocNo = objPOI.Doc_No__c;
                        objOIW.DocDate = objPOI.Doc_Date__c;    
                        objOIW.specification = objPOI.Specification__c;
                        objOIW.strIndentItemId = objPOI.Purchase_Indent_Line_Item__c;
                        objOIW.pandingMRNQty = 0;
                        objOIW.stockActual = objPOI.Stock_Actual__c;
                        objOIW.IndentQty = objPOI.Purchase_Indent_Quantity__c;
                        objOIW.Quantity = objPOI.Quantity__c;
                        objOIW.Unit = '';
                        objOIW.Rate = objPOI.Sales_Price__c;
						/*if(mapIdVsPart.containskey(objPOI.Product_Part__c) && mapIdVsPart.get(objPOI.Product_Part__c).UOI__c != null)
							objOIW.UOI = mapIdVsPart.get(objPOI.Product_Part__c).UOI__c;*/
						
						objOIW.UOI = objPOI.UOI_Text__c;
						
                        objOIW.Amount = objPOI.Total_Amount__c;
                        objOIW.DiscRate = objPOI.Discount__c;
                        objOIW.DiscAmount = objPOI.Discount_Amount__c;
                        objOIW.GrossAmount = objPOI.Total_Amount__c;
                        objOIW.HSNCode =objPOI.HSN_Code__c;
                        objOIW.CGSTRate =objPOI.CGST__c;
                        objOIW.CGSTAmount = objPOI.CGST_Amount_Formula__c;
                        objOIW.SGSTRate  = objPOI.SGST__c;
                        objOIW.SGSTAmount = objPOI.SGST_Amount_Formula__c;
                        objOIW.IGSTRate = objPOI.IGST__c;
                        objOIW.IGSTAmount = objPOI.IGST_Amount_Formula__c;
                        objOIW.NetAmount = objPOI.Net_Amount_Formula__c;
                        objOIW.DeliveryDate = objPOI.Delivery_Date__c;
                        objOIW.application = objPOI.Application__c;
                        objOIW.Remarks = objPOI.Remark__c;
                        objOIW.isEdit = true;
                        objOIW.strPartErr ='';
                        objOIW.strDeliveryDateErr ='';
                        objOIW.strQuantityErr ='';
                        objOIW.strRateErr ='';
                        objOIW.boolShowError = false;
                        objMainWrap.lstOIW.add(objOIW);
                    }
                }
                
            }
            
            
            List<Charges__c> chargeslist =[SELECT CGST__c,Charges__c,Charge_Percentage__c,Id,IGST__c,MRN__c,Name,Net_Amount__c,Purchase_Order__c,
                                           Quote__c,SGST__c,Total_Amount__c,Charges__r.name 
                                           FROM Charges__c 
                                           Where Purchase_Order__c =:strRecordID];
            
            map<id,tax__c> taxmap = new map<id,tax__c>();
            if(!taxlist.isEmpty()){
                taxmap.putall(taxlist);
            }
            
            if(!chargeslist.isEmpty()){
                for(Charges__c ch:chargeslist){
                    TaxDetails objTD = new TaxDetails();
                    objTD.objTax = taxmap.get(ch.Charges__c);
                    objTD.strTaxId = ch.Charges__c;
                    objTD.strTaxName = ch.Charges__r.Name;
                    objTD.TaxPercentage = taxmap.get(ch.Charges__c).Tax_Percentage__c;
                    objTD.CGST = ch.CGST__c ;
                    objTD.SGST = ch.SGST__c;
                    objTD.IGST = ch.IGST__c;
                    objTD.objcharge = ch;
                    objTD.decTaxAmount =  ch.Total_Amount__c;
                    objTD.NetAmount =  ch.Net_Amount__c;
                    objTD.ischargeItem = true;
                    objMainWrap.lstTaxDetails.add(objTD);
                } 
            }
        }
        return JSON.serialize(objMainWrap);
    }
    
    @AuraEnabled
    public static string getPurchaseIndentItems(String recordId, List<Id> itemsId){
        List<IndentItemWrapper> lstOIWrapper = new List<IndentItemWrapper>();
        if(String.isNotBlank(recordId)){
            set<Id> setId = new set<Id>();
            map<Id, Stock__c> mapIdvsStock = new map<Id, Stock__c>();
            List<Purchase_Indent_Line_Item__c> lstFilterItem = new List<Purchase_Indent_Line_Item__c>();
            
            List<Purchase_Indent_Line_Item__c> lst = [Select Id, Name, QTY__c, Product_Part__c, Product_Part__r.Name, Product_Part__r.Part_Name__c,Product_Part__r.Usage__c, 
                                                      Product_Part__r.HSN_Code__c,Product_Part__r.UOM__c,Product_Part__r.UOI__c, Purchase_Indent__c, Purchase_Indent__r.Ware_House__c, 
                                                      Purchase_Indent__r.Purchase_Indent_Number__c, Purchase_Indent__r.CreatedDate,Application__c, Remark__c
                                                      From Purchase_Indent_Line_Item__c 
                                                      where Purchase_Indent__c =: recordId
                                                      AND Product_Part__c != null];
            if(lst.size() > 0){
                
                String strWareHouseId = lst[0].Purchase_Indent__r.Ware_House__c;
                if(itemsId.size() > 0){
                    for(Purchase_Indent_Line_Item__c obj : lst){
                        if(!itemsId.contains(obj.Id))
                            lstFilterItem.add(obj);
                    }
                }
                else
                   lstFilterItem.addAll(lst);
                    
                        
                for(Purchase_Indent_Line_Item__c obj : lstFilterItem)
                    setId.add(obj.Product_Part__c);
				
				map<Id, Part__c> mapIdVsPart = new map<Id, Part__c>();
				
				 if(setId.size() > 0){
					for(Part__c objPart : [Select Id, Name,Part_Name__c,Usage__c,HSN_CODE__c,List_Price_Standard_price__c,UOI__c
										   from Part__c where Id =:setId])
					{
						mapIdVsPart.put(objPart.Id, objPart);
					}
				}
                
                for(Stock__c objStock : [Select Id, Product_In__c, Product_Out__c, Product_Part__c, Total_Quantity__c,Ware_House__c
                                         from Stock__c 
                                         where Product_Part__c =: setId
                                         And Ware_House__c =: strWareHouseId])
                {                    
                    mapIdvsStock.put(objStock.Product_Part__c, objStock);
                }
                
                for(Purchase_Indent_Line_Item__c obj : lstFilterItem){
                    IndentItemWrapper objwrap = new IndentItemWrapper();
					
					if(mapIdVsPart.containskey(obj.Product_Part__c) && mapIdVsPart.get(obj.Product_Part__c).UOI__c != null)
						obj.UOI_Text__c = mapIdVsPart.get(obj.Product_Part__c).UOI__c;
                    objwrap.objPILI = obj;
                    if(mapIdvsStock.containsKey(obj.Product_Part__c))
                        objwrap.objStock = mapIdvsStock.get(obj.Product_Part__c);
                    lstOIWrapper.add(objwrap);
                }
            }
        }
        return JSON.serialize(lstOIWrapper);
    }
    @AuraEnabled
    public static string getIndentItemsId(String strIndentId){
        List<Id> lstId = new List<Id>();
        if(String.isNotBlank(strIndentId)){
            for(Purchase_Indent_Line_Item__c obj : [Select Id from Purchase_Indent_Line_Item__c where Purchase_Indent__c =: strIndentId])
                lstId.add(obj.Id);
        }
        return JSON.serialize(lstId);
    }
    
    @AuraEnabled
    public static string SavePurchaseOrder(string strMainWrapper){
        mainWrapper objMainWrap = new mainWrapper();
        
        List<Purchase_Order_Line_Item__c> lstPOLI = new List<Purchase_Order_Line_Item__c>();
        try{
            system.debug('strMainWrapper--'+strMainWrapper);
            objMainWrap = (mainWrapper)Json.deserialize(strMainWrapper, mainWrapper.class);
            objMainWrap.success = true;
            if(objMainWrap.objPurchaseOrder != null){
                objMainWrap.objPurchaseOrder.Shipping_Zip_Postal_Code__c=Integer.valueof(objMainWrap.objPurchaseOrder.Shipping_Zip_Postal_Code__c);
                objMainWrap.objPurchaseOrder.Billing_Zip_Postal_Code__c=Integer.valueof(objMainWrap.objPurchaseOrder.Billing_Zip_Postal_Code__c);
                upsert objMainWrap.objPurchaseOrder;
                
                String strPurchaseOrderId =objMainWrap.objPurchaseOrder.Id;
                set<Id> setIdPOLI = new set<Id>();
                List<Purchase_Order_Line_Item__c> DeletePOLIList = new List<Purchase_Order_Line_Item__c>();
                List<Purchase_Order_Line_Item__c> lstSavedPOLI =[Select Id, Name from Purchase_Order_Line_Item__c where Purchase_Order__c =: strPurchaseOrderId];
                
                for(OrderItemWapper objOIW : objMainWrap.lstOIW){
                    Purchase_Order_Line_Item__c obj = new Purchase_Order_Line_Item__c();
                    if(String.isNotBlank(objOIW.strId)){
                        obj.Id = objOIW.strId;
                        setIdPOLI.add(obj.Id);
                    }
                    obj.HSN_Code__c = objOIW.HSNCode;
                    obj.Purchase_Order__c = objMainWrap.objPurchaseOrder.Id;
                    obj.Product_Part__c = objOIW.objPart.Id;
                    obj.Name = objOIW.objPart.Part_Name__c;
                    if(objMainWrap.objPurchaseOrder.Against__c == 'Direct')
                    	obj.UOI_Text__c = objOIW.objPart.UOI__c;
                    else
                        obj.UOI_Text__c = objOIW.UOI;
                    obj.Doc_No__c = objOIW.DocNo;
                    if(objOIW.DocDate != null)
                        obj.Doc_Date__c = objOIW.DocDate.date();
                    obj.Quantity__c = objOIW.Quantity;
                    obj.Sales_Price__c = objOIW.Rate;
                    obj.Discount__c = objOIW.DiscRate;
                    obj.CGST__c = objOIW.CGSTRate;
                    obj.SGST__c = objOIW.SGSTRate;
                    obj.IGST__c = objOIW.IGSTRate;
                    obj.Delivery_Date__c = objOIW.DeliveryDate;
                    obj.Remark__c = objOIW.remarks;
                    obj.Specification__c = objOIW.specification;
                    if(String.isNotBlank(objOIW.strIndentItemId))
                        obj.Purchase_Indent_Line_Item__c = objOIW.strIndentItemId;
                    obj.Application__c = objOIW.application;
                    obj.Stock_Actual__c = objOIW.stockActual;
                    
                    lstPOLI.add(obj);
                }
                if(lstPOLI.size() > 0)
                    upsert lstPOLI;
               
                
                //delete Purchase Order Item
                if(lstSavedPOLI.size()>0){
                    if(setIdPOLI.size() > 0){
                        for(Purchase_Order_Line_Item__c obj : lstSavedPOLI)
                            if(!setIdPOLI.contains(obj.Id))
                                DeletePOLIList.add(obj);
                    }
                    else{
                        DeletePOLIList.addAll(lstSavedPOLI);
                    }
                    if(DeletePOLIList.size() > 0)
                        delete DeletePOLIList;
                }
                //End delete Logic               
               
                set<Id> setIdCharges = new set<Id>();
                List<Charges__c> deleteLStCharges = new List<Charges__c>();
                List<Charges__c> lstSavedCharges = [Select Id , Name from Charges__c where Purchase_Order__c =:strPurchaseOrderId];                
                
                if(objMainWrap.lstTaxDetails.size()> 0){
                    List<Charges__c> lstCharge = new List<Charges__c>();
                    for(TaxDetails td : objMainWrap.lstTaxDetails){
                        Charges__c objCharges = new Charges__c();
                        if(td.ischargeItem){
                            objCharges.Id = td.objcharge.Id;
                            setIdCharges.add(objCharges.Id);
                        } 
                        objCharges.Charges__c = td.strTaxId;
                        objCharges.Charge_Percentage__c = td.TaxPercentage;
                        objCharges.Total_Amount__c = td.TotalAmountAfterDisc;
                        objCharges.IGST__c =td.IGST ;
                        objCharges.SGST__c =td.SGST ;
                        objCharges.CGST__c =td.CGST ;
                        objCharges.Purchase_Order__c = objMainWrap.objPurchaseOrder.Id;
                        lstCharge.add(objCharges);  
                    }
                    upsert lstCharge;
                }
                
                //Delete Charges
                if(lstSavedCharges.size()>0){
                    if(setIdCharges.size() > 0){
                        for(Charges__c obj : lstSavedCharges)
                            if(!setIdCharges.contains(obj.Id))
                                deleteLStCharges.add(obj);
                    }
                    else{
                        deleteLStCharges.addAll(lstSavedCharges);
                    }
                    if(deleteLStCharges.size() > 0)
                        delete deleteLStCharges;
                }
                //End Delete Charges
            }
        }
        catch(DMLException dm){
            objMainWrap.success = false;
            objMainWrap.strErrorMessage = dm.getDmlMessage(0);
        }
        return JSON.serialize(objMainWrap);
    }
    
    /*@AuraEnabled
    public static string getWareHouseDetails(){
        List<Ware_House__c> lstWareHouse = new List<Ware_House__c>();
        set<string> setCity = new set<string>();
        
        for(option objOption : getPickVal(Purchase_Order__c.Bill_To__c.getDescribe()))
            setCity.add(objOption.value);
        for(option objOption : getPickVal(Purchase_Order__c.Ship_To__c.getDescribe()))
            setCity.add(objOption.value);
        
        lstWareHouse = [Select Id, City__c, Contact_No__c,  Contact_Person__c,  Country__c, E_Mail__c,  GSTIN_No__c,State_Code__c,  State_Province__c,  Street__c,Name, Zip_Postal_Code__c  
                                                       From Ware_House__c 
                                                       where City__c =:setCity];
        return JSON.serialize(lstWareHouse);
    }*/
    
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
        public List<OrderItemWapper> lstOIW;
        public List<option> againstPickList;
        public List<option> applicationPickList;
        public List<option> billToPickList;
        public List<option> shipToPickList;
        public List<option> currencyPickList;
        public List<option> UOIPickList;
        public list<option> lstTaxType;
        public list<option> lstPurchaseIndent; //This list hold the the Purchase Indent for Edit mode
        public list<TaxDetails> lstTaxDetails;
        public List<Tax__c> lstTax;
        public Purchase_Order__c objPurchaseOrder;
        //public user objIBUser;
        public boolean isDirect;
        public boolean success;
        public string strErrorMessage;
        
        
        public mainWrapper(){
            lstOIW = new List<OrderItemWapper>();
            againstPickList = new List<option>();
            applicationPickList = new List<option>();
            billToPickList = new List<option>();
            shipToPickList = new List<option>();
            currencyPickList = new List<option>();
            UOIPickList = new List<option>();
            lstPurchaseIndent = new List<option>();
            
            objPurchaseOrder = new Purchase_Order__c();
            lstTaxType = new List<option>();
            lstTaxDetails = new list<TaxDetails>();
            lstTax = new List<Tax__c>();
            isDirect = true;
            success = false;
            strErrorMessage = '';
        }
    }
    
    public class OrderItemWapper{
        public Part__c objPart;
        public string strId;
        public string DocNo;
        public string UOI;
        public Datetime DocDate;    
        public String specification;
        public String strIndentItemId;
        public Integer pandingMRNQty;
        public Decimal stockActual;
        public Decimal IndentQty;
        public Decimal Quantity;
        public String Unit;
        public Decimal Rate;
        public Decimal Amount;
        public Decimal DiscRate;
        public Decimal DiscAmount;
        public Decimal GrossAmount;
        public String HSNCode;
        public Decimal CGSTRate;
        public Decimal CGSTAmount;
        public Decimal SGSTRate;
        public Decimal SGSTAmount;
        public Decimal IGSTRate;
        public Decimal IGSTAmount;
        public Decimal NetAmount;
        public date DeliveryDate;
        public String application;
        public String Remarks;
        public boolean isEdit;
        
        public String strPartErr;
        public String strDeliveryDateErr;
        public String strQuantityErr;
        public String strRateErr;
        public boolean boolShowError;
        
        public OrderItemWapper(){
            objPart = new Part__c();
            strId= '';
            DocNo= '';
            DocDate= null;    
            specification= '';
            strIndentItemId='';
            pandingMRNQty= 0;
            stockActual= 0;
            IndentQty= 0;
            Quantity= 0;
            Unit= '';
            Rate= 0;
            Amount= 0;
            DiscRate= 0;
            DiscAmount= 0;
            GrossAmount= 0;
            HSNCode= '';
            CGSTRate= 0;
            CGSTAmount= 0;
            SGSTRate= 0;
            SGSTAmount= 0;
            IGSTRate= 0;
            IGSTAmount= 0;
            NetAmount= 0;
            DeliveryDate= null;
            application= '';
            Remarks= '';
            isEdit = false;
            
            strPartErr ='';
            strDeliveryDateErr = '';
            strQuantityErr = '';
            strRateErr = '';
            boolShowError = false;
        }
    }
    
    public class IndentItemWrapper{
        Purchase_Indent_Line_Item__c objPILI;
        Stock__c objStock;
        boolean isSelected ;
        
        public IndentItemWrapper(){
            objPILI = new Purchase_Indent_Line_Item__c();
            objStock = new Stock__c();
            isSelected = true;
        }
    }
    
    public class TaxDetails{
        public Tax__c objTax;
        public Charges__c objcharge;
        public string strTaxId;
        public string strTaxName;
        public decimal TaxPercentage;
        public decimal decTaxAmount;
        public decimal CGST;
        public decimal SGST;
        public decimal IGST;
        public decimal NetAmount;
        public Boolean ischargeItem;
        //This Field "TotalAmountAfterDisc" is Used as a rollup summary field which calculate Total amount after discount of Purchase Order Items.
        public decimal TotalAmountAfterDisc;
        public TaxDetails(){
            objTax = new Tax__c();
            objcharge = new Charges__c();
            strTaxId = '';
            strTaxName = '';
            TaxPercentage = 0;
            decTaxAmount = 0;
            CGST = 0;
            SGST = 0;
            IGST = 0;
            NetAmount = 0;
            ischargeItem = false;
            TotalAmountAfterDisc =0;
        }
    }

    public class option
    {
        public string value;
        public string label;
    }

}