public class PerformanceInvoice
{
    public Opportunity__c opp{get;set;} 
    public contact con{get;set;}
    
    public list<contact> conlst{get;set;}
    public Account Acc{get;set;}
   public contact ShippingContact{get;set;}
    
   public list<contact> ShippingCon{get;set;}
     
    
    public Account ShippingAcc{get;set;}
   
    public Pdf_Header__mdt pdfheader{get;set;}
    public decimal totalCgst{get;set;}
    public decimal totalSgst{get;set;}
    public decimal totalIgst{get;set;} 
    public decimal totalTax{get;set;}
    public decimal totalAmountAfterTax{get;set;} 
    public decimal totalAmount{get;set;} 
    public decimal totalAmountNotIncludedTax{get;set;} 
    public string totalAmountaftertaxinWords{get;set;}
    public string sign{get;set;}
    
    public list<Line_item__c> Litem{get;set;}
    
    public string strBillingAddress{get;set;}
    public string strShippingAddress{get;set;}
    
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
     public date lcDate{set;get;}
    public string lcTerm{set;get;}
   
    public decimal amountTCS{get;set;}
    public decimal totalAmountWithTCS{get;set;}
    
    public PerformanceInvoice(ApexPages.StandardController controller)      
    {
        lstCharges= new list<Charges__c>();
        Litem=new list<Line_Item__c>();
        opp=new opportunity__c();
        con=new contact();
        Acc=new Account();
        pdfheader=new Pdf_Header__mdt();
        
        id queryString = ApexPages.currentPage().getParameters().get('id');
        
        
        
        opp=[select Invoice_No__c,Invoice_Date__c,PI_Date__c,PI_Type__c,Reverse_Charges__c,Customer_PO_No__c,PO_Date__c,/*ESN_No1__c,ESN_No1__r.Name
             ,*/Customer_Asset__c,Customer_Asset__r.name,State__c,Place_of_supply_formula__c,Transportation_Mode__c,Transporter_Name__c,Vehicle_Docket_No__c,Quote_Number__c,Quote_Date__c,
             Date_of_Supply__c,Place_of_Supply__c,Shipping_Account__c,Shipping_City__c,Shipping_Country__c,Shipping_Zip_Postal_Code__c,Shipping_State_Province__c,Shipping_Street__c,Ware_House__c,Payment_Terms__c,Contact_Person__c,OEM_Customer__c,Office__c,Proforma_Invoice__c
             ,Ware_House__r.city__c,Ware_House__r.branch__c,LC_Date__c,LC_Term__c,Term_and_Condition__c,OEM_Customer__r.ShippingState,OwnerId  from Opportunity__c where id =:queryString limit 1];  
        if(opp.Shipping_Account__c!=null){
        ShippingCon = [select id,name, phone,MobilePhone, email,isPrimary__c from contact where isPrimary__c= true AND Accountid =:opp.Shipping_Account__c limit 1];
        if(ShippingCon.size()>0){
                ShippingContact = ShippingCon[0];
            }
        }
        system.debug('opp'+opp.id);
        system.debug('opp.ShippingStreet'+ opp.Shipping_Street__c);
        system.debug('opp.Shipping_Zip_Postal_Code__c'+ opp.Shipping_Zip_Postal_Code__c);
        system.debug('opp.Shipping_State_Province__c'+ opp.Shipping_State_Province__c);
        system.debug('opp.Shipping_City__c'+ opp.Shipping_City__c);
        system.debug('opp.Shipping_Country__c'+ opp.Shipping_Country__c);
        
        if(opp.LC_Date__c !=null){
           lcDate= opp.LC_Date__c;
        }
        if(opp.LC_Term__c !=null){
            lcTerm=opp.LC_Term__c;
        }
        
        user ur =[SELECT Id,Branch__c,User_Signature__c from user where id =:opp.OwnerId];
        if(ur.User_Signature__c!=null)
        sign = ur.User_Signature__c;
        system.debug(sign);
        System.debug('----'+ur.Branch__c);
        
        //Pdf header data
        string branch = opp.Ware_House__r.branch__c;
        List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
        String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt WHERE Branch__c =:branch Order by Effected_Date__c ASC LIMIT 1';
        pdfheader =  Database.query(pdfHeaderQuery);
        
        
        con = [select id,Name,Email,MobilePhone,Accountid from contact where id=:opp.Contact_Person__c limit 1];
        system.debug('contact'+con.id);
        
        Acc=[select id ,TCS_Charges_Enable__c,GSTIN_No__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingAddress,BillingPostalCode,ShippingCountry,
             ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState,ShippingAddress, name,Billing_State_Code__c,Shipping_State_Code__c from Account where id =:opp.OEM_Customer__c];
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
        strShippingAddress = Acc?.ShippingStreet;
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
        
        
        Litem=[select Application__c,Amount_Formula__c,CGST__c,Delivery_Date__c,Description__c,
               Discount__c,DiscountN__c,Expected_date__c,HSN_Code__c,IGST__c,Name,List_Price__c,Opportunity__c,
               Product_Part__c,Product_Part__r.uom__c,Product_Part__r.HSN_Code__c,Part_Name__c,Unit__c,Quantity__c,Quote__c,Remark__c,
               Saleable_Stock__c,Sales_Order__c,CGST_Amount_Formula__c,IGST_Amount_Formula__c,SGST_Amount_Formula__c,
               Taxable_Amount_Formula__c,Sales_Price__c,Total_Amount_Formula__c,SGST__c,Specification__c,Discount_Amount__c, Product_Part__r.Name,Product_Part__r.Part_Name__c,Net_Amount__c from Line_Item__c where Opportunity__c=:opp.id];
        
         totalCgst=0;
         totalSgst=0;
         totalIgst=0;
         totalAmountAfterTax=0;
         totalTax=0;
         totalAmount =0;
         totalAmountNotIncludedTax=0;
         totalAmountaftertaxinWords ='';

        
        for(Line_Item__c lit : Litem){
            if(lit.CGST_Amount_Formula__c!=null && lit.CGST_Amount_Formula__c >0){
               totalCgst= totalCgst+lit.CGST_Amount_Formula__c;
            }
           
            if(lit.SGST_Amount_Formula__c!=null && lit.SGST_Amount_Formula__c >0){
               totalSgst= totalSgst+lit.SGST_Amount_Formula__c;
            }
            if(lit.IGST_Amount_Formula__c!=null && lit.IGST_Amount_Formula__c >0){
               totalIgst= totalIgst+lit.IGST_Amount_Formula__c;
            }
            if(lit.Net_Amount__c != null && lit.Net_Amount__c >0)
                totalAmount= totalAmount+lit.Net_Amount__c;
                
            if(lit.Taxable_Amount_Formula__c != null && lit.Taxable_Amount_Formula__c >0)
                totalAmountNotIncludedTax = totalAmountNotIncludedTax+lit.Taxable_Amount_Formula__c;
             system.debug('totalIgst'+totalIgst);
        }
        
        totalCgst=totalCgst.round();
        totalSgst=totalSgst.round();
        totalIgst=totalIgst.round();
        totalAmount=totalAmount.round();
        totalAmountNotIncludedTax=totalAmountNotIncludedTax.round();
        
       totalTax= totalIgst+totalSgst+totalCgst;
       totalTax=totalTax.round();
       
        /*if(totalAmount> 0){
            totalAmount= totalAmount.round();
           totalAmountaftertaxinWords = UtilityClass.NoToWord(totalAmount.intValue());
        }*/
        strWareHouseState = '';
        strWareHouseCode = '';
        strWareHouseCity = '';
        list<Ware_House__c> lseWH = new list<Ware_House__c>();
        if(opp != null && opp.ware_house__c != null){
        lseWH = [Select Id, Name, City__c, State_Code__c,State_Province__c  from Ware_House__c where id =: opp.ware_house__c];
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
        lstCharges = [Select Id, name,Charges__c,Charges__r.Name,CGST__c,IGST__c,SGST__c,Total_Amount__c,Quote__c,Opportunity__c,Net_Amount__c,Charge_Amount__c,CGST_Amount__c,SGST_Amount__c,IGST_Amount__c from Charges__c where Opportunity__c =: opp.Id];   
        
        for(Charges__c objCharg : lstCharges)
        {
            TotalAmountWithCharges = TotalAmountWithCharges+objCharg.Net_Amount__c;
            TotalGSTCharges = TotalGSTCharges+ objCharg?.CGST_Amount__c+objCharg?.SGST_Amount__c+objCharg?.IGST_Amount__c;
            totalAmountCgst = totalAmountCgst+objCharg?.CGST_Amount__c;
            totalAmountSgst = totalAmountSgst+objCharg?.SGST_Amount__c;
            totalAmountIgst = totalAmountIgst+objCharg?.IGST_Amount__c;
            totalAmountSumNotIncludedTax = totalAmountSumNotIncludedTax+objCharg?.Charge_Amount__c;
        }
        totalAmountCgst = totalAmountCgst+totalCgst;
        totalAmountCgst=totalAmountCgst.round();
        totalAmountSgst = totalAmountSgst+totalSgst;
        totalAmountSgst=totalAmountSgst.round();
        totalAmountIgst = totalAmountIgst+totalIgst;
        totalAmountIgst=totalAmountIgst.round();
        TotalGSTCharges = totalAmountCgst+totalAmountSgst+totalAmountIgst;
        TotalGSTCharges=TotalGSTCharges.round();
        
        totalAmountSumNotIncludedTax=totalAmountSumNotIncludedTax.round();
        
        TotalAmountWithCharges = TotalAmountWithCharges+totalAmount;
        totalAmountaftertaxinWords = UtilityClass.NoToWord(TotalAmountWithCharges.intValue());
        totalAmountaftertaxinWords = totalAmountaftertaxinWords+' rupees only';
        TotalAmountWithCharges=TotalAmountWithCharges.round();
        totalAmountSumNotIncludedTax = totalAmountSumNotIncludedTax+totalAmountNotIncludedTax;
        totalAmountSumNotIncludedTax=totalAmountSumNotIncludedTax.round();
        
        decimal amountTCSPer = 0;
        amountTCS = 0;
        if(Acc.TCS_Charges_Enable__c ==true)
        {
        amountTCS = ((TotalAmountWithCharges * decimal.valueof(system.label.TCS_Percentage))/100);
       // system.debug('...amountTCS....'+amountTCS/100);
        //amountTCS = (TotalAmountWithCharges-amountTCSPer).setScale(2);
        amountTCS = amountTCS.setScale(2);
        system.debug(amountTCS+'....amountTCSPer.'+amountTCSPer+'....'+TotalAmountWithCharges);
        totalAmountWithTCS = 0;
        totalAmountWithTCS = TotalAmountWithCharges +amountTCS;
        totalAmountWithTCS = totalAmountWithTCS.round();
        
        totalAmountaftertaxinWords = UtilityClass.NoToWord(totalAmountWithTCS.intValue());
        totalAmountaftertaxinWords = totalAmountaftertaxinWords+' rupees only';
        }
        String myGeneratedFileName = opp.Proforma_Invoice__c+'.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename);
    }  
    
    public void updatePIDate()
    {
        id queryString = ApexPages.currentPage().getParameters().get('id');
        
        opp=[select Stage__c,Invoice_No__c,Invoice_Date__c,PI_Date__c,PI_Type__c,Reverse_Charges__c,Customer_PO_No__c,PO_Date__c,Customer_Asset__c,Customer_Asset__r.name,State__c,Transportation_Mode__c,Transporter_Name__c,Vehicle_Docket_No__c,Quote_Number__c,Quote_Date__c,
             Date_of_Supply__c,Place_of_Supply__c,Ware_House__c,Payment_Terms__c,Contact_Person__c,OEM_Customer__c,Office__c,Proforma_Invoice__c
             ,Ware_House__r.city__c,Term_and_Condition__c,OEM_Customer__r.ShippingState  from Opportunity__c where id =:queryString limit 1];  
        system.debug('opp'+opp);
        if(opp.PI_Date__c == null && opp.Stage__c != 'Closed Won'){
            opp.PI_Date__c= system.today();
            update opp;
        }
    }
}