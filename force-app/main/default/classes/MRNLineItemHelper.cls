public class MRNLineItemHelper {
   public static void createStockLandedAmount(List<MRN_Line_Item__c> triggerNew, Map<Id, MRN_Line_Item__c> oldMapMRNLI)
    {
        set<string> setOfProductId = new set<string>();
        set<string> setOfWarehouseId = new set<string>();
        set<string> setOfMRNLineItemId = new set<string>();
        
        set<string> setOfMRNLineItemIdLandedAmount = new set<string>();
        for(MRN_Line_Item__c objMRNLI : triggerNew)
        {
            setOfMRNLineItemId.add(objMRNLI.Id);
            if(objMRNLI.Part_Number__c != null)
                setOfProductId.add(objMRNLI.Part_Number__c);
            if(objMRNLI.Ware_House_Formula__c != null)
                setOfWarehouseId.add(objMRNLI.Ware_House_Formula__c);
        }
        if(setOfMRNLineItemId.size()>0)
        {
            map<string,string> mapProductWareHouseBaseStock = new map<string,string>();
            for(Stock__c objStock : [select Id,Ware_House__c,Product_Part__c from Stock__c where Ware_House__c IN: setOfWarehouseId and Product_Part__c IN: setOfProductId])
            {
                mapProductWareHouseBaseStock.put(objStock.Product_Part__c+'-'+objStock.Ware_House__c,objStock.Id);
            }
            
            system.debug('...mapProductWareHouseBaseStock..'+mapProductWareHouseBaseStock);
            
            list<Stock_Landed_Amount__c> lstOfSLA = new list<Stock_Landed_Amount__c>();
            for(MRN_Line_Item__c objMRNLI : [Select id, Name, Ware_House_Formula__c, Part_Number__c, Part_Number__r.Name, Landed_Cost_Unit_Rate__c, MRN__c, MRN__r.Ware_House__c, MRN__r.MRN_Type__c,MRN__r.MRN_Delivery_Type__c from MRN_Line_Item__c where id IN: setOfMRNLineItemId and (MRN__r.MRN_Type__c ='Purchase Order' OR MRN__r.MRN_Type__c ='Direct') ])
            {
            system.debug('...str..'+objMRNLI.Part_Number__c+'-'+objMRNLI.MRN__r.Ware_House__c);
                if(mapProductWareHouseBaseStock.containskey(objMRNLI.Part_Number__c+'-'+objMRNLI.MRN__r.Ware_House__c) && mapProductWareHouseBaseStock.get(objMRNLI.Part_Number__c+'-'+objMRNLI.MRN__r.Ware_House__c) != null) 
                {
                    Stock_Landed_Amount__c objSLA = new Stock_Landed_Amount__c();
                    objSLA.Ware_House__c = objMRNLI.Ware_House_Formula__c;
                    objSLA.Product_Part__c = objMRNLI.Part_Number__c;
                    objSLA.Stock__c = mapProductWareHouseBaseStock.get(objMRNLI.Part_Number__c+'-'+objMRNLI.Ware_House_Formula__c);
                    objSLA.MRN_Line_Item__c = objMRNLI.Id;
                    lstOfSLA.add(objSLA);
                }
            }
            if(lstOfSLA.size()>0)
                insert lstOfSLA;
        }
    }
}