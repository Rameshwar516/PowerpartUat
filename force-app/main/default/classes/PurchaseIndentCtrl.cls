public class PurchaseIndentCtrl
{
    public Purchase_Indent__c PurchaseInd{get;set;} 
    public contact con{get;set;}
    public Account Acc{get;set;}
    public list<Purchase_Indent_Line_Item__c> PILitem{get;set;}
    
     public Pdf_Header__mdt pdfheader{get;set;}
    
    
    public PurchaseIndentCtrl(ApexPages.StandardController controller)      
    {
        PILitem=new list<Purchase_Indent_Line_Item__c>();
        PurchaseInd=new Purchase_Indent__c();
        con=new contact();
        Acc=new Account();
        
        id queryString = ApexPages.currentPage().getParameters().get('id');
        pdfheader=new Pdf_Header__mdt();
        
        if(queryString !=null){
            PurchaseInd=[select Id,Name,CreatedDate,Procurement__c,Department__c,Ware_House__r.Branch__c,Ware_House__r.City__c,Indent_Date__c,Indent_By__c,Indent_By__r.Name,Reference_No__c,Reference_Date__c,Purchase_Indent_Number__c,Terms_and_Conditions__c from Purchase_Indent__c where id =:queryString limit 1];  
                 
           string branch = PurchaseInd.Ware_House__r.Branch__c ;
            List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
            String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt WHERE Branch__c =:branch Order by Effected_Date__c ASC LIMIT 1';
            pdfheader =  Database.query(pdfHeaderQuery);
            
            /*system.debug(PurchaseOrd.Id+'opp.....'+PurchaseOrd.Contact_Person__c);
            if(PurchaseOrd.Contact_Person__c !=null)
                con = [select id,Name,Email,MobilePhone,Accountid from contact where id=:PurchaseOrd.Contact_Person__c limit 1];
            
            system.debug('contact'+con.id);
            if(con.Accountid !=null)
                Acc=[select id ,GSTIN_No__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingAddress,BillingPostalCode,ShippingCountry,ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState,ShippingAddress, name,Billing_State_Code__c,Shipping_State_Code__c from Account where id =:con.Accountid];*/
            
         
            PILitem=[select Id,Name,Part_Name__c,Purchase_Indent__c,Product_Part__c,Product_Part__r.Name,Remark__c,QTY__c,Stock_Actual__c,Product_Part__r.UOM__c from Purchase_Indent_Line_Item__c where Purchase_Indent__c=:PurchaseInd.id];
            
         
            String myGeneratedFileName = PurchaseInd.Purchase_Indent_Number__c+'.pdf';
            Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename);
        }
    }  
    
}