public class AddProductDeliveryNoteControler {
    
    public static WrappMain recordlist {get;set;}
    
    @AuraEnabled 
    public static string productOnLoad(string RecordId)
    {
        recordlist = new WrappMain();
        Boolean booleantrue = true;
        string objname =findObjectNameFromRecordIdPrefix(RecordId);
        Boolean IGST=false;
        list<charges__c> chargeslist = new list<charges__c>();
        list<Delivery_Note_Line_Item__c> lineitemonrecord  = new  list<Delivery_Note_Line_Item__c>();
        set<string> stateset = new set<string>();
        list<Ware_House__c> whlist=[SELECT State_Code__c,State_Province__c FROM Ware_House__c];
        for(Ware_House__c wh:whlist) stateset.add(wh.State_Code__c);
        list<TaxDetails> TaxDetailslist = new list<TaxDetails>();
        String state='';
        state=[SELECT Id,Customer_Party__r.Billing_State_Code__c From Sales_Order_Dispatch_Delivery_Note__c  WHERE id=:RecordId].Customer_Party__r.Billing_State_Code__c;
        lineitemonrecord=[SELECT Accept_QTY__c,Amount__c,Application__c,Assessable_Value__c,Bill_QTY__c,BIN_NO__c,CGST__c,
                          CreatedById,CreatedDate,Delivery_Date__c,Discount_Currency__c,Discount__c,FOLIO_NO__c,
                          Gross_Amount__c,GST__c,HSN_Code__c,Id,IGST__c,IsDeleted,Landing_Rate__c,LastActivityDate,LastModifiedById,
                          LastModifiedDate,List_Price__c,Name,Net_Amount__c,OwnerId,Part_Name__c,Part_Number__c,Pending_MRN_Qty__c,
                          Product_Part__c,Quantity__c,RECEIPT_QTY__c,Remark__c,Sales_Order_Dispatch_Delivery_Note__c,SGST__c,
                          Specification__c,Stock__c,SystemModstamp,Unit_Price__c,Unit__c,Usage__c,Ware_House__c,
                          Product_Part__r.Part_Name__c,Product_Part__r.name FROM Delivery_Note_Line_Item__c WHERE 
                         Sales_Order_Dispatch_Delivery_Note__c =:RecordId];
        chargeslist =[SELECT CGST_Amount__c,CGST__c,Charges__c,Charge_Amount__c,Charge_Percentage__c,CreatedById,CreatedDate,Id,
                      IGST_Amount__c,IGST__c,IsDeleted,LastModifiedById,LastModifiedDate,MRN__c,Name,Net_Amount__c,Opportunity__c,
                      OwnerId,Quote__c,Sales_Order__c,SGST_Amount__c,SGST__c,SystemModstamp,Total_Amount__c,Charges__r.Name FROM Charges__c WHERE
                      Delivery_Note__c =:RecordId ]; 
        list<tax__c> taxlist =[SELECT Basic_Percentage__c,CreatedById,CreatedDate,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,
                               LastReferencedDate,LastViewedDate,Name,OwnerId,SystemModstamp,Tax_Percentage__c FROM Tax__c];
        map<id,tax__c> taxmap = new map<id,tax__c>();
        if(!taxlist.isEmpty()) taxmap.putall(taxlist);
        if(!String.isblank(state)){
            recordlist.statecode = true;
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
                        objTD.ischargeItem = booleantrue;
                    TaxDetailslist.add(objTD);
                } 
            }
            // making same wraper list we using in add part component with line item recod which is on quote/opportunity
            // 
            list<prodwrappChild> lineitemlist = new list<prodwrappChild>();
            if(!lineitemonrecord.isempty()){
                for(Delivery_Note_Line_Item__c objOppPro:lineitemonrecord){
                    prodwrappChild objchild = new prodwrappChild();
                    objchild.DiscountAmount=0; 
                    objchild.totalAmount =objOppPro.Amount__c ;
                    //objchild.TotalAfterDiscount =objOppPro.Taxable_Amount__c ;
                    objOppPro.SGST__c=objOppPro.SGST__c ;
                    objOppPro.CGST__c=objOppPro.CGST__c ;  
                    objOppPro.IGST__c=objOppPro.IGST__c ;
                   //objchild.CGSTAmount=objOppPro.CGST_Amount__c ;
                    //objchild.SGSTAmount=objOppPro.SGST_Amount__c ;
                    //objchild.IGSTAmount=objOppPro.IGST_Amount__c ; 
                    //objchild.NetTotalAmount = objOppPro.Total_Amount__c ;
                    objchild.objProdchild = objOppPro;
                    objchild.PartName = objOppPro.Product_Part__r.Part_Name__c ;
                    objchild.Partnumber= objOppPro.Product_Part__r.name ;
                    objchild.isSelected = booleantrue;
                    objchild.isLineItem = booleantrue;                  
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
            recordlist.success = true;
            recordlist.lstTaxType = new list<TaxType>();
            recordlist.lstTaxDetails = new List<TaxDetails>();
            recordlist.lstCharges = new List<TaxDetails>();
            for(Tax__c objTax : [Select Id,Name,Tax_Percentage__c,Basic_Percentage__c from Tax__c]){
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
                objTD.CGST = 0.00;
                objTD.SGST = 0.00;
                objTD.IGST = 0.00;
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
                    wrapproductId.add(prdwrp.objProdchild.Product_Part__c);
                }
            }
        }
        string objname =findObjectNameFromRecordIdPrefix(recordId);
        system.debug('recordId '+recordId);
        system.debug('obj '+objname);
        list<prodwrappChild> prodwrap = new list<prodwrappChild>();
        String lineitemquery = 'SELECT Application__c,CGST__c,Delivery_Date__c,HSN_Code__c,Id,';
        lineitemquery = lineitemquery + 'IGST__c,List_Price__c,Name,Net_Amount__c,';
        lineitemquery = lineitemquery + ' Product_Part__c,Quantity__c,';
        lineitemquery = lineitemquery + 'Remark__c,Unit_Price__c,';
        lineitemquery = lineitemquery + 'SGST__c,Specification__c,';
        lineitemquery = lineitemquery + 'Unit__c FROM Delivery_Note_Line_Item__c Where  Sales_Order_Dispatch_Delivery_Note__c =:  recordId' ;
        List<Delivery_Note_Line_Item__c> prelineitemrecord = database.query(lineitemquery);
        Set<id> lineitemset = New Set<Id>();
        if(!prelineitemrecord.isEmpty()){
            System.debug('Lineitem available');
            
            for(Delivery_Note_Line_Item__c lnt : prelineitemrecord )
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
            string soql = 'select ' + string.join(leadfieldNames, ', ') +' from ' + objectName ; 
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
                prdwrap.isSelected = false; 
                listproduct.add(prdwrap);
            }
            if(lineitemset.size() > 0){
                wrapproductId.removeall(lineitemset);
            } 
            
