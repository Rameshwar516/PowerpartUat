public class SalesOrderLineItemTriggerHelper {
    
    public static void onInsertMethod(list<Sales_Order_Line_Item__c> newSolList){
        Set<string> productIdSet = new set<string>();
        for(Sales_Order_Line_Item__c sol: newSolList)
            productIdSet.add(sol.Product_Part__c);
        List<String> stockfields = UtilityClass.getAllFields('stock__c');
        String stockstring = 'Select ' +String.Join(stockfields, ',')+ ' From stock__c Where Product_Part__c in:productIdSet';
        list<stock__c> stocklist =  Database.query(stockstring);
        map<string,stock__c> stockmap = new map<string,stock__c> ();
        if(!stocklist.isempty()){
            for(stock__c stockrecord: stocklist){
                stockmap.put(stockrecord.Product_Part__c+'-'+stockrecord.Ware_House__c, stockrecord);
            }   
        }
        list<stock__c> updateStock = new list<stock__c>();
        for(Sales_Order_Line_Item__c solitem: newSolList){
            Stock__c currentStock = new stock__c();
            if(stockmap.get(solitem.Product_Part__c+'-'+solitem.warehouse__c) !=null){
                currentStock= stockmap.get(solitem.Product_Part__c+'-'+solitem.warehouse__c);
            }
            solitem.Stock__c = currentStock.id;
            if(solitem.Freeze_Qunatity__c<= currentStock.Total_Unbooked_Quantity__c && solitem.Freeze_Qunatity__c!=0 && solitem.Freeze_Qunatity__c <= solitem.Quantity__c){
                solitem.Freeze_Stock__c = currentStock.id;
                currentStock.Freeze_Quantity__c = currentStock.Freeze_Quantity__c +solitem.Freeze_Qunatity__c;
                updateStock.add(currentStock);
            }   
        } 
        if(!updateStock.isEmpty())
            update updateStock;
    }
    
    public static void onDeleteMethod(list<Sales_Order_Line_Item__c> newSolList){
        Set<string> productIdSet = new set<string>();
        for(Sales_Order_Line_Item__c sol: newSolList)
            productIdSet.add(sol.Product_Part__c);
        List<String> stockfields = UtilityClass.getAllFields('stock__c');
        String stockstring = 'Select ' +String.Join(stockfields, ',')+ ' From stock__c Where Product_Part__c in:productIdSet';
        list<stock__c> stocklist =  Database.query(stockstring);
        map<string,stock__c> stockmap = new map<string,stock__c> ();
        if(!stocklist.isempty()){
            for(stock__c stockrecord: stocklist){
                stockmap.put(stockrecord.Product_Part__c+'-'+stockrecord.Ware_House__c, stockrecord);
            }   
        }
        list<stock__c> updateStock = new list<stock__c>();
        for(Sales_Order_Line_Item__c solitem: newSolList){
            Stock__c currentStock = new stock__c();
            if(stockmap.get(solitem.Product_Part__c+'-'+solitem.warehouse__c) !=null){
                currentStock= stockmap.get(solitem.Product_Part__c+'-'+solitem.warehouse__c);
            }
            if(solitem.Freeze_Qunatity__c<= currentStock.Total_Unbooked_Quantity__c && solitem.Freeze_Qunatity__c!=0 && solitem.Freeze_Qunatity__c <= solitem.Quantity__c){
                currentStock.Freeze_Quantity__c = currentStock.Freeze_Quantity__c - solitem.Freeze_Qunatity__c;
                updateStock.add(currentStock);
            }   
        } 
        if(!updateStock.isEmpty())
            update updateStock;
    }
    
    public static void onupdateMethod(list<Sales_Order_Line_Item__c> newSolList, map<id,Sales_Order_Line_Item__c> NewSolMap,  map<id,Sales_Order_Line_Item__c> OldSolMap){
        Set<string> productIdSet = new set<string>();
        List<user> Userlist = [Select Id,isUnfreezeUser__c from user Where id =:UserInfo.getUserId()];
        user Currentuser = new User();
        if(!Userlist.isEmpty())
           Currentuser = Userlist[0];
        for(Sales_Order_Line_Item__c sol: newSolList)
            productIdSet.add(sol.Product_Part__c);
        List<String> stockfields = UtilityClass.getAllFields('stock__c');
        String stockstring = 'Select ' +String.Join(stockfields, ',')+ ' From stock__c Where Product_Part__c in:productIdSet';
        list<stock__c> stocklist =  Database.query(stockstring);
        map<string,stock__c> stockmap = new map<string,stock__c> ();
        if(!stocklist.isempty()){
            
            for(stock__c stockrecord: stocklist){
                stockmap.put(stockrecord.Product_Part__c+'-'+stockrecord.Ware_House__c, stockrecord);
            }   
        }
        list<stock__c> updateStock = new list<stock__c>();
        for(Sales_Order_Line_Item__c solitem: newSolList){
            Stock__c currentStock = new stock__c();
            if(stockmap.get(solitem.Product_Part__c+'-'+solitem.warehouse__c) !=null){
                currentStock= stockmap.get(solitem.Product_Part__c+'-'+solitem.warehouse__c);
            }
            solitem.Stock__c = currentStock.id;
            
            if(solitem.Freeze_Qunatity__c<= currentStock.Total_Unbooked_Quantity__c &&  solitem.Freeze_Qunatity__c <= solitem.Quantity__c && OldSolMap.get(solitem.id).Freeze_Qunatity__c != NewSolMap.get(solitem.id).Freeze_Qunatity__c){
                 if(OldSolMap.get(solitem.id).Freeze_Qunatity__c < NewSolMap.get(solitem.id).Freeze_Qunatity__c ){
                    //freeze Stock
                    solitem.Freeze_Stock__c = currentStock.id;
                    currentStock.Freeze_Quantity__c = currentStock.Freeze_Quantity__c +((NewSolMap.get(solitem.id).Freeze_Qunatity__c)-OldSolMap.get(solitem.id).Freeze_Qunatity__c);
                    updateStock.add(currentStock); 
                }
                else if(OldSolMap.get(solitem.id).Freeze_Qunatity__c > NewSolMap.get(solitem.id).Freeze_Qunatity__c && Currentuser.isUnfreezeUser__c ==true){
                    //Unfreeze Stock
                    solitem.Freeze_Stock__c = currentStock.id;
                    currentStock.Freeze_Quantity__c = currentStock.Freeze_Quantity__c -((OldSolMap.get(solitem.id).Freeze_Qunatity__c)-NewSolMap.get(solitem.id).Freeze_Qunatity__c);
                    updateStock.add(currentStock); 
                }
            }   
        } 
        if(!updateStock.isEmpty())
            update updateStock;
        
        for(Sales_Order_Line_Item__c solitem: newSolList){
            if(NewSolMap.get(solitem.id).Deliverd_Quantity__c !=OldSolMap.get(solitem.id).Deliverd_Quantity__c && NewSolMap.get(solitem.id).Quantity__c ==NewSolMap.get(solitem.id).Deliverd_Quantity__c)
                solitem.Freeze_Stock__c=null;
        }
    }

    
    
}