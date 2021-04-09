public class classCreateDeliveryNoteLIghtngComp {
    
    public static wrappermain wrap{get;set;}
    
    
    @AuraEnabled
    public static string onloadSalesOrder(string recordid){        
        wrap =new wrappermain();
        List<String> salesorder = UtilityClass.getAllFields('Sales_Order__c');
        String salesorderQuery = 'Select ' +String.Join(salesorder, ',')+ ',Ware_House__r.State_Code__c,Customer_Name__r.Billing_State_Code__c,Opportunity__r.Reference_Number__c,Opportunity__r.Reference_Date__c from Sales_Order__c where id=:recordid';
        list<Sales_Order__c> objSalesOrder =  Database.query(salesorderQuery);
        
        List<String> SOL = UtilityClass.getAllFields('Sales_Order_Line_Item__c');
        String SOLQuery = 'Select ' +String.Join(SOL, ',')+ ', Product_Part__r.Part_Name__c, Product_Part__r.Name from Sales_Order_Line_Item__c where Sales_Order__c=: recordid';
        list<Sales_Order_Line_Item__c> objsalesOrderLineItem =  Database.query(SOLQuery);
        
        List<String> dnorder = UtilityClass.getAllFields('Sales_Order_Dispatch_Delivery_Note__c');
        String deliverynoteQuery = 'Select ' +String.Join(dnorder, ',')+ ',Sales_Order__r.Ware_House__r.State_Code__c,Customer_Party__r.Billing_State_Code__c from Sales_Order_Dispatch_Delivery_Note__c where id=:recordid';
        list<Sales_Order_Dispatch_Delivery_Note__c>  deliverynote =  Database.query(deliverynoteQuery);
        
        List<String> DNL = UtilityClass.getAllFields('Delivery_Note_Line_Item__c');
        String DNLQuery = 'Select ' +String.Join(DNL, ',')+ ', Product_Part__r.Part_Name__c, Product_Part__r.Name from Delivery_Note_Line_Item__c where Sales_Order_Dispatch_Delivery_Note__c =: recordid';
        list<Delivery_Note_Line_Item__c> deliverynoteLineItem =  Database.query(DNLQuery);
        
        wrap.recordid=recordid;
        string soid='';
        if(!deliverynote.isempty())
        soid = deliverynote[0].Sales_Order__c;
        String DSOLQuery = 'Select ' +String.Join(SOL, ',')+ ', Product_Part__r.Part_Name__c, Product_Part__r.Name from Sales_Order_Line_Item__c where Sales_Order__c=:soid ';
        list<Sales_Order_Line_Item__c> objDeliverysalesOrderLineItem =  Database.query(DSOLQuery);
        
        Map<string,Sales_Order_Line_Item__c> DSOLMap = new Map<string,Sales_Order_Line_Item__c>();
        if(!objDeliverysalesOrderLineItem.isempty())
            for(Sales_Order_Line_Item__c soli: objDeliverysalesOrderLineItem)
            DSOLMap.put(soli.Product_Part__c,soli);
        
        if(!objSalesOrder.isempty()){
            wrap.isupdate =false;
            wrap.objSales_Order=objSalesOrder[0];
            if(objSalesOrder[0].Ware_House__r.State_Code__c == objSalesOrder[0].Customer_Name__r.Billing_State_Code__c){
                wrap.igstvalue=false;
            }
            else{
                wrap.igstvalue=true;
            }
        }
         if(!deliverynote.isempty()){
             wrap.isupdate =true;
             if(deliverynote[0].Sales_Order__r.Ware_House__r.State_Code__c == deliverynote[0].Customer_Party__r.Billing_State_Code__c){
                 wrap.igstvalue=false;
             }
             else{
                 wrap.igstvalue=true;
             }
         }
        System.debug('wrap.isupdate=== '+wrap.isupdate);
       
        map<string,decimal>prodVsQty=new map<string,decimal>();
        list<Sales_Order_Dispatch_Delivery_Note__c> lstSalesOrder=[select id,Sales_order__c,(select id,Product_Part__c,quantity__c from Delivery_Note_Line_Items__r) from Sales_Order_Dispatch_Delivery_Note__c where Sales_order__c=:recordid];
       
        if(lstSalesOrder.size()>0){
            decimal qty=0;
            for(Sales_Order_Dispatch_Delivery_Note__c so:lstSalesOrder){
                if(so.Delivery_Note_Line_Items__r.size()>0)
                    for(Delivery_Note_Line_Item__c delNotLinItem:so.Delivery_Note_Line_Items__r){
                        if(prodVsQty.containsKey(delNotLinItem.Product_Part__c)){
                            qty=prodVsQty.get(delNotLinItem.Product_Part__c);
                            prodVsQty.put(delNotLinItem.Product_Part__c,qty+delNotLinItem.Quantity__c);
                        }else{
                            prodVsQty.put(delNotLinItem.Product_Part__c,delNotLinItem.Quantity__c);
                        }
                    }
            }   
        }
        list<wrapchild> lstwrpchild = new list<wrapchild>();  
        if(objsalesOrderLineItem.size()>0){         
            for(Sales_Order_Line_Item__c objsalli : objsalesOrderLineItem){
                decimal i=0;
                wrapchild childwrp = new wrapchild();
                childwrp.qty=objsalli.Quantity__c;
                childwrp.isSelected=false;
                childwrp.soliChild=objsalli;
                childwrp.checkboxDisable=false;   
                if(prodVsQty.size()>0){
                    if(prodVsQty.containskey(objsalli.Product_Part__c)){
                        if(objsalli.Quantity__c==prodVsQty.get(objsalli.Product_Part__c)){
                            childwrp.checkboxDisable=true;  
                            i=objsalli.Quantity__c;
                        }else{
                            i=objsalli.Quantity__c-prodVsQty.get(objsalli.Product_Part__c);   
                        }
                    }else{
                        i=0;
                    }      
                }
                childwrp.productid = objsalli.Product_Part__c;
                childwrp.productnumber= objsalli.Product_Part__r.name;
                childwrp.productname = objsalli.Product_Part__r.Part_Name__c;
                childwrp.quantity = objsalli.Quantity__c;
                childwrp.hsncode = objsalli.HSN_Code__c;
                childwrp.reMaininQTY=integer.valueof(i);
                childwrp.salesprice = objsalli.Unit_Price__c;
                childwrp.totalprice = childwrp.salesprice*childwrp.reMaininQTY;
                childwrp.discount = objsalli.Discount__c;
                childwrp.discountamount = (childwrp.totalprice*childwrp.discount)/100;
                childwrp.totalamount = childwrp.totalprice - childwrp.discountamount;
                childwrp.cgst = objsalli.CGST__c;
                childwrp.cgstamount = (childwrp.totalamount*childwrp.cgst)/100;
                childwrp.sgst = objsalli.SGST__c ;
                childwrp.sgstamount = (childwrp.totalamount*childwrp.sgst)/100;
                childwrp.igst = objsalli.IGST__c;
                childwrp.igstamount = (childwrp.totalamount*childwrp.igst)/100;
                childwrp.nettotal = childwrp.totalamount+childwrp.igstamount+childwrp.sgstamount+childwrp.cgstamount;
                childwrp.deliverydate = objsalli.Expected_Date__c;
                childwrp.remark = objsalli.Description__c;
                lstwrpchild.add(childwrp);    
            }          
        }
        else if(deliverynoteLineItem.size()>0){         
                for(Delivery_Note_Line_Item__c objdnli : deliverynoteLineItem){
                    decimal i=0;
                    wrapchild childwrp = new wrapchild();
                    childwrp.qty=objdnli.Quantity__c;
                    childwrp.isSelected=false;
                //    childwrp.soliChild=objdnli;
                    childwrp.checkboxDisable=false; 
                    childwrp.productid = objdnli.Product_Part__c;
                    childwrp.productnumber= objdnli.Product_Part__r.name;
                    childwrp.productname = objdnli.Product_Part__r.Part_Name__c;
                    childwrp.quantity = DSOLMap.get(objdnli.Product_Part__c).Quantity__c;
                    childwrp.hsncode = objdnli.HSN_Code__c;
                    childwrp.reMaininQTY = integer.valueof(objdnli.Quantity__c);
                    childwrp.salesprice = objdnli.Unit_Price__c;
                    childwrp.totalprice = childwrp.salesprice*childwrp.reMaininQTY;
                    childwrp.discount = objdnli.Discount__c;
                    childwrp.discountamount = (childwrp.totalprice*childwrp.discount)/100;
                    childwrp.totalamount = childwrp.totalprice - childwrp.discountamount;
                    childwrp.cgst = objdnli.CGST__c;
                    childwrp.cgstamount = (childwrp.totalamount*childwrp.cgst)/100;
                    childwrp.sgst = objdnli.SGST__c ;
                    childwrp.sgstamount = (childwrp.totalamount*childwrp.sgst)/100;
                    childwrp.igst = objdnli.IGST__c;
                    childwrp.igstamount = (childwrp.totalamount*childwrp.igst)/100;
                    childwrp.nettotal = childwrp.totalamount+childwrp.igstamount+childwrp.sgstamount+childwrp.cgstamount;
                    childwrp.deliverydate = objdnli.Delivery_Date__c ;
                    childwrp.remark = objdnli.Remark__c ;
                    childwrp.id = objdnli.id;
                    lstwrpchild.add(childwrp);    
                }
            }
        if(lstwrpchild.size()>0){
            wrap.wrapChildlst = lstwrpchild;
            wrap.success= true;
        }
        return json.serialize(wrap);
    }	
    
    @AuraEnabled
    public static string createDeliveryNoteObjAndItems(string strMainWrapper){
        Savepoint sp = Database.setSavepoint();
        string dcid ='';
        wrap = new wrappermain();
        list<Delivery_Note_Line_Item__c>lstDelNotItem=new list<Delivery_Note_Line_Item__c>();
        list<Sales_Order_Line_Item__c> sollst=new list<Sales_Order_Line_Item__c>();
        system.debug('strMainWrapper-----------'+strMainWrapper);
        try{
            map<string,decimal>prodVsQty=new map<string,decimal>();
            map<string,Sales_Order_Line_Item__c>prodVsOrderItem=new map<string,Sales_Order_Line_Item__c>();
            map<string,Stock__c>prodIdVsStock=new map<string,Stock__c>();
            string sodid='';
            if(strMainWrapper !='' && strMainWrapper !=null){
                wrap = (wrappermain)Json.deserialize(strMainWrapper, wrappermain.class);
                 dcid = wrap.recordid;
                wrap.success= true;
                System.debug('isupdate=== '+wrap.isupdate);
                if(!wrap.isupdate){
                if(wrap.wrapChildlst.size()>0 && wrap.objSales_Order != null){
                    decimal qty=0;
                    sodid = wrap.objSales_Order.Id;
                    list<Sales_Order_Line_Item__c>lstOrderItem=[select id,Product_Part__c,sales_order__c,quantity__c from Sales_Order_Line_Item__c where sales_order__c=:wrap.objSales_Order.Id];
                    if(lstOrderItem.size()>0){
                        for(Sales_Order_Line_Item__c sOI:lstOrderItem){
                            prodVsOrderItem.put(sOI.Product_Part__c,sOI);
                        }
                    }
                    list<Sales_Order_Dispatch_Delivery_Note__c>lstSalesOrder=[select id,Sales_order__c,(select id,Product_Part__c,quantity__c from Delivery_Note_Line_Items__r) from Sales_Order_Dispatch_Delivery_Note__c where Sales_order__c=:wrap.objSales_Order.Id];
                    if(lstSalesOrder.size()>0){
                        for(Sales_Order_Dispatch_Delivery_Note__c so:lstSalesOrder){
                            if(so.Delivery_Note_Line_Items__r.size()>0)
                                for(Delivery_Note_Line_Item__c delNotLinItem:so.Delivery_Note_Line_Items__r){
                                    if(prodVsQty.containsKey(delNotLinItem.Product_Part__c)){
                                        qty=prodVsQty.get(delNotLinItem.Product_Part__c);
                                        prodVsQty.put(delNotLinItem.Product_Part__c,qty+delNotLinItem.Quantity__c);
                                    }else{
                                        prodVsQty.put(delNotLinItem.Product_Part__c,delNotLinItem.Quantity__c);
                                    }
                                }
                        }
                        
                    }
                    if(wrap.objSales_Order.Ware_House__c != null){
                        list<Stock__c>lstStock=[select id,Product_Part__c,Freeze_Quantity__c,Product_Out__c from Stock__c where Ware_House__c=:wrap.objSales_Order.Ware_House__c];
                        if(lstStock.size()>0){
                            for(Stock__c st:lstStock){
                                prodIdVsStock.put(st.Product_Part__c,st);
                            }
                        } 
                    }
                    Sales_Order_Dispatch_Delivery_Note__c sOD=new Sales_Order_Dispatch_Delivery_Note__c();
                    system.debug('prodVsQty-----------'+prodVsQty+'-----'+prodVsOrderItem);                
                    sOD.Sales_Order__c= wrap.objSales_Order.Id;
                    sOD.Vehicle_No__c= wrap.objSales_Order.Vehicle_Docket_No_F_Opp__c;
                    sOD.LC_Date__c= wrap.objSales_Order.LC_Date__c;
                    sOD.LC_Term__c= wrap.objSales_Order.LC_Term__c;
                    sOD.Customer_Party__c= wrap.objSales_Order.Customer_Name__c;
                    sOD.Mode__c= wrap.objSales_Order.Mode_of_Transport__c;
                    sOD.Remark__c= wrap.objSales_Order.Remark__c;
                    sOD.Shipping_Account__c= wrap.objSales_Order.Shipping_Account__c;
                    sOD.Transporter__c= wrap.objSales_Order.Transporter_Name__c;
                    sOD.Email_of_Contact__c= wrap.objSales_Order.Contact_Person__r.Email;
                    sOD.Reference_No__c=wrap.objSales_Order.Opportunity__r.Reference_Number__c;
                    sOD.Reference_Date__c=wrap.objSales_Order.Opportunity__r.Reference_Date__c;
                    sOD.Date__c=system.today();
                    sOD.Payment_Term__c=wrap.objSales_Order.Payment_Terms__c;
                    sOD.Type__c = wrap.objSales_Order.Type_SOA__c;
                    insert sOD;
                    decimal taxableamount=0;
                    list<Stock__c>lstStockUpdate=new list<Stock__c>();     
                    boolean b=true;
                    for(wrapchild wc:wrap.wrapChildlst){
                        if(wc.isSelected){
                            if(wc.soliChild.Product_Part__c != null && prodIdVsStock.containsKey(wc.soliChild.Product_Part__c)){
                                Stock__c s=new Stock__c();
                                s.Id=prodIdVsStock.get(wc.soliChild.Product_Part__c).Id;
                                s.Product_Out__c=prodIdVsStock.get(wc.soliChild.Product_Part__c).Product_Out__c+wc.reMaininQTY;
                                s.Freeze_Quantity__c=prodIdVsStock.get(wc.soliChild.Product_Part__c).Freeze_Quantity__c-wc.reMaininQTY;
                                lstStockUpdate.add(s);
                            }
                            Delivery_Note_Line_Item__c dLI =new Delivery_Note_Line_Item__c();
                            dLI.Sales_Order_Dispatch_Delivery_Note__c=sOD.Id;
                            dLI.Product_Part__c=wc.soliChild.Product_Part__c;
                            dLi.List_Price__c=wc.soliChild.List_Price__c;
                            dLi.Discount__c=wc.discount;
                            dLi.Sales_Price__c=wc.salesprice;
                            dli.IGST__c=wc.igst;
                            dli.CGST__c=wc.cgst;
                            dli.SGST__c=wc.sgst;
                            dli.Product_Part__c=wc.soliChild.Product_Part__c;
                            dli.Unit_Price__c=wc.salesprice;
                            dli.HSN_Code__c=wc.hsncode;
                            dli.Remark__c = wc.remark;
                            dli.Delivery_Date__c = wc.deliverydate;
                            taxableamount = taxableamount+ wc.totalamount;
                            decimal oldQtyPlusLtestQty=0;
                            if(prodVsQty.get(wc.soliChild.Product_Part__c) != null){
                                oldQtyPlusLtestQty=prodVsQty.get(wc.soliChild.Product_Part__c)+wc.reMaininQTY;
                            }else{
                                oldQtyPlusLtestQty=wc.reMaininQTY;
                            }
                            if(prodVsQty.containsKey(wc.soliChild.Product_Part__c) && prodVsOrderItem.containsKey(wc.soliChild.Product_Part__c) && oldQtyPlusLtestQty > prodVsOrderItem.get(wc.soliChild.Product_Part__c).quantity__c){
                                b=false;
                            }
                            else if(oldQtyPlusLtestQty > prodVsOrderItem.get(wc.soliChild.Product_Part__c).quantity__c){
                                b=false;
                            }
                            else{
                                dLI.Quantity__c=wc.reMaininQTY;
                                lstDelNotItem.add(dLI);
                            }
                        }                           
                    }  
                    
                    wrap =new wrappermain();
                    List<String> chargesstr = UtilityClass.getAllFields('Charges__c');
                    String chargesQuery = 'Select ' +String.Join(chargesstr, ',')+ ' from Charges__c where Sales_Order__c=:sodid';
                    list<Charges__c> objcharges =  Database.query(chargesQuery);
                    list<Charges__c> insertcharges = new list<Charges__c>();
                    if(!objcharges.isempty())
                        for(Charges__c chg:objcharges){
                            Charges__c newchg = new Charges__c();
                            newchg.Delivery_Note__c = sOD.Id;
                            newchg.Total_Amount__c = taxableamount;
                            newchg.Charge_Percentage__c = chg.Charge_Percentage__c;
                            newchg.SGST__c = chg.SGST__c;
                            newchg.CGST__c = chg.cGST__c;
                            newchg.IGST__c = chg.IGST__c;
                            newchg.Charges__c = chg.Charges__c;
                            insertcharges.add(newchg);
                        }
                    
                    if(b==false){
                        Database.RollBack(sp);  
                        wrap.success = false;
                        wrap.strErrorMessage = 'This part full quantity already send.';
                    }else{
                        if(lstDelNotItem.size()>0){
                            Insert lstDelNotItem;
                            if(lstStockUpdate.size()>0){
                                update lstStockUpdate;
                            }
                            if(!insertcharges.isempty())
                               insert insertcharges;
                            system.debug('lstDelNotItem---'+lstDelNotItem);
                                                        wrap.success = true;
                        }
                        else{
                            Database.RollBack(sp); 
                            wrap.success = false;
                        }   
                    }                   
                }
                    }
                else{
                    decimal taxableamount=0;
                    for(wrapchild wc:wrap.wrapChildlst){
                        if(wc.isSelected){
                            
                            Delivery_Note_Line_Item__c dLI =new Delivery_Note_Line_Item__c();

                            dLi.Discount__c=wc.discount;
                            dLi.Sales_Price__c=wc.salesprice;
                            dli.IGST__c=wc.igst;
                            dli.CGST__c=wc.cgst;
                            dli.SGST__c=wc.sgst;
                            dli.Unit_Price__c=wc.salesprice;
                            dli.HSN_Code__c=wc.hsncode;
                            dLI.Quantity__c=wc.reMaininQTY;
                            dli.id = wc.id;
                            dli.Remark__c = wc.remark;
                            dli.Delivery_Date__c = wc.deliverydate;
                            taxableamount = taxableamount+ wc.totalamount;
                            lstDelNotItem.add(dLI);   
                            system.debug('---'+lstDelNotItem.size());
                        }                           
                    }
                    
                    system.debug('dcid'+dcid);
                    List<String> chargesstr = UtilityClass.getAllFields('Charges__c');
                    String chargesQuery = 'Select ' +String.Join(chargesstr, ',')+ ' from Charges__c where Delivery_Note__c=:dcid';
                    list<Charges__c> objcharges =  Database.query(chargesQuery);
                    list<Charges__c> upcharges = new list<Charges__c>();
                    if(!objcharges.isempty())
                        for(Charges__c chg:objcharges){
                            Charges__c newchg = new Charges__c();
                            newchg = chg;
                            newchg.Total_Amount__c = taxableamount;
                            system.debug('newchg '+newchg.id);
                            system.debug('newchg '+upcharges.size());
                            upcharges.add(newchg);
                            
                        }
                    if(!lstDelNotItem.isempty()){
                        
                        wrap.success = true;
                         Update lstDelNotItem;
                        if(!upcharges.isempty())
                            update upcharges;
                        System.debug('update');
                    }  
                }
            }            
        }
        catch(exception e){
            wrap.success = false;
            wrap.strErrorMessage = e.getMessage();
        }
        system.debug('wrap---'+wrap);
        return json.serialize(wrap);
        
    }
    
    public class wrappermain{
        public string recordid;
        public boolean isupdate;
        public Boolean igstvalue;
        public boolean success;
        public Sales_Order_Line_Item__c objSol;
        public Boolean isSelected{get;set;}
        public Boolean itemNotSelected;
        public string strErrorMessage;
        public string strSuccessMessage;
        public list<wrapchild> wrapChildlst{get;set;}
        public Sales_Order__c objSales_Order;
        
        
        public wrappermain(){
            
            
            wrapChildlst = new list<wrapchild>();
            objSol = new Sales_Order_Line_Item__c();
            objSales_Order = new Sales_Order__c();
            success = false; 
            strErrorMessage = '';
            strSuccessMessage='';
        }
    }
    
    
    public class wrapchild{
        
        public decimal qty{get;set;}
        public Boolean isSelected{get;set;}
        public Sales_Order_Line_Item__c soliChild{get;set;}  
        public Delivery_Note_Line_Item__c dnliChild{get;set;}
        public string productname;
        public string productid;
        public string productnumber;
        public decimal quantity;
        public integer reMaininQTY; 
        public Boolean checkboxDisable;
        public Decimal salesprice;
        public Decimal totalprice;
        public Decimal discount;
        public Decimal discountamount;
        public Decimal totalamount;
        public string hsncode;
        public Decimal cgst;
        public Decimal cgstamount;
        public Decimal sgst;
        public Decimal sgstamount;
        public Decimal igst;
        public Decimal igstamount;
        public Decimal nettotal;
        public date deliverydate;
        public String remark;
        public String id;
        public wrapchild(){
            qty = 0;
            isSelected = true;
            soliChild = new Sales_Order_Line_Item__c();
        }
    }
    
}