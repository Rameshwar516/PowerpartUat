public class MRNCmpControlerV2 {

    @AuraEnabled
    public static string doInit(string strRecordId)
    {
        wrapper objWrap = new wrapper();
        objWrap.lstDeliveryNoteLIWrap = new List<DeliveryNoteLIWrapper>();
        objWrap.lstMRNLineItems = new List<DeliveryNoteLIWrapper>();
        objWrap.lstOldCharges = new List<TaxDetails>();
        objWrap.lstTaxType = new list<TaxType>();
        objWrap.lstTaxDetails = new List<TaxDetails>();
        objWrap.lstCharges = new List<TaxDetails>();
        objWrap.lstDeliveryType = new List<string>();
        objWrap.lstCurrencyType = new List<string>();
        objWrap.lstDispatchMode = new List<string>();
        objWrap.lstInsuranceofBOE = new List<string>();
        objWrap.lstUnitType = new List<string>();
        objWrap.lstCustomDutyRate = new List<string>();
        objWrap.lstCustomSurRate = new List<string>();
        objWrap.lstGSTRate = new List<string>();
        objWrap.lstUOM = new List<string>();
        objWrap.lstUOI = new List<string>();
        objWrap.lstSubMain = new List<DeliveryNoteLIWrapper>();
        objWrap.objMRN = new MRN__c();
        
        objWrap.TotalTaxAmount =0;
        for(Tax__c objTax : [Select Id,Name,Tax_Percentage__c,Basic_Percentage__c from Tax__c]){
            TaxType objTaxT = new TaxType();
            objTaxT.value = objTax.Name;
            objTaxT.id = objTax.id;
            objWrap.lstTaxType.add(objTaxT);
            TaxDetails objTD = new TaxDetails();
            objTD.objTax = objTax;
            objTD.strTaxId = objTax.Id;
            objTD.strTaxName = objTax.Name;
            objTD.TaxPercentage = objTax.Tax_Percentage__c;
            objTD.decTaxAmount = 0.00;
            objTD.GST = 0.00;
            objTD.CGST = 0.00;
            objTD.SGST = 0.00;
            objTD.IGST = 0.00;
            objTD.NetAmount =0.00;
            objWrap.lstTaxDetails.add(objTD);
        }
        
        map<string,Stock__c> mapNoOfStock = new map<string,Stock__c>();
        for(Stock__c objStock : [Select Id,Name,Ware_House__c,Ware_House__r.City__c,Product_Part__c,Quantity__c,Total_Quantity__c from Stock__c]){
            mapNoOfStock.put(objStock.Product_Part__c+'-'+objStock.Ware_House__c,objStock);
        }
        Schema.DescribeFieldResult fieldResultStatusDT = MRN__c.MRN_Delivery_Type__c.getDescribe();
        List<Schema.PicklistEntry> pListStatusDT = fieldResultStatusDT.getPicklistValues();
        for (Schema.PicklistEntry DT: pListStatusDT) {
            objWrap.lstDeliveryType.add(DT.getLabel());
        }
        Schema.DescribeFieldResult fieldResultStatusC = MRN__c.Currency__c.getDescribe();
        List<Schema.PicklistEntry> pListStatusC = fieldResultStatusC.getPicklistValues();
        for (Schema.PicklistEntry DT: pListStatusC) {
            objWrap.lstCurrencyType.add(DT.getLabel());
        }
        Schema.DescribeFieldResult fieldResultStatusDM = MRN__c.Dispatch_Mode__c.getDescribe();
        List<Schema.PicklistEntry> pListStatusDM = fieldResultStatusDM.getPicklistValues();
        for (Schema.PicklistEntry DT: pListStatusDM) {
            objWrap.lstDispatchMode.add(DT.getLabel());
        }
        
        Schema.DescribeFieldResult fieldResultStatusBOE = MRN__c.Insurance_of_BOE__c.getDescribe();
        List<Schema.PicklistEntry> pListStatusBOE = fieldResultStatusBOE.getPicklistValues();
        for (Schema.PicklistEntry DT: pListStatusBOE) {
            objWrap.lstInsuranceofBOE.add(DT.getLabel());
        }   
        
        
        Schema.DescribeFieldResult fieldResultStatus = Part__c.FULL_UNIT_SPARE_UNIT__c.getDescribe();
        List<Schema.PicklistEntry> pListStatus = fieldResultStatus.getPicklistValues();
        for (Schema.PicklistEntry p1: pListStatus) {
            objWrap.lstUnitType.add(p1.getLabel());
        }        
        Schema.DescribeFieldResult fieldResultCDR = MRN__c.Custom_Duty_Rate__c.getDescribe();
        List<Schema.PicklistEntry> pListCDR = fieldResultCDR.getPicklistValues();
        for (Schema.PicklistEntry p1: pListCDR) {
            objWrap.lstCustomDutyRate.add(p1.getLabel());
        }   
        Schema.DescribeFieldResult fieldResultCSR = MRN__c.Custom_Sur_Rate__c.getDescribe();
        List<Schema.PicklistEntry> pListCSR = fieldResultCSR.getPicklistValues();
        for (Schema.PicklistEntry p1: pListCSR) {
            objWrap.lstCustomSurRate.add(p1.getLabel());
        }   
        Schema.DescribeFieldResult fieldResultGSTRate = MRN__c.GST_Rate__c.getDescribe();
        List<Schema.PicklistEntry> pListGSTRate = fieldResultGSTRate.getPicklistValues();
        for (Schema.PicklistEntry p1: pListGSTRate) {
            objWrap.lstGSTRate.add(p1.getLabel());
        } 
        
        Schema.DescribeFieldResult fieldResultUOM = Part__c.UOM__c.getDescribe();
        List<Schema.PicklistEntry> pListUOM = fieldResultUOM.getPicklistValues();
        for (Schema.PicklistEntry p1: pListUOM) {
            objWrap.lstUOM.add(p1.getLabel());
        } 
        
        Schema.DescribeFieldResult fieldResultUOI = Part__c.UOI__c.getDescribe();
        List<Schema.PicklistEntry> pListUOI = fieldResultUOI.getPicklistValues();
        for (Schema.PicklistEntry p1: pListUOI) {
            objWrap.lstUOI.add(p1.getLabel());
        }
            
        if(String.isBlank(strRecordId)){
            DeliveryNoteLIWrapper objSMW = new DeliveryNoteLIWrapper();
            /*objSMW.lstUnitType = new List<string>();
            objSMW.lstCustomDutyRate = new List<string>();
            objSMW.lstCustomSurRate = new List<string>();
            objSMW.lstGSTRate = new List<string>();
            objSMW.lstUOM = new List<string>();
            objSMW.lstUOI = new List<string>();*/
            objSMW.objPart = new Part__c();
            objSMW.IsEdit = false;
            objSMW.decGrossAmount = 0;
            objSMW.IntNetAmount = 0;
            objSMW.IntLandingRate =0;
            objSMW.IntBillQty = 0;
            objSMW.IntReceiptQty =0;
            objSMW.IntBinQty = '';
            objSMW.IntAcceptQty =0;
            objSMW.IntPOQty = 0;
            objSMW.IntShortQty =0;
            objSMW.strUOM ='NOS';
            objSMW.strUOI = '';
            objSMW.IntPriceGBP = 0;
            objSMW.IntTotalAmountGBP =0;
            objSMW.IntUNIT = 0;
            objSMW.IntDutyRate = 10;
            objSMW.IntSurRate =10;
            objSMW.IntItemFreighGBP =0;
            objSMW.IntItemvalueINR =0;
            objSMW.IntAssessableValueINR = 0;
            objSMW.IntCDutyAmountINR =0;
            objSMW.IntTotalLandedAmountINR =0;
            objSMW.IntLandedCostUnitINR =0;
            objSMW.IntTaxableValue =0;
            objSMW.IntGSTRate =0;
            objSMW.IntGSTAmount =0;
            objSMW.IntTotalInsuranceCost =0;
            objSMW.IntLANDUnitRateINR = 0;
            objSMW.IntCGSTRate =0;
            objSMW.IntCGSTAmount =0;
            objSMW.IntSGSTRate =0;
            objSMW.IntSGSTAmount =0;
            objSMW.IntIGSTRate =0;
            objSMW.IntIGSTAmount =0;
            objSMW.strRack ='';
            objSMW.StockTotalProduct =0;
            objWrap.lstDeliveryNoteLIWrap.add(objSMW);
            system.debug('....objWrap.lstDeliveryNoteLIWrap'+objWrap.lstDeliveryNoteLIWrap.size());
            system.debug('..objSMW..'+ Json.serialize(objSMW));
        }
        if(strRecordId !=null && strRecordId !=''){
            objWrap.lstDeliveryNoteLIWrap = new List<DeliveryNoteLIWrapper>();
            
            
            map<String , Schema.SObjectType> globalDescriptionMRN = Schema.getGlobalDescribe();
            Schema.sObjectType sObjTypeMRN = globalDescriptionMRN.get('MRN__c');
            Schema.DescribeSObjectResult describeResultMRN = sObjTypeMRN.getDescribe();
            List<string> leadfieldNamesMRN = new List<String>(describeResultMRN.fields.getMap().keySet()); 
            string soqlMRN = 'select ' + string.join(leadfieldNamesMRN, ',') +' from MRN__c where Id =: strRecordId' ; 
            List<MRN__c> lstMRN = Database.query(soqlMRN);
            if(lstMRN.size()>0){
                objWrap.objMRN = lstMRN[0];
            }
            
            map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
            Schema.sObjectType sObjType = globalDescription.get('MRN_Line_Item__c');
            Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
            List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
            string soql = 'select ' + string.join(leadfieldNames, ',') +',Part_Number__r.name, Stock__r.Total_Unbooked_Quantity__c,Part_Number__r.Specification__c,Part_Number__r.UOI__c,Ware_House__r.City__c,Part_Number__r.UOM__c,Part_Number__r.Part_Name__c from MRN_Line_Item__c where MRN__c =: strRecordId' ; 
            System.debug('inSoql---- '+soql);
            List<MRN_Line_Item__c> lstMRNLI = Database.query(soql);
            for(MRN_Line_Item__c objMLI : lstMRNLI){
                
                if(objWrap.objMRN.MRN_Type__c != 'Sales Return'){
                    DeliveryNoteLIWrapper objSMW = new DeliveryNoteLIWrapper();
                    objSMW.strPartNumber = objMLI.Part_Number__r.Name;
                    objSMW.strDescription = objMLI.Part_Number__r.Part_Name__c;
                    /*objSMW.lstUnitType = new List<string>();
                    objSMW.lstCustomDutyRate = new List<string>();
                    objSMW.lstCustomSurRate = new List<string>();
                    objSMW.lstGSTRate = new List<string>();
                    objSMW.lstUOM = new List<string>();
                    objSMW.lstUOI = new List<string>();*/
                    for(Part__c objPart : [Select Id, Name,Part_Name__c,Usage__c,HSN_CODE__c,UOM__c,List_Price_Standard_price__c,BinNumber__c from Part__c where Id =:objMLI.Part_Number__c])
                    {
                        objSMW.objPart = objPart;
                    }
                    for(integer i=0;i<objWrap.lstGSTRate.size();i++){
                        System.debug('-----------label------ '+objWrap.lstGSTRate[i]);
                    }
                    
                    objSMW.strDocNo = objMLI.DOC_Number__c;
                    if(objMLI.POC_Date__c != null)
                        objSMW.docDate = objMLI.POC_Date__c;
                    
                    objSMW.IsEdit = false;
                    objSMW.IntBinQty = objSMW.objPart.BinNumber__c;
                    objSMW.strRack = objSMW.objPart.BinNumber__c;    
                    objSMW.strHSN = objMLI.HSN_SAC__c;
                    objSMW.strUOM = objMLI.Part_Number__r.UOM__c;
                    objSMW.strUOI = objMLI.UOI__c;
                    objSMW.IntUNIT = integer.valueof(objMLI.Unit__c);
                    
                    objSMW.IntBillQty = integer.valueof(objMLI.Bill_QTY__c);
                    objSMW.IntReceiptQty = integer.valueof(objMLI.Received_QTY__c);
                    objSMW.IntAcceptQty =integer.valueof(objMLI.Short_QTY__c);
                    objSMW.IntPOQty = integer.valueof(objMLI.PO_QTY__c);
                    objSMW.IntShortQty =integer.valueof(objMLI.Short_QTY__c);
                    objSMW.decGrossAmount = 0;
                    objSMW.IntLandingRate =0;
                    decimal InvSurcharge =0;
                    decimal FreightInvoice =0;
                    objSMW.IntNetAmount = objMLI.Net_Amount_Formula__c; 
                    objSMW.IntPriceGBP = objMLI.Item_Price_Unit__c;
                    objSMW.IntTotalAmountGBP =objMLI.Total_Amount_GBP__c;
                    objSMW.IntDutyRate = objMLI.Duty_Rates__c;
                    objSMW.IntSurRate = objMLI.Sur_Rate__c;   
                    objSMW.IntItemFreighGBP =objMLI.Item_Value_With_Freight_Surcharge__c;
                    objSMW.IntItemvalueINR =objMLI.Total_Item_Value_In_INR_input__c;														
                    objSMW.IntAssessableValueINR = objMLI.Assessable_Value_Including_Insurance__c;
                    objSMW.IntCDutyAmountINR =objMLI.Custom_Duty_Amount__c;
                    objSMW.IntTotalLandedAmountINR =0;	
                    objSMW.IntLandedCostUnitINR =0;
                    objSMW.IntTaxableValue =objMLI.PO_Taxable_Amount_input__c;
                    objSMW.IntGSTRate =objMLI.GST__c;
                    objSMW.IntGSTAmount =objMLI.GST_Amount__c;
                    objSMW.IntTotalInsuranceCost =objMLI.Total_For_Book_formula__c;
                    objSMW.IntLANDUnitRateINR = Integer.valueof(objMLI.Landed_Cost_Unit_Rate__c);
                    objSMW.IntCGSTRate =Integer.valueof(objMLI.PO_CGST__c);
                    objSMW.IntCGSTAmount =Integer.valueof(objMLI.PO_CGST_Amount__c);
                    objSMW.IntSGSTRate =Integer.valueof(objMLI.PO_SGST__c);
                    objSMW.IntSGSTAmount =Integer.valueof(objMLI.PO_SGST_Amount__c);
                    objSMW.IntIGSTRate =Integer.valueof(objMLI.PO_IGST__c);
                    objSMW.IntIGSTAmount =Integer.valueof(objMLI.PO_IGST_Amount__c);
                    
                    if(objMLI.Part_Number__c !=null && objMLI.Ware_House__c !=null){
                        objSMW.StockTotalProduct =Integer.valueof(objMLI.Stock__r.Total_Unbooked_Quantity__c);
                        objSMW.StockId =objMLI.Stock__c; 
                    }else{
                        objSMW.StockTotalProduct =0;
                    }
                    objSMW.ObjMRNLI = objMLI;
                    objWrap.lstDeliveryNoteLIWrap.add(objSMW);
                }else{
                    
                    DeliveryNoteLIWrapper objW = new DeliveryNoteLIWrapper();
                    objW.lstUnitType = new List<string>();
                    objW.ObjMRNLI = objMLI;
                    objW.IsEdit = true;
                    objWrap.lstMRNLineItems.add(objW);
                }
            }
            List<Charges__c> lstCharge = [select Id,Charges__c,Charges__r.Name,GST__c,CGST__c,SGST__c,IGST__c,Net_Amount__c,Total_Amount__c, MRN__c from Charges__c where MRN__c=: strRecordId];
            decimal TaxAmount =0;
            for(Charges__c objChar : lstCharge){
                TaxDetails objTaxDetails = new TaxDetails();
                objTaxDetails.strTaxName = objChar.Charges__r.Name;
                objTaxDetails.strTaxId = objChar.Charges__c;
                objTaxDetails.decTaxAmount =  objChar.Total_Amount__c;
                objTaxDetails.GST = objChar.GST__c;
                objTaxDetails.CGST = objChar.CGST__c;
                objTaxDetails.SGST = objChar.SGST__c;
                objTaxDetails.IGST = objChar.IGST__c;
                objTaxDetails.NetAmount = objChar.Net_Amount__c;
                TaxAmount = TaxAmount+objTaxDetails.NetAmount;
                objWrap.lstOldCharges.add(objTaxDetails);
            }
            objWrap.TotalTaxAmount = TaxAmount;
        }
        return Json.serialize(objWrap);
    }
    
    @AuraEnabled
    public static string addRowMethod(string strWrap)
    {
        system.debug('...strWrap...'+strWrap);
        wrapper objmainWrap = (wrapper)Json.deserialize(strWrap, wrapper.class);
        list<DeliveryNoteLIWrapper> listDNOTE = objmainWrap.lstDeliveryNoteLIWrap;
        if(listDNOTE.size()>0){
            DeliveryNoteLIWrapper objSMW = new DeliveryNoteLIWrapper();
            objSMW.objPart = new Part__c();
            objSMW.IsEdit = false;
            objSMW.decGrossAmount = 0;
            objSMW.IntNetAmount = 0;
            objSMW.IntLandingRate =0;
            objSMW.IntBillQty = 0;
            objSMW.IntReceiptQty =0;
            objSMW.IntBinQty = '';
            objSMW.IntAcceptQty =0;
            objSMW.IntPOQty = 0;
            objSMW.IntShortQty =0;
            objSMW.strUOM ='NOS';
            objSMW.strUOI = '';
            objSMW.IntPriceGBP = 0;
            objSMW.IntTotalAmountGBP =0;
            objSMW.IntUNIT = 0;
            objSMW.IntDutyRate = 10;
            objSMW.IntSurRate =10;
            objSMW.IntItemFreighGBP =0;
            objSMW.IntItemvalueINR =0;
            objSMW.IntAssessableValueINR = 0;
            objSMW.IntCDutyAmountINR =0;
            objSMW.IntTotalLandedAmountINR =0;
            objSMW.IntLandedCostUnitINR =0;
            objSMW.IntTaxableValue =0;
            objSMW.IntGSTRate =0;
            objSMW.IntGSTAmount =0;
            objSMW.IntTotalInsuranceCost =0;
            objSMW.IntLANDUnitRateINR = 0;
            objSMW.IntCGSTRate =0;
            objSMW.IntCGSTAmount =0;
            objSMW.IntSGSTRate =0;
            objSMW.IntSGSTAmount =0;
            objSMW.IntIGSTRate =0;
            objSMW.IntIGSTAmount =0;
            objSMW.strRack ='';
            objSMW.StockTotalProduct =0;
            listDNOTE.add(objSMW);
        }
        return Json.serialize(objmainWrap);
    }
    
    @AuraEnabled
    public static string UpdateMRNLI(string lstMRNLineItems, string strRecordId, string lstCharges,decimal IntTotalAmount, string strWrap,Decimal TotalTax)
    {  
        Decimal IntTaxableValue = 0;
        Decimal IntCDutyAmountINR = 0;
        Decimal IntItemFreighGBP = 0;
        Decimal SubtotaltotallineitemvalueinInr = 0;
        Decimal SubtotalAssesablevalue=0;
        Decimal SubtotalItemAmount = 0;
        
        
        system.debug('...strWrap...'+strWrap);
        wrapper objmainWrap = (wrapper)Json.deserialize(strWrap, wrapper.class);
        //List<DeliveryNoteLIWrapper> lstMRNLineItem = (List<DeliveryNoteLIWrapper>)Json.deserialize(lstMRNLineItems, List<DeliveryNoteLIWrapper>.Class);
        List<TaxDetails> lstTaxDetails = (List<TaxDetails>)Json.deserialize(lstCharges, List<TaxDetails>.Class);
        List<MRN_Line_Item__c> lstMRNLI = new List<MRN_Line_Item__c>();
        for(DeliveryNoteLIWrapper objMRNLI : objmainWrap.lstMRNLineItems){
            MRN_Line_Item__c objMRNLItems = new MRN_Line_Item__c();
            if(objmainWrap.objMRN.MRN_Type__c == 'Sales Return'){
                objMRNLItems =objMRNLI.ObjMRNLI;
                objMRNLItems.Stock__c =objMRNLI.StockId;
                lstMRNLI.add(objMRNLItems);
            }  
        } 
        system.debug('..!@#,....'+objmainWrap.lstDeliveryNoteLIWrap.size());
        for(DeliveryNoteLIWrapper objMRNLI : objmainWrap.lstDeliveryNoteLIWrap){
            MRN_Line_Item__c objMRNLItems = new MRN_Line_Item__c();
            if(objmainWrap.objMRN.MRN_Type__c == 'Purchase Order' || objmainWrap.objMRN.MRN_Type__c == 'Direct'){
                 Decimal FreightInvoice=0;
                    Decimal TotalAmountGBP=0;
                    Decimal ItemValueInINR=0;
                    Decimal AssessableValueINR=0;
                    Decimal TaxableAmount=0;
                if(objmainWrap.objMRN.MRN_Type__c == 'Direct'){
                    if(ObjMRNLI.objPart !=null)
                        objMRNLItems.Part_Number__c = ObjMRNLI.objPart.Id;
                }
              
                if(objMRNLI.ObjMRNLI !=null && objMRNLI.ObjMRNLI.Id !=null)
                    objMRNLItems.Id =objMRNLI.ObjMRNLI.Id;
                else
                    objMRNLItems.MRN__c = objmainWrap.objMRN.Id;
                
                objMRNLItems.HSN_SAC__c = objMRNLI.strHSN;
                objMRNLItems.BIN_NO__c = objMRNLI.IntBinQty;
                objMRNLItems.PO_QTY__c = objMRNLI.IntPOQty;
                objMRNLItems.Bill_QTY__c = objMRNLI.IntBillQty;
                objMRNLItems.Received_QTY__c = objMRNLI.IntReceiptQty;
                objMRNLItems.UOM__c = objMRNLI.strUOM;
                objMRNLItems.UOI__c = objMRNLI.strUOI;
                objMRNLItems.Item_Price_Unit__c = objMRNLI.IntPriceGBP;
                
                
               
                if(objmainWrap.objMRN.MRN_Delivery_Type__c=='Import'){
                    TotalAmountGBP =  objMRNLItems.Received_QTY__c * objMRNLItems.Item_Price_Unit__c;
                    FreightInvoice =TotalAmountGBP+((TotalAmountGBP*(objmainWrap.objMRN.freight__c /objmainWrap.objMRN.Ex_Work_Value__c )*100)/100)+((TotalAmountGBP*(objmainWrap.objMRN.Surcharge__c /objmainWrap.objMRN.Ex_Work_Value__c )*100)/100);
                    ItemValueInINR = objmainWrap.objMRN.Exchange_Rate__c*FreightInvoice;
                    AssessableValueINR = ItemValueInINR+(ItemValueInINR * decimal.valueof(objmainWrap.objMRN.Insurance_of_BOE__c)/100);
              		TaxableAmount=AssessableValueINR+objMRNLI.IntCDutyAmountINR;
                }
                else{
                    TotalAmountGBP=0;
                    FreightInvoice=0;
                    ItemValueInINR = objMRNLItems.Received_QTY__c * objMRNLItems.Item_Price_Unit__c;
                    AssessableValueINR = 0;
                    TaxableAmount=ItemValueInINR;
                }
                
                objMRNLItems.Total_Amount_Input__c =TotalAmountGBP;
                objMRNLItems.Item_Value_With_Freight_Surcharge__c=FreightInvoice;
                objMRNLItems.Total_Item_Value_In_INR_input__c=ItemValueInINR;
                objMRNLItems.Assessable_Value_INR__c=AssessableValueINR;
                objMRNLItems.PO_Taxable_Amount_input__c=TaxableAmount;  
                
                objMRNLItems.Duty_Rates__c = objMRNLI.IntDutyRate;
                objMRNLItems.Sur_Rate__c = objMRNLI.IntSurRate;
                if(objMRNLI.IntGSTRate!=null)
                objMRNLItems.GST__c = objMRNLI.IntGSTRate;
                if(objMRNLI.IntCGSTRate!=null)
                objMRNLItems.PO_CGST__c = objMRNLI.IntCGSTRate;
                if(objMRNLI.IntSGSTRate!=null)
                objMRNLItems.PO_SGST__c = objMRNLI.IntSGSTRate;
                if(objMRNLI.IntIGSTRate!=null)
                objMRNLItems.PO_IGST__c = objMRNLI.IntIGSTRate;
                objMRNLItems.Rack__c = objMRNLI.strRack;
                objMRNLItems.Unit__c= integer.valueof(objMRNLI.IntUNIT);
                if(objMRNLI.IntBillQty !=null && objMRNLI.IntPriceGBP !=null)
                    SubtotalItemAmount =SubtotalItemAmount+(objMRNLI.IntBillQty*objMRNLI.IntPriceGBP);
                System.debug('subototalItem---- '+SubtotalItemAmount+'--- '+objMRNLI.IntAssessableValueINR+'----'+objMRNLI.IntCDutyAmountINR);
             
                
                if(objMRNLI.IntCDutyAmountINR !=null)
                    IntCDutyAmountINR =IntCDutyAmountINR+objMRNLI.IntCDutyAmountINR;
                
                if(objMRNLI.IntItemFreighGBP !=null)
                    IntItemFreighGBP =IntItemFreighGBP+objMRNLI.IntItemFreighGBP;
                
                if(objMRNLI.IntAssessableValueINR !=null)
                    SubtotalAssesablevalue = SubtotalAssesablevalue+objMRNLI.IntAssessableValueINR;
                
                if(objMRNLI.IntItemvalueINR !=null)
                    SubtotaltotallineitemvalueinInr=SubtotaltotallineitemvalueinInr+objMRNLI.IntItemvalueINR;
                
                lstMRNLI.add(objMRNLItems);
            }
        } 
        map<string, string> mapOfCharges = new map<string, string>();
        list<Charges__c> existcharges = [Select Id,Name,Charges__c,MRN__c,MRN_Charge_Percent__c from Charges__c where MRN__c=: strRecordId]; 
        for(Charges__c objChar :existcharges){
            mapOfCharges.put(objChar.Charges__c,objChar.Id);
        }
        List<Charges__c> lstCharge = new List<Charges__c>();
        Decimal totalcharges =0;
        Decimal dcCharges =0;
        Decimal clgCharges =0;
        for(TaxDetails objWrap : lstTaxDetails){
            Charges__c objCharges = new Charges__c();
            objCharges.MRN__c = strRecordId;
            objCharges.Charges__c = objWrap.strTaxId;
            if(mapOfCharges.containsKey(objWrap.strTaxId)){
                objCharges.Id = mapOfCharges.get(objWrap.strTaxId);
            }
            objCharges.GST__c = objWrap.GST;
            if(Label.clgCharges ==objWrap.strTaxId)
                clgCharges =objWrap.decTaxAmount;
            if(Label.dcChargeId ==objWrap.strTaxId)
                dcCharges =objWrap.decTaxAmount;
            objCharges.IGST__c = objWrap.IGST;
            objCharges.SGST__c = objWrap.SGST;
            objCharges.CGST__c = objWrap.CGST;
            objCharges.Total_Amount__c = objWrap.decTaxAmount; //IntTotalAmount;
            if(objmainWrap.objMRN.MRN_Delivery_Type__c=='Domestic'){
                    objCharges.Charge_Percentage__c=100;
                }
            totalcharges =totalcharges+(objCharges.Total_Amount__c/SubtotalItemAmount);
            lstCharge.add(objCharges);
            System.debug('lstCharge--------- '+lstCharge.size());
            system.debug(objWrap.strTaxName+'...strTaxName....'+objWrap.TaxPercentage);
        }
        
        //update MRN
        if(clgCharges !=null && SubtotalItemAmount !=null && objmainWrap.objMRN.Exchange_Rate__c !=null){
            objmainWrap.objMRN.clgCharges__c=((clgCharges/ objmainWrap.objMRN.Exchange_Rate__c)/SubtotalItemAmount)*100;
            objmainWrap.objMRN.dcCharges__c=((dcCharges/ objmainWrap.objMRN.Exchange_Rate__c)/SubtotalItemAmount)*100;
                }
            else{
                objmainWrap.objMRN.clgCharges__c=0;
            objmainWrap.objMRN.dcCharges__c=0;
            }
        objmainWrap.objMRN.Total_Charges_Percentage__c=totalcharges*100;
        objmainWrap.objMRN.Subtotal_Item_Freight_GBP__c = IntItemFreighGBP;
        objmainWrap.objMRN.Subtotal_Custom_Duty_Amount_INR__c = IntCDutyAmountINR;
        objmainWrap.objMRN.Subtotal_Taxable_Amount__c = IntTaxableValue;
        objmainWrap.objMRN.Subtotal_Item_Value_in_INR__c=SubtotaltotallineitemvalueinInr;
        objmainWrap.objMRN.Subtotal_Assessable_Value_INR__c=SubtotalAssesablevalue;
        objmainWrap.objMRN.Charges_Net_Amount__c = TotalTax;
        objmainWrap.objMRN.Subtotal_Item_Amount__c =SubtotalItemAmount;
        update objmainWrap.objMRN; 
        
        if(lstMRNLI.size()>0){
            Upsert lstMRNLI;
            
            set<string> setOfCharges = new set<string>();
            for(MRN_Line_Item__c mli : lstMRNLI)
            {
                setOfCharges.add(mli.id);
            }
            delete [select Id from MRN_Line_Item__c where ID NOT IN: setOfCharges and MRN__c =: strRecordId];
        }
        
        System.debug('lstCharge---2------ '+lstCharge.size());
        if(lstCharge.size()>0){
            upsert lstCharge;
            set<string> setOfCharges = new set<string>();
            for(Charges__c objCharge : lstCharge)
            {
                setOfCharges.add(objCharge.id);
            }
            try{
                 delete [select Id from Charges__c where ID NOT IN: setOfCharges and MRN__c =: strRecordId];
            }
            catch(Exception ex){
                System.debug('ex------ '+ex.getMessage());
            }
        }
        else if(lstCharge.isempty() && !existcharges.isempty()){
            try{
                 delete [select Id from Charges__c where MRN__c =: strRecordId];
            }
            catch(Exception ex){
                System.debug('ex------ '+ex.getMessage());
            }
        }
        return strRecordId;
    }
    @AuraEnabled
    public static string CreateMRNandLineItems(string strMRNName, string strType, string lstDeliveryNoteLI, string lstCharges, decimal IntTotalAmount, string strWareHouse, string strWrap,Decimal TotalTax,Account supplier)
    {
        // string supplier =''
        system.debug(lstCharges+'...strWrap....'+strWrap);
        list<Contact> con = new list<contact>();
        Decimal IntTaxableValue = 0;
        Decimal IntCDutyAmountINR = 0;
        Decimal IntItemFreighGBP = 0;
        Decimal SubtotaltotallineitemvalueinInr = 0;
        Decimal SubtotalAssesablevalue=0;
        Decimal SubtotalItemAmount = 0;
        
        if(supplier!=null)
            con =[SELECT id from contact where accountid=:supplier.id and isPrimary__c =true limit 1];
        List<TaxDetails> lstTaxDetails = (List<TaxDetails>)Json.deserialize(lstCharges, List<TaxDetails>.Class);
        wrapper objmainWrap = (wrapper)Json.deserialize(strWrap, wrapper.class);
        if(strType !=null && strType != ''){
            List<DeliveryNoteLIWrapper> lstDeliveryNoteLineItems = (List<DeliveryNoteLIWrapper>)Json.deserialize(lstDeliveryNoteLI, List<DeliveryNoteLIWrapper>.Class);
            List<MRN_Line_Item__c> lstMRNLI = new List<MRN_Line_Item__c>();
            if(lstDeliveryNoteLineItems.size()>0){
                //---------------------------Sales Return--------------------------------
                if(strType == 'Sales Return'){
                    objmainWrap.objMRN.MRN_Type__c = 'Sales Return';
                    
                    if(TotalTax ==null){
                        objmainWrap.objMRN.Charges_Net_Amount__c =0;
                    }
                    else{
                        
                        objmainWrap.objMRN.Charges_Net_Amount__c = TotalTax;
                    }
                    objmainWrap.objMRN.stage__c= 'Draft';
                    objmainWrap.objMRN.Supplier__c=supplier?.id;
                    if(!con.isempty())
                    objmainWrap.objMRN.Supplier_Contact_Name__c=con[0]?.id;
                    objmainWrap.objMRN.Ware_House__c = lstDeliveryNoteLineItems[0].ObjDNLI.Sales_Order_Dispatch_Delivery_Note__r.Sales_Order__r.Ware_House__c;
                    objmainWrap.objMRN.Delivery_Note__c = lstDeliveryNoteLineItems[0].ObjDNLI.Sales_Order_Dispatch_Delivery_Note__c;
                    objmainWrap.objMRN.Contact_Name__c = lstDeliveryNoteLineItems[0].ObjDNLI.Sales_Order_Dispatch_Delivery_Note__r.Contact_Person_Name__c;
                    objmainWrap.objMRN.OEM_Customer__c = lstDeliveryNoteLineItems[0].ObjDNLI.Sales_Order_Dispatch_Delivery_Note__r.Customer_Party__c;
                    objmainWrap.objMRN.Shipping_Account__c = lstDeliveryNoteLineItems[0].ObjDNLI.Sales_Order_Dispatch_Delivery_Note__r.Shipping_Account__c;
                    insert objmainWrap.objMRN;
                    for(DeliveryNoteLIWrapper objDN : lstDeliveryNoteLineItems){
                        system.debug('...objDN.'+objDN);
                        MRN_Line_Item__c objMRNLI = new MRN_Line_Item__c();
                        objMRNLI.MRN__c = objmainWrap.objMRN.Id;
                        objMRNLI.Part_Number__c = objDN.ObjDNLI.Product_Part__c;
                        objMRNLI.Quantity__c = objDN.ObjDNLI.Quantity__c;
                        objMRNLI.Sales_Price__c = objDN.ObjDNLI.Sales_Price__c;
                        objMRNLI.Total_Amount_Input__c = objMRNLI.Quantity__c*objMRNLI.Sales_Price__c;
                        if(objDN.ObjDNLI.CGST__c!=null)
                            objMRNLI.CGST__c = objDN.ObjDNLI.CGST__c;
                        objMRNLI.DOC_Number__c = objDN.strDocNo;
                        if(objDN.ObjDNLI.SGST__c!=null)
                        objMRNLI.SGST__c = objDN.ObjDNLI.SGST__c; 
                        if(objDN.ObjDNLI.IGST__c!=null)
                        objMRNLI.IGST__c = objDN.ObjDNLI.IGST__c;
                        objMRNLI.Remarks__c = objDN.ObjDNLI.Remark__c;
                        objMRNLI.Delivery_Note_Line_Item__c = objDN.ObjDNLI.Id;
                        objMRNLI.Discount__c = objDN.ObjDNLI.Discount__c;
                        objMRNLI.Specification__c = objDN.ObjDNLI.Specification__c;
                        objMRNLI.Delivery_Date__c = objDN.ObjDNLI.Delivery_Date__c;
                        objMRNLI.Application__c = objDN.ObjDNLI.Application__c;
                        objMRNLI.Usage__c = objDN.ObjDNLI.Usage__c;
                        objMRNLI.Stock__c =objDN.StockId;
                        if(objDN.docDate != null)
                            objMRNLI.POC_Date__c = objDN.docDate;
                        lstMRNLI.add(objMRNLI);
                    }
                }

            if(objmainWrap.lstDeliveryNoteLIWrap.size()>0){
                if(strType == 'Purchase Order' || strType =='Direct'){
                    Decimal FreightInvoice=0;
                    Decimal TotalAmountGBP=0;
                    Decimal ItemValueInINR=0;
                    Decimal AssessableValueINR=0;
                    Decimal TaxableAmount=0;

                    objmainWrap.objMRN.MRN_Type__c = strType;
                    objmainWrap.objMRN.Ware_House__c = strWareHouse;
                    objmainWrap.objMRN.Charges_Net_Amount__c = TotalTax;
                    objmainWrap.objMRN.Subtotal_Item_Amount__c =SubtotalItemAmount;
                    objmainWrap.objMRN.Supplier__c=supplier.id;
                    
                    if(!con.isEmpty())
                    objmainWrap.objMRN.Supplier_Contact_Name__c=con[0]?.id;
                    //--------Insert Mrn------------
                    insert objmainWrap.objMRN; 
                    
                    for(DeliveryNoteLIWrapper objDN : objmainWrap.lstDeliveryNoteLIWrap){
                        MRN_Line_Item__c objMRNLI = new MRN_Line_Item__c();
                        if(objmainWrap.objMRN.MRN_Type__c == 'Direct'){
                            if(objDN.objPart !=null)
                                objMRNLI.Part_Number__c = objDN.objPart.Id;
                        }
                        else
                        {
                            if(objDN.objPart != null)
                                objMRNLI.Part_Number__c = objDN.objPart.Id;
                            objMRNLI.DOC_Number__c = objDN.strDocNo;
                            if(objDN.docDate != null)
                                objMRNLI.POC_Date__c = objDN.docDate;
                        }
                        if(strType == 'Purchase Order'){
                            if(objDN.objPOLI != null && objDN.objPOLI.Id != null)
                                objMRNLI.Purchase_Order_Line_Item__c = objDN.objPOLI.Id;
                            objMRNLI.Stock__c =objDN.StockId;
                        }
                        
                        objMRNLI.MRN__c = objmainWrap.objMRN.Id;
                        objMRNLI.Ware_House__c = strWareHouse;
                        objMRNLI.UOM__c = objDN.strUOM;
                        objMRNLI.UOI__c = objDN.strUOI;
                        objMRNLI.Remarks__c = objDN.objPOLI.Remark__c;
                        objMRNLI.HSN_SAC__c = objDN.strHSN;
                        objMRNLI.BIN_NO__c = objDN.IntBinQty;
                        objMRNLI.Unit__c= integer.valueof(objDN.IntUNIT);                 
                        objMRNLI.Bill_QTY__c = objDN.IntBillQty;
                        objMRNLI.Received_QTY__c =objDN.IntReceiptQty;
                        objMRNLI.PO_QTY__c = objDN.IntPOQty;
                        objMRNLI.Accept_QTY__c = objDN.IntAcceptQty;
                        objMRNLI.Item_Price_Unit__c = objDN.IntPriceGBP;
                        TotalAmountGBP =  objMRNLI.Bill_QTY__c * objMRNLI.Item_Price_Unit__c;
                        
                        if(objmainWrap.objMRN.MRN_Delivery_Type__c=='Import'){
                            FreightInvoice =TotalAmountGBP+((TotalAmountGBP*(objmainWrap.objMRN.Freight__c/objmainWrap.objMRN.Ex_Work_Value__c )*100 )/100)+((TotalAmountGBP*(objmainWrap.objMRN.Surcharge__c /objmainWrap.objMRN.Ex_Work_Value__c )*100)/100);
                            ItemValueInINR = objmainWrap.objMRN.Exchange_Rate__c*FreightInvoice;
                            AssessableValueINR = ItemValueInINR+(ItemValueInINR * decimal.valueof(objmainWrap.objMRN.Insurance_of_BOE__c)/100);
                            TaxableAmount=AssessableValueINR+objDN.IntCDutyAmountINR;
                        }
                        else{
                            TotalAmountGBP=0;
                            FreightInvoice =0;
                            ItemValueInINR =  objMRNLI.Bill_QTY__c * objMRNLI.Item_Price_Unit__c;
                            AssessableValueINR = 0;
                            TaxableAmount=objMRNLI.Bill_QTY__c * objMRNLI.Item_Price_Unit__c;
                        }
                        objMRNLI.Total_Amount_Input__c =TotalAmountGBP;
                        objMRNLI.Item_Value_With_Freight_Surcharge__c=FreightInvoice;
                        objMRNLI.Total_Item_Value_In_INR_input__c=ItemValueInINR;
                        objMRNLI.Assessable_Value_INR__c=AssessableValueINR;
                        objMRNLI.PO_Taxable_Amount_input__c=TaxableAmount;    
                        objMRNLI.Discount__c = objDN.objPOLI.Discount__c;
                        if(objDN.IntCGSTRate!=null)
                        objMRNLI.PO_CGST__c = objDN.IntCGSTRate;
                        if(objDN.IntSGSTRate!=null)
                        objMRNLI.PO_SGST__c = objDN.IntSGSTRate;
                        if(objDN.IntIGSTRate!=null)
                        objMRNLI.PO_IGST__c = objDN.IntIGSTRate;
                        if(objDN.IntGSTRate!=null)
                        objMRNLI.GST__c = objDN.IntGSTRate;
                        objMRNLI.Sur_Rate__c =objDN.IntSurRate;
                        objMRNLI.Duty_Rates__c =objDN.IntDutyRate;
                        objMRNLI.Landing_Rate__c = objDN.IntLandingRate;
                        objMRNLI.Net_Amount__c = objDN.IntNetAmount;
                        SubtotalItemAmount =SubtotalItemAmount+(objDN.IntBillQty*objDN.IntPriceGBP);
                        if(IntTaxableValue!=null && objDN.IntTaxableValue!=null)
                            IntTaxableValue =IntTaxableValue+objDN.IntTaxableValue;
                        if(objmainWrap.objMRN.MRN_Delivery_Type__c=='Import'){
                            IntCDutyAmountINR =IntCDutyAmountINR+objDN.IntCDutyAmountINR;
                            IntItemFreighGBP =IntItemFreighGBP+objDN.IntItemFreighGBP;
                            SubtotalAssesablevalue = SubtotalAssesablevalue+objDN.IntAssessableValueINR;
                            SubtotaltotallineitemvalueinInr=SubtotaltotallineitemvalueinInr+objDN.IntItemvalueINR;
                        }
                        lstMRNLI.add(objMRNLI);
                    }
                }
            }
        }
            List<Charges__c> lstCharge = new List<Charges__c>();
            Decimal totalCharges =0;
            Decimal dcCharges =0;
            Decimal clgCharges =0;
            for(TaxDetails objWrap : lstTaxDetails){
                Charges__c objCharges = new Charges__c();
                objCharges.MRN__c = objmainWrap.objMRN.Id;
                objCharges.Charges__c = objWrap.strTaxId;
                objCharges.GST__c = objWrap.GST;
                objCharges.IGST__c = objWrap.IGST;
                objCharges.SGST__c = objWrap.SGST;
                objCharges.CGST__c = objWrap.CGST;
                if(objmainWrap.objMRN.MRN_Delivery_Type__c=='Domestic'){
                    objCharges.Charge_Percentage__c=100;
                }
                if(Label.clgCharges ==objWrap.strTaxId)
                    clgCharges =objWrap.decTaxAmount;
                if(Label.dcChargeId ==objWrap.strTaxId)
                    dcCharges =objWrap.decTaxAmount;
                objCharges.Total_Amount__c = objWrap.decTaxAmount; //IntTotalAmount;
                
                totalCharges=totalCharges+(objCharges.Total_Amount__c/SubtotalItemAmount);
                lstCharge.add(objCharges);
            }
            if(clgCharges !=null && SubtotalItemAmount !=null && objmainWrap.objMRN.Exchange_Rate__c !=null){
            objmainWrap.objMRN.clgCharges__c=((clgCharges/ objmainWrap.objMRN.Exchange_Rate__c)/SubtotalItemAmount)*100;
            objmainWrap.objMRN.dcCharges__c=((dcCharges/ objmainWrap.objMRN.Exchange_Rate__c)/SubtotalItemAmount)*100;
                }
            else{
                objmainWrap.objMRN.clgCharges__c=0;
            objmainWrap.objMRN.dcCharges__c=0;
            }
            
            objmainWrap.objMRN.Total_Charges_Percentage__c = totalCharges*100;
            objmainWrap.objMRN.Subtotal_Item_Freight_GBP__c = IntItemFreighGBP;
            objmainWrap.objMRN.Subtotal_Custom_Duty_Amount_INR__c = IntCDutyAmountINR;
            objmainWrap.objMRN.Subtotal_Taxable_Amount__c = IntTaxableValue;
            objmainWrap.objMRN.Subtotal_Item_Value_in_INR__c=SubtotaltotallineitemvalueinInr;
            objmainWrap.objMRN.Subtotal_Assessable_Value_INR__c=SubtotalAssesablevalue;
            objmainWrap.objMRN.Charges_Net_Amount__c = TotalTax;
            objmainWrap.objMRN.Subtotal_Item_Amount__c =SubtotalItemAmount;
            update objmainWrap.objMRN; 
            if(lstMRNLI.size()>0){
                Insert lstMRNLI;
            }
            if(lstCharge.size()>0){
                Insert lstCharge;
            }
            return objmainWrap.objMRN.Id;
        }else{
            return null;
        }
        
    }
    
    @AuraEnabled
    public static string fetchData(string strWrap, String searchKeyWord, string strWareHouseId, string strSupplier) {
        
        //wrapper objmainWrap = new wrapper();
        system.debug('..strWrap..'+strWrap);
        //if(strWrap !=null && strWrap !='')
        wrapper objmainWrap = (wrapper)Json.deserialize(strWrap, wrapper.class);
        objmainWrap.LstWrapperResult=new List<WrapperResult>();
        String newSearchText = '%'+searchKeyWord+'%';
        if(searchKeyWord !=null && searchKeyWord !=''){
            map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
            Schema.sObjectType sObjType = globalDescription.get('Purchase_Order__c');
            Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
            List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
            string soql = 'select ' + string.join(leadfieldNames, ',') +' from Purchase_Order__c where Purchase_Order_Number__c LIKE:newSearchText and Ware_House__c =:strWareHouseId and Supplier__c =: strSupplier LIMIT 5'; 
            system.debug('......'+soql);
            List<Purchase_Order__c> lstSODN = Database.query(soql);
            for(Purchase_Order__c objPO : lstSODN){
                WrapperResult objWrap = new WrapperResult();
                system.debug(objPO.Id+'...objPO.Id......'+objPO.Purchase_Order_Number__c);
                objWrap.RecordId = objPO.Id;
                if(objPO.Ref_No__c != null)
                    objWrap.RecordName = objPO.Purchase_Order_Number__c+'('+objPO.Ref_No__c+')';
                else
                    objWrap.RecordName = objPO.Purchase_Order_Number__c;
                system.debug(objWrap.RecordId+'...objWrap.RecordId.....'+objWrap.RecordName);
                objmainWrap.LstWrapperResult.add(objWrap);
            }   
        }
        system.debug('....LstWrapperResult.....'+objmainWrap.LstWrapperResult);
        return JSON.serialize(objmainWrap);
    }
    
    @AuraEnabled
    public static string SearchPurchaseOrderLI(string strWrap, string objectName, string strPurchaseOrderId, string strWareHouseId)
    {
        //wrapper objmainWrap = new wrapper();
        system.debug(strPurchaseOrderId+'..strWrap....'+strWrap);
        List<String> lstPurchaseOrder = strPurchaseOrderId.split(',');
        
        wrapper objmainWrap = (wrapper)Json.deserialize(strWrap, wrapper.class);
        objmainWrap.lstDeliveryNoteLIWrap = new List<DeliveryNoteLIWrapper>();
        List<WrapperResult> itemsPurchaseOrderLI = objmainWrap.itemsPurchaseOrderLI;
        try
        {
            system.debug(itemsPurchaseOrderLI+'.....'+objmainWrap.itemsPurchaseOrderLI.size()+'.....'+objmainWrap.itemsPurchaseOrderLI);
            Set<Id> SetOfId = new Set<Id>();
            for(string strId : lstPurchaseOrder){
                SetOfId.add(strId);
            }
            system.debug('...SetOfId....'+SetOfId);
            string filter = '';
            if(SetOfId.size()>0 && SetOfId !=null){
                map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
                Schema.sObjectType sObjType = globalDescription.get(objectName);
                Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
                List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
                
                /* Adding the object and filter by name to the soql */
                string soql = 'select ' + string.join(leadfieldNames, ',') +',Purchase_Order__r.Purchase_Order_Number__c,Product_Part__r.UOI__c,Purchase_Order__r.PO_Date__c,Product_Part__r.BinNumber__c,Purchase_Order__r.Name,Purchase_Order__r.CreatedDate,Ware_House__r.City__c,Ware_House__r.Name, Product_Part__r.Name,Product_Part__r.Part_Name__c,Product_Part__r.HSN_CODE__c,Product_Part__r.UOM__c from ' + objectName ; 
                system.debug('......'+soql);     
                soql += ' where Purchase_Order__c IN: SetOfId';
                system.debug('====='+soql);
                List<Purchase_Order_Line_Item__c> lstPOLI = Database.query(soql);
                
                system.debug('lstPOLI......'+lstPOLI.size());
                map<string,Stock__c> mapNoOfStock = new map<string,Stock__c>();//where Ware_House__c =: strWareHouseId
                for(Stock__c objStock : [Select Id,Name,Ware_House__c,Ware_House__r.City__c,Product_Part__c,Quantity__c,Total_Quantity__c from Stock__c where Ware_House__c =: strWareHouseId]){
                    mapNoOfStock.put(objStock.Product_Part__c+'-'+objStock.Ware_House__c,objStock);
                }
                //soql += 'order by Name limit 10';
                system.debug(mapNoOfStock+'...mapNoOfStock....'+mapNoOfStock.size());
                for(Purchase_Order_Line_Item__c objPOLI : lstPOLI){
                    
                    for(integer i=0;i<objmainWrap.lstGSTRate.size();i++){
                        System.debug('-----------label------ '+objmainWrap.lstGSTRate[i]);
                    }
                    
                    DeliveryNoteLIWrapper objSMW = new DeliveryNoteLIWrapper();
                    objSMW.strDocNo = objPOLI.Purchase_Order__r.Purchase_Order_Number__c;
                    if(objPOLI.Purchase_Order__r.PO_Date__c != null)
                        objSMW.docDate = objPOLI.Purchase_Order__r.PO_Date__c;
                    
                     Part__c objPartID = new Part__c();
                     if(objPOLI.Product_Part__c != null){
                        objPartID.Id = objPOLI.Product_Part__c;
                        objSMW.objPart = objPartID;
                     }
                    objSMW.objPOLI =objPOLI;
                    objSMW.strPartNumber = objPOLI.Product_Part__r.Name;
                    objSMW.strDescription = objPOLI.Product_Part__r.Part_Name__c;
                    objSMW.strHSN = objPOLI.HSN_Code__c;   
                    objSMW.strWareHouse = objPOLI.Ware_House__r.Name;
                    objSMW.IsEdit = true;
                    objSMW.decGrossAmount = objPOLI.Total_Amount__c - objPOLI.Discount_Amount__c;
                    objSMW.IntNetAmount = objPOLI.Net_Amount_Formula__c;
                    objSMW.IntLandingRate =0;
                    objSMW.IntPOQty=integer.valueof(objPOLI.Quantity__c);
                    objSMW.IntBillQty = integer.valueof(objPOLI.Quantity__c);
                    objSMW.IntReceiptQty = integer.valueof(objPOLI.Quantity__c);
                    objSMW.IntBinQty = objPOLI.Product_Part__r.BinNumber__c;
                    objSMW.IntAcceptQty =objSMW.IntBillQty-objSMW.IntReceiptQty;
                    objSMW.IntShortQty =0;
                    objSMW.strUOM = 'NOS';
                    objSMW.strUOI = objPOLI.Product_Part__r.UOI__c;
                    objSMW.IntPriceGBP = objPOLI.Sales_Price__c;
                    objSMW.IntTotalAmountGBP =integer.valueof(objPOLI.Quantity__c) *objPOLI.Sales_Price__c;
                    objSMW.IntDutyRate =10;
                    objSMW.IntSurRate =10;
                    objSMW.IntTotalLandedAmountINR =0;
                    objSMW.IntLandedCostUnitINR =0;
                    
                    decimal TotalGBPAmount = integer.valueof(objPOLI.Quantity__c) *objPOLI.Sales_Price__c;
                    if(objmainWrap.objMRN.MRN_Delivery_Type__c == 'Import'){
                        decimal InvSurcharge = objmainWrap.objMRN.Surcharge__c *100/objmainWrap.objMRN.Ex_Work_Value__c;
                        decimal FreightInvoice = objmainWrap.objMRN.Freight__c*100/objmainWrap.objMRN.Ex_Work_Value__c;
                        
                        objSMW.IntItemFreighGBP =TotalGBPAmount+(TotalGBPAmount* InvSurcharge/100)+(TotalGBPAmount*FreightInvoice/100);
                        objSMW.IntItemvalueINR =objSMW.IntItemFreighGBP*objmainWrap.objMRN.Exchange_Rate__c;
                        objSMW.IntAssessableValueINR = objSMW.IntItemvalueINR+(objSMW.IntItemvalueINR * decimal.valueof(objmainWrap.objMRN.Insurance_of_BOE__c)/100);
                        objSMW.IntCDutyAmountINR =objSMW.IntAssessableValueINR *objSMW.IntDutyRate/100+(objSMW.IntAssessableValueINR * objSMW.IntDutyRate/100 * objSMW.IntSurRate/100);
                        
                        objSMW.IntTaxableValue =objSMW.IntAssessableValueINR + objSMW.IntCDutyAmountINR;
                        objSMW.IntGSTRate =18;
                        objSMW.IntGSTAmount =objSMW.IntTaxableValue*objSMW.IntGSTRate/100;
                        objSMW.IntTotalInsuranceCost =objSMW.IntTaxableValue+objSMW.IntGSTAmount;
                    }
                    else{
                        objSMW.IntCGSTRate =objPOLI.CGST__c;
                        objSMW.IntCGSTAmount =objPOLI.CGST_Amount_Formula__c;
                        objSMW.IntSGSTRate =objPOLI.SGST__c;
                        objSMW.IntSGSTAmount =objPOLI.SGST_Amount_Formula__c;
                        objSMW.IntIGSTRate =objPOLI.IGST__c;
                        objSMW.IntIGSTAmount =objPOLI.IGST_Amount_Formula__c;
                        objSMW.IntTaxableValue =  objPOLI.Taxable_Amount_Formula__c;
                        objSMW.IntTotalInsuranceCost =objPOLI.Net_Amount_Formula__c;
                        
                    }
                    objSMW.IntLANDUnitRateINR = 0;
                    
                    objSMW.strRack ='';
                    
                    if(objPOLI.Product_Part__c !=null && strWareHouseId !=null && mapNoOfStock.containskey(objPOLI.Product_Part__c+'-'+strWareHouseId) && mapNoOfStock.get(objPOLI.Product_Part__c+'-'+strWareHouseId) != null){
                        objSMW.StockTotalProduct =Integer.valueof(mapNoOfStock.get(objPOLI.Product_Part__c+'-'+strWareHouseId).Total_Quantity__c);
                        objSMW.StockId =mapNoOfStock.get(objPOLI.Product_Part__c+'-'+strWareHouseId).Id; 
                    }
                    
                    objmainWrap.lstDeliveryNoteLIWrap.add(objSMW);
                    
                }
            }
        }catch(Exception e)
        {
            objMainWrap.Issuccess= false;
            objMainWrap.strError = ExceptionMessage.getExceptionMsg(e);
        }
        return JSON.serialize(objmainWrap);
    }
    
    public class wrapper
    {
        public string strError;
        public string strSuccess;
        public boolean Issuccess;
        public List<Delivery_Note_Line_Item__c> ObjDNLI;
        public List<DeliveryNoteLIWrapper> lstDeliveryNoteLIWrap;
        public List<DeliveryNoteLIWrapper> lstMRNLineItems;
        public List<WrapperResult> LstWrapperResult;
        public List<WrapperResult> itemsPurchaseOrderLI;
        public list<TaxType> lstTaxType;
        public list<TaxDetails> lstOldCharges;
        public list<TaxDetails> lstTaxDetails;
        public list<TaxDetails> lstCharges;
        public string strRemarks;
        public List<string> lstDeliveryType;
        public List<string> lstCurrencyType;
        public List<string> lstDispatchMode;
        public List<string> lstInsuranceofBOE;
        public MRN__c objMRN;
        public list<DeliveryNoteLIWrapper> lstSubMain;
        public decimal TotalTaxAmount;
        public List<string> lstUnitType;
        public List<string> lstCustomDutyRate;
        public List<string> lstCustomSurRate;
        public List<string> lstGSTRate;
        public List<string> lstUOM;
        public List<string> lstUOI;
    }
    public Class WrapperResult{
        @AuraEnabled
        public string RecordId{get;set;}
        @AuraEnabled
        public string RecordName{get;set;}
    }
    public class TaxType{
        public string id;
        public string value;
    }
    public class TaxDetails{
        public Tax__c objTax;
        public string strTaxId;
        public string strTaxName;
        public decimal TaxPercentage;
        public decimal decTaxAmount;
        public decimal GST;
        public decimal CGST;
        public decimal SGST;
        public decimal IGST;
        public decimal NetAmount;
    }
    public class DeliveryNoteLIWrapper 
    {
        public Delivery_Note_Line_Item__c ObjDNLI;
        public MRN_Line_Item__c  ObjMRNLI;
        public Purchase_Order_Line_Item__c objPOLI;
        public string strPartNumber;
        public Part__c objPart;
        public string strDescription;
        public string strHSN;
        public boolean IsEdit;
        public Integer StockTotalProduct;
        public string StockId;
        public decimal decGrossAmount;
        public decimal IntNetAmount;
        public string strWareHouse;
        public decimal IntLandingRate;
        public decimal IntAcceptQty;
        public string strUnit;
        public List<string> lstUnitType;
        public Integer IntBillQty;
        public Integer IntReceiptQty;
        public String IntBinQty;
        public Integer IntShortQty;
        public Integer IntPOQty;
        public string strUOM;
        public string strUOI;
        public decimal IntPriceGBP;
        public decimal IntTotalAmountGBP;
        public decimal IntItemFreighGBP;
        public decimal IntItemvalueINR;
        public decimal IntAssessableValueINR;
        public decimal IntDutyRate;
        public decimal IntSurRate;
        public decimal IntCDutyAmountINR;
        public decimal IntLANDUnitRateINR;
        public decimal IntTotalLandedAmountINR;
        public decimal IntLandedCostUnitINR;
        public decimal IntTaxableValue;
        public decimal IntGSTRate;
        public decimal IntGSTAmount;
        public decimal IntTotalInsuranceCost;
        public decimal IntCGSTRate;
        public decimal IntCGSTAmount;
        public decimal IntSGSTRate;
        public decimal IntSGSTAmount;
        public decimal IntIGSTRate;
        public decimal IntIGSTAmount;
        public string strRack;
        public decimal IntUNIT;
        public string strDocNo;
        public date docDate;
    }
}