public class SaleOrderAcknowledgement {
    
    public Sales_Order__c objSO {get;set;}
    public Account objAcc {get;set;}
    public Contact objCon {get;set;}
    public list<Contact> ShippingObjCon {get;set;}
    
    public string sign{get;set;}
    
    public contact ShippingContact{get;set;}
    
    public Account objShippingAcc {get;set;}
    public Contact objShippingCon {get;set;}
    
    public Pdf_Header__mdt pdfheader{get;set;}
    public decimal TotalAmountwithoutround{get; set;}
    public string totalAmountWithTCSstring{get; set;}
    public List<wrapper> lstSOIW {get; set;}
    public decimal subTotalTaxableAmount{get;set;}
    public decimal subTotalAmount{get;set;}
    public Decimal SubTotalIGST{get;set;}
    public Decimal SubTotalCGST{get;set;}
    public Decimal SubTotalSGST{get;set;}
    public decimal TotalTaxableAmount{get;set;}
    public decimal TotalAmount{get;set;}
    public String TotalAmountInWords{get;set;}
    public Decimal TotalIGST{get;set;}
    public Decimal TotalCGST{get;set;}
    public Decimal TotalSGST{get;set;}
    public Decimal TotalGST{get;set;}
    public GSTCharges objGSTCharge{get;set;}
    
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
    
    public decimal amountTCS{get;set;}
    public decimal totalAmountWithTCS{get;set;}
    
    public boolean igstbool {get;set;}
    public list<taxSummary> taxSummarylist {get;set;}
    
