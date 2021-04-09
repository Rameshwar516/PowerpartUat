public class SalesOrderHelper {
    public void onBeforeUpdate(List<Sales_Order__c> triggerNew, Map<Id, Sales_Order__c> TOM){
        checkLineItemsOnInsert(triggerNew,TOM);
    }
    
    public void checkLineItemsOnInsert(List<Sales_Order__c> triggerNew, Map<Id, Sales_Order__c> oldmap){
        set<string> setOfSOID = new set<string>();
        for(Sales_Order__c objSO : triggerNew)
        {
            if(objSO.Status__c == 'Freeze' && oldmap.get(objSO.Id).Status__c != objSO.Status__c){
                setOfSOID.add(objSO.Id);
            }
        }
        if(setOfSOID.size()>0)
        {
            set<string> setOfProduct = new set<string>();
            map<string, list<Sales_Order_Line_Item__c>> mapSORelatedProductItem = new map<string,list<Sales_Order_Line_Item__c>>();
            for(Sales_Order_Line_Item__c objSO : [SELECT Id,product_part__c,Sales_Order__r.Ware_House__c,Quantity__c,Sales_Order__c FROM Sales_Order_Line_Item__c where Sales_Order__c IN: setOfSOID])
            {
                setOfProduct.add(objSO.product_part__c);
                if(mapSORelatedProductItem.containskey(objSO.Sales_Order__c) && mapSORelatedProductItem.get(objSO.Sales_Order__c) != null)
                {
                    list<Sales_Order_Line_Item__c> lstSOI = new list<Sales_Order_Line_Item__c>();
                    lstSOI = mapSORelatedProductItem.get(objSO.Sales_Order__c);
                    lstSOI.add(objSO);
                    mapSORelatedProductItem.put(objSO.Sales_Order__c,lstSOI);
                }
                else
                {
                    list<Sales_Order_Line_Item__c> lstSOI = new list<Sales_Order_Line_Item__c>();
                    lstSOI.add(objSO);
                    mapSORelatedProductItem.put(objSO.Sales_Order__c,lstSOI);
                }
            }
            
            map<string,Stock__c> mapIdRelatedStock = new map<string,Stock__c>();
            map<string, Stock__c> mapWareHouseProductbasedQuantity = new map<string, Stock__c>();
            map<string, string> mapWareHouseProductbasedStockId = new map<string, string>();
            for(Stock__c objStock : [select id,Name,Product_Part__c,Quantity__c,Total_Unbooked_Quantity__c,Ware_House__c,Freeze_Quantity__c from Stock__c where Product_Part__c IN: setOfProduct])
            {
                mapIdRelatedStock.put(objStock.Id,objStock);
                mapWareHouseProductbasedQuantity.put(objStock.Ware_House__c+'-'+objStock.Product_Part__c,objStock);
                mapWareHouseProductbasedStockId.put(objStock.Ware_House__c+'-'+objStock.Product_Part__c,objStock.Id);
                System.debug(objStock.Ware_House__c+'-'+objStock.Product_Part__c);
            }
            
            for(Sales_Order__c objSO : triggerNew)
            {
                map<string,Stock__c> mapIdRelatedStockClone = new map<string,Stock__c>(mapIdRelatedStock);
                string strwareHouseDifferent = '';
                boolean isStockAvailableBothWareHouse = false;
                integer countLst = 0;
                if(objSO.Ware_House__c != system.label.Gurgaon_Ware_House)
                {
                    strwareHouseDifferent = system.label.Gurgaon_Ware_House;
                }
                else{
                    strwareHouseDifferent = system.label.Kolkata_Warehouse;
                }
                if(mapSORelatedProductItem.containskey(objSO.id) && mapSORelatedProductItem.get(objSO.id) != null)
                {
                    for(Sales_Order_Line_Item__c objSOI : mapSORelatedProductItem.get(objSO.id))
                    {
                        if(countLst >0 && isStockAvailableBothWareHouse)
                        {
                            System.debug('countLst------- '+countLst+'...isStockAvailableBothWareHouse'+isStockAvailableBothWareHouse);
                            countLst = countLst+1;
                            if(objSO.Ware_House__c != null && mapWareHouseProductbasedStockId.containskey(objSO.Ware_House__c+'-'+objSOI.Product_Part__c) && mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c) != null)
                            {
                                System.debug('objSO.Ware_House__c------- '+objSO.Ware_House__c);
                                if(mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c)).Total_Unbooked_Quantity__c > objSOI.Quantity__c)
                                {
                                    Stock__c objStock = new stock__c();
                                    objStock = mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c));
                                    objStock.Freeze_Quantity__c = objStock.Freeze_Quantity__c + objSOI.Quantity__c;
                                    mapIdRelatedStock.put(objStock.Id,objStock);
                                    isStockAvailableBothWareHouse = true;
                                }
                                else{
                                    isStockAvailableBothWareHouse = false;
                                }
                                if(mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c)).Total_Unbooked_Quantity__c < objSOI.Quantity__c)
                                {
                                system.debug('objSOI.Product_Part__c)-----'+objSOI.Product_Part__c);
                                    decimal intCountWareHouseQuantity = objSOI.Quantity__c - mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c)).Total_Unbooked_Quantity__c ;
                                    
                                    Stock__c objStock = new stock__c();
                                    objStock = mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c));
                                    objStock.Freeze_Quantity__c = objStock.Freeze_Quantity__c+mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c)).Total_Unbooked_Quantity__c;
                                    mapIdRelatedStock.put(objStock.Id,objStock);
                                    
                                    Stock__c objStock2 = new stock__c();
                                    objStock2 = mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(strwareHouseDifferent+'-'+objSOI.Product_Part__c));
                                    system.debug('--------'+isStockAvailableBothWareHouse );
                  system.debug('----objStock2.Total_Unbooked_Quantity__c----'+objStock2.Total_Unbooked_Quantity__c );
                  system.debug('-----intCountWareHouseQuantity---'+intCountWareHouseQuantity );
                                    if(objStock2.Total_Unbooked_Quantity__c >= intCountWareHouseQuantity)
                                    {
                                    system.debug('objStock2.Freeze_Quantity__c-----'+objStock2.Freeze_Quantity__c);
                                        objStock2.Freeze_Quantity__c = objStock2.Freeze_Quantity__c + intCountWareHouseQuantity;
                                        mapIdRelatedStock.put(objStock2.Id,objStock2);
                                        isStockAvailableBothWareHouse = true;
                                    }
                                    else{
                                        isStockAvailableBothWareHouse = false;
                                    }
                                }
                            }
                            
                            else 
                            {
                                System.debug('objSO.Ware_House__c---else---- ');
                                Stock__c objStock2 = new stock__c();
                                objStock2 = mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(strwareHouseDifferent+'-'+objSOI.Product_Part__c));
                                if(objStock2 !=null)
                                if(objStock2.Total_Unbooked_Quantity__c > objSOI.Quantity__c)
                                {
                                    objStock2.Freeze_Quantity__c = objStock2.Freeze_Quantity__c + objSOI.Quantity__c;
                                    mapIdRelatedStock.put(objStock2.Id,objStock2);
                                    isStockAvailableBothWareHouse = true;
                                }
                                else{
                                        isStockAvailableBothWareHouse = false;
                                    }
                            }
                                                           
                        }
                        else if(countLst == 0){
                            countLst = countLst+1;
                            if(objSO.Ware_House__c != null && mapWareHouseProductbasedStockId.containskey(objSO.Ware_House__c+'-'+objSOI.Product_Part__c) && mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c) != null)
                            {
                                System.debug('objSO.Ware_House__c------- '+objSO.Ware_House__c);
                                if(mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c)).Total_Unbooked_Quantity__c > objSOI.Quantity__c)
                                {
                                    Stock__c objStock = new stock__c();
                                    objStock = mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c));
                                    objStock.Freeze_Quantity__c = objStock.Freeze_Quantity__c + objSOI.Quantity__c;
                                    mapIdRelatedStock.put(objStock.Id,objStock);
                                    isStockAvailableBothWareHouse = true;
                                }
                                else{
                                    isStockAvailableBothWareHouse = false;
                                }
                                if(mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c)).Total_Unbooked_Quantity__c < objSOI.Quantity__c)
                                {
                                system.debug('objSOI.Product_Part__c)-----'+objSOI.Product_Part__c);
                                    decimal intCountWareHouseQuantity = objSOI.Quantity__c - mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c)).Total_Unbooked_Quantity__c ;
                                    
                                    Stock__c objStock = new stock__c();
                                    objStock = mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c));
                                    objStock.Freeze_Quantity__c = objStock.Freeze_Quantity__c+mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(objSO.Ware_House__c+'-'+objSOI.Product_Part__c)).Total_Unbooked_Quantity__c;
                                    mapIdRelatedStock.put(objStock.Id,objStock);
                                    
                                    Stock__c objStock2 = new stock__c();
                                    system.debug('--------'+strwareHouseDifferent+'-'+objSOI.Product_Part__c );
                                    system.debug('--------'+mapWareHouseProductbasedStockId.get(strwareHouseDifferent+'-'+objSOI.Product_Part__c) );
                                    objStock2 = mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(strwareHouseDifferent+'-'+objSOI.Product_Part__c));
                                    system.debug('--------'+isStockAvailableBothWareHouse );
                                    system.debug('--------'+objStock2.Total_Unbooked_Quantity__c );
                                    system.debug('--------'+intCountWareHouseQuantity );
                                    if(objStock2.Total_Unbooked_Quantity__c > intCountWareHouseQuantity)
                                    {
                                    system.debug('objStock2.Freeze_Quantity__c-----'+objStock2.Freeze_Quantity__c);
                                        objStock2.Freeze_Quantity__c = objStock2.Freeze_Quantity__c + intCountWareHouseQuantity;
                                        mapIdRelatedStock.put(objStock2.Id,objStock2);
                                        isStockAvailableBothWareHouse = true;
                                    }
                                    else{
                                        isStockAvailableBothWareHouse = false;
                                    }
                                }
                            }
                            
                            else 
                            {
                                System.debug('objSO.Ware_House__c---else---- ');
                                Stock__c objStock2 = new stock__c();
                                objStock2 = mapIdRelatedStock.get(mapWareHouseProductbasedStockId.get(strwareHouseDifferent+'-'+objSOI.Product_Part__c));
                                if(objStock2.Total_Unbooked_Quantity__c > objSOI.Quantity__c)
                                {
                                    objStock2.Freeze_Quantity__c = objStock2.Freeze_Quantity__c + objSOI.Quantity__c;
                                    mapIdRelatedStock.put(objStock2.Id,objStock2);
                                    isStockAvailableBothWareHouse = true;
                                }
                                else{
                                        isStockAvailableBothWareHouse = false;
                                    }
                            }
                        }
                    }
                    system.debug('-----isStockAvailableBothWareHouse---'+isStockAvailableBothWareHouse );
                     if(!isStockAvailableBothWareHouse){
                                mapIdRelatedStock = mapIdRelatedStockClone;
                                objSO.addError('Stock is not available.');
                            }
                }
            }
            if(mapIdRelatedStock.size()>0)
                update mapIdRelatedStock.values();
        }
    }
}