public class PurchaseOrderInvoice
{
    public Purchase_Order__c PurchaseOrd{get;set;} 
    public contact con{get;set;}
    public Account Acc{get;set;}
    public decimal totalCgst{get;set;}
    public decimal totalSgst{get;set;}
    public decimal totalIgst{get;set;} 
    public decimal totalTax{get;set;}
    public decimal totalAmountAfterTax{get;set;} 
    public decimal totalAmount{get;set;} 
    public decimal totalAmountNotIncludedTax{get;set;} 
    public string totalAmountaftertaxinWords{get;set;}
    
    public list<Purchase_Order_Line_Item__c> POLitem{get;set;}
    
    public string strBillingAddress{get;set;}
    public string strWHBillingAddress{get;set;}
    public string strShippingAddress{get;set;}
    public string strWHShippingAddress{get;set;}
    
    public string strBillingState{get;set;}
    public string strBillingCode{get;set;}
    public string strShippingState{get;set;}
    public string strShippingCode{get;set;}
    
    public string strWareHouseState{get;set;}
    public string strWareHouseCode{get;set;}
    public string strWareHouseCity{get;set;}
    
    public list<Charges__c> lstCharges{get;set;}
    public decimal TotalAmountWithCharges{get;set;}
    public decimal TotalGSTCharges{get;set;}
    
    public decimal totalAmountCgst{get;set;}
    public decimal totalAmountSgst{get;set;}
    public decimal totalAmountIgst{get;set;} 
    public decimal totalAmountSumNotIncludedTax{get;set;}
    public string strShipToname {get;set;}
    public PurchaseOrderInvoice(ApexPages.StandardController controller)      
    {
        lstCharges= new list<Charges__c>();
        POLitem=new list<Purchase_Order_Line_Item__c>();
        PurchaseOrd=new Purchase_Order__c();
        con=new contact();
        Acc=new Account();
        
        id queryString = ApexPages.currentPage().getParameters().get('id');
        
        
        PurchaseOrd=[select Id,Name,Against__c,Bill_To__c,Billing_City__c,Billing_Country__c,Billing_State__c,Billing_Street__c,Billing_Zip_Postal_Code__c,Contact_No__c,Contact_person__c,Customer_Name__c,Delivery_Domestic__c,Email__c,Freight_Domestic__c,IGST_Domestic__c,Insurance_Domestic__c,Insurance_Import__c,Local_Supplier__c,Mode_of_Shipping__c,Payment_Domestic__c,Payment_terms__c,PO_Date__c,Purchase_Order_Number__c,Ref_Date__c,Ref_No__c,Ship_To__c,Shipping_City__c,Shipping_Country__c,Shipping_State_Province__c,Shipping_Street__c,Shipping_Terms__c,Shipping_Zip_Postal_Code__c,Supplier__c,Supplier__r.Name,Supplier_Name__c,Transportation_Mode__c,Transporter_Name__c,Ware_House__c,Ware_House__r.Name,CreatedDate,Term_And_Conditions__c,Bill_To_Formula__c,Billing_Street_formula__c,Billing_City_Formula__c,Billing_State_Formula__c,Billing_Country_Formula__c,Shipping_Ware_House__c,Shipping_Ware_House__r.Name,Shipping_Customer__c,Shipping_Customer__r.Name,Ship_To_Formula__c,Shipping_Street_Formula__c,Shipping_City_Formula__c,Shipping_Zip_Postal_Code_Formula__c,Shipping_State_Formula__c,Shipping_Country_Formula__c,Currency__c from Purchase_Order__c where id =:queryString limit 1];  
            
        if(PurchaseOrd.Shipping_Ware_House__c !=null){
            strShipToname = PurchaseOrd.Shipping_Ware_House__r.Name;
        }else{
            strShipToname = PurchaseOrd.Shipping_Customer__r.Name;
        }
        strWHBillingAddress = '';
        if(PurchaseOrd.Bill_To_Formula__c !=null && PurchaseOrd.Bill_To_Formula__c !=''){
            strWHBillingAddress = PurchaseOrd.Bill_To_Formula__c;
        }
        if(PurchaseOrd.Billing_Street_formula__c !=null && PurchaseOrd.Billing_Street_formula__c !=''){
            strWHBillingAddress = strWHBillingAddress+', '+PurchaseOrd.Billing_Street_formula__c;
        }
        if(PurchaseOrd.Billing_City_Formula__c !=null && PurchaseOrd.Billing_City_Formula__c !=''){
            strWHBillingAddress = strWHBillingAddress+', '+PurchaseOrd.Billing_City_Formula__c;
        }
        if(PurchaseOrd.Billing_Zip_Postal_Code__c !=null){
            strWHBillingAddress = strWHBillingAddress+', '+PurchaseOrd.Billing_Zip_Postal_Code__c;
        }
        if(PurchaseOrd.Billing_State_Formula__c !=null && PurchaseOrd.Billing_State_Formula__c !=''){
            strWHBillingAddress = strWHBillingAddress+', '+PurchaseOrd.Billing_State_Formula__c;
        }
        if(PurchaseOrd.Billing_Country_Formula__c !=null && PurchaseOrd.Billing_Country_Formula__c !=''){
            strWHBillingAddress = strWHBillingAddress+', '+PurchaseOrd.Billing_Country_Formula__c;
        }
        
        
        strWHShippingAddress ='';
        if(PurchaseOrd.Ship_To_Formula__c != null && PurchaseOrd.Ship_To_Formula__c !=''){
            strWHShippingAddress = PurchaseOrd.Ship_To_Formula__c;
        }if(PurchaseOrd.Shipping_Street_Formula__c != null && PurchaseOrd.Shipping_Street_Formula__c !=''){
            strWHShippingAddress = strWHShippingAddress+', '+PurchaseOrd.Shipping_Street_Formula__c;
        }if(PurchaseOrd.Shipping_City_Formula__c != null && PurchaseOrd.Shipping_City_Formula__c !=''){
            strWHShippingAddress = strWHShippingAddress+', '+PurchaseOrd.Shipping_City_Formula__c;
        }if(PurchaseOrd.Shipping_Zip_Postal_Code_Formula__c != null && PurchaseOrd.Shipping_Zip_Postal_Code_Formula__c !=''){
            strWHShippingAddress = strWHShippingAddress+', '+PurchaseOrd.Shipping_Zip_Postal_Code_Formula__c;
        }if(PurchaseOrd.Shipping_State_Formula__c != null && PurchaseOrd.Shipping_State_Formula__c !=''){
            strWHShippingAddress = strWHShippingAddress+', '+PurchaseOrd.Shipping_State_Formula__c;
        }if(PurchaseOrd.Shipping_Country_Formula__c != null && PurchaseOrd.Shipping_Country_Formula__c !=''){
            strWHShippingAddress = strWHShippingAddress+', '+PurchaseOrd.Shipping_Country_Formula__c;
        }
        
        system.debug(PurchaseOrd.Id+'opp.....'+PurchaseOrd.Contact_Person__c);
        if(PurchaseOrd.Contact_Person__c !=null)
            con = [select id,Name,Email,MobilePhone,Accountid from contact where id=:PurchaseOrd.Contact_Person__c limit 1];
        
        system.debug('contact'+con.id);
        if(con.Accountid !=null)
            Acc=[select id ,GSTIN_No__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingAddress,BillingPostalCode,ShippingCountry,ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState,ShippingAddress, name,Billing_State_Code__c,Shipping_State_Code__c from Account where id =:con.Accountid];
        
        system.debug('Account'+Acc.id);
        
        strBillingAddress = '';
        strBillingAddress = Acc?.BillingStreet;
        if(strBillingAddress != null && strBillingAddress !='' && Acc.BillingCity != null && Acc.BillingCity !='')
            strBillingAddress = strBillingAddress+', '+Acc.BillingCity;
        else if(Acc.BillingCity != null && Acc.BillingCity !='')
            strBillingAddress = Acc.BillingCity;
            
        if(strBillingAddress != null && strBillingAddress !='' && Acc.BillingState != null && Acc.BillingState !='')
            strBillingAddress = strBillingAddress+', '+Acc.BillingState ;
        else if(Acc.BillingState != null && Acc.BillingState !='')
            strBillingAddress = Acc.BillingState;
        
        if(strBillingAddress != null && strBillingAddress !='' && Acc.BillingPostalCode != null && Acc.BillingPostalCode !='')
            strBillingAddress = strBillingAddress+', '+Acc?.BillingPostalCode  ;
        else if(Acc.BillingPostalCode != null && Acc.BillingPostalCode !='')
            strBillingAddress = Acc.BillingPostalCode ;
            
        if(strBillingAddress != null && strBillingAddress !='' && Acc.BillingCountry != null && Acc.BillingCountry !='')
            strBillingAddress = strBillingAddress+', '+Acc.BillingCountry  ;
        else if(Acc.BillingCountry != null && Acc.BillingCountry !='')
            strBillingAddress = Acc.BillingCountry ;
        
        
        /*
        Billing State And Billing Code, Shipping State and Shipping Code
        */
        
        strBillingState = '';
        strBillingCode = '';
        strShippingState = '';
        strShippingCode = '';
        
        strBillingState = Acc?.BillingState ;
        strBillingCode = Acc?.Billing_State_Code__c ;
        
        strShippingAddress = '';
        strShippingAddress = Acc?.ShippingCity;
        if(strShippingAddress != null && strShippingAddress !='' && Acc.ShippingCity != null && Acc.ShippingCity !='')
            strShippingAddress = strShippingAddress+', '+Acc.ShippingCity;
        else if(Acc.ShippingCity != null && Acc.ShippingCity != '')
            strShippingAddress = Acc.ShippingCity;
            
        if(strShippingAddress != null && strShippingAddress !='' && Acc.ShippingState != null && Acc.ShippingState != '')
            strShippingAddress = strShippingAddress+', '+Acc?.ShippingState ;
        else if(Acc.ShippingState != null && Acc.ShippingState != '')
            strShippingAddress = Acc.ShippingState;
        
        if(strShippingAddress != null && strShippingAddress !='' && Acc.ShippingPostalCode != null && Acc.ShippingPostalCode != '')
            strShippingAddress = strShippingAddress+', '+Acc.ShippingPostalCode  ;
        else if(Acc.ShippingPostalCode != null && Acc.ShippingPostalCode != '')
            strShippingAddress = Acc.ShippingPostalCode ;
            
        if(strShippingAddress != null && strShippingAddress !='' && Acc.ShippingCountry != null && Acc.ShippingCountry != '')
            strShippingAddress = strShippingAddress+', '+Acc.ShippingCountry  ;
        else if(Acc.ShippingCountry != null && Acc.ShippingCountry != '')
            strShippingAddress = Acc.ShippingCountry ; 
        
            strShippingState = Acc?.ShippingState;
            strShippingCode = Acc?.Shipping_State_Code__c;
        
        if(strShippingAddress == null || strShippingAddress =='')
        {
            strShippingAddress = strBillingAddress;
            strShippingState = Acc?.BillingState;
            strShippingCode = Acc?.Billing_State_Code__c;
        }
        
        
        POLitem=[select Id,Name,Purchase_Order__c,Amount_INR_GBP__c,CGST__c,CGST_Amount__c,CGST_Amount_Formula__c,CGST_Rate__c,Delivery_Date__c,Description__c,Discount__c,Discount_Amount__c,DiscountN__c,Expected_date__c,HSN_Code__c,HSN_SAC__c  ,IGST__c,IGST_Amount__c,IGST_Amount_Formula__c,IGST_Rate__c,Less_Discount_On__c,List_Price__c,Net_Amount_Formula__c,Part_Name__c,Product_Part__c,Specification__c,Product_part_No__c,ProductName__c,Quantity__c,Remark__c,Saleable_Stock__c,Sales_Price__c,SGST__c,SGST_Amount__c,SGST_Amount_Formula__c,SGST_Rate__c,Taxable_Amount_Formula__c,Taxable_Value__c,Total_Amount__c,Unit__c,Unit_Price_INR_GBP__c,Ware_House__c,Product_Part__r.Name,Product_Part__r.Part_Name__c,Product_Part__r.UOM__c,Product_Part__r.HSN_CODE__c from Purchase_Order_Line_Item__c where Purchase_Order__c=:PurchaseOrd.id];
        
         totalCgst=0;
         totalSgst=0;
         totalIgst=0;
         totalAmountAfterTax=0;
         totalTax=0;
         totalAmount =0;
         totalAmountNotIncludedTax=0;
         totalAmountaftertaxinWords ='';

        
        for(Purchase_Order_Line_Item__c lit : POLitem){
            if(lit.CGST_Amount_Formula__c!=null && lit.CGST_Amount_Formula__c >0){
               totalCgst= totalCgst+lit.CGST_Amount_Formula__c;
            }
           
            if(lit.SGST_Amount_Formula__c!=null && lit.SGST_Amount_Formula__c >0){
               totalSgst= totalSgst+lit.SGST_Amount_Formula__c;
            }
            if(lit.IGST_Amount_Formula__c!=null && lit.IGST_Amount_Formula__c >0){
               totalIgst= totalIgst+lit.IGST_Amount_Formula__c;
            }
            if(lit.Net_Amount_Formula__c != null && lit.Net_Amount_Formula__c >0)
                totalAmount= totalAmount+lit.Net_Amount_Formula__c;
                
            if(lit.Taxable_Amount_Formula__c != null && lit.Taxable_Amount_Formula__c >0)
                totalAmountNotIncludedTax = totalAmountNotIncludedTax+lit.Taxable_Amount_Formula__c;
             system.debug('totalIgst'+totalIgst);
        }
        
        totalCgst.round();
        totalSgst.round();
        totalIgst.round();
        totalAmount.round();
        totalAmountNotIncludedTax.round();
        
       totalTax= totalIgst+totalSgst+totalCgst;
       totalTax.round();
       
        /*if(totalAmount> 0){
            totalAmount= totalAmount.round();
           totalAmountaftertaxinWords = UtilityClass.NoToWord(totalAmount.intValue());
        }*/
        strWareHouseState = '';
        strWareHouseCode = '';
        strWareHouseCity = '';
        list<Ware_House__c> lseWH = new list<Ware_House__c>();
        if(PurchaseOrd != null && PurchaseOrd.Billing_City__c != null){
        lseWH = [Select Id, Name, City__c, State_Code__c,State_Province__c  from Ware_House__c where City__c =: PurchaseOrd.Billing_City__c];
            if(lseWH.size()>0 && lseWH[0] != null){
                strWareHouseState = lseWH[0]?.State_Province__c;
                strWareHouseCode = lseWH[0]?.State_Code__c;
                strWareHouseCity = lseWH[0]?.City__c;
            }
        }
         
        TotalAmountWithCharges = 0;
        TotalGSTCharges = 0;
        totalAmountCgst =0;
        totalAmountSgst = 0;
        totalAmountIgst = 0;
        totalAmountSumNotIncludedTax = 0;
        lstCharges = [Select Id, name,Charges__c,Charges__r.Name,CGST__c,IGST__c,SGST__c,Total_Amount__c,Quote__c,Opportunity__c,Net_Amount__c,Charge_Amount__c,CGST_Amount__c,SGST_Amount__c,IGST_Amount__c from Charges__c where Opportunity__c =: PurchaseOrd.Id];   
        
        for(Charges__c objCharg : lstCharges)
        {
            TotalAmountWithCharges = TotalAmountWithCharges+objCharg.Net_Amount__c;
            TotalGSTCharges = TotalGSTCharges+ objCharg?.CGST_Amount__c+objCharg?.SGST_Amount__c+objCharg?.IGST_Amount__c;
            totalAmountCgst = objCharg?.CGST_Amount__c;
            totalAmountSgst = objCharg?.SGST_Amount__c;
            totalAmountIgst = objCharg?.IGST_Amount__c;
            totalAmountSumNotIncludedTax = totalAmountSumNotIncludedTax+objCharg?.Charge_Amount__c;
        }
        totalAmountCgst = totalAmountCgst+totalCgst;
        totalAmountCgst.round();
        totalAmountSgst = totalAmountSgst+totalSgst;
        totalAmountSgst.round();
        totalAmountIgst = totalAmountIgst+totalIgst;
        totalAmountIgst.round();
        TotalGSTCharges = totalAmountCgst+totalAmountSgst+totalAmountIgst;
        TotalGSTCharges.round();
        
        totalAmountSumNotIncludedTax.round();
        
        TotalAmountWithCharges = TotalAmountWithCharges+totalAmount;
        totalAmountaftertaxinWords = UtilityClass.NoToWord(TotalAmountWithCharges.intValue());
        if(PurchaseOrd.Currency__c != 'INR')
       	 	totalAmountaftertaxinWords = totalAmountaftertaxinWords+' '+PurchaseOrd.Currency__c+' only';
        else
            totalAmountaftertaxinWords = 'Rupees '+totalAmountaftertaxinWords+' only';
        TotalAmountWithCharges.round();
        totalAmountSumNotIncludedTax = totalAmountSumNotIncludedTax+totalAmountNotIncludedTax;
        totalAmountSumNotIncludedTax.round();
        
        String myGeneratedFileName = PurchaseOrd.Purchase_Order_Number__c+'.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename);
    }  
    
}