public class classPdfCreditNote {
    
    public MRN__c MrndcNote{get;set;}
    
    public Account OEMdcNote{get;set;}
    
    public  DC_Note__c dcNote{get;set;}
    public  list<DC_Note_Line_Item__c> dcNoteLi{get;set;}
    public  Date dte{get;set;}
    public  Sales_Order_Return__c sor{get;set;}
    //public Sales_Order_Return_Line_Item__c sorli{get;set;}
    public decimal totalLiNeItemCgst{get;set;}
    public decimal totalLiNeItemSgst{get;set;}
    public Decimal totalLiNeItemIgst{get;set;}
    public Decimal totalLiNeItemTaxableAMT{get;set;}
    public Decimal totalLiNeItemNetAmt{get;set;}
    public Decimal totalTaxLINEITEMCGSTSGSTIGST{get;set;}
    
    public list<Charges__c> lstCharges{get;set;}
    public decimal totalTaxableValueIncludeChargeAmt1{get;set;}
    public decimal totalCgstIncludeCharge{get;set;}
    public Decimal totalSgstIncludeCharge{get;set;}
    public Decimal totalIgstIncludeCharge{get;set;}
    public Decimal totaltaxableCHSGSTCGSTIGST{get;set;}
     public Decimal totaltaxGstAMount{get;set;}
    
    public Decimal TotalFinalAmountAfterTaxRoundOff{get;set;}
    public String totalAmountaftertaxinWords{get;set;}
    
      public string strBillingAddress{get;set;}
    public string strShippingAddress{get;set;}
    public string strBillingState{get;set;}
    public string strBillingCode{get;set;}
    public string strShippingState{get;set;}
    public string strShippingCode{get;set;}
    
