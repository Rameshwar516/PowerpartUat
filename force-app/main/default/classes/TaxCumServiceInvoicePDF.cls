public class TaxCumServiceInvoicePDF {
    
    public Invoice__c objInvoice {get;set;}
    //public Account objSupplier {get;set;}
    //public Contact objSupplierContact {get;set;}
    public Bank_Details__mdt objBankDetail{get;set;}
    public List<Invoice_Line_Item__c> lstILI {get;set;}
    public decimal subTotalTaxableAmount{get;set;}
    public decimal subTotalAmount{get;set;}
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
    
    public TaxCumServiceInvoicePDF(ApexPages.StandardController controller){
        String strId = ApexPages.currentPage().getParameters().get('id');
        
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
            
            String strInvoiceQuery = 'Select ' +String.Join(lstInvoiceField, ',')+ ',ESN_No__r.Name,Customer_Name__r.Name, Contact_Person__r.Name, Contact_Person__r.Email, DC_No__r.Delivery_Note_Number__c From Invoice__c where Id =: strId';
            String strInvoiceLineItemQuery = 'Select ' +String.Join(lstInvoiceLineItemField, ',')+ ',Part_Number__r.Name From Invoice_Line_Item__c where Invoice__c =: strId';            
            
            List<Invoice__c> lstInvoiceOrder =  Database.query(strInvoiceQuery);
            if(lstInvoiceOrder.size() > 0){
                objInvoice = lstInvoiceOrder[0];
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
                    if(objILI.IGST__c > 0 )
                        IGST = objILI.IGST__c;
                }
                
                TotalTaxableAmount = subTotalTaxableAmount;
                TotalAmount = subTotalAmount;
                TotalIGST = SubTotalIGST;
                TotalCGST = SubTotalCGST;
                TotalSGST = SubTotalSGST;
                TotalGST = TotalIGST+TotalCGST+TotalSGST;
                
                if(subTotalTaxableAmount > 0 )
                    GSTOnReverseCharge = (subTotalTaxableAmount *18 )/100;
                
                    if(TotalAmount > 0){
                    RoundOffValue =TotalAmount;
                    TotalAmount = TotalAmount.round();
                    RoundOffValue = RoundOffValue - TotalAmount;
                    TotalAmountInWords = UtilityClass.NoToWord(TotalAmount.intValue());
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
    
}