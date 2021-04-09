public class PurchaseOrder {
    public Purchase_Order__c objPO {get;set;}
    public Account objSupplier {get;set;}
    public Contact objSupplierContact {get;set;}
    public Ware_House__c objWHBillTo {get;set;}
    public Ware_House__c objWHShipTo {get;set;}
    //public List<wrapper> lstPOIW {get; set;}
    public List<Purchase_Order_Line_Item__c> lstPOI {get;set;}
    public decimal subTotalTaxableAmount{get;set;}
    public decimal subTotalAmount{get;set;}
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
    
    public PurchaseOrder(ApexPages.StandardController controller){
        String strId = ApexPages.currentPage().getParameters().get('id');
        
        if(String.isNotBlank(strId)){
            
            lstPOI = new List<Purchase_Order_Line_Item__c>();
            objWHBillTo = new Ware_House__c();
            objWHShipTo = new Ware_House__c();
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
            
            List<String> lstPurchaseOrderField = UtilityClass.getAllFields('Purchase_Order__c');
            List<String> lstPurchaseOrderItemField = UtilityClass.getAllFields('Purchase_Order_Line_Item__c');
            
            String strPurchaseOrderQuery = 'Select ' +String.Join(lstPurchaseOrderField, ',')+ ' From Purchase_Order__c where Id =: strId';
            String strPurchaseOrderItemQuery = 'Select ' +String.Join(lstPurchaseOrderItemField, ',')+ ' From Purchase_Order_Line_Item__c where Purchase_Order__c =: strId';
            
            List<Purchase_Order__c> lstPurchaseOrder =  Database.query(strPurchaseOrderQuery);
            if(lstPurchaseOrder.size() > 0){
                objPO = lstPurchaseOrder[0];
                if(String.isNotEmpty(objPO.Supplier__c)){
                    objSupplier = [Select Id,Name, BillingCity,BillingCountry, BillingPostalCode,BillingState,BillingStreet,GSTIN_No__c ,Billing_State_Code__c,
                                   (Select Id, Email, MobilePhone, Name from contacts ) 
                                   from Account 
                                   where Id =: objPO.Supplier__c];
                    if(objSupplier.contacts.size() > 0){
                        objSupplierContact = objSupplier.contacts[0];
                    }
                }
                // Receiver And Consignee Details from wareHouse
                if(String.isNotBlank(objPO.Bill_To__c) && String.isNotBlank(objPO.Ship_To__c)){
                    set<String> setCity = new set<String>();
                    setCity.add(objPO.Bill_To__c);
                    setCity.add(objPO.Ship_To__c);
                    List<Ware_House__c> lstWareHouse = [Select Id, City__c, Contact_No__c,  Contact_Person__c,  Country__c, E_Mail__c,  GSTIN_No__c,State_Code__c,  State_Province__c,  Street__c,Name, Zip_Postal_Code__c  
                                                       From Ware_House__c 
                                                       where City__c =:setCity];
                    for(Ware_House__c objWH : lstWareHouse){
                        if(objPO.Bill_To__c ==  objWH.City__c)
                            objWHBillTo = objWH;
                        if(objPO.Ship_To__c ==  objWH.City__c)
                            objWHShipTo = objWH;
                    }
                }
                    
            }
             
            lstPOI = Database.query(strPurchaseOrderItemQuery);
            if(lstPOI.size() > 0){
                for(Purchase_Order_Line_Item__c objPOLI : lstPOI){
                    if(objPOLI.Taxable_Amount_Formula__c > 0)
                        subTotalTaxableAmount += objPOLI.Taxable_Amount_Formula__c;
                    if(objPOLI.Net_Amount_Formula__c > 0)
                        subTotalAmount += objPOLI.Net_Amount_Formula__c;
                    if(objPOLI.IGST_Amount_Formula__c > 0)
                        SubTotalIGST += objPOLI.IGST_Amount_Formula__c;
                    if(objPOLI.CGST_Amount_Formula__c > 0)
                        SubTotalCGST += objPOLI.CGST_Amount_Formula__c;
                    if(objPOLI.SGST_Amount_Formula__c > 0)
                        SubTotalSGST += objPOLI.SGST_Amount_Formula__c;
                }
                
                TotalTaxableAmount = subTotalTaxableAmount;
                TotalAmount = subTotalAmount;
                TotalIGST = SubTotalIGST;
                TotalCGST = SubTotalCGST;
                TotalSGST = SubTotalSGST;
                TotalGST = TotalIGST+TotalCGST+TotalSGST;
                
                if(TotalAmount > 0){
                    TotalAmount = TotalAmount.round();
                    TotalAmountInWords = UtilityClass.NoToWord(TotalAmount.intValue());
                }
            }
        }
    }   
    
    /*public class wrapper{
        public Purchase_Order_Line_Item__c objPOLI;
        public Decimal CGSTAmount;
        public Decimal SGSTAmount;
        public Decimal IGSTAmount;
        
        public wrapper(){
            objPOLI = new Purchase_Order_Line_Item__c();
            CGSTAmount = 0;
            SGSTAmount = 0;
            IGSTAmount = 0;
        }
        
    }*/

}