    public classPdfCreditNote(ApexPages.StandardController controller)
    {
        dcNote=new DC_Note__c();
        dcNoteLi=new list<DC_Note_Line_Item__c>();
        sor=new Sales_Order_Return__c();
        
        //  sorli=new Sales_Order_Return_Line_Item__c();
        
        
        String strId = ApexPages.currentPage().getParameters().get('id');
        if(strId!=null){
            
            
            dcNote=[select id,Bill_To_Customer_Name__r.Name,Billing_Address__c,Billing_GSTIN_No__c,Container_No__c,Customer_Party__c,
                    Delivery_Term__c,Detail__c,Dispatch_Address__c,Dispatch_Date__c,Dispatch_No__c,ESN_No__c,Dispatch_To_Customer_Name__r.name,
                    LC_Date__c,LC_Expected_Date__c,createdDate,LC_Term__c,MRN__c,Sales_Order_Return__c,Sales_Order_Return__r.Customer_Party__c,MRN__r.OEM_Customer__c,Payment_Method__c,Shipping_GSTIN_No__c,Name,
                    Voucher_Date__c from DC_Note__c where id =:strId];
            
            DateTime dT = dcNote.createdDate;
            dte = date.newinstance(dT.year(), dT.month(), dT.day());
            
            
            dcNoteLi=[select id,Amount__c,CGST_Amount__c,Part_Number__r.HSN_Code__c,Part_Number__r.Name,CGST__c,Name,Discount_Currency__c,Discount__c,
                      IGST_Amount__c,IGST__c,Part_Name__c,Part_Number__c, Part_Number__r.UOM__c,Quantity__c,SGST_Amount__c,SGST__c,
                      Doc_No__c,Taxable_Amount__c,Net_Amount__c,Total_Amount__c,Unit__c,Unit_Price__c from DC_Note_Line_Item__c where Doc_No__c =:dcNote.id];
            
            if(dcNoteLi.size()>0){
                totalLiNeItemCgst=0;
                totalLiNeItemSgst=0;
                totalLiNeItemIgst=0;
                totalLiNeItemTaxableAMT=0;
                totalLiNeItemNetAmt=0;
                totalTaxLINEITEMCGSTSGSTIGST=0;    
                for(DC_Note_Line_Item__c dcli:dcNoteLi){
                    if(dcli.CGST_Amount__c!=null && dcli.CGST_Amount__c >0){
                        totalLiNeItemCgst= totalLiNeItemCgst+dcli.CGST_Amount__c;
                    }
                    
                    if(dcli.SGST_Amount__c!=null && dcli.SGST_Amount__c >0){
                        totalLiNeItemSgst= totalLiNeItemSgst+dcli.SGST_Amount__c;
                    }
                    if(dcli.IGST_Amount__c!=null && dcli.IGST_Amount__c >0){
                        totalLiNeItemIgst= totalLiNeItemIgst+dcli.IGST_Amount__c;
                    }
                    if(dcli.Net_Amount__c != null && dcli.Net_Amount__c >0)
                        totalLiNeItemNetAmt= totalLiNeItemNetAmt+dcli.Net_Amount__c;
                    
                    if(dcli.Taxable_Amount__c != null && dcli.Taxable_Amount__c >0)
                        totalLiNeItemTaxableAMT = totalLiNeItemTaxableAMT+dcli.Taxable_Amount__c;
                }
                //total of Csgt, Sgst , Igst Tax of line item
                totalTaxLINEITEMCGSTSGSTIGST = totalTaxLINEITEMCGSTSGSTIGST + totalLiNeItemCgst + totalLiNeItemSgst + totalLiNeItemIgst;
                
                // RoundingOff All Amounts
                totalLiNeItemCgst.round();
                totalLiNeItemSgst.round();
                totalLiNeItemIgst.round();
                totalLiNeItemTaxableAMT.round();
                totalLiNeItemNetAmt.round();
                totalTaxLINEITEMCGSTSGSTIGST.round();
                
            }
            totalTaxableValueIncludeChargeAmt1=0;
            totalCgstIncludeCharge=0;
            totalSgstIncludeCharge=0;
            totalIgstIncludeCharge=0;      
            totaltaxableCHSGSTCGSTIGST=0;
            TotalFinalAmountAfterTaxRoundOff=0;
            totaltaxGstAMount=0;
            totalAmountaftertaxinWords='';
            
            lstCharges = [Select Id, name,Charges__c,Charges__r.Name,CGST__c,IGST__c,SGST__c,Total_Amount__c,Quote__c,Opportunity__c,Net_Amount__c,
                          Charge_Amount__c,CGST_Amount__c,SGST_Amount__c,IGST_Amount__c from Charges__c where DC_Note__c =: dcNote.Id];   
            
            for(Charges__c objCharg : lstCharges)
            {
                totalTaxableValueIncludeChargeAmt1 = totalTaxableValueIncludeChargeAmt1+objCharg.Charge_Amount__c;
               // OverAlltotalGstCharge = OverAlltotalGstCharge+ objCharg?.CGST_Amount__c+objCharg?.SGST_Amount__c+objCharg?.IGST_Amount__c;
                totalCgstIncludeCharge =totalCgstIncludeCharge+ objCharg?.CGST_Amount__c;
                totalSgstIncludeCharge =totalSgstIncludeCharge+ objCharg?.SGST_Amount__c;
                totalIgstIncludeCharge = totalIgstIncludeCharge+objCharg?.IGST_Amount__c;
                // totalAmountSumNotIncludedTax = totalAmountSumNotIncludedTax+objCharg?.Charge_Amount__c;
            }  
            
            totalTaxableValueIncludeChargeAmt1 = totalTaxableValueIncludeChargeAmt1 + totalLiNeItemTaxableAMT;
            totalCgstIncludeCharge = totalCgstIncludeCharge + totalLiNeItemCgst;
            totalSgstIncludeCharge = totalSgstIncludeCharge + totalLiNeItemSgst;
            totalIgstIncludeCharge = totalIgstIncludeCharge + totalLiNeItemIgst;
            
            //Total OverAll Gst Amount
            totaltaxGstAMount = totaltaxGstAMount + totalCgstIncludeCharge + totalSgstIncludeCharge + totalIgstIncludeCharge;
            // Final Net Amount Display
            totaltaxableCHSGSTCGSTIGST = totaltaxableCHSGSTCGSTIGST + totalTaxableValueIncludeChargeAmt1 + totalCgstIncludeCharge + totalSgstIncludeCharge + totalIgstIncludeCharge;  
           
            //Final Net AMount Round Off
            TotalFinalAmountAfterTaxRoundOff = TotalFinalAmountAfterTaxRoundOff + totaltaxableCHSGSTCGSTIGST;
            TotalFinalAmountAfterTaxRoundOff.round();
            // Total Amount In Words 
            totalAmountaftertaxinWords = UtilityClass.NoToWord(TotalFinalAmountAfterTaxRoundOff.intValue());
                totalAmountaftertaxinWords = totalAmountaftertaxinWords+' rupees only';
            
            sor=[select id,Bill_To_Customer_Name__c,Billing_Address__c,Billing_GSTIN_No__c,Container_No__c,Customer_Party__c,Dispatch_Address__c,
                 Dispatch_To_Customer_Name__c,MRN__c,Shipping_GSTIN_No__c,Name from Sales_Order_Return__c where id=:dcNote.Sales_Order_Return__c];
            
            //    sorli=[select id,Amount__c,CGST_Amount__c,CGST__c,Discount__c,Discount_Currency__c,Doc_Date__c,Doc_No__c,IGST_Amount__c,IGST__c,
            //         Net_Amount__c,Part_Name__c,Part_Number__c,Quantity__c,SGST_Amount__c,SGST__c,Taxable_Amount__c,Total_Amount__c,Unit__c,
            //       Unit_Price__c from Sales_Order_Return_Line_Item__c where Doc_No__c=: sor.id ];
            
            
           MrndcNote=[select id,OEM_Customer__c ,Contact_Name__c , E_Way_Bill_Date__c,E_Way_Bill_No__c from MRN__c where id=:dcNote.MRN__c];
            
            
            OEMdcNote=[select id ,GSTIN_No__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingAddress,BillingPostalCode,
                       ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState,ShippingAddress, name,Shipping_State_Code__c,
                       ShippingCountry, Billing_State_Code__c from Account where id =:dcNote.Customer_Party__c ];
            
          strBillingAddress = '';
        strBillingAddress = OEMdcNote?.BillingStreet;
        if(strBillingAddress != null && strBillingAddress !='' && OEMdcNote.BillingCity != null && OEMdcNote.BillingCity !='')
            strBillingAddress = strBillingAddress+', '+OEMdcNote.BillingCity;
        else if(OEMdcNote.BillingCity != null && OEMdcNote.BillingCity !='')
            strBillingAddress = OEMdcNote.BillingCity;
            
        if(strBillingAddress != null && strBillingAddress !='' && OEMdcNote.BillingState != null && OEMdcNote.BillingState !='')
            strBillingAddress = strBillingAddress+', '+OEMdcNote.BillingState ;
        else if(OEMdcNote.BillingState != null && OEMdcNote.BillingState !='')
            strBillingAddress = OEMdcNote.BillingState;
       
        if(strBillingAddress != null && strBillingAddress !='' && OEMdcNote.BillingPostalCode != null && OEMdcNote.BillingPostalCode !='')
            strBillingAddress = strBillingAddress+', '+OEMdcNote?.BillingPostalCode  ;
        else if(OEMdcNote.BillingPostalCode != null && OEMdcNote.BillingPostalCode !='')
            strBillingAddress = OEMdcNote.BillingPostalCode ;
            
        if(strBillingAddress != null && strBillingAddress !='' && OEMdcNote.BillingCountry != null && OEMdcNote.BillingCountry !='')
            strBillingAddress = strBillingAddress+', '+OEMdcNote.BillingCountry  ;
        else if(OEMdcNote.BillingCountry != null && OEMdcNote.BillingCountry !='')
            strBillingAddress = OEMdcNote.BillingCountry ;
        
 /*
        Billing State And Billing Code, Shipping State and Shipping Code
        */
        strBillingState = '';
        strBillingCode = '';
        strShippingState = '';
        strShippingCode = '';
        
        strBillingState = OEMdcNote?.BillingState ;
        strBillingCode = OEMdcNote?.Billing_State_Code__c ;
        
        strShippingAddress = '';
        strShippingAddress = OEMdcNote?.ShippingCity;
        if(strShippingAddress != null && strShippingAddress !='' && OEMdcNote.ShippingCity != null && OEMdcNote.ShippingCity !='')
            strShippingAddress = strShippingAddress+', '+OEMdcNote.ShippingCity;
        else if(OEMdcNote.ShippingCity != null && OEMdcNote.ShippingCity != '')
            strShippingAddress = OEMdcNote.ShippingCity;
            
        if(strShippingAddress != null && strShippingAddress !='' && OEMdcNote.ShippingState != null && OEMdcNote.ShippingState != '')
            strShippingAddress = strShippingAddress+', '+OEMdcNote?.ShippingState ;
        else if(OEMdcNote.ShippingState != null && OEMdcNote.ShippingState != '')
            strShippingAddress = OEMdcNote.ShippingState;
        
        if(strShippingAddress != null && strShippingAddress !='' && OEMdcNote.ShippingPostalCode != null && OEMdcNote.ShippingPostalCode != '')
            strShippingAddress = strShippingAddress+', '+OEMdcNote.ShippingPostalCode  ;
        else if(OEMdcNote.ShippingPostalCode != null && OEMdcNote.ShippingPostalCode != '')
            strShippingAddress = OEMdcNote.ShippingPostalCode ;
            
        if(strShippingAddress != null && strShippingAddress !='' && OEMdcNote.ShippingCountry != null && OEMdcNote.ShippingCountry != '')
            strShippingAddress = strShippingAddress+', '+OEMdcNote.ShippingCountry  ;
        else if(OEMdcNote.ShippingCountry != null && OEMdcNote.ShippingCountry != '')
            strShippingAddress = OEMdcNote.ShippingCountry ; 
        
            strShippingState = OEMdcNote?.ShippingState;
            strShippingCode = OEMdcNote?.Shipping_State_Code__c;
        
        if(strShippingAddress == null || strShippingAddress =='')
        {
            strShippingAddress = strBillingAddress;
            strShippingState = OEMdcNote?.BillingState;
            strShippingCode = OEMdcNote?.Billing_State_Code__c;
        }
        }
    }
}