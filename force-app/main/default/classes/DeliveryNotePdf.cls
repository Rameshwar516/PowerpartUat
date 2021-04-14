public class DeliveryNotePdf {
    public Sales_Order_Dispatch_Delivery_Note__c objdlvrynot {get;set;}
    
     public Contact ShippingObjCon {get;set;}
    
    public List<Delivery_Note_Line_Item__c> lstDeliverylineitem{get; set;}
     public static List<childwrapper> Deliverylineitemwrapper{get; set;}
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
        
        List<String> AllDeliverynotefield = UtilityClass.getAllFields('Sales_Order_Dispatch_Delivery_Note__c');
        String DeliverynoteQuery = 'Select ' +String.Join(AllDeliverynotefield, ',')+' ,Shipping_Account__r.Name,Shipping_Account__r.Shipping_GSTIN_No__c,Shipping_Account__r.Shipping_State_Code__c,Customer_Party__r.TCS_Charges_Enable__c From Sales_Order_Dispatch_Delivery_Note__c where id =: strId';
        list<Sales_Order_Dispatch_Delivery_Note__c> DeliveryNoteList =  Database.query(DeliverynoteQuery); 
        
        if(DeliveryNoteList.size()>0){
           objdlvrynot =DeliveryNoteList[0];
        }
        list<contact> conlist = [select id, name,mobilephone,email ,isPrimary__c from contact where isPrimary__c= true AND Accountid =:objdlvrynot.Shipping_Account__c limit 1];
        
        if(!conlist.isempty())
        ShippingObjCon = conlist[0];
        
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
                wdli.binnumber = mapStock.get(dli.Product_Part__c).Bin_Number__c;
                GrossTotal = GrossTotal + dli.Gross_Amount__c;
                Quantity=Quantity+dli.Quantity__c;
                
                Deliverylineitemwrapper.add(wdli);
            }
        totalamount = Charges+GrossTotal;
        
       
        if(!DeliveryNoteList.isempty() && DeliveryNoteList[0].Customer_Party__r.TCS_Charges_Enable__c)
        TCSAmount=(totalamount * decimal.valueof(system.label.TCS_Percentage)).setScale(2);
        
        NetValue = totalamount+TCSAmount;
        
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
}