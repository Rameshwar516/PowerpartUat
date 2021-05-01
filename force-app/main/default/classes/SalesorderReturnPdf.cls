public class SalesorderReturnPdf {
    public Sales_Order_Return__c lstSOR{get; set;}
     public list<Contact> conlst{get; set;}
    public Contact con{get; set;}
    public List<Sales_Order_Return_Line_Item__c> lstSORlineitem{get; set;}
    public Pdf_Header__mdt pdfheader{get;set;}
    public Decimal GrossTotal{get; set;}
    public Decimal TCSAmount{get; set;}
    public Decimal NetValue{get; set;}
    public Decimal Quantity{get; set;}
    public string totalAmountinWords{get; set;}
    
    
    public SalesorderReturnPdf(ApexPages.StandardController controller){
        String strId = ApexPages.currentPage().getParameters().get('id');
        pdfheader=new Pdf_Header__mdt();
        List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
        String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt Order by Effected_Date__c ASC LIMIT 1';
        pdfheader =  Database.query(pdfHeaderQuery);
       
        lstSOR=[select id, Shipping_Account__c from Sales_Order_Return__c where id =:strId ];
        
        conlst=[select id,name,email, Mobilephone from contact where Accountid =:lstSOR.Shipping_Account__c limit 1 ]; 
        con=conlst[0];
        GrossTotal = 0;
        TCSAmount = 0;
        NetValue = 0;
        Quantity = 0;
        Decimal totalamount = 0;
        totalAmountinWords = '';
        
        List<String> SORlineitem = UtilityClass.getAllFields('Sales_Order_Return_Line_Item__c');
        String strSORlineitemquery = 'Select ' +String.Join(SORlineitem, ',')+',Part_Number__r.name,Part_Number__r.uom__c, Part_Number__r.Part_Name__c, Part_Number__r.HSN_CODE__c'+' From Sales_Order_Return_Line_Item__c where Doc_No__c =: strId';
        lstSORlineitem =  Database.query(strSORlineitemquery);  
        if(!lstSORlineitem.isempty())
            for(Sales_Order_Return_Line_Item__c dli :lstSORlineitem){
                GrossTotal = GrossTotal + dli.Net_Amount__c;
            }
        totalamount = GrossTotal;

        NetValue = totalamount;
        
        totalAmountinWords = UtilityClass.NoToWord(NetValue.intValue());
        totalAmountinWords = 'Ruppes '+totalAmountinWords+' only';
    }
    
}