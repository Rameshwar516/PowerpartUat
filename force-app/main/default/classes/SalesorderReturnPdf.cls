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
     public Decimal totalIGST{get; set;}
     public Decimal totalCgst{get; set;}
     public Decimal totalsgst{get; set;}
     public Decimal overallGst{get; set;}
    public string totalAmountinWords{get; set;}
    
    
    public SalesorderReturnPdf(ApexPages.StandardController controller){
        String strId = ApexPages.currentPage().getParameters().get('id');
        pdfheader=new Pdf_Header__mdt();
        List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
        String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt Order by Effected_Date__c ASC LIMIT 1';
        pdfheader =  Database.query(pdfHeaderQuery);
       
        lstSOR=[select id,name, Shipping_Account__c from Sales_Order_Return__c where id =:strId ];
        
           ApexPages.currentPage().getHeaders().put('content-disposition', 'filename=' +' Sales Order Return -'+lstSOR.name+'.PDF');
                system.debug('strfileName '+' Sales Order Return -'+lstSOR.name);  
        
        if(lstSOR.Shipping_Account__c!=null){
        conlst=[select id,salutation,name,email, Mobilephone from contact where Accountid =:lstSOR.Shipping_Account__c  AND isPrimary__c=true limit 1 ]; 
            if(conlst.size()>0){
        con = conlst[0];
            }
        }
        totalCgst=0;
            totalIGST=0;
            totalsgst=0;
            overallGst=0;
            
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
                totalIGST = totalIGST + dli.IGST_Amount__c;
                totalCgst = totalCgst + dli.CGST_Amount__c;
                totalsgst = totalsgst + dli.SGST_Amount__c;
            }
        totalamount = GrossTotal;
        
        overallGst = overallGst + totalIGST + totalCgst + totalsgst;
        
        NetValue = totalamount.round();
        
        totalAmountinWords = UtilityClass.NoToWord(NetValue.intValue());
        totalAmountinWords = 'Rupees '+totalAmountinWords+' only';
    }
    
}