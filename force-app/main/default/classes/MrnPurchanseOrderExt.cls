public class MrnPurchanseOrderExt {
    public MRN__c objMrn {get;set;}
    public List<MRN_Line_Item__c> objMrnItemList {get;set;}
    public List<Charges__c>objChargesList{get;set;}
    public Decimal poQty{get;set;}
    public Decimal billQty{get;set;}
    public Decimal recQty{get;set;}
    public Decimal shortQty{get;set;}
    public Decimal subTotalItemAmount{get;set;}
    
    public Decimal subTotalWithFreightAndSurchargeAmount{get;set;}
    public Decimal totalWithFreightAndSurchargeAmount{get;set;}
    public Decimal subTotalItemValueInINR{get;set;}
    public Decimal totalItemValueInINR{get;set;}
    public Decimal subTotalAssessableValue{get;set;}
    public Decimal subTotalCustomDutyAmount{get;set;}
    public Decimal subTotalLandedAmountInInr{get;set;}
    public Decimal subTotalTaxableValue{get;set;}
    public Decimal subTotalGSTAmount{get;set;}
    public Decimal totalGSTAmount{get;set;}
    public Decimal subTotalBookAmount{get;set;}
    public Decimal totalBookAmount{get;set;}
    public Decimal totalMRNExchangeCharge{get;set;}
    public Decimal totalChargeSUM{get;set;}
    public String strAmount{get;set;}
    public Decimal subPoQty{get;set;}
    // For Domestic
    public Decimal totalCgstAmount{get;set;}
    public Decimal totalSgstAmount{get;set;}
    public Decimal totalIgstAmount{get;set;}
    public Decimal totalTaxValueAmount{get;set;}
    
    public ImportWrapper objIW{get;set;}
    
    
    public MrnPurchanseOrderExt(ApexPages.StandardController controller)      
    {
        String strId = ApexPages.currentPage().getParameters().get('id');
        system.debug('strId-----'+strId);
        if(String.isNotBlank(strId)){
            objMrnItemList = new List<MRN_Line_Item__c>();
            objChargesList = new List<Charges__c>();
            
            poQty=0; billQty=0; recQty=0; shortQty=0; subTotalItemAmount=0;
            subTotalWithFreightAndSurchargeAmount=0; totalWithFreightAndSurchargeAmount =0;
            subTotalItemValueInINR=0; totalItemValueInINR=0; subTotalAssessableValue=0;
            subTotalCustomDutyAmount=0; subTotalLandedAmountInInr=0; subTotalTaxableValue=0;
            subTotalGSTAmount=0; totalGSTAmount=0; subTotalBookAmount=0; totalBookAmount=0;
            totalCgstAmount=0;totalSgstAmount=0;totalIgstAmount=0;totalTaxValueAmount=0;
            totalMRNExchangeCharge = 0; strAmount='';totalChargeSUM =0;subPoQty=0;
            
            List<String> lstMrnField = UtilityClass.getAllFields('MRN__c');
            List<String> lstMrnItemField = UtilityClass.getAllFields('MRN_Line_Item__c');
            List<String> lstChargesField = UtilityClass.getAllFields('Charges__c');
            system.debug('lstChargesField'+lstChargesField);
            String strMrnQuery = 'Select OEM_Customer__r.ShippingStreet,OEM_Customer__r.ShippingCity, OEM_Customer__r.ShippingState, OEM_Customer__r.ShippingPostalCode, OEM_Customer__r.ShippingCountry, Contact_Name__r.Name, OEM_Customer__r.Name, OEM_Customer__r.BillingStreet,OEM_Customer__r.BillingCity, OEM_Customer__r.BillingState, OEM_Customer__r.BillingPostalCode, OEM_Customer__r.BillingCountry,OEM_Customer__r.Billing_State_Code__c,OEM_Customer__r.Shipping_State_Code__c,' +String.Join(lstMrnField, ',')+ ' From MRN__c where Id =: strId';
            String strMrnItemQuery = 'Select Part_Number__r.Name,Part_Number__r.Specification__c,Part_Number__r.Part_Name__c,' +String.Join(lstMrnItemField, ',')+ ' From MRN_Line_Item__c where MRN__c =: strId';
            String strChargesQuery = 'Select Charges__r.Name,' +String.Join(lstChargesField, ',')+ ' From Charges__c where MRN__c =: strId';
            List<MRN__c> lstPurchaseOrder =  Database.query(strMrnQuery);
            if(lstPurchaseOrder.size()>0){
                objMrn=lstPurchaseOrder[0];
                system.debug('......objMrn.MRN_Delivery_Type__c..'+objMrn.MRN_Delivery_Type__c);
                objIW = new ImportWrapper();
                if(objMrn.MRN_Delivery_Type__c=='Import'){
                objIW.TotalInvValue = objMrn.Ex_Work_Value__c?.setScale(2);
                    
                objIW.TotalInvValueInINR = (objMrn.Ex_Work_Value__c * objMrn.Exchange_Rate__c)?.setScale(2);
                    
                objIW.InvSurcharge = (objMrn.Inv_Surcharge__c*100)?.setScale(2);
                objIW.InvSurchargeInINR = (objMrn.Surcharge__c * objMrn.Exchange_Rate__c)?.setScale(2);
                objIW.InsuranceOfBOEInINR = objIW.TotalInvValue * decimal.valueOf(objMrn.Insurance_of_BOE__c) * objMrn.Exchange_Rate__c;
                objIW.InsuranceOfBOEInINR = objIW.InsuranceOfBOEInINR?.setScale(2);
                objIW.FreightOfInvoice = (objMrn.Freight_of_Invoice__c)?.setScale(2);
                objIW.FreightOfInvoiceInINR = (objMrn.Freight__c * objMrn.Exchange_Rate__c)?.setScale(2);
                }
                
            }
            objMrnItemList=Database.query(strMrnItemQuery);
            if(objMrnItemList.size()>0){
                for(MRN_Line_Item__c mrnObj:objMrnItemList){
                    if(mrnObj.Quantity__c !=null){
                        poQty += mrnObj.Quantity__c;
                    }
                    if(mrnObj.Bill_QTY__c !=null){
                        billQty+=mrnObj.Bill_QTY__c;
                    }
                    if(mrnObj.Received_QTY__c !=null){
                        recQty+=mrnObj.Received_QTY__c;
                    }
                    if(mrnObj.Short_QTY__c !=null){
                        shortQty+=mrnObj.Short_QTY__c;
                    }
                    if(mrnObj.PO_QTY__c !=null){
                        subPoQty+=mrnObj.PO_QTY__c;
                    }
                    
                    if(mrnObj.Total_Amount_GBP__c !=null){
                        subTotalItemAmount+=mrnObj.Total_Amount_GBP__c;
                    }
                    if(mrnObj.Item_Value_with_Freight_and_Surcharges__c !=null){
                        totalWithFreightAndSurchargeAmount+=mrnObj.Item_Value_with_Freight_and_Surcharges__c;
                        subTotalWithFreightAndSurchargeAmount+=mrnObj.Item_Value_with_Freight_and_Surcharges__c;
                    }
                    if(mrnObj.Total_Item_Value_in_INR__c !=null){
                        subTotalItemValueInINR+=mrnObj.Total_Item_Value_in_INR__c;
                        totalItemValueInINR+=mrnObj.Total_Item_Value_in_INR__c;
                    }
                    if(mrnObj.Assessable_Value_Including_Insurance__c !=null){
                        subTotalAssessableValue+=mrnObj.Assessable_Value_Including_Insurance__c;
                    }
                    if(mrnObj.Custom_Duty_Amount__c !=null){
                        subTotalCustomDutyAmount+=mrnObj.Custom_Duty_Amount__c;
                    }
                    if(mrnObj.Total_Landed_Amount__c !=null){
                        subTotalLandedAmountInInr+=mrnObj.Total_Landed_Amount__c;
                    }
                    if(mrnObj.Taxable_Amount_Formula__c !=null){
                        subTotalTaxableValue+=mrnObj.Taxable_Amount_Formula__c;
                    }
                    if(mrnObj.GST_Amount__c !=null){
                        subTotalGSTAmount+=mrnObj.GST_Amount__c;
                        totalGSTAmount+=mrnObj.GST_Amount__c;
                    }
                    if(mrnObj.Total_For_Book_formula__c !=null){
                        subTotalBookAmount+=mrnObj.Total_For_Book_formula__c;
                        System.debug('book '+mrnObj.Total_For_Book_formula__c);
                        System.debug('Sub '+subTotalBookAmount);
                        totalBookAmount+=mrnObj.Total_For_Book_formula__c;
                    }
                    
                    // For Domestic 
                    if(mrnObj.CGST_Amount_Formula__c !=null){
                        totalCgstAmount+=mrnObj.CGST_Amount_Formula__c;
                    } 
                    if(mrnObj.SGST_Amount_Formula__c !=null){
                        totalSgstAmount+=mrnObj.SGST_Amount_Formula__c;
                    } 
                    if(mrnObj.IGST_Amount_Formula__c !=null){
                        totalIgstAmount+=mrnObj.IGST_Amount_Formula__c;
                    } 
                    if(mrnObj.Taxable_Value__c !=null){
                        totalTaxValueAmount+=mrnObj.Taxable_Value__c;
                    } 
                }
                System.debug('Sub1'+subTotalBookAmount);
                subTotalBookAmount = subTotalBookAmount?.setScale(2);
                System.debug('Sub2'+subTotalBookAmount);
            }
            objChargesList =  Database.query(strChargesQuery);
            
            decimal totalBookedAmount = 0;
            totalBookedAmount = subTotalBookAmount;
            if(objChargesList.size()>0){
                for(Charges__c chr:objChargesList){
                    if(chr.MRN_Charge_Exchange_Rate__c > 0){
                        totalWithFreightAndSurchargeAmount+=chr.MRN_Charge_Exchange_Rate__c;
                        totalMRNExchangeCharge+= chr.MRN_Charge_Exchange_Rate__c;
                    }        
                    if(chr.Total_Amount__c > 0){
                        totalItemValueInINR+=chr.Total_Amount__c;
                        totalChargeSUM +=chr.Total_Amount__c;
                    }  
                    if(chr.Total_Amount__c > 0 && chr.GST__c > 0){
                        totalGSTAmount+=(chr.Total_Amount__c*chr.GST__c)/100;
                    }
                    if(objMrn.MRN_Delivery_Type__c == 'Import')
                            totalBookAmount+= totalGSTAmount + chr.Total_Amount__c;
                    
                    if(objMrn.MRN_Delivery_Type__c == 'Domestic')
                            totalBookAmount+= chr.CGST_Amount__c+ chr.SGST_Amount__c+ chr.IGST_Amount__c+ chr.Total_Amount__c;
                    
                    if(objMrn.MRN_Delivery_Type__c == 'Import' && chr.Net_Amount__c >0)
                    {
                        totalBookedAmount = totalBookedAmount+chr.Net_Amount__c;
                    }                       
                }
                
                totalBookAmount=totalBookAmount+lstPurchaseOrder[0]?.Less_Insurance__c;
                totalWithFreightAndSurchargeAmount= totalWithFreightAndSurchargeAmount?.setScale(2);
                totalItemValueInINR= totalItemValueInINR?.setScale(2);
                totalGSTAmount= totalGSTAmount?.setScale(2);
                totalBookAmount= totalBookAmount?.setScale(2);
                if(objMrn.MRN_Delivery_Type__c == 'Import'){
                    totalBookedAmount = totalBookedAmount+lstPurchaseOrder[0]?.Less_Insurance__c;
                    totalBookedAmount= totalBookedAmount?.setScale(2);
                    totalBookAmount = totalBookedAmount;
                }
            }            
        }
        if(totalBookAmount > 0)
            strAmount = UtilityClass.NoToWord(totalBookAmount.intValue());
    }
    
    public class ImportWrapper{
        
        //Related To Purchase Order (For Import)
        public Decimal TotalInvValue{get;set;}
        public Decimal TotalInvValueInINR{get;set;}
        public Decimal InvSurcharge{get;set;}
        public Decimal InvSurchargeInINR{get;set;}
        public Decimal InsuranceOfBOEInINR{get;set;}
        public Decimal FreightOfInvoice{get;set;}
        public Decimal FreightOfInvoiceInINR{get;set;}
        
        public ImportWrapper(){
            TotalInvValue = 0;
            TotalInvValueInINR = 0;
            InvSurcharge = 0;
            InvSurchargeInINR = 0;
            InsuranceOfBOEInINR = 0;
            FreightOfInvoice = 0;
            FreightOfInvoiceInINR = 0;
        }
    }
}