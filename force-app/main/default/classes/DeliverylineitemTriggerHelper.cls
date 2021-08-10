public class DeliverylineitemTriggerHelper {
    
    public static void onInsertMethod(list<Delivery_Note_Line_Item__c> newSolList){
        map<id,Sales_Order_Line_Item__c> Solimap = new map<id,Sales_Order_Line_Item__c>();
        list<Sales_Order_Line_Item__c> Solilistget = new list<Sales_Order_Line_Item__c>();
        list<Sales_Order_Line_Item__c> Solilist = new list<Sales_Order_Line_Item__c>();
        set<string> soliIdSet = new set<string>();
        for(Delivery_Note_Line_Item__c dcln:newSolList){
            Sales_Order_Line_Item__c soli = new Sales_Order_Line_Item__c();
            soli.id = dcln.Sales_Order_Line_Item__c;
            soli.Deliverd_Quantity__c = dcln.Quantity__c;
            Solimap.put(soli.id,soli);
            soliIdSet.add(soli.id);
        } 
        
        if(!soliIdSet.isempty())
            Solilistget = [Select id,Deliverd_Quantity__c,Quantity__c from Sales_Order_Line_Item__c where id in:soliIdSet];
        
        if(!Solilistget.isempty())
            for(Sales_Order_Line_Item__c solitem:Solilistget){
                if(Solimap.containsKey(solitem.id)){
                    solitem.id = solitem.id;
                    solitem.Deliverd_Quantity__c = Solimap.get(solitem.id).Deliverd_Quantity__c + solitem.Deliverd_Quantity__c;
                    
                    Solilist.add(solitem);
                }   
            } 
        
        if(!Solilist.isempty())
            update Solilist;
    }
    
    public static void onDeleteMethod(list<Delivery_Note_Line_Item__c> oldSolList){
        map<id,Sales_Order_Line_Item__c> Solimap = new map<id,Sales_Order_Line_Item__c>();
        list<Sales_Order_Line_Item__c> Solilistget = new list<Sales_Order_Line_Item__c>();
        list<Sales_Order_Line_Item__c> Solilist = new list<Sales_Order_Line_Item__c>();
        set<string> soliIdSet = new set<string>();
        for(Delivery_Note_Line_Item__c dcln:oldSolList){
            Sales_Order_Line_Item__c soli = new Sales_Order_Line_Item__c();
            soli.id = dcln.Sales_Order_Line_Item__c;
            soli.Deliverd_Quantity__c = dcln.Quantity__c;
            Solimap.put(soli.id,soli);
            soliIdSet.add(soli.id);
        } 
        
        if(!soliIdSet.isempty())
            Solilistget = [Select id,Deliverd_Quantity__c from Sales_Order_Line_Item__c where id in:soliIdSet];
        
        if(!Solilistget.isempty())
            for(Sales_Order_Line_Item__c solitem:Solilistget){
                if(Solimap.containsKey(solitem.id)){
                    solitem.id = solitem.id;
                    if(Solimap.get(solitem.id).Deliverd_Quantity__c > solitem.Deliverd_Quantity__c)
                    solitem.Deliverd_Quantity__c = Solimap.get(solitem.id).Deliverd_Quantity__c - solitem.Deliverd_Quantity__c;
                    else
                    solitem.Deliverd_Quantity__c = solitem.Deliverd_Quantity__c -Solimap.get(solitem.id).Deliverd_Quantity__c;    
                    Solilist.add(solitem);
                }   
            } 
        
        if(!Solilist.isempty())
            update Solilist;
    }
    
    public static void onupdateMethod(list<Delivery_Note_Line_Item__c> newSolList, map<id,Delivery_Note_Line_Item__c> NewSolMap,  map<id,Delivery_Note_Line_Item__c> OldSolMap){
        map<id,Sales_Order_Line_Item__c> Solimap = new map<id,Sales_Order_Line_Item__c>();
        list<Sales_Order_Line_Item__c> Solilistget = new list<Sales_Order_Line_Item__c>();
        list<Sales_Order_Line_Item__c> Solilist = new list<Sales_Order_Line_Item__c>();
        set<string> soliIdSet = new set<string>();
        for(Delivery_Note_Line_Item__c dcln:newSolList){
            if(NewSolMap.get(dcln.id).Quantity__c != OldSolMap.get(dcln.id).Quantity__c){
                Sales_Order_Line_Item__c soli = new Sales_Order_Line_Item__c();
                soli.id = dcln.Sales_Order_Line_Item__c;
                soli.Deliverd_Quantity__c = dcln.Quantity__c;
                Solimap.put(soli.id,soli);
                soliIdSet.add(soli.id);
            }
        } 
        
        if(!soliIdSet.isempty())
            Solilistget = [Select id,Deliverd_Quantity__c from Sales_Order_Line_Item__c where id in:soliIdSet];
        
        if(!Solilistget.isempty())
            for(Sales_Order_Line_Item__c solitem:Solilistget){
                if(Solimap.containsKey(solitem.id)){
                    solitem.id = solitem.id;
                    solitem.Deliverd_Quantity__c = Solimap.get(solitem.id).Deliverd_Quantity__c + solitem.Deliverd_Quantity__c;
                    Solilist.add(solitem);
                }   
            } 
        
        if(!Solilist.isempty())
            update Solilist;
    }
    
}