            if(wrapproductId.size() > 0 ){
                string soql2 = 'select ' + string.join(leadfieldNames, ',') +' from ' + objectName ; 
                if(filter.trim() != ''){    
                    soql2 += ' where id IN : wrapproductId and ( name Like ' + filter + ' or Part_Name__c LIKE ' + filter + ')';
                } 
                soql2 += 'order by Name limit 10';
                for(Part__c pr :Database.query(soql2)){
                    prodwrapp prdwrap = new prodwrapp(); 
                    prdwrap.objProd = pr;
                    prdwrap.isSelected = true; 
                    listproduct.add(prdwrap);
                }}
            recordlist.lstWrapp=listproduct;
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
            for(Part__c objP : [select id, name,Part_Name__c, List_Price_Standard_price__c, Product_Family__c,GST__c,(SELECT Id,Total_Quantity__c,Ware_House__r.city__c FROM Stocks__r ) from Part__c limit 10]) 
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
            if(prodchild.objProdchild.Product_Part__c == prodwrappobj.objProd.id){
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
    public static string addRecord(string strWrap)
    {
        System.debug('add Record method called');
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        try
        {
            List<prodwrapp> lstWrappNew = objwrap.lstWrapp;
            List<prodwrappChild> lstWrappTwoNew = new List<prodwrappChild>();
            Set<id> lineitemids = new set<id>();
            System.debug('lstWrappNewSz---- '+lstWrappNew.size());
            for( integer i = 0 ; i<lstWrappNew.size();  i++)
            {
                if(lstWrappNew[i].isSelected)
                {
                    prodwrappChild objchild = new prodwrappChild();
                    objchild.isSelected = true;
                    
                    Delivery_Note_Line_Item__c objOppPro = new Delivery_Note_Line_Item__c();
                    objOppPro.List_Price__c = lstWrappNew[i].objProd.List_Price_Standard_price__c;
                    objOppPro.Unit_Price__c = lstWrappNew[i].objProd.List_Price_Standard_price__c;
                    objOppPro.Quantity__c = 1;
                    objOppPro.HSN_Code__c = lstWrappNew[i].objProd.HSN_CODE__c;
                    objOppPro.Product_Part__c = lstWrappNew[i].objProd.id; 
                    objOppPro.Discount__c=0;
                    objchild.DiscountAmount=0; 
                    objchild.totalAmount = Integer.valueOf(objOppPro.Quantity__c*objOppPro.Unit_Price__c);
                    objchild.TotalAfterDiscount = Integer.valueOf(objOppPro.Quantity__c*objOppPro.Unit_Price__c);
                    
                    if(objwrap.igstvalue){
                        objOppPro.SGST__c=0;
                        objOppPro.CGST__c=0;
                        if(lstWrappNew[i].objProd.GST__c != null) objOppPro.IGST__c= lstWrappNew[i].objProd.GST__c;
                        if(lstWrappNew[i].objProd.GST__c == null) objOppPro.IGST__c= 0;
                    }
                    else{
                        if(lstWrappNew[i].objProd.GST__c != null)  objOppPro.SGST__c=(lstWrappNew[i].objProd.GST__c)/2;
                        if(lstWrappNew[i].objProd.GST__c != null)  objOppPro.CGST__c=(lstWrappNew[i].objProd.GST__c)/2;
                        if(lstWrappNew[i].objProd.GST__c == null)  objOppPro.SGST__c=0;
                        if(lstWrappNew[i].objProd.GST__c == null)  objOppPro.CGST__c=0;
                        objOppPro.IGST__c=0;
                    }
                    objchild.CGSTAmount=(Integer.valueOf(objOppPro.Quantity__c*objOppPro.Unit_Price__c)*objOppPro.CGST__c)/100;
                    objchild.SGSTAmount=(Integer.valueOf(objOppPro.Quantity__c*objOppPro.Unit_Price__c)*objOppPro.SGST__c)/100;
                    objchild.IGSTAmount=(Integer.valueOf(objOppPro.Quantity__c*objOppPro.Unit_Price__c)*objOppPro.IGST__c)/100; 
                    objchild.NetTotalAmount = Integer.valueOf(objOppPro.Quantity__c*objOppPro.Unit_Price__c)+objchild.CGSTAmount+objchild.SGSTAmount+objchild.IGSTAmount;
                    objchild.objProdchild = objOppPro;
                    objchild.PartName = lstWrappNew[i].objProd.Part_Name__c;
                    objchild.Partnumber= lstWrappNew[i].objProd.name;
                    System.debug('-idset---'+objwrap.lineitemid);
                    if(objwrap.lineitemid == null)
                    {
                        System.debug('If ProductId---- '+objwrap.lineitemid);
                        lstWrappTwoNew.add(objchild);
                        lineitemids.add(objOppPro.Product_Part__c);  
                        objwrap.lineitemid = lineitemids;
                        System.debug('If Complete--- ');
                        System.debug('contain1 list---- '+objwrap.lineitemid);
                    }
                    else
                    {
                        System.debug('else ProductId---- '+objOppPro.Product_Part__c);
                        if(objwrap.lineitemid.contains(objOppPro.Product_Part__c) == False)
                        {
                            lstWrappTwoNew.add(objchild); 
                            lineitemids.add(objOppPro.Product_Part__c);  
                            objwrap.lineitemid.addall(lineitemids);
                            System.debug('contain2 list---- '+objwrap.lineitemid);
                        }                   
                    }
                    System.debug('After---- '+lstWrappTwoNew);   
                }
            }
            objwrap.success = true;
            if(objwrap.lstWrappTwo == null)
            {
                objwrap.lstWrappTwo = lstWrappTwoNew;
                objwrap.isSelectedProduct =true;
                System.debug('Null Add list---- ');
            }
            else
            {
                objwrap.lstWrappTwo.addall(lstWrappTwoNew);
                objwrap.isSelectedProduct =true;
                System.debug('merge list---- ');
            }    
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage = e.getMessage();
        }
        system.debug('..........'+json.serialize(objwrap));
        return json.serialize(objwrap); 
    }   
    
    @AuraEnabled
    public static string saveRecord(string strWrap, string RecordId,string lstCharges, Decimal decTotalAmount)
    {
        system.debug('Save method called'+'quoteId----- '+RecordId);
        string objname =findObjectNameFromRecordIdPrefix(RecordId);
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        List<TaxDetails> lstTaxDetails = (List<TaxDetails>)Json.deserialize(lstCharges, List<TaxDetails>.Class);
        try
        {
            List<prodwrappChild> OppLineChild = objwrap.lstWrappTwo;
            List<Delivery_Note_Line_Item__c> insertOppProduct = new List<Delivery_Note_Line_Item__c>();
            for(prodwrappChild obj : OppLineChild)
            {
                Delivery_Note_Line_Item__c objOppProduct = obj.objProdchild;
                if(objOppProduct.Quantity__c > 0 && objOppProduct.Unit_Price__c >0)
                {
                    objOppProduct.Sales_Order_Dispatch_Delivery_Note__c = RecordId;
                    insertOppProduct.add(objOppProduct);
                }
            }
            
            System.debug('insertedLineItemsSz--- '+!insertOppProduct.isEmpty());
            if(!insertOppProduct.isEmpty())
            {
                objwrap.success = true;
                System.debug('insertOppDebug---- '+insertOppProduct);
                database.upsert(insertOppProduct,false);
                
                System.debug('insertOppDebugEnd---- ');
                objwrap.strMessage = system.label.Add_Product_Success_Msg;
            }
            
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
                    objCharges.Delivery_Note__c=RecordId;
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
    public static string deleteRecord(string strWrap)
    {      
        prodwrappChild objwrap = (prodwrappChild)Json.deserialize(strWrap, prodwrappChild.class);
        try{
           Delete objwrap.objProdchild;
        }
         catch(exception ex){
                
            }
        return null;
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
    
    
    //This Method get object name base of recordid
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
            
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
            
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){   
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();         
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();    
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
    
    public class WrappMain
    {    
        @AuraEnabled public list<prodwrapp> lstWrapp {get;set;}
        @AuraEnabled public list<prodwrappChild> lstWrappTwo {get;set;}
        @AuraEnabled public list<prodwrappChild> Lineitemonrecord {get;set;}
        @AuraEnabled public set<Id> lineitemid {get;set;}
        @AuraEnabled public set<Id> quoteId {get;set;}
        @AuraEnabled public Boolean isSelectedProduct {get; set;}
        @AuraEnabled public boolean igstvalue {get;set;} 
        @AuraEnabled public string objectname {get;set;}
        @AuraEnabled public boolean success;    
        @AuraEnabled public boolean statecode;
        @AuraEnabled public string strMessage;
        @AuraEnabled public list<TaxType> lstTaxType;
        @AuraEnabled public list<TaxDetails> lstTaxDetails;
        @AuraEnabled public list<TaxDetails> lstTaxDetailsAvailable;
        @AuraEnabled public list<TaxDetails> lstCharges;
    }
    
    public class prodwrapp
    {    
        @AuraEnabled public Part__c objProd{get;set;}
        @AuraEnabled public Boolean isSelected {get; set;}
    }
    public class prodwrappChild
    {
        // public Deal_Product__c objProdchild{get;set;}
        @AuraEnabled public Delivery_Note_Line_Item__c objProdchild{get;set;}
        @AuraEnabled public decimal  totalAmount{get;set;}
        @AuraEnabled public decimal  DiscountAmount{get;set;}
        @AuraEnabled public decimal  TotalAfterDiscount{get;set;}
        @AuraEnabled public decimal  CGSTAmount{get;set;}
        @AuraEnabled public decimal  SGSTAmount{get;set;}
        @AuraEnabled public decimal  IGSTAmount{get;set;}
        @AuraEnabled public decimal  NetTotalAmount{get;set;}
        @AuraEnabled public Boolean isSelected {get; set;}
        @AuraEnabled public Boolean isLineItem {get; set;}
        @AuraEnabled public String Partnumber {get; set;}
        @AuraEnabled public String PartName {get; set;}
        
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