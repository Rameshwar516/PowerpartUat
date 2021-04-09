public class InvoiceComponentController {

    public static WrappMain recordlist {get;set;}
    
    @AuraEnabled 
    public static string productOnLoad(string RecordId)
    {
        recordlist = new WrappMain();
        string warehouse = '';
        string warehousename = '';
        Boolean booleantrue = true;
        Boolean service=false;
        String state='';
        Boolean IGST=false;
        list<charges__c> chargeslist = new list<charges__c>();
        list<TaxDetails> TaxDetailslist = new list<TaxDetails>();
        list<Invoice_Line_Item__c> lineitemonrecord  = new  list<Invoice_Line_Item__c>();
        map<id,tax__c> taxmap = new map<id,tax__c>();
        set<string> stateset = new set<string>();
        list<Ware_House__c> whlist=[SELECT State_Code__c,State_Province__c FROM Ware_House__c];
        for(Ware_House__c wh:whlist) stateset.add(wh.State_Code__c);
        
        List<String> lstInvoiceField = UtilityClass.getAllFields('Invoice__c');
        List<String> lstInvoiceItemField = UtilityClass.getAllFields('Invoice_Line_Item__c');
        List<String> lstChargesField = UtilityClass.getAllFields('Charges__c');
        List<String> lstTaxField = UtilityClass.getAllFields('tax__c');
        String strInvoiceQuery = 'Select ' +String.Join(lstInvoiceField, ',')+' ,DC_No__r.Sales_Order__r.Opportunity__r.isService__c,  Place_of_Supply__r.State_Code__c, Customer_Name__r.Billing_State_Code__c  From Invoice__c where Id =: RecordId';
        String strInvoiceItemQuery = 'Select ' +String.Join(lstInvoiceItemField, ',')+ ' ,Part_Number__r.List_Price_Standard_price__c,Part_Number__r.name, Part_Number__r.Part_Name__c FROM Invoice_Line_Item__c where Invoice__c =: RecordId';
        String strChargesQuery = 'Select ' +String.Join(lstChargesField, ',')+ ' ,Charges__r.Name From Charges__c where Invoice__c =: RecordId';
        String strTaxQuery = 'Select ' +String.Join(lstTaxField, ',')+ ' From tax__c';
        
        Invoice__c InvoiceRecord = Database.query(strInvoiceQuery);
        state =InvoiceRecord.Customer_Name__r.Billing_State_Code__c;
        warehouse =InvoiceRecord.Place_of_Supply__c;
        warehousename=InvoiceRecord.Place_of_Supply__r.State_Code__c;
        service = InvoiceRecord.DC_No__r.Sales_Order__r.Opportunity__r.isService__c;
        if(InvoiceRecord.Status__c=='Approved'){
                recordlist.closed =booleantrue;
            } 
        lineitemonrecord = Database.query(strInvoiceItemQuery);
        chargeslist =  Database.query(strChargesQuery);
        list<tax__c> taxlist = Database.query(strTaxQuery);
        
        
        if(!taxlist.isEmpty())taxmap.putall(taxlist);
        if(!String.isblank(state)){
            recordlist.statecode = true;
            if(!chargeslist.isEmpty()){
                for(Charges__c ch:chargeslist){
                    TaxDetails objTD = new TaxDetails();
                    objTD.objTax = taxmap.get(ch.Charges__c);
                    objTD.strTaxId = ch.Charges__c;
                    objTD.strTaxName = ch.Charges__r.Name;
                    objTD.TaxPercentage = ch.Charge_Percentage__c.setscale(2);
                    objTD.CGST = ch.CGST__c ;
                    objTD.SGST = ch.SGST__c;
                    objTD.IGST = ch.IGST__c;
                    objTD.objcharge = ch;
                    objTD.decTaxAmount =  ch.Total_Amount__c;
                    objTD.NetAmount =  ch.Net_Amount__c;
                        objTD.ischargeItem = booleantrue;
                    TaxDetailslist.add(objTD);
                } 
            }
            // making same wraper list we using in add part component with line item recod which is on quote/opportunity
            // 
            set<string> partidset = new set<string>();
            if(!lineitemonrecord.isempty()){
                for(Invoice_Line_Item__c objOppPro:lineitemonrecord){
                    partidset.add(objOppPro.Part_Number__c);
                }
            }
            list<Stock__c> stlist = [SELECT Id, Total_Quantity__c, Ware_House__r.City__c, Ware_House__r.State_Code__c,Product_Part__c,Total_Unbooked_Quantity__c,Freeze_Quantity__c from Stock__c WHERE Product_Part__c IN:partidset and Ware_House__c =:warehouse];
            map<string,decimal> stcountmap = new map<string,decimal>();
            map<string,stockwrap> stwraptmap = new map<string,stockwrap>();
            
            for(Stock__c st:stlist){
                stockwrap stw = new stockwrap();
                stw.stockamount = st.Total_Quantity__c;
                stw.saleableamount = st.Total_Unbooked_Quantity__c;
                if(st.Freeze_Quantity__c!=null){
                  stw.freezeamount = st.Freeze_Quantity__c;  
                }
                else{
                    stw.freezeamount = 0;
                }
                
                stcountmap.put(st.Product_Part__c,st.Total_Unbooked_Quantity__c);
                stwraptmap.put(st.Product_Part__c,stw);
            }
            // 
            list<prodwrappChild> lineitemlist = new list<prodwrappChild>();
            if(!lineitemonrecord.isempty()){
                for(Invoice_Line_Item__c objOppPro:lineitemonrecord){
                    prodwrappChild objchild = new prodwrappChild();
                    objchild.DiscountAmount=0; 
                    objchild.totalAmount =objOppPro.Amount__c ;
                    objchild.TotalAfterDiscount =objOppPro.Taxable_Amount__c ;
                    objOppPro.SGST__c=objOppPro.SGST__c ;
                    objOppPro.CGST__c=objOppPro.CGST__c ;  
                    objOppPro.IGST__c=objOppPro.IGST__c ;
                    objchild.CGSTAmount=objOppPro.CGST_Amount__c ;
                    objchild.SGSTAmount=objOppPro.SGST_Amount__c ;
                    objchild.IGSTAmount=objOppPro.IGST_Amount__c ; 
                    objchild.NetTotalAmount = objOppPro.Net_Amount__c ;
                    objchild.objProdchild = objOppPro;
                    objchild.PartName = objOppPro.Part_Number__r.Part_Name__c ;
                    objchild.Partnumber= objOppPro.Part_Number__r.name ;
                    objchild.isSelected = booleantrue;
                    objchild.isLineItem = booleantrue;
                   // objchild.stockamount = stcountmap.get(objOppPro.Product_Part__c);
                    objchild.stockamount = stwraptmap.get(objOppPro.Part_Number__c).stockamount;
                    objchild.saleableamount = stwraptmap.get(objOppPro.Part_Number__c).saleableamount;
                    objchild.POamount = stwraptmap.get(objOppPro.Part_Number__c).freezeamount;
                    lineitemlist.add(objchild);
                }
            }            
            if(!stateset.contains(state)) IGST=true;
            
            recordlist.lstWrapp = new list<prodwrapp>(); 
            List<prodwrappChild> lstWrappTwoNew = new List<prodwrappChild>();
            recordlist.Lineitemonrecord = lineitemlist; 
            recordlist.lstTaxDetailsAvailable = TaxDetailslist;
            recordlist.lstWrappTwo = lineitemlist;
            recordlist.lineitemid = new set<id>();
            recordlist.quoteId = new set<Id>();
            recordlist.isSelectedProduct = false;
            recordlist.quoteId.add(RecordId);
            recordlist.igstvalue=IGST;
            recordlist.isService =service;
            recordlist.success = true;
            recordlist.lstTaxType = new list<TaxType>();
            recordlist.lstTaxDetails = new List<TaxDetails>();
            recordlist.lstCharges = new List<TaxDetails>();
            for(Tax__c objTax : [Select Id,Name,Tax_Percentage__c,Basic_Percentage__c,CGST__c,SGST__c,IGST__c from Tax__c]){
                TaxType objTaxT = new TaxType();
                objTaxT.value = objTax.Name;
                objTaxT.id = objTax.id;
                recordlist.lstTaxType.add(objTaxT);
                TaxDetails objTD = new TaxDetails();
                objTD.objTax = objTax;
                objTD.strTaxId = objTax.Id;
                objTD.strTaxName = objTax.Name;
                objTD.TaxPercentage = objTax.Tax_Percentage__c;
                objTD.decTaxAmount = 0.00;
                if(recordlist.igstvalue){
                    objTD.CGST = 0;
                    objTD.SGST = 0;
                    objTD.IGST = objTax.IGST__c;
                }
                else{
                    objTD.CGST = objTax.CGST__c;
                    objTD.SGST = objTax.SGST__c;
                    objTD.IGST = 0;  
                }
                objTD.NetAmount =0.00;
                recordlist.lstTaxDetails.add(objTD);
            }
        }
        else{
            recordlist.statecode = false;
        }
        system.debug('....recordlist...'+recordlist);
        return json.serialize(recordlist);
    }
    @AuraEnabled
    public static String getSearchProduct(string objectName, string queryText,String objwrap,String recordId)
    {
        Set<id> wrapproductId = New Set<Id>(); 
        System.debug('recordId');
        WrappMain oldwrap = new WrappMain();
        oldwrap = (WrappMain)Json.deserialize(objwrap, WrappMain.class);
        System.debug('oldwrap.lstWrapp '+oldwrap.lstWrappTwo);
        if(oldwrap.lstWrappTwo != null){
            for(prodwrappChild prdwrp : oldwrap.lstWrappTwo){
                if(prdwrp.isSelected = true){
                    wrapproductId.add(prdwrp.objProdchild.Part_Number__c);
                }
            }
        }
        list<prodwrappChild> prodwrap = new list<prodwrappChild>();
        List<Sales_Order_Line_Item__c> prelineitemrecord = [SELECT Amount__c,CGST__c,CreatedById,CreatedDate,Description__c,
                                                            Discount_Amount__c,Discount__c,Expected_Date__c,GST__c,HSN_Code__c,Id,IGST__c,Name,OwnerId,
                                                            Product_Part__c,Quantity__c,Sales_Order__c,SGST__c,Taxable_Amount__c,Total_Amount__c,
                                                            Unit_Price__c,Product_Part__r.name,Unit__c FROM Sales_Order_Line_Item__c Where  Sales_Order__c = :recordId];
        
        Set<id> lineitemset = New Set<Id>();
        if(!prelineitemrecord.isEmpty()){
            for(Sales_Order_Line_Item__c lnt : prelineitemrecord )
            {
                lineitemset.add(lnt.Product_Part__c);
                wrapproductId.add(lnt.Product_Part__c); 
            }
        } 
        recordlist = new WrappMain();
        recordlist.lstWrapp = new list<prodwrapp>();
        list<prodwrapp> listproduct= new list<prodwrapp>();
        try
        {
            string filter = '';
            set<Id> setProductId = new set<Id>(); 
            if(queryText != null && queryText.trim() !='')
                filter = ' \''+ string.escapeSingleQuotes(queryText) + '%\'';
            map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
            Schema.sObjectType sObjType = globalDescription.get(objectName);
            Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
            List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
            
            for(Part__c prdObj :  [select id, name, List_Price_Standard_price__c, Product_Family__c from Part__c limit 10])
            {
                setProductId.add(prdObj.id);
            }
            System.debug('setProductId---- '+setProductId);
            /* Adding the object and filter by name to the soql */
            string soql = 'select ' + string.join(leadfieldNames, ', ') +',(SELECT Id, Total_Quantity__c, Ware_House__r.City__c,Total_Unbooked_Quantity__c from Stocks__r) from ' + objectName ; 
            system.debug('......'+soql);
            if(filter.trim() != ''){
                
                if(wrapproductId.size() > 0 ){
                    soql += ' where id NOT IN : wrapproductId and ( name Like ' + filter + ' or Part_Name__c LIKE ' + filter + ')';
                }
                else{
                    soql += ' where ( name Like ' + filter + ' or Part_Name__c LIKE ' + filter + ')';
                }
            }   
            system.debug('====='+soql);
            soql += 'order by Name limit 10';
            for(Part__c pr :Database.query(soql)){
                prodwrapp prdwrap = new prodwrapp(); 
                prdwrap.objProd = pr;
                if(!pr.stocks__r.isempty()){
                    for(Stock__c st:pr.stocks__r){
                        if(st.Ware_House__r.City__c == 'Gurugram'){
                         prdwrap.Grwr = Integer.valueOf(st.Total_Unbooked_Quantity__c);   
                        }
                        if(st.Ware_House__r.City__c == 'Kolkata'){
                         prdwrap.Klwr = Integer.valueOf(st.Total_Unbooked_Quantity__c);   
                        }
                        
                    }
                }
                prdwrap.isSelected = false; 
                listproduct.add(prdwrap);
            }
            if(lineitemset.size() > 0){
                wrapproductId.removeall(lineitemset);
            } 
            
            if(wrapproductId.size() > 0 ){
                string soql2 = 'select ' + string.join(leadfieldNames, ',') +',(SELECT Id, Total_Quantity__c, Ware_House__r.City__c,Total_Unbooked_Quantity__c from Stocks__r)  from ' + objectName ; 
                if(filter.trim() != ''){    
                    soql2 += ' where id IN : wrapproductId and ( name Like ' + filter + ' or Part_Name__c LIKE ' + filter + ')';
                } 
                soql2 += 'order by Name limit 10';
                for(Part__c pr :Database.query(soql2)){
                    prodwrapp prdwrap = new prodwrapp(); 
                    prdwrap.objProd = pr;
                    if(!pr.stocks__r.isempty()){
                    for(Stock__c st:pr.stocks__r){
                        if(st.Ware_House__r.City__c == 'Gurugram'){
                         prdwrap.Grwr = Integer.valueOf(st.Total_Unbooked_Quantity__c);   
                        }
                        if(st.Ware_House__r.City__c == 'Kolkata'){
                         prdwrap.Klwr = Integer.valueOf(st.Total_Unbooked_Quantity__c);   
                        }
                        
                    }
                }
                    prdwrap.isSelected = true; 
                    listproduct.add(prdwrap);
                }}
            
            
            
            
            set<string> partid = new set<string>();
            for(prodwrapp pd:listproduct){
                partid.add(pd.objProd.id);
            }
            
            list<Part__History> parthistory = [SELECT Field,NewValue,OldValue,ParentId FROM Part__History WHERE ParentId IN: partid];
            
            map<string,string> partoldfieldvalue = new map<string,string>();
            if(!parthistory.isempty())
                for(Part__History ph :parthistory){
                    if(ph.Field =='name'){
                        if(partoldfieldvalue ==null || !partoldfieldvalue.containskey(ph.ParentId) ){
                            String odval = String.valueOf(ph.OldValue);
                            partoldfieldvalue.put(ph.ParentId,odval);
                        }
                        else{
                            String odval = partoldfieldvalue.get(ph.ParentId)+', '+String.valueOf(ph.OldValue);
                            partoldfieldvalue.put(ph.ParentId,odval);
                        }
                    }
                }
            list<prodwrapp> listproductwitholdpart= new list<prodwrapp>();
            for(prodwrapp pd:listproduct){
                pd.oldPartName = partoldfieldvalue.get(pd.objProd.id);
                listproductwitholdpart.add(pd);
            }
            
            recordlist.lstWrapp=listproductwitholdpart;
            recordlist.isSelectedProduct = false;
            recordlist.success = true;
            System.debug('End Search '+json.serialize(recordlist));
            return json.serialize(recordlist);
        }
        catch(Exception ex)
        {
            system.debug('Exception---- '+ex.getMessage());
            return null;
        }
    }
    
    
    @AuraEnabled
    public static string onselectPick(string strWrap)
    {
        System.debug('Select pick method called');
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        try
        { 
            for(Part__c objP : [select id, name, List_Price_Standard_price__c, Product_Family__c,GST__c,Service_Price__c from Part__c limit 10]) 
            {
                prodwrapp objwrapp = new prodwrapp(); 
                objwrapp.objProd = objP;
                objwrapp.isSelected = false;
                objwrap.lstWrapp.add(objwrapp);
            }   
            objwrap.isSelectedProduct = true;
            objwrap.success = true;
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage=e.getMessage();
        }
        system.debug('..........'+json.serialize(objwrap));
        return json.serialize(objwrap);  
    }   
    
    @AuraEnabled
    public static string removeRecord(string strWrap, string prodwrappstr)
    {
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);      
        prodwrapp prodwrappobj = (prodwrapp)Json.deserialize(prodwrappstr, prodwrapp.class);
        List<prodwrappChild> lstWrapplineItem = objwrap.lstWrappTwo;
        List<prodwrapp> lstWrappProduct = objwrap.lstWrapp;
        Set<id> lineitemids = objwrap.lineitemid;
        integer i=0;
        integer x=0;
        for(prodwrappChild prodchild : lstWrapplineItem){
            x++;
            if(prodchild.objProdchild.Part_Number__c == prodwrappobj.objProd.id){
                i=lstWrapplineItem.indexOf(prodchild);
                System.debug('integer i '+i);
            }           
        }
        for(id prodchild : lineitemids){
            if(prodchild == prodwrappobj.objProd.id){
                lineitemids.remove(prodchild);
            }           
        }
        for(prodwrapp prodchild : lstWrappProduct){
            
            if(prodchild.objProd.id == prodwrappobj.objProd.id){
                x=lstWrappProduct.indexOf(prodchild);
                prodchild.isSelected = false;
                System.debug('integer x '+x);
            }           
        }
        System.debug('size '+lstWrapplineItem.size());
        lstWrapplineItem.remove(i);
        objwrap.lstWrapp = lstWrappProduct;
        objwrap.lstWrappTwo =  lstWrapplineItem;
        return json.serialize(objwrap);
    }
    
    @AuraEnabled
    public static string saveRecord(string strWrap, string RecordId,string lstCharges, Decimal decTotalAmount)
    {
        system.debug('Save method called'+'quoteId----- '+RecordId);

        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        List<TaxDetails> lstTaxDetails = (List<TaxDetails>)Json.deserialize(lstCharges, List<TaxDetails>.Class);
        try
        {
            List<prodwrappChild> OppLineChild = objwrap.lstWrappTwo;
            List<Invoice_Line_Item__c> insertOppProduct = new List<Invoice_Line_Item__c>();
            for(prodwrappChild obj : OppLineChild)
            {
                Invoice_Line_Item__c objOppProduct = obj.objProdchild;
                if(objOppProduct.Quantity__c > 0 && objOppProduct.Unit_Price__c >0)
                {
                    objOppProduct.invoice__c = RecordId;
                    insertOppProduct.add(objOppProduct);
                }
            }
            
            System.debug('insertedLineItemsSz--- '+!insertOppProduct.isEmpty());
            if(!insertOppProduct.isEmpty())
            {
                objwrap.success = true;
                database.upsert(insertOppProduct,false);
                objwrap.strMessage = system.label.Add_Product_Success_Msg;
            }
            
            System.debug('lstTaxDetails---- '+lstTaxDetails.size());
            List<Charges__c> lstCharge = new List<Charges__c>();
            if(!lstTaxDetails.isempty()){
                for(TaxDetails td : lstTaxDetails){
                    Charges__c objCharges = new Charges__c();
                    if(td.ischargeItem) objCharges.id = td.objcharge.id;
                    objCharges.Charges__c = td.strTaxId;
                    objCharges.Charge_Percentage__c = td.TaxPercentage;
                    objCharges.Total_Amount__c = decTotalAmount;
                    objCharges.IGST__c =td.IGST ;
                    objCharges.SGST__c =td.SGST ;
                    objCharges.CGST__c =td.CGST ;
                    objCharges.invoice__c=RecordId;
                    lstCharge.add(objCharges);                   
                    system.debug(td.strTaxName+'...strTaxName....'+td.TaxPercentage);
                }
            }
            upsert lstCharge;
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage = e.getMessage();
        }
        
        return json.serialize(objwrap);
    }  

    
     @AuraEnabled
    public static string deltecharges(string strWrap)
    {      
        TaxDetails objwrap = (TaxDetails)Json.deserialize(strWrap, TaxDetails.class);
        try{
           Delete objwrap.objcharge;
        }
         catch(exception ex){
                
            }
        return null;
    }
        
    
    public class WrappMain
    {    
        @AuraEnabled public list<prodwrapp> lstWrapp {get;set;}
        @AuraEnabled public list<prodwrappChild> lstWrappTwo {get;set;}
        @AuraEnabled public set<Id> lineitemid {get;set;}
        @AuraEnabled public set<Id> quoteId {get;set;}
        @AuraEnabled public Boolean isSelectedProduct {get; set;}
        @AuraEnabled public boolean igstvalue {get;set;} 
        @AuraEnabled public string objectname {get;set;}
        @AuraEnabled public boolean success;
        @AuraEnabled public string strMessage;
        @AuraEnabled public list<prodwrappChild> Lineitemonrecord {get;set;}
        @AuraEnabled public boolean statecode;
        @AuraEnabled public list<TaxType> lstTaxType;
        @AuraEnabled public list<TaxDetails> lstTaxDetails;
        @AuraEnabled public list<TaxDetails> lstTaxDetailsAvailable;
        @AuraEnabled public list<TaxDetails> lstCharges;
        @AuraEnabled public boolean closed; 
        @AuraEnabled public string wrname;
        @AuraEnabled public boolean isService; 
    }
    
    public class prodwrapp
    {    
        @AuraEnabled public Part__c objProd{get;set;}
        @AuraEnabled public Boolean isSelected {get; set;}
        @AuraEnabled public Integer Klwr {get;set;}
        @AuraEnabled public Integer GrWr {get;set;}
        @AuraEnabled public string oldPartName {get; set;}
    }
    public class prodwrappChild
    {
        @AuraEnabled public Invoice_Line_Item__c objProdchild{get;set;}
        @AuraEnabled public decimal  totalAmount{get;set;}
        @AuraEnabled public decimal  DiscountAmount{get;set;}
        @AuraEnabled public decimal  TotalAfterDiscount{get;set;}
        @AuraEnabled public decimal  CGSTAmount{get;set;}
        @AuraEnabled public decimal  SGSTAmount{get;set;}
        @AuraEnabled public decimal  IGSTAmount{get;set;}
        @AuraEnabled public decimal  NetTotalAmount{get;set;}
        @AuraEnabled public Boolean isSelected {get; set;}
         @AuraEnabled public String Partnumber {get; set;}
        @AuraEnabled public String PartName {get; set;}
         @AuraEnabled public Boolean isLineItem {get; set;}
        @AuraEnabled public decimal  saleableamount{get;set;}
        @AuraEnabled public decimal  stockamount{get;set;}
        @AuraEnabled public decimal  POamount{get;set;}
        
    }
    
     public class stockwrap{
        @AuraEnabled public decimal stockamount;
        @AuraEnabled public decimal saleableamount;
         @AuraEnabled public decimal freezeamount;
    }
    public class TaxType{
        @AuraEnabled public string id;
        @AuraEnabled public string value;
    }
    public class TaxDetails{
        @AuraEnabled public Tax__c objTax;
        @AuraEnabled public Charges__c objcharge;
        @AuraEnabled public string strTaxId;
        @AuraEnabled public string strTaxName;
        @AuraEnabled public decimal TaxPercentage;
        @AuraEnabled public decimal decTaxAmount;
        @AuraEnabled public decimal CGST;
        @AuraEnabled public decimal SGST;
        @AuraEnabled public decimal IGST;
        @AuraEnabled public decimal NetAmount;
        @AuraEnabled public Boolean ischargeItem {get; set;}
        
    }
    

}