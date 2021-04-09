public class classCreateDeliveryNoteLIghtngComp {
    
    public static wrappermain wrap{get;set;}
    
    
    @AuraEnabled
    public static string onloadSalesOrder(string recordid){        
        wrap =new wrappermain();
        Sales_Order__c objSalesOrder=[select id,Ware_House__c,name,Opportunity__c,GSTIN_No_Formula__c,Customer_Name__c,Contact_Person__c from 
                                      Sales_Order__c where id=:recordid];
        
        list<Sales_Order_Line_Item__c> objsalesOrderLineItem = [select id,name,Available_Quantity__c,List_Price__c,Discount__c,Unit_Price__c,Quantity__c,Sales_Order__c,Product_Part__c,Product_Part__r.Part_Name__c,Product_Part__r.Name,Part_Name_formula__c from Sales_Order_Line_Item__c
                                                                where Sales_Order__c=: recordid];
        wrap.objSales_Order=objSalesOrder;
        map<string,decimal>prodVsQty=new map<string,decimal>();
        list<Sales_Order_Dispatch_Delivery_Note__c>lstSalesOrder=[select id,Sales_order__c,(select id,Product_Part__c,quantity__c from Delivery_Note_Line_Items__r) from Sales_Order_Dispatch_Delivery_Note__c where Sales_order__c=:recordid];
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
        system.debug('prodVsQty--------'+prodVsQty);
        list<wrapchild> lstwrpchild = new list<wrapchild>();  
        if(objsalesOrderLineItem.size()>0){
            
            for(Sales_Order_Line_Item__c objsalli : objsalesOrderLineItem){
                decimal i=0;
                wrapchild childwrp = new wrapchild();
                childwrp.qty=objsalli.Quantity__c;
                childwrp.isSelected=false;
                childwrp.soliChild=objsalli;
                        system.debug('prodVsQtyffffff--------'+prodVsQty.get(objsalli.Product_Part__c));
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
                childwrp.reMaininQTY=integer.valueof(i);
                system.debug('childwrp.reMaininQTY--------'+childwrp.reMaininQTY);
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
        wrap = new wrappermain();
        list<Sales_Order_Line_Item__c> sollst=new list<Sales_Order_Line_Item__c>();
        system.debug('strMainWrapper-----------'+strMainWrapper);
            try{
            map<string,decimal>prodVsQty=new map<string,decimal>();
            map<string,Sales_Order_Line_Item__c>prodVsOrderItem=new map<string,Sales_Order_Line_Item__c>();
            map<string,Stock__c>prodIdVsStock=new map<string,Stock__c>();

			if(strMainWrapper !='' && strMainWrapper !=null){
               wrap = (wrappermain)Json.deserialize(strMainWrapper, wrappermain.class);
            wrap.success= true;
            if(wrap.wrapChildlst.size()>0 && wrap.objSales_Order != null){
                decimal qty=0;
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
                system.debug('prodVsQty-----------'+prodVsQty+'-----'+prodVsOrderItem);
                Sales_Order_Dispatch_Delivery_Note__c sOD=new Sales_Order_Dispatch_Delivery_Note__c();
                sOD.Sales_Order__c= wrap.objSales_Order.Id;
                insert sOD;
                system.debug('sOD-----------'+sOD);
                 list<Stock__c>lstStockUpdate=new list<Stock__c>();
                list<Delivery_Note_Line_Item__c>lstDelNotItem=new list<Delivery_Note_Line_Item__c>();
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
                        dLi.Discount__c=wc.soliChild.Discount__c;
                        dLi.Sales_Price__c=wc.soliChild.Unit_Price__c;
                        decimal oldQtyPlusLtestQty=0;
                        if(prodVsQty.get(wc.soliChild.Product_Part__c) != null){
                            oldQtyPlusLtestQty=prodVsQty.get(wc.soliChild.Product_Part__c)+wc.reMaininQTY;
                        }else{
                            oldQtyPlusLtestQty=wc.reMaininQTY;
                        }
                        if(prodVsQty.containsKey(wc.soliChild.Product_Part__c) && prodVsOrderItem.containsKey(wc.soliChild.Product_Part__c) && oldQtyPlusLtestQty > prodVsOrderItem.get(wc.soliChild.Product_Part__c).quantity__c){
                            b=false;
                        }else if(oldQtyPlusLtestQty > prodVsOrderItem.get(wc.soliChild.Product_Part__c).quantity__c){
                             b=false;
                        }else{
                            dLI.Quantity__c=wc.reMaininQTY;
                            lstDelNotItem.add(dLI);
                        }
                      // wrap.itemNotSelected=true;
                    }/*else{
                     wrap.itemNotSelected=false;    
                    }*/
                    
                    
                }
                /*if(wrap.itemNotSelected==false){
                    Database.RollBack(sp);  
                    wrap.success = false;
                    wrap.strErrorMessage = 'Please select at least single item.';
                }*/
                if(b==false){
                    Database.RollBack(sp);  
                    wrap.success = false;
                    wrap.strErrorMessage = 'This part full quantity already send.';
                }else{
                    if(lstDelNotItem.size()>0){
                        insert lstDelNotItem;
                        if(lstStockUpdate.size()>0){
                            update lstStockUpdate;
                        }
                        system.debug('lstDelNotItem---'+lstDelNotItem);
                    }else{
                      Database.RollBack(sp); 
                        wrap.success = false;
                    }   
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
public integer reMaininQTY; 
        public Boolean checkboxDisable;
    public wrapchild(){
            qty = 0;
            isSelected = true;
            soliChild = new Sales_Order_Line_Item__c();
        }
    }
    
}