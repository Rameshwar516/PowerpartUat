public class ClassQuotePDf {
    public opportunity__c opp{get;set;}
    public list<contact> con{get;set;}
    
    public contact conBill{get;set;}
    public contact ShippingContact{get;set;}
    
   public list<contact> ShippingCon{get;set;}
    public Quote__c quotee{get;set;}
    public Account Acc{get;set;}
    public Account ShippAcc{get;set;}
    
     public Pdf_Header__mdt pdfheader{get;set;}
    
    public list<Line_item__c> Litem{get;set;}  
    public decimal totaltaxable{get;set;}
    public decimal totalCgst{get;set;}
    public decimal totalIgst{get;set;}
    public decimal totalSgst{get;set;}
    public decimal TotalAMount{get;set;}
    public decimal totalGsttax{get;set;}
    public decimal totalAmountaftertax{get;set;}
    public string totalAmountaftertaxinWords{get;set;}
    public Date dte{get;set;}
    
    public string strBillingAddress{get;set;}
    public string strShippingAddress{get;set;}
    
    public string strBillingState{get;set;}
    public string strBillingCode{get;set;}
    public string strShippingState{get;set;}
    public string strShippingCode{get;set;}
    
    public string strWareHouseState{get;set;}
    public string strWareHouseCode{get;set;}
  //   public string strWareHouseCity{get;set;}
    
    public list<Charges__c> lstCharges{get;set;}
    public decimal TotalAmountWithCharges{get;set;}
    public decimal TotalGSTCharges{get;set;}
    
    public decimal totalAmountCgst{get;set;}
    public decimal totalAmountSgst{get;set;}
    public decimal totalAmountIgst{get;set;} 
    public decimal totalAmountSumNotIncludedTax{get;set;}
    public decimal totalAmountNotIncludedTax{get;set;} 
    public decimal totalTax{get;set;}
    
    public decimal totalTaxAmount{get;set;}
    
    public boolean isWareHouseStateCode{get;set;}
    
    // public List<wrapper> lstSOIW {get; set;}
    //public decimal TotalTaxableAmount{get;set;}
    
    
    public ClassQuotePDf(ApexPages.StandardController controller){
        
        quotee = new Quote__c();
        
        Litem=new list<Line_Item__c>();
        opp=new opportunity__c();
        con=new list<contact>();
        Acc=new Account();
        
         pdfheader=new Pdf_Header__mdt();
        
        String strId = ApexPages.currentPage().getParameters().get('id');
        
        quotee = [select id,Billing_Address__c,Contact_Name__c,Customer_Party__c,Date__c,Email__c,Mobile__c,Opportunity__c,
                  Name,Quote_Type__c,Quote_Validity__c,Shipping_Account__c,Opportunity__r.LC_Date__c,Opportunity__r.Transporter_Name__c,Opportunity__r.LC_Term__c,Delivery_Period__c,Shipping_Address__c ,Quote_Number__c,Customer_Party__r.ShippingState,
                   Quote__c.Opportunity__r.Office__c , Quote__c.Opportunity__r.Ware_House__r.Name,Quote__c.Opportunity__r.Ware_House__r.Branch__c,Quote__c.Opportunity__r.Ware_House__r.City__c
                   from Quote__c where id=:strId limit 1];
        
        system.debug('Quote'+Quotee.id);
        if(quotee.Shipping_Account__c!=null){
        ShippingCon = [select id,name, phone,MobilePhone, email,isPrimary__c from contact where isPrimary__c= true AND Accountid =:quotee.Shipping_Account__c limit 1];
        if(ShippingCon.size()>0){
                ShippingContact = ShippingCon[0];
            }
        }
         string branch = quotee.Opportunity__r.Ware_House__r.Branch__c;
        List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
        String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt WHERE Branch__c =:branch Order by Effected_Date__c ASC LIMIT 1';
        pdfheader =  Database.query(pdfHeaderQuery);
        
         String myGeneratedFileName = quotee?.Quote_Number__c+'.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename);
        if(quotee.Contact_Name__c!=null){
            
        con = [select id,Name,Email,Fax,HomePhone,MobilePhone,Title,Accountid  from contact where id=:quotee.Contact_Name__c limit 1];
        
            if(con.size()>0){
                conBill = con[0];
            }
        }
        Acc=[select id ,GSTIN_No__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingAddress,BillingPostalCode,ShippingCountry,
             ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState,ShippingAddress, name,Shipping_State_Code__c,Billing_State_Code__c from Account where id =:quotee.Customer_Party__c];
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
        
        opp=[select id,Application__c,Contact_Person__c,createdDate,Customer_PO_No__c,OEM_Customer__c,Date_of_Supply__c,Description__c,
             Invoice_Date__c,Invoice_No__c,Opportunity_Close_Date__c,Name,
             Payment_Terms__c,PI_Type__c,Place_of_Supply__c,PO_Date__c,Reason_for_Closed_Lost__c,
             Reference_Number__c,Stage__c,State__c,Transportation_Mode__c,Transporter_Name__c,Vehicle_Docket_No__c from
             opportunity__c where id =: quotee.Opportunity__c];
        system.debug('opportunity'+opp.id) ;       
        //dte='';
        //dte=DATEVALUE(opp.createdDate);
        DateTime dT = opp.createdDate;
        dte = date.newinstance(dT.year(), dT.month(), dT.day());
        
        Litem=[select Application__c,Amount_Formula__c,CGST__c,Delivery_Date__c,Description__c,
               Discount__c,Expected_date__c,HSN_Code__c,IGST__c,Name,List_Price__c,Opportunity__c,
               Product_Part__c,Product_Part__r.uom__c,Product_Part__r.Old_Part__r.Part_Name__c,Product_Part__r.name,Product_Part__r.Part_Name__c,Part_Name__c,Unit__c,Discount_Amount__c  ,Quantity__c,Quote__c,Remark__c,
               Saleable_Stock__c,Sales_Order__c,CGST_Amount_Formula__c,IGST_Amount_Formula__c,SGST_Amount_Formula__c,
               Taxable_Amount_Formula__c,Sales_Price__c,Net_Amount__c,Total_Amount_Formula__c,SGST__c,Specification__c from Line_Item__c where Quote__c=:quotee.id];
        
        if(Litem.size() > 0){
            totalGsttax=0;
            totalAmountaftertax=0;
            totaltaxable=0;
            totalCgst=0;
            totalSgst=0;
            totalIgst=0;
            TotalAMount=0;
            totalAmountaftertaxinWords='';
            
            for(Line_Item__c liobj : Litem){
                if(liobj.Taxable_Amount_Formula__c!=null){
                    totaltaxable=totaltaxable+liobj.Taxable_Amount_Formula__c;
                }
                if(liobj.CGST_Amount_Formula__c!=null){
                    totalCgst=totalCgst+ liobj.CGST_Amount_Formula__c;
                }
                if(liobj.SGST_Amount_Formula__c!=null){
                    totalSgst=totalSgst+ liobj.SGST_Amount_Formula__c;
                }
                if(liobj.IGST_Amount_Formula__c!=null){
                    totalIgst=totalIgst+ liobj.IGST_Amount_Formula__c;
                }
                if(liobj.Net_Amount__c!=null){
                    TotalAMount=TotalAMount+ liobj.Net_Amount__c;
                }
                totalGsttax=totalCgst+totalSgst+totalIgst;
                totalAmountaftertax=TotalAMount+totalGsttax;
                totalAmountaftertax.round();
                if(totalAmountaftertax > 0){
                    totalAmountaftertax = totalAmountaftertax.round();
                    totalAmountaftertaxinWords = UtilityClass.NoToWord(totalAmountaftertax.intValue());
                }
            }
            totalAmountNotIncludedTax = 0;
            totalTax = 0;
            totalTax= totalIgst+totalSgst+totalCgst;
            strWareHouseState = '';
            strWareHouseCode = '';
            list<Ware_House__c> lseWH = new list<Ware_House__c>();
            if(quotee.Opportunity__c != null && quotee.Opportunity__r.ware_house__c != null){
            lseWH = [Select Id, Name, City__c, State_Code__c,State_Province__c  from Ware_House__c where id =: quotee.Opportunity__r.ware_house__c];
                if(lseWH.size()>0 && lseWH[0] != null){
                    strWareHouseState = lseWH[0]?.State_Province__c;
                    strWareHouseCode = lseWH[0]?.State_Code__c;
                }
            }
            
                TotalAmountWithCharges = 0;
                TotalGSTCharges = 0;
                totalAmountCgst =0;
                totalAmountSgst = 0;
                totalAmountIgst = 0;
                totalAmountSumNotIncludedTax = 0.0;
                lstCharges = [Select Id, name,Charges__c,Charges__r.Name,CGST__c,IGST__c,SGST__c,Total_Amount__c,Quote__c,Opportunity__c,Net_Amount__c,Charge_Amount__c,CGST_Amount__c,SGST_Amount__c,IGST_Amount__c from Charges__c where Quote__c =: quotee.Id];   
                
                for(Charges__c objCharg : lstCharges)
                {
                    TotalAmountWithCharges = TotalAmountWithCharges+objCharg.Net_Amount__c;
                    TotalGSTCharges = TotalGSTCharges+ objCharg?.CGST_Amount__c+objCharg?.SGST_Amount__c+objCharg?.IGST_Amount__c;
                    totalAmountCgst = totalAmountCgst+objCharg.CGST_Amount__c;
                    totalAmountSgst = totalAmountSgst+objCharg.SGST_Amount__c;
                    totalAmountIgst = totalAmountIgst+objCharg.IGST_Amount__c;
                    totalAmountSumNotIncludedTax = totalAmountSumNotIncludedTax+objCharg?.Charge_Amount__c;
                    system.debug('....totalAmountIgst.....'+totalAmountIgst);
                }
                totalAmountCgst = totalAmountCgst+totalCgst;
                totalAmountCgst=totalAmountCgst.round();
                totalAmountSgst = totalAmountSgst+totalSgst;
                totalAmountSgst=totalAmountSgst.round();
                totalAmountIgst = totalAmountIgst+totalIgst;
                totalAmountIgst=totalAmountIgst.round();
                totalTaxAmount = 0;
                system.debug('....totalAmountIgstAfterLoop.....'+totalAmountIgst+',,,totalIgst,,'+totalIgst);
                
                totalTaxAmount = totalAmountCgst+ totalAmountSgst+ totalAmountIgst;
                totalTaxAmount=totalTaxAmount.round();
                totalAmount=totalAmount.round();
                TotalAmountWithCharges = TotalAmountWithCharges+totalAmount;
                totalAmountaftertaxinWords = UtilityClass.NoToWord(TotalAmountWithCharges.intValue());
                totalAmountaftertaxinWords = totalAmountaftertaxinWords +' rupees only';
                TotalAmountWithCharges=TotalAmountWithCharges.round();
                totalAmountSumNotIncludedTax = totalAmountSumNotIncludedTax+totalAmountNotIncludedTax+totaltaxable; 
                totalAmountSumNotIncludedTax=totalAmountSumNotIncludedTax.round();
                
            //Condition Added for state Code
            string strStateCode = ''; 
             strStateCode = [SELECT Id,Customer_Party__r.Billing_State_Code__c,Opportunity__r.Office__c From Quote__c WHERE id=:strId].Customer_Party__r.Billing_State_Code__c;
             
            isWareHouseStateCode = false;
            for(Ware_House__c wh:[SELECT State_Code__c,State_Province__c FROM Ware_House__c where State_Province__c =: strStateCode]) 
            {
                isWareHouseStateCode = true;
            }
       }
    }
   /* public class wrapper{
        public Line_Item__c liitem{get;set;}
        public decimal TotalTaxableAmount{get; set;}
        
        public wrapper(){
            TotalTaxableAmount=0;
        }
        
    }	*/
    
}