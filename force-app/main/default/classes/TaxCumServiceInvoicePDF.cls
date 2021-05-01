public class TaxCumServiceInvoicePDF {
    
    public Invoice__c objInvoice {get;set;}
    
    public Contact ShippingObjCon {get;set;}
    //public Account objSupplier {get;set;}
    //public Contact objSupplierContact {get;set;}
    public Bank_Details__mdt objBankDetail{get;set;}
    public List<Invoice_Line_Item__c> lstILI {get;set;}
    public decimal subTotalTaxableAmount{get;set;}
    public decimal subTotalAmount{get;set;}
    
    public Pdf_Header__mdt pdfheader{get;set;}
    public list<Charges__c> lstCharges{get;set;}
    
    public decimal subTotalQuatity{get;set;}
    public Decimal SubTotalIGST{get;set;}
    public Decimal SubTotalCGST{get;set;}
    public Decimal SubTotalSGST{get;set;}
    public decimal TotalTaxableAmount{get;set;}
    public decimal TotalAmount{get;set;}
    public String TotalAmountInWords{get;set;}
    public Decimal TotalIGST{get;set;}
    public Decimal TotalCGST{get;set;}
    public Decimal TotalSGST{get;set;}
    public Decimal TotalGST{get;set;}
    public Decimal CGST{get;set;}
    public Decimal SGST{get;set;}
    public Decimal IGST{get;set;}
    public Decimal GSTOnReverseCharge{get;set;}
    public Decimal RoundOffValue{get;set;}
    
    public boolean igstbool {get;set;}
    public list<taxSummary> taxSummarylist {get;set;}
    
    public TaxCumServiceInvoicePDF(ApexPages.StandardController controller){
        String strId = ApexPages.currentPage().getParameters().get('id');
        pdfheader=new Pdf_Header__mdt();
        
        if(String.isNotBlank(strId)){
            objInvoice = new Invoice__c();
            objBankDetail = new Bank_Details__mdt();
            lstILI = new List<Invoice_Line_Item__c>();
            subTotalTaxableAmount = 0;
            subTotalAmount = 0;
            SubTotalIGST = 0;
            SubTotalCGST = 0;
            SubTotalSGST = 0;
            TotalTaxableAmount = 0;
            subTotalQuatity =0 ;
            TotalAmount = 0;
            TotalAmountInWords ='';
            TotalIGST = 0;
            TotalCGST = 0;
            TotalSGST = 0;
            TotalGST = 0;
            CGST =0;
            SGST =0;
            IGST =0;
            GSTOnReverseCharge =0;
            RoundOffValue =0;
            
            List<String> lstInvoiceField = UtilityClass.getAllFields('Invoice__c');
            List<String> lstInvoiceLineItemField = UtilityClass.getAllFields('Invoice_Line_Item__c');
            
            String strInvoiceQuery = 'Select ' +String.Join(lstInvoiceField, ',')+ ',Shipping_Account__r.name,Shipping_Account__r.Shipping_State_Code__c,Shipping_Account__r.Shipping_GSTIN_No__c ,Customer_Name__r.Name,DC_No__r.Sales_Order__r.Ware_House__r.Branch__c,DC_No__r.Sales_Order__r.Ware_House__r.City__c, Contact_Person__r.Name, Contact_Person__r.Email, DC_No__r.Delivery_Note_Number__c From Invoice__c where Id =: strId';
            String strInvoiceLineItemQuery = 'Select ' +String.Join(lstInvoiceLineItemField, ',')+ ',Part_Number__r.Name,Part_Number__r.Part_Name__c,Part_Number__r.UOM__c From Invoice_Line_Item__c where Invoice__c =: strId';            
            
            List<Invoice__c> lstInvoiceOrder =  Database.query(strInvoiceQuery);
            if(lstInvoiceOrder.size() > 0){
                objInvoice = lstInvoiceOrder[0];
                ShippingObjCon = new Contact();
                
                list<Contact> listShippingObjCon = new list<Contact>();
                if(objInvoice.Shipping_Account__c!=null ){
              listShippingObjCon = [select id,name, mobilephone,email,isPrimary__c from contact where isPrimary__c=true AND Accountid =:objInvoice.Shipping_Account__c limit 1];
                    if(listShippingObjCon.size()>0){
                    ShippingObjCon = listShippingObjCon[0];
                    }
                }
                string branch = objInvoice.DC_No__r.Sales_Order__r.Ware_House__r.Branch__c ;
            List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
            String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt WHERE Branch__c =:branch Order by Effected_Date__c ASC LIMIT 1';
            pdfheader =  Database.query(pdfHeaderQuery);
            
                /*if(String.isNotEmpty(objInvoice.Supplier__c)){
                    objSupplier = [Select Id,Name, BillingCity,BillingCountry, BillingPostalCode,BillingState,BillingStreet,GSTIN_No__c ,Billing_State_Code__c,
                                   (Select Id, Email, MobilePhone, Name from contacts ) 
                                   from Account 
                                   where Id =: objInvoice.Supplier__c];
                    if(objSupplier.contacts.size() > 0){
                        objSupplierContact = objSupplier.contacts[0];
                    }
                }*/
                
                    
            }
            
               
            
            map<decimal,decimal> taxsummaryMap = new map<decimal,decimal>();
             igstbool=false;
            lstILI = Database.query(strInvoiceLineItemQuery);
            if(lstILI.size() > 0){
                for(Invoice_Line_Item__c objILI : lstILI){
                    if(objILI.Taxable_Amount__c > 0)
                        subTotalTaxableAmount += objILI.Taxable_Amount__c;
                    if(objILI.Net_Amount__c > 0)
                        subTotalAmount += objILI.Net_Amount__c;
                    if(objILI.IGST_Amount__c > 0)
                        SubTotalIGST += objILI.IGST_Amount__c;
                    if(objILI.CGST_Amount__c > 0)
                        SubTotalCGST += objILI.CGST_Amount__c;
                    if(objILI.SGST_Amount__c > 0)
                        SubTotalSGST += objILI.SGST_Amount__c;
                    if(objILI.Quantity__c > 0)
                        subTotalQuatity += objILI.Quantity__c;
                    if(objILI.CGST__c > 0 )
                        CGST = objILI.CGST__c;
                    if(objILI.SGST__c > 0 )
                        SGST = objILI.SGST__c;
                    if(objILI.IGST__c > 0 ){
                        IGST = objILI.IGST__c;  
                        igstbool=true;
                    }
                      
                    

                    if(taxsummaryMap.isempty() ){
                        if((objILI.SGST__c > 0 && !taxsummaryMap.containskey(objILI.SGST__c))){
                            decimal taxammount =  objILI.Taxable_Amount__c;
                            taxsummaryMap.put(objILI.SGST__c,taxammount);
                            system.debug('SGST empty');
                        }
                        if((objILI.IGST__c > 0  && !taxsummaryMap.containskey(objILI.IGST__c))){
                            decimal taxammount =  objILI.Taxable_Amount__c;
                            taxsummaryMap.put(objILI.IGST__c,taxammount);
                            system.debug('IGST empty');
                        }
                    }
                    else if((objILI.SGST__c > 0 && !taxsummaryMap.containskey(objILI.SGST__c))){
                        decimal taxammount =  objILI.Taxable_Amount__c;
                        taxsummaryMap.put(objILI.SGST__c,taxammount);
                        system.debug('SGST');
                    }
                    else if((objILI.IGST__c > 0  && !taxsummaryMap.containskey(objILI.IGST__c))){
                        decimal taxammount =  objILI.Taxable_Amount__c;
                        taxsummaryMap.put(objILI.IGST__c,taxammount);
                        system.debug('IGST');
                    }
                    else{
                        
                        if(objILI.SGST__c > 0 ){
                            decimal taxammount =  taxsummaryMap.get(objILI.SGST__c)+objILI.Taxable_Amount__c;
                            taxsummaryMap.put(objILI.SGST__c,taxammount);
                            
                        }
                        
                        system.debug(objILI.IGST__c );
                        system.debug(taxsummaryMap.get(objILI.IGST__c));
                        if(objILI.IGST__c > 0 ){
                            decimal taxammount =  taxsummaryMap.get(objILI.IGST__c)+objILI.Taxable_Amount__c;
                            taxsummaryMap.put(objILI.IGST__c,taxammount); 
                            
                        }
                        
                    } 
                }
                
                taxSummarylist = new list<taxSummary>();
                if(!taxsummaryMap.isempty()){
                    list<decimal> key = new list<decimal>();
                    key.addall(taxsummaryMap.keySet());
                    key.sort();
                    for(integer i=0;i < key.size();i++)
                    {
                        taxSummary ts = new taxSummary();
                        ts.percentage = key[i];
                        System.debug(key[i]);
                        ts.taxamount = taxsummaryMap.get(ts.percentage);
                        ts.gstamount = ((ts.percentage*ts.taxamount)/100).setScale(2);
                        taxSummarylist.add(ts);  
                    }
                }
                system.debug('list size '+taxSummarylist.size());
                
                decimal totalAmountCgst = 0;
                decimal totalAmountSgst = 0;
                decimal totalAmountIgst = 0;
                decimal TotalAmountWithCharges = 0;
                List<String> AllChargesFields = UtilityClass.getAllFields('Charges__c');
                String ChargesQuery = 'Select ' +String.Join(AllChargesFields, ',')+ ' ,Charges__r.Name From Charges__c where INVOICE__C =: strId';
                lstCharges = Database.query(ChargesQuery);
                
                TotalTaxableAmount = subTotalTaxableAmount;
                
                
                for(Charges__c objCharg : lstCharges)
                {
                    TotalTaxableAmount = TotalTaxableAmount+objCharg.Charge_Amount__c;
                    totalAmountCgst = totalAmountCgst+objCharg.CGST_Amount__c;
                    totalAmountSgst = totalAmountSgst+objCharg.SGST_Amount__c;
                    totalAmountIgst = totalAmountIgst+objCharg.IGST_Amount__c;
                    TotalAmountWithCharges = TotalAmountWithCharges+objCharg.Net_Amount__c;
                }   
                
                
                
                TotalIGST = (SubTotalIGST+TotalIGST+ totalAmountIgst).setScale(2);
                TotalCGST = (SubTotalCGST+totalAmountCgst+TotalCGST).setScale(2);
                TotalSGST = (SubTotalSGST+totalAmountSgst+TotalSGST).setScale(2);
                TotalGST = TotalIGST+TotalCGST+TotalSGST;
                TotalAmount = subTotalAmount+TotalAmountWithCharges;
                
                if(subTotalTaxableAmount > 0 )
                    GSTOnReverseCharge = ((subTotalTaxableAmount *18 )/100).setScale(2);
                    if(TotalAmount > 0){
                    RoundOffValue =TotalAmount;
                    TotalAmount = TotalAmount.round();
                    RoundOffValue = RoundOffValue - TotalAmount;
                    TotalAmountInWords = 'Rupees '+UtilityClass.NoToWord(TotalAmount.intValue())+' only';
                }
            }
            
            //Get Bank Details
            List<Bank_Details__mdt> lstBankDetails = [select Id, Bank_Name__c, Bank_Account_Number__c, Bank_Address__c, IFC_RTGS_NEFT__c 
                                                      from Bank_Details__mdt 
                                                      order By Created_Date__c Desc];
            if(lstBankDetails.size() > 0)
                objBankDetail = lstBankDetails[0];
            
        }
    } 
    
    public class taxSummary{
        public  Decimal percentage {get;set;}
        public  Decimal taxamount {get;set;}
        public  Decimal gstamount {get;set;}
    }
    
}