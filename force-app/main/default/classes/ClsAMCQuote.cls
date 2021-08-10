public class ClsAMCQuote {
    public list<Line_item__c> lineitem{get;set;}
    public Quote__c quot{get;set;}
    public string sign{get;set;}
     public decimal roundAmt{get;set;}
    public decimal totalGatAmount{get;set;}
    
       public Pdf_Header__mdt pdfheader{get;set;}
     //public decimal roundvalue{get;set;}
     //public decimal roundvalues{get;set;}
    
    public ClsAMCQuote(ApexPages.StandardController controller) {
        id queryString = ApexPages.currentPage().getParameters().get('id');
        lineitem= new list<Line_item__c>();
        quot= new Quote__c();
         
          pdfheader=new Pdf_Header__mdt();
        
       
        
        quot=[select id,name ,ownerid,Opportunity__r.Ware_House__r.Branch__c from Quote__c where id=:queryString];
        
          string branch = quot.Opportunity__r.Ware_House__r.Branch__c ;
            List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
            String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt WHERE Branch__c =:branch Order by Effected_Date__c ASC LIMIT 1';
            pdfheader =  Database.query(pdfHeaderQuery);
        
          String pageName = ApexPages.currentPage().getUrl();
            system.debug(' pageName '+pageName);
            
              if(pageName.contains('AMC')  )
            {              
                ApexPages.currentPage().getHeaders().put('content-disposition', 'filename=' +'  AMC Quote - '+quot.Name+'.PDF');
                system.debug('strfileName '+' AMC Quote-'+quot.Name);       
                
            }
        else{
            
                ApexPages.currentPage().getHeaders().put('content-disposition', 'filename=' +'  Service Quote - '+quot.Name+'.PDF');
                system.debug('strfileName '+' Service Quote-'+quot.Name);   
        }
        
         user ur =[SELECT Id,Branch__c,User_Signature__c from user where id =:quot.OwnerId];
        if(!String.isBlank(ur.User_Signature__c))
        sign = ur.User_Signature__c;
        
        if(String.isBlank(ur.User_Signature__c))
        sign =System.Label.Default_User_Sign;
        
        system.debug(sign);
        
        lineitem=[select Application__c,Amount_Formula__c,CGST__c,Delivery_Date__c,Description__c,GST__c,GST_Amount__c,
               Discount__c,DiscountN__c,Expected_date__c,HSN_Code__c,IGST__c,Name,List_Price__c,Opportunity__c,
               Product_Part__c,Product_Part__r.uom__c,Product_Part__r.HSN_Code__c,Part_Name__c,Quantity__c,Quote__c,Remark__c,
               Saleable_Stock__c,Sales_Order__c,CGST_Amount_Formula__c,IGST_Amount_Formula__c,SGST_Amount_Formula__c,
               Taxable_Amount_Formula__c,Sales_Price__c,Total_Amount_Formula__c,SGST__c,Part_Serial_No__c,Total_Amount_GST__c,Discount_Amount__c,
               Product_Part__r.Name,Product_Part__r.Part_Name__c,Net_Amount__c from Line_Item__c where Quote__c=:queryString];
        
    }

}