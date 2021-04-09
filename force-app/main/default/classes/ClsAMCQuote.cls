public class ClsAMCQuote {
    public list<Line_item__c> lineitem{get;set;}
    public ClsAMCQuote(ApexPages.StandardController controller) {
        id queryString = ApexPages.currentPage().getParameters().get('id');
        lineitem= new list<Line_item__c>();
        
        lineitem=[select Application__c,Amount_Formula__c,CGST__c,Delivery_Date__c,Description__c,GST__c,GST_Amount__c,
               Discount__c,DiscountN__c,Expected_date__c,HSN_Code__c,IGST__c,Name,List_Price__c,Opportunity__c,
               Product_Part__c,Product_Part__r.uom__c,Product_Part__r.HSN_Code__c,Part_Name__c,Unit__c,Quantity__c,Quote__c,Remark__c,
               Saleable_Stock__c,Sales_Order__c,CGST_Amount_Formula__c,IGST_Amount_Formula__c,SGST_Amount_Formula__c,
               Taxable_Amount_Formula__c,Sales_Price__c,Total_Amount_Formula__c,SGST__c,Specification__c,Total_Amount_GST__c,Discount_Amount__c, Product_Part__r.Name,Product_Part__r.Part_Name__c,Net_Amount__c from Line_Item__c where Quote__c=:queryString];
        
    }

}