    public SaleOrderAcknowledgement(ApexPages.StandardController controller){
        String strId = ApexPages.currentPage().getParameters().get('id');
        
        pdfheader=new Pdf_Header__mdt();
        
        //Initialization
        objSO = new Sales_Order__c();
        objAcc = new Account();
        objCon = new contact();
        
        objShippingAcc = new Account();
        objShippingCon = new contact();
        
        
        lstSOIW = new List<wrapper>();
        subTotalTaxableAmount = 0;
        subTotalAmount = 0;
        SubTotalIGST = 0;
        SubTotalCGST = 0;
        SubTotalSGST = 0;
        TotalTaxableAmount = 0;
        TotalAmount = 0;
        TotalAmountInWords ='';
        TotalIGST = 0;
        TotalCGST = 0;
        TotalSGST = 0;
        TotalGST = 0;
        TotalAmountwithoutround=0;
        objGSTCharge = new GSTCharges();
        
        if(String.isNotBlank(strId)){
            
            List<String> lstSalesOrderField = UtilityClass.getAllFields('Sales_Order__c');
            List<String> lstSalesOrderItemField = UtilityClass.getAllFields('Sales_Order_Line_Item__c');
            
            
            String strSalesOrderQuery = 'Select ' +String.Join(lstSalesOrderField, ',')+',Shipping_Account__r.Print_Name__c,Customer_Name__r.ShippingState,Shipping_Account__r.name,Shipping_Account__r.Shipping_State_Code__c,Shipping_Account__r.Shipping_GSTIN_No__c,Ware_House__r.Branch__c,Ware_House__r.city__c,ESN_No_lookup__r.Name,Opportunity__r.Office__c,Shipping_Account__r.ShippingState,Customer_Name__r.TCS_Charges_Enable__c'+ ' From Sales_Order__c where Id =: strId';
            String strSalesOrderItemQuery = 'Select ' +String.Join(lstSalesOrderItemField, ',')+ ',Product_Part__r.name,Product_Part__r.uom__c,Product_Part__r.Part_Name__c From Sales_Order_Line_Item__c where Sales_Order__c =: strId';
            
            
            List<Sales_Order__c> lstSaleOrder =  Database.query(strSalesOrderQuery);
            if(lstSaleOrder.size() > 0)
                objSO = lstSaleOrder[0];
            
                  ApexPages.currentPage().getHeaders().put('content-disposition', 'filename=' +' Sales Order - '+objSO.Sales_Order_Acknowledge_Number__c+'.PDF');
                system.debug('strfileName '+' Sales Order-'+objSO.Sales_Order_Acknowledge_Number__c);       
            
             user ur =[SELECT Id,Branch__c,User_Signature__c from user where id =:objSO.OwnerId];
        if(!String.isBlank(ur.User_Signature__c))
        sign = ur.User_Signature__c;
        
        if(String.isBlank(ur.User_Signature__c))
        sign =System.Label.Default_User_Sign;
        
        system.debug(sign);
            
            if(objSO.Shipping_Account__c!=null){
        ShippingObjCon = [select id,name, salutation,phone,MobilePhone, email,isPrimary__c from contact where isPrimary__c= true AND Accountid =:objSO.Shipping_Account__c limit 1];
        if(ShippingObjCon.size()>0){
                ShippingContact = ShippingObjCon[0];
            }
        }
            string branch = objSO.Ware_House__r.Branch__c ;
            List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
            String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt WHERE Branch__c =:branch Order by Effected_Date__c ASC LIMIT 1';
            pdfheader =  Database.query(pdfHeaderQuery);
            
            if(String.isNotEmpty(objSO.Customer_Name__c)){
                String id = objSO.Customer_Name__c;
                String strAccount = 'Select Id, Print_Name__c, Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,GSTIN_No__c,Billing_State_Code__c,Shipping_State_Code__c,(Select Id, Name, Email,salutation, MobilePhone from contacts where isPrimary__c = true) from Account where Id = : id';
                List<Account> lstAcc = Database.query(strAccount);
                if(lstAcc.size() > 0){
                    objAcc = lstAcc[0];
                    if(objAcc.contacts.size()>0)
                        objCon = objAcc.contacts[0];
                }  
            }    
            
            strBillingAddress = '';
            strBillingAddress = objAcc.BillingStreet;
            if(strBillingAddress != null && strBillingAddress !='' && objAcc.BillingCity != null && objAcc.BillingCity !='')
                strBillingAddress = strBillingAddress+', '+objAcc.BillingCity;
            else if(objAcc.BillingCity != null && objAcc.BillingCity !='')
                strBillingAddress = objAcc.BillingCity;
            
            if(strBillingAddress != null && strBillingAddress !='' && objAcc.BillingState != null && objAcc.BillingState !='')
                strBillingAddress = strBillingAddress+', '+objAcc.BillingState ;
            else if(objAcc.BillingState != null && objAcc.BillingState !='')
                strBillingAddress = objAcc.BillingState;
            
            if(strBillingAddress != null && strBillingAddress !='' && objAcc.BillingPostalCode != null && objAcc.BillingPostalCode !='')
                strBillingAddress = strBillingAddress+', '+objAcc?.BillingPostalCode  ;
            else if(objAcc.BillingPostalCode != null && objAcc.BillingPostalCode !='')
                strBillingAddress = objAcc.BillingPostalCode ;
            
            if(strBillingAddress != null && strBillingAddress !='' && objAcc.BillingCountry != null && objAcc.BillingCountry !='')
                strBillingAddress = strBillingAddress+', '+objAcc.BillingCountry  ;
            else if(objAcc.BillingCountry != null && objAcc.BillingCountry !='')
                strBillingAddress = objAcc.BillingCountry ;
            
            
            /*
Billing State And Billing Code, Shipping State and Shipping Code
*/
            
            if(String.isNotEmpty(objSO.Shipping_Account__c)){
                String id = objSO.Shipping_Account__c;
                String strAccount = 'Select Id, Print_Name__c,Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,GSTIN_No__c,Billing_State_Code__c,Shipping_State_Code__c,(Select Id, Name, Email, MobilePhone from contacts where isPrimary__c = true) from Account where Id = : id';
                List<Account> lstAcc = Database.query(strAccount);
                if(lstAcc.size() > 0){
                    objShippingAcc = lstAcc[0];
                    if(objShippingAcc.contacts.size()>0)
                        objShippingCon = objShippingAcc.contacts[0];
                }  
            }    
            
            strBillingState = '';
            strBillingCode = '';
            strShippingState = '';
            strShippingCode = '';
            
            strBillingState = objShippingAcc?.BillingState ;
            strBillingCode = objShippingAcc?.Billing_State_Code__c ;
            
            strShippingAddress = '';
            strShippingAddress = objShippingAcc?.ShippingCity;
            if(strShippingAddress != null && strShippingAddress !='' && objShippingAcc.ShippingCity != null && objShippingAcc.ShippingCity !='')
                strShippingAddress = strShippingAddress+', '+objShippingAcc.ShippingCity;
            else if(objShippingAcc.ShippingCity != null && objShippingAcc.ShippingCity != '')
                strShippingAddress = objShippingAcc.ShippingCity;
            
            if(strShippingAddress != null && strShippingAddress !='' && objShippingAcc.ShippingState != null && objShippingAcc.ShippingState != '')
                strShippingAddress = strShippingAddress+', '+objShippingAcc?.ShippingState ;
            else if(objShippingAcc.ShippingState != null && objShippingAcc.ShippingState != '')
                strShippingAddress = objShippingAcc.ShippingState;
            
            if(strShippingAddress != null && strShippingAddress !='' && objShippingAcc.ShippingPostalCode != null && objShippingAcc.ShippingPostalCode != '')
                strShippingAddress = strShippingAddress+', '+objShippingAcc.ShippingPostalCode  ;
            else if(objShippingAcc.ShippingPostalCode != null && objShippingAcc.ShippingPostalCode != '')
                strShippingAddress = objShippingAcc.ShippingPostalCode ;
            
            if(strShippingAddress != null && strShippingAddress !='' && objShippingAcc.ShippingCountry != null && objShippingAcc.ShippingCountry != '')
                strShippingAddress = strShippingAddress+', '+objShippingAcc.ShippingCountry  ;
            else if(objShippingAcc.ShippingCountry != null && objShippingAcc.ShippingCountry != '')
                strShippingAddress = objShippingAcc.ShippingCountry ; 
            
            strShippingState = objShippingAcc?.ShippingState;
            strShippingCode = objShippingAcc?.Shipping_State_Code__c;
            
            if(strShippingAddress == null || strShippingAddress =='')
            {
                strShippingAddress = strBillingAddress;
                strShippingState = objShippingAcc?.BillingState;
                strShippingCode = objShippingAcc?.Billing_State_Code__c;
            }
            
            map<decimal,decimal> taxsummaryMap = new map<decimal,decimal>();
             igstbool=false;
            
            List<Sales_Order_Line_Item__c> lstSOI = Database.query(strSalesOrderItemQuery);
            set<string> productIDSet = new set<string>();
            if(lstSOI.size() > 0){
                for(Sales_Order_Line_Item__c objSOLI : lstSOI)
            		productIDSet.add(objSOLI.Product_Part__c);
            } 
            system.debug('-----AND Ware_House__c=:objSO.Ware_House__c-------------------'+objSO.Ware_House__c);
            String warehouse = objSO.Ware_House__c; 
                List<String> lststockField = UtilityClass.getAllFields('Stock__c');
                String strStockQuery = 'Select ' +String.Join(lststockField, ',')+' From Stock__c where Product_Part__c IN:productIDSet AND Ware_House__c=: warehouse';
                list<stock__c> stocklist = Database.query(strStockQuery);
            Map<string,stock__c> stockmap = new Map<string,stock__c>(); 
            if(!stocklist.isempty()) for(stock__c st:stocklist) stockmap.put(st.Product_Part__c, st);
            
            
            if(lstSOI.size() > 0){
                for(Sales_Order_Line_Item__c objSOLI : lstSOI){
                    wrapper objWrap = new wrapper();
                    objWrap.objSOLI = objSOLI;
                    if(objSOLI.IGST__c > 0 && objSOLI.Taxable_Amount__c > 0)
                        objWrap.IGSTAmount = ((objSOLI.Taxable_Amount__c * objSOLI.IGST__c)/100).setScale(2);
                    if(objSOLI.SGST__c > 0 && objSOLI.Taxable_Amount__c > 0)
                        objWrap.SGSTAmount = ((objSOLI.Taxable_Amount__c * objSOLI.SGST__c)/100).setScale(2);
                    if(objSOLI.CGST__c > 0 && objSOLI.Taxable_Amount__c > 0)
                        objWrap.CGSTAmount = ((objSOLI.Taxable_Amount__c * objSOLI.CGST__c)/100).setScale(2);
                    
                    if(stockmap.containskey(objSOLI.Product_Part__c) && objSOLI.Quantity__c <= stockmap.get(objSOLI.Product_Part__c).Total_Unbooked_Quantity__c){
                        System.debug(objSOLI.Quantity__c+' ------ '+stockmap.get(objSOLI.Product_Part__c).Total_Unbooked_Quantity__c);
                        objWrap.isAvailable =true;
                    }
                    lstSOIW.add(objWrap);
                    
                    subTotalTaxableAmount = subTotalTaxableAmount+objSOLI.Taxable_Amount__c ;
                    subTotalAmount = subTotalAmount + objSOLI.Total_Amount__c;
                    SubTotalIGST = SubTotalIGST + objWrap.IGSTAmount;
                    SubTotalCGST = SubTotalCGST + objWrap.CGSTAmount;
                    SubTotalSGST = SubTotalSGST + objWrap.SGSTAmount;
                    if(objSOLI.IGST__c > 0)
                        igstbool=true;
                
                    if(taxsummaryMap.isempty() ){
                        if((objSOLI.SGST__c > 0 && !taxsummaryMap.containskey(objSOLI.SGST__c))){
                            decimal taxammount =  objSOLI.Taxable_Amount__c;
                            taxsummaryMap.put(objSOLI.SGST__c,taxammount);
                            system.debug('SGST empty');
                        }
                        if((objSOLI.IGST__c > 0  && !taxsummaryMap.containskey(objSOLI.IGST__c))){
                            decimal taxammount =  objSOLI.Taxable_Amount__c;
                            taxsummaryMap.put(objSOLI.IGST__c,taxammount);
                            system.debug('IGST empty');
                        }
                    }
                    else if((objSOLI.SGST__c > 0 && !taxsummaryMap.containskey(objSOLI.SGST__c))){
                        decimal taxammount =  objSOLI.Taxable_Amount__c;
                        taxsummaryMap.put(objSOLI.SGST__c,taxammount);
                        system.debug('SGST');
                    }
                    else if((objSOLI.IGST__c > 0  && !taxsummaryMap.containskey(objSOLI.IGST__c))){
                        decimal taxammount =  objSOLI.Taxable_Amount__c;
                        taxsummaryMap.put(objSOLI.IGST__c,taxammount);
                        system.debug('IGST');
                    }
                    else{  
                        if(objSOLI.SGST__c > 0 ){
                            decimal taxammount =  taxsummaryMap.get(objSOLI.SGST__c)+objSOLI.Taxable_Amount__c;
                            taxsummaryMap.put(objSOLI.SGST__c,taxammount);
                            
                        }
                        if(objSOLI.IGST__c > 0 ){
                            decimal taxammount =  taxsummaryMap.get(objSOLI.IGST__c)+objSOLI.Taxable_Amount__c;
                            taxsummaryMap.put(objSOLI.IGST__c,taxammount);  
                        } 
                    }      
                }
                
                
                taxSummarylist = new list<taxSummary>();
                if(!taxsummaryMap.isempty()){
                    list<decimal> key = new list<decimal>();
                    key.addall(taxsummaryMap.keySet());
                    for(integer i=0;i < key.size();i++)
                    {
                        taxSummary ts = new taxSummary();
                        ts.percentage = key[i];
                        ts.taxamount = taxsummaryMap.get(ts.percentage);
                        ts.gstamount = ((ts.percentage*ts.taxamount)/100).setScale(2);
                        taxSummarylist.add(ts);  
                    }
                }
                system.debug('list size '+taxSummarylist.size());

                
                if(objSO.Packing_Charges__c > 0 && subTotalTaxableAmount > 0)
                    objGSTCharge.PackingCharges = ((subTotalTaxableAmount*objSO.Packing_Charges__c)/100).setScale(2);
                if(objSO.IGST__c > 0 && objGSTCharge.PackingCharges > 0)
                    objGSTCharge.PackingChargeIGST = ((objGSTCharge.PackingCharges * objSO.IGST__c)/100).setScale(2);
                if(objSO.SGST__c > 0 && objGSTCharge.PackingCharges > 0)
                    objGSTCharge.PackingChargeSGST = ((objGSTCharge.PackingCharges * objSO.SGST__c)/100).setScale(2);
                if(objSO.CGST__c > 0 && objGSTCharge.PackingCharges > 0)
                    objGSTCharge.PackingChargeCGST = ((objGSTCharge.PackingCharges * objSO.CGST__c)/100).setScale(2);
                if(objGSTCharge.PackingCharges > 0 &&(objSO.IGST__c > 0 || objSO.SGST__c > 0 || objSO.CGST__c > 0))
                    objGSTCharge.PackingChargeTotal = objGSTCharge.PackingCharges + objGSTCharge.PackingChargeIGST + objGSTCharge.PackingChargeSGST + objGSTCharge.PackingChargeCGST; 
                
                if(objSO.Freight__c > 0)
                    objGSTCharge.FreightCharges = (objSO.Freight__c).setScale(2);
                if(objSO.IGST__c > 0 &&  objGSTCharge.FreightCharges > 0)
                    objGSTCharge.FreightIGST = (( objGSTCharge.FreightCharges * objSO.IGST__c)/100).setScale(2);
                if(objSO.SGST__c > 0 &&  objGSTCharge.FreightCharges > 0)
                    objGSTCharge.FreightSGST = (( objGSTCharge.FreightCharges * objSO.SGST__c)/100).setScale(2);
                if(objSO.CGST__c > 0 &&  objGSTCharge.FreightCharges > 0)
                    objGSTCharge.FreightCGST = (( objGSTCharge.FreightCharges * objSO.CGST__c)/100).setScale(2); 
                if( objGSTCharge.FreightCharges > 0 &&(objSO.IGST__c > 0 || objSO.SGST__c > 0 || objSO.CGST__c > 0))
                    objGSTCharge.FreightTotal =  objGSTCharge.FreightCharges + objGSTCharge.FreightIGST + objGSTCharge.FreightSGST + objGSTCharge.FreightCGST;  
                
                TotalTaxableAmount = subTotalTaxableAmount + objGSTCharge.PackingCharges + objGSTCharge.FreightCharges;
                TotalAmount = subTotalAmount + objGSTCharge.PackingChargeTotal + objGSTCharge.FreightTotal;
                
                
                
                
                
                
                
                
                
                
                /*TotalIGST = SubTotalIGST + objGSTCharge.PackingChargeIGST + objGSTCharge.FreightIGST;
TotalCGST = SubTotalCGST + objGSTCharge.PackingChargeCGST + objGSTCharge.FreightCGST;
TotalSGST = SubTotalSGST + objGSTCharge.PackingChargeSGST + objGSTCharge.FreightSGST;
TotalGST = TotalIGST+ TotalCGST+ TotalSGST;*/
                
            }
            strWareHouseState = '';
            strWareHouseCode = '';
            strWareHouseCity = '';
            list<Ware_House__c> lseWH = new list<Ware_House__c>();
            if(objSO.Ware_House__c != null)
            {
                lseWH = [Select Id, Name, City__c, State_Code__c,State_Province__c from Ware_House__c where Id =: objSO.Ware_House__c];
                if(lseWH.size()>0 && lseWH[0] != null){
                    strWareHouseState = lseWH[0]?.State_Province__c;
                    strWareHouseCode = lseWH[0]?.State_Code__c;
                    strWareHouseCity = lseWH[0]?.City__c;
                }
            }
            
            decimal totalAmountCgst = 0;
            decimal totalAmountSgst = 0;
            decimal totalAmountIgst = 0;
            decimal TotalAmountWithCharges = 0;
            lstCharges = [Select Id, name,Charges__c,Charges__r.Name,CGST__c,IGST__c,SGST__c,Total_Amount__c,Quote__c,Opportunity__c,Net_Amount__c,Charge_Amount__c,CGST_Amount__c,SGST_Amount__c,IGST_Amount__c,Sales_Order__c from Charges__c where Sales_Order__c =: strId];   
            
            for(Charges__c objCharg : lstCharges)
            {
                TotalTaxableAmount = TotalTaxableAmount+objCharg.Charge_Amount__c;
                totalAmountCgst = totalAmountCgst+objCharg.CGST_Amount__c;
                totalAmountSgst = totalAmountSgst+objCharg.SGST_Amount__c;
                totalAmountIgst = totalAmountIgst+objCharg.IGST_Amount__c;
                TotalAmountWithCharges = TotalAmountWithCharges+objCharg.Net_Amount__c;
            }  
            system.debug('...'+totalAmountCgst+'..'+totalAmountSgst+'....'+totalAmountIgst);
            TotalTaxableAmount = TotalTaxableAmount;
            TotalIGST = (SubTotalIGST+TotalIGST+ totalAmountIgst);
            TotalCGST = (SubTotalCGST+totalAmountCgst+TotalCGST);
            TotalSGST = (SubTotalSGST+totalAmountSgst+TotalSGST);
            TotalGST = TotalIGST+ TotalCGST+ TotalSGST;
            TotalAmount = (subTotalAmount+TotalAmountWithCharges);
            TotalAmountwithoutround= TotalAmountwithoutround + TotalAmount;
            TotalAmount=TotalAmount.round();
            decimal amountTCSPer = 0;
            amountTCS = 0;
            if(TotalAmount > 0){
                TotalAmount = TotalAmount;
                TotalAmountInWords ='Rupees '+ UtilityClass.NoToWord(TotalAmount.intValue())+' only';
            }
            if(objSO.Customer_Name__r.TCS_Charges_Enable__c)
            {
                amountTCS = (TotalAmount * decimal.valueof(system.label.TCS_Percentage)/100);
                amountTCS = amountTCS.setScale(2);
                //amountTCS = (TotalAmount-amountTCSPer).setScale(2);
                
                system.debug(amountTCS+'.....'+amountTCSPer+'....'+TotalAmount);
                totalAmountWithTCS = 0;
                totalAmountWithTCS = TotalAmount +amountTCS;
                totalAmountWithTCS = totalAmountWithTCS.round();
                
                //totalAmountaftertaxinWords = UtilityClass.NoToWord(totalAmountWithTCS.intValue());
                //totalAmountaftertaxinWords = totalAmountaftertaxinWords+' rupees only';
                
                if(totalAmountWithTCS > 0)
                {
                    totalAmountWithTCS = totalAmountWithTCS.round();
                    totalAmountWithTCSstring =totalAmountWithTCS+'.00';
                    TotalAmountInWords = 'Rupees '+UtilityClass.NoToWord(totalAmountWithTCS.intValue())+' only';
                }
            }
        }
    }
    
    public class wrapper{
        public Sales_Order_Line_Item__c objSOLI{get; set;}
        public Decimal CGSTAmount{get; set;}
        public Decimal SGSTAmount{get; set;}
        public Decimal IGSTAmount{get; set;}
        public Boolean isAvailable{get; set;}
        
        public wrapper(){
            objSOLI = new Sales_Order_Line_Item__c();
            CGSTAmount = 0;
            SGSTAmount = 0;
            IGSTAmount = 0;
            isAvailable=false;
        }
        
    }
    
    public class GSTCharges{
        public Decimal PackingCharges{get;set;}
        public Decimal PackingChargeIGST{get;set;}
        public Decimal PackingChargeCGST{get;set;}
        public Decimal PackingChargeSGST{get;set;}
        public Decimal PackingChargeTotal{get;set;}
        public Decimal FreightCharges{get;set;}
        public Decimal FreightIGST{get;set;}
        public Decimal FreightCGST{get;set;}
        public Decimal FreightSGST{get;set;}
        public Decimal FreightTotal{get;set;}
        
        public GSTCharges(){
            PackingCharges = 0;
            PackingChargeIGST = 0;
            PackingChargeCGST = 0;
            PackingChargeSGST = 0; 
            PackingChargeTotal = 0;
            FreightCharges = 0;
            FreightIGST = 0;
            FreightCGST = 0;
            FreightSGST = 0;
            FreightTotal = 0;
        }
    }
    public class taxSummary{
        public  Decimal percentage {get;set;}
        public  Decimal taxamount {get;set;}
        public  Decimal gstamount {get;set;}
    }
}