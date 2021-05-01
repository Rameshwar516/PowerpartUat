public class classPdfDebitNote {
    public MRN__c MrndcNote{get;set;}
    
    public Account OEMdcNote{get;set;}
    
    public DC_Note__c dcNote{get;set;}
    public Pdf_Header__mdt pdfheader{get;set;}
    
    
    public List<DC_Note_Line_Item__c> dcNoteLi{get;set;}
    
    public Date dte{get;set;}
    
    public decimal totalLiIgst{get;set;}
    public decimal totalLisgst{get;set;}
    public Decimal totalLiCgst{get;set;}
    public Decimal totalLiTaxableAMT{get;set;}
    public Decimal totalLiNetAmt{get;set;}
    public Decimal totalTax{get;set;}
    
    
    public list<Charges__c> lstCharges{get;set;}
    public decimal totalTaxableValueIncludeChargeAmt1{get;set;}
    public decimal totalCgstIncludeCharge{get;set;}
    public Decimal totalSgstIncludeCharge{get;set;}
    public Decimal totalIgstIncludeCharge{get;set;}
    
    public Decimal OverAlltotalGstCharge{get;set;}
    public Decimal TotalFinalAmountAfterTax{get;set;}
    public Decimal TotalFinalAmountAfterTaxRoundOff{get;set;}
    public Decimal totaltaxableCHSGSTCGSTIGST{get;set;}
    public String totalAmountaftertaxinWords{get;set;}
    
    public string strBillingAddress{get;set;}
    public string strShippingAddress{get;set;}
    public string strBillingState{get;set;}
    public string strBillingCode{get;set;}
    public string strShippingState{get;set;}
    public string strShippingCode{get;set;}
    
    
    public classPdfDebitNote(ApexPages.StandardController controller)
    {
        String strId = ApexPages.currentPage().getParameters().get('id');
        pdfheader=new Pdf_Header__mdt();
        
        if(strId!=null && strId!='')
        {
            
            dcNote=[select id,Bill_To_Customer_Name__r.Name,Billing_Address__c,Billing_GSTIN_No__c,Container_No__c,Customer_Party__c,
                    Delivery_Term__c,Detail__c,Dispatch_Address__c,Dispatch_Date__c,Dispatch_No__c,ESN_No__c,Dispatch_To_Customer_Name__r.name,
                    LC_Date__c,LC_Expected_Date__c,createdDate,LC_Term__c,MRN__c,MRN__r.Ware_House__r.Branch__c,MRN__r.Ware_House__r.City__c,MRN__r.OEM_Customer__r.ShippingState,Payment_Method__c,Shipping_GSTIN_No__c,Name,Voucher_Date__c from
                    DC_Note__c where id =:strId];
            
            string branch = dcNote.MRN__r.Ware_House__r.Branch__c ;
            List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
            String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt WHERE Branch__c =:branch Order by Effected_Date__c ASC LIMIT 1';
            pdfheader =  Database.query(pdfHeaderQuery);
            
            DateTime dT = dcNote.createdDate;
            dte = date.newinstance(dT.year(), dT.month(), dT.day());
            
            dcNoteLi=[select id,Amount__c,CGST_Amount__c,Part_Number__r.HSN_CODE__c,Part_Number__r.Name,CGST__c,Name,Discount_Currency__c,Discount__c,
                      IGST_Amount__c,IGST__c,Part_Name__c,Part_Number__c, Part_Number__r.UOM__c,Quantity__c,SGST_Amount__c,SGST__c,
                      Doc_No__c,Taxable_Amount__c,Net_Amount__c,Total_Amount__c,Unit__c,Unit_Price__c from DC_Note_Line_Item__c where Doc_No__c =:dcNote.id];
            
            
            totalLiCgst=0;
            totalLiSgst=0;
            totalLiIgst=0;
            totalLiNetAmt=0;
            totalLiTaxableAMT=0;
            totalTax=0;
            totalAmountaftertaxinWords='';
            if(dcNoteLi.size() > 0)
            {
                for(DC_Note_Line_Item__c objSOLI : dcNoteLi)
                {
                    if(objSOLI.CGST_Amount__c!=null && objSOLI.CGST_Amount__c >0){
                        totalLiCgst= totalLiCgst+objSOLI.CGST_Amount__c;
                    }
                    
                    if(objSOLI.SGST_Amount__c!=null && objSOLI.SGST_Amount__c >0){
                        totalLiSgst= totalLiSgst+objSOLI.SGST_Amount__c;
                    }
                    if(objSOLI.IGST_Amount__c!=null && objSOLI.IGST_Amount__c >0){
                        totalLiIgst= totalLiIgst+objSOLI.IGST_Amount__c;
                    }
                    if(objSOLI.Net_Amount__c != null && objSOLI.Net_Amount__c >0)
                        totalLiNetAmt= totalLiNetAmt+objSOLI.Net_Amount__c;
                    
                    if(objSOLI.Taxable_Amount__c != null && objSOLI.Taxable_Amount__c >0)
                        totalLiTaxableAMT = totalLiTaxableAMT+objSOLI.Taxable_Amount__c;
                    
                }
                
                totalLiCgst.round();
                totalLiSgst.round();
                totalLiIgst.round();
                totalLiNetAmt.round();
                totalLiTaxableAMT.round();
                totalTax= totalLiCgst+totalLiSgst+totalLiIgst;
                totalTax.round();
                
                totalTaxableValueIncludeChargeAmt1=0;
                totalCgstIncludeCharge=0;  
                totalSgstIncludeCharge=0;
                totalIgstIncludeCharge=0;
                OverAlltotalGstCharge=0;
                
                totaltaxableCHSGSTCGSTIGST=0;
                TotalFinalAmountAfterTax=0;
                
                TotalFinalAmountAfterTaxRoundOff=0;
                
                lstCharges = [Select Id, name,Charges__c,Charges__r.Name,CGST__c,IGST__c,SGST__c,Total_Amount__c,Quote__c,Opportunity__c,Net_Amount__c,
                              Charge_Amount__c,CGST_Amount__c,SGST_Amount__c,IGST_Amount__c from Charges__c where DC_Note__c =: dcNote.Id];   
                if(lstCharges.size()>0){
                    for(Charges__c objCharg : lstCharges)
                    {
                        totalTaxableValueIncludeChargeAmt1 = totalTaxableValueIncludeChargeAmt1+objCharg.Charge_Amount__c;
                        OverAlltotalGstCharge = OverAlltotalGstCharge+ objCharg?.CGST_Amount__c+objCharg?.SGST_Amount__c+objCharg?.IGST_Amount__c;
                        totalCgstIncludeCharge =totalCgstIncludeCharge+ objCharg?.CGST_Amount__c;
                        totalSgstIncludeCharge =totalSgstIncludeCharge+ objCharg?.SGST_Amount__c;
                        totalIgstIncludeCharge = totalIgstIncludeCharge+objCharg?.IGST_Amount__c;
                        // totalAmountSumNotIncludedTax = totalAmountSumNotIncludedTax+objCharg?.Charge_Amount__c;
                    }
                }
                totalCgstIncludeCharge = totalCgstIncludeCharge+totalLiCgst;
                totalCgstIncludeCharge.round();
                
                totalSgstIncludeCharge = totalSgstIncludeCharge+totalLiSgst;
                totalSgstIncludeCharge.round();
                
                totalIgstIncludeCharge = totalIgstIncludeCharge+totalLiIgst;
                totalIgstIncludeCharge.round();
                
                OverAlltotalGstCharge = 0;
                
                OverAlltotalGstCharge = OverAlltotalGstCharge+totalCgstIncludeCharge+totalSgstIncludeCharge+totalIgstIncludeCharge;
                
                
                // OverAlltotalGstCharge=OverAlltotalGstCharge+totalTax;
                
                totalTaxableValueIncludeChargeAmt1=totalTaxableValueIncludeChargeAmt1+totalLiTaxableAMT;
                
                totaltaxableCHSGSTCGSTIGST=totaltaxableCHSGSTCGSTIGST+totalTaxableValueIncludeChargeAmt1+OverAlltotalGstCharge;
                
                TotalFinalAmountAfterTax=TotalFinalAmountAfterTax+OverAlltotalGstCharge+totalTaxableValueIncludeChargeAmt1;
                
                TotalFinalAmountAfterTaxRoundOff=TotalFinalAmountAfterTaxRoundOff+TotalFinalAmountAfterTax;
                
                
                TotalFinalAmountAfterTaxRoundOff.round();
                
                totalAmountaftertaxinWords = UtilityClass.NoToWord(TotalFinalAmountAfterTaxRoundOff.intValue());
                totalAmountaftertaxinWords = totalAmountaftertaxinWords+' rupees only';
                
                MrndcNote=[select id,OEM_Customer__c ,Contact_Name__c , E_Way_Bill_Date__c,E_Way_Bill_No__c from MRN__c where id=:dcNote.MRN__c];
                
                if(MrndcNote.OEM_Customer__c !=null){
                    OEMdcNote=[select id ,GSTIN_No__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingAddress,BillingPostalCode,
                               ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState,ShippingAddress, name,Shipping_State_Code__c,
                               ShippingCountry, Billing_State_Code__c from Account where id =:MrndcNote.OEM_Customer__c ];
                    
                    
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
        }
    }