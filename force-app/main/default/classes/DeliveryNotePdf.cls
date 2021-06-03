public class DeliveryNotePdf {
    public Sales_Order_Dispatch_Delivery_Note__c objdlvrynot {get;set;}
    public Contact ShippingObjCon {get;set;}
    public List<Delivery_Note_Line_Item__c> lstDeliverylineitem{get; set;}
    public static List<childwrapper> Deliverylineitemwrapper{get; set;}
    public list<Charges__c> lstCharges{get;set;}
    public Pdf_Header__mdt pdfheader{get;set;}
    public Account objAcc {get;set;}
    public Contact objCon {get;set;}
     public Decimal roundtotalamt{get; set;}
    
    public Decimal GrossTotal{get; set;}
    public Decimal Charges{get; set;}
    public Decimal TCSAmount{get; set;}
    public Decimal NetValue{get; set;}
    public Decimal Quantity{get; set;}
    public string totalAmountinWords{get; set;}
    
    public Decimal subTotalTaxableAmount{get; set;}
    public Decimal SubTotalCGST{get; set;}
    public Decimal SubTotalSGST{get; set;}
    public Decimal SubTotalIGST{get; set;}
    public Decimal subTotalAmount{get; set;}
    
    public Decimal TotalTaxableAmount{get; set;}
    public Decimal FullTotalAmount{get; set;}
    public Decimal TotalCGST{get; set;}
    public Decimal TotalSGST{get; set;}
    public Decimal TotalIGST{get; set;}
    public Decimal TotalGST{get;set;}
    public decimal amountTCS{get;set;}
    public decimal totalAmountWithTCS{get;set;}
    
    public Boolean igstbool{get; set;}
    public list<taxSummary> taxSummarylist {get;set;}
    
    
    public DeliveryNotePdf(ApexPages.StandardController controller){
        String strId = ApexPages.currentPage().getParameters().get('id');
        pdfheader=new Pdf_Header__mdt();
        List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
        String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt Order by Effected_Date__c ASC LIMIT 1';
        pdfheader =  Database.query(pdfHeaderQuery);
        lstCharges= new list<Charges__c>();
        
        GrossTotal = 0;
        Charges = 0;
        TCSAmount = 0;
        NetValue = 0;
        Quantity = 0;
        Decimal totalamount = 0;
        totalAmountinWords = '';
        
        subTotalTaxableAmount = 0;
        subTotalAmount = 0;
        SubTotalIGST = 0;
        SubTotalCGST = 0;
        SubTotalSGST = 0;
        TotalTaxableAmount = 0;
        TotalAmount = 0;
        TotalAmountInWords ='';
        TotalIGST = 0;
        TotalCGST = 0;
        TotalSGST = 0;
        TotalGST = 0;
        map<decimal,decimal> taxsummaryMap = new map<decimal,decimal>();
             igstbool=false;
        
        List<String> AllDeliverynotefield = UtilityClass.getAllFields('Sales_Order_Dispatch_Delivery_Note__c');
        String DeliverynoteQuery = 'Select ' +String.Join(AllDeliverynotefield, ',')+' ,Shipping_Account__r.Name,Shipping_Account__r.Shipping_GSTIN_No__c,Shipping_Account__r.Shipping_State_Code__c,Customer_Party__r.TCS_Charges_Enable__c From Sales_Order_Dispatch_Delivery_Note__c where id =: strId';
        list<Sales_Order_Dispatch_Delivery_Note__c> DeliveryNoteList =  Database.query(DeliverynoteQuery); 
        
        if(DeliveryNoteList.size()>0){
            objdlvrynot =DeliveryNoteList[0];
        }
        if(objdlvrynot.Shipping_Account__c!=null){
            list<contact> conlist = [select id, name,salutation,mobilephone,email ,isPrimary__c from contact where isPrimary__c= true AND Accountid =:objdlvrynot.Shipping_Account__c limit 1];
            
            if(!conlist.isempty())
                ShippingObjCon = conlist[0];
        }
        
        if(String.isNotEmpty(objdlvrynot.Customer_Party__c)){
                String accid = objdlvrynot.Customer_Party__c;
                String strAccount = 'Select Id, Print_Name__c, Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,GSTIN_No__c,Billing_State_Code__c,Shipping_State_Code__c,(Select Id,salutation, Name, Email, MobilePhone from contacts where isPrimary__c = true) from Account where Id = : accid';
                List<Account> lstAcc = Database.query(strAccount);
                if(lstAcc.size() > 0){
                    objAcc = lstAcc[0];
                    if(objAcc.contacts.size()>0)
                        objCon = objAcc.contacts[0];
                }  
            }    
        
        List<String> Chargeritem = UtilityClass.getAllFields('Charges__c');
        String strCharges = 'Select ' +String.Join(Chargeritem, ',')+',Charges__r.name From Charges__c where Delivery_Note__c =: strId';
        System.debug('strChanges--- '+strCharges);
        lstCharges =  Database.query(strCharges); 
        if(!lstCharges.isEmpty())
            for(Charges__c chr:lstCharges){
                Charges = Charges+ chr.Net_Amount__c;
            }
        
        List<String> Deliverylineitem = UtilityClass.getAllFields('Delivery_Note_Line_Item__c');
        String strdeliverylineitemquery = 'Select ' +String.Join(Deliverylineitem, ',')+',Product_Part__r.UOM__c,Product_Part__r.name, Product_Part__r.Part_Name__c, Product_Part__r.HSN_CODE__c,Product_Part__r.Binnumber__c,Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Ware_House__c'+' From Delivery_Note_Line_Item__c where Sales_Order_Dispatch_Delivery_Note__c =: strId';
        lstDeliverylineitem =  Database.query(strdeliverylineitemquery); 
        system.debug('lstDeliverylineitem '+ lstDeliverylineitem[0].Product_Part__r.UOM__c);
        set<string> productid = new set<string>();
        String warehouse = '';
        
        
        if(!lstDeliverylineitem.isempty())
            for(Delivery_Note_Line_Item__c dli :lstDeliverylineitem){
                warehouse = dli.Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Ware_House__c;
                productid.add(dli.Product_Part__c);
            }
        
        
        list<stock__c> lststock = new list<stock__c>();
        List<String> Stockitem = UtilityClass.getAllFields('stock__c');
        String strStock = 'Select ' +String.Join(Stockitem, ',')+' From stock__c WHERE Product_Part__c IN: productid and Ware_House__c =:warehouse';
        lststock =  Database.query(strStock); 
        
        Map<string,stock__c> mapStock = new Map<string,stock__c>();
        
        if(!lststock.isempty())
            for(stock__c stk : lststock){
                mapStock.put(stk.Product_Part__c,stk);
            }
        
        
        
        Deliverylineitemwrapper = new list<childwrapper>();
        if(!lstDeliverylineitem.isempty())
            for(Delivery_Note_Line_Item__c dli :lstDeliverylineitem){
                childwrapper wdli = new childwrapper();
                wdli.objDLI = dli;
                system.debug('dli.Product_Part__c  '+dli.Product_Part__c);
                if(mapStock.containsKey(dli.Product_Part__c)){
                    wdli.binnumber = mapStock.get(dli.Product_Part__c).Bin_Number__c;
                }
                GrossTotal = GrossTotal + dli.Gross_Amount__c;
                Quantity=Quantity+dli.Quantity__c; 
                Deliverylineitemwrapper.add(wdli);
                
                subTotalTaxableAmount = subTotalTaxableAmount+dli.Taxable_Amount__c;
                subTotalAmount = subTotalAmount+dli.Gross_Amount__c;
                SubTotalIGST = SubTotalIGST+dli.IGST_Amount__c;
                SubTotalCGST = SubTotalCGST+dli.CGST_Amount__c;
                SubTotalSGST = SubTotalSGST+dli.SGST_Amount__c;
                TotalTaxableAmount = subTotalTaxableAmount;
                FullTotalAmount = subTotalAmount;
                TotalIGST = SubTotalIGST;
                TotalCGST = SubTotalCGST;
                TotalSGST = SubTotalSGST;
                
                if(dli.IGST__c > 0)
                        igstbool=true;
                
                    if(taxsummaryMap.isempty() ){
                        if((dli.SGST__c > 0 && !taxsummaryMap.containskey(dli.SGST__c))){
                            decimal taxammount =  dli.Taxable_Amount__c;
                            taxsummaryMap.put(dli.SGST__c,taxammount);
                            system.debug('SGST empty');
                        }
                        if((dli.IGST__c > 0  && !taxsummaryMap.containskey(dli.IGST__c))){
                            decimal taxammount =  dli.Taxable_Amount__c;
                            taxsummaryMap.put(dli.IGST__c,taxammount);
                            system.debug('IGST empty');
                        }
                    }
                    else if((dli.SGST__c > 0 && !taxsummaryMap.containskey(dli.SGST__c))){
                        decimal taxammount =  dli.Taxable_Amount__c;
                        taxsummaryMap.put(dli.SGST__c,taxammount);
                        system.debug('SGST');
                    }
                    else if((dli.IGST__c > 0  && !taxsummaryMap.containskey(dli.IGST__c))){
                        decimal taxammount =  dli.Taxable_Amount__c;
                        taxsummaryMap.put(dli.IGST__c,taxammount);
                        system.debug('IGST');
                    }
                    else{  
                        if(dli.SGST__c > 0 ){
                            decimal taxammount =  taxsummaryMap.get(dli.SGST__c)+dli.Taxable_Amount__c;
                            taxsummaryMap.put(dli.SGST__c,taxammount);
                            
                        }
                        if(dli.IGST__c > 0 ){
                            decimal taxammount =  taxsummaryMap.get(dli.IGST__c)+dli.Taxable_Amount__c;
                            taxsummaryMap.put(dli.IGST__c,taxammount);  
                        } 
                    }  
            }
        
         taxSummarylist = new list<taxSummary>();
                if(!taxsummaryMap.isempty()){
                    list<decimal> key = new list<decimal>();
                    key.addall(taxsummaryMap.keySet());
                    for(integer i=0;i < key.size();i++)
                    {
                        taxSummary ts = new taxSummary();
                        ts.percentage = key[i];
                        ts.taxamount = taxsummaryMap.get(ts.percentage);
                        ts.gstamount = ((ts.percentage*ts.taxamount)/100).setScale(2);
                        taxSummarylist.add(ts);  
                    }
                }
        
        lstCharges =  Database.query(strCharges); 
        if(!lstCharges.isEmpty())
            for(Charges__c chr:lstCharges){
                Charges = Charges+ chr.Net_Amount__c;
                TotalTaxableAmount = TotalTaxableAmount+chr.Charge_Amount__c;
                FullTotalAmount = FullTotalAmount+chr.Net_Amount__c;
                TotalIGST = TotalIGST+chr.IGST_Amount__c;
                TotalCGST = TotalCGST+chr.CGST_Amount__c;
                TotalSGST = TotalSGST+chr.SGST_Amount__c;
            }
         roundtotalamt=FullTotalAmount.round();

        totalamount = Charges+GrossTotal;        
        
        if(!DeliveryNoteList.isempty() && DeliveryNoteList[0].Customer_Party__r.TCS_Charges_Enable__c)
            TCSAmount=(totalamount * decimal.valueof(system.label.TCS_Percentage)).setScale(2);
        
        amountTCS=TCSAmount;
        if(objdlvrynot.Without_Pricing__c != true && objdlvrynot.With_Bin_Number__c != true ){
            NetValue = FullTotalAmount+TCSAmount;
        }else{
            NetValue = totalamount+TCSAmount;
        }
        
        totalAmountWithTCS =NetValue.round();
        
        
        totalAmountinWords = UtilityClass.NoToWord(NetValue.intValue());
        totalAmountinWords = 'Rupees '+totalAmountinWords+' only';
    }
    
    public class wrapper{
        public Delivery_Note_Line_Item__c objDLI{get; set;}
    }
    
    public class childwrapper{
        public Delivery_Note_Line_Item__c objDLI{get; set;}
        public string binnumber{get; set;} 
    }
    
    public class taxSummary{
        public  Decimal percentage {get;set;}
        public  Decimal taxamount {get;set;}
        public  Decimal gstamount {get;set;}
    }
}