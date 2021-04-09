public class DeliveryNotePdf {
    public List<Delivery_Note_Line_Item__c> lstDeliverylineitem{get; set;}
     public list<Charges__c> lstCharges{get;set;}
    public Pdf_Header__mdt pdfheader{get;set;}
    public Decimal GrossTotal{get; set;}
    public Decimal Charges{get; set;}
    public Decimal TCSAmount{get; set;}
    public Decimal NetValue{get; set;}
    public Decimal Quantity{get; set;}
    public string totalAmountinWords{get; set;}
    
    
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
        
        List<String> Chargeritem = UtilityClass.getAllFields('Charges__c');
        String strCharges = 'Select ' +String.Join(Chargeritem, ',')+',Charges__r.name From Charges__c where Delivery_Note__c =: strId';
        System.debug('strChanges--- '+strCharges);
        lstCharges =  Database.query(strCharges); 
        if(!lstCharges.isEmpty())
            for(Charges__c chr:lstCharges){
                Charges = Charges+ chr.Net_Amount__c;
            }
        
        List<String> Deliverylineitem = UtilityClass.getAllFields('Delivery_Note_Line_Item__c');
        String strdeliverylineitemquery = 'Select ' +String.Join(Deliverylineitem, ',')+',Product_Part__r.name, Product_Part__r.Part_Name__c, Product_Part__r.HSN_CODE__c,Product_Part__r.Binnumber__c'+' From Delivery_Note_Line_Item__c where Sales_Order_Dispatch_Delivery_Note__c =: strId';
        lstDeliverylineitem =  Database.query(strdeliverylineitemquery);  
        if(!lstDeliverylineitem.isempty())
            for(Delivery_Note_Line_Item__c dli :lstDeliverylineitem){
                GrossTotal = GrossTotal + dli.Gross_Amount__c;
                Quantity=Quantity+dli.Quantity__c;
            }
        totalamount = Charges+GrossTotal;
        TCSAmount=(totalamount * decimal.valueof(system.label.TCS_Percentage)).setScale(2);
        NetValue = totalamount+TCSAmount;
        
        totalAmountinWords = UtilityClass.NoToWord(NetValue.intValue());
        totalAmountinWords = totalAmountinWords+' rupees only';
    }
    
    public class wrapper{
        public Delivery_Note_Line_Item__c objDLI{get; set;}
        
    }
}