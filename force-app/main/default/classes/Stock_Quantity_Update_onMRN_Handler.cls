public class Stock_Quantity_Update_onMRN_Handler {
    public static void updatestock(List<mrn__c> triggernew,map<Id,mrn__c> oldMap){
        Set<id> mrnIdSet = new Set<id>();
        Set<id> setProductId = new Set<id>();
        list<MRN_Line_Item__c> MrnLineItemList = new list<MRN_Line_Item__c>();
        Map<id,stock__c> stockmap = new Map<id,stock__c>(); 
        list<stock__c> stocklist = new list<stock__c>();
        for(mrn__c mrn : triggernew){ 
            if(mrn.Stage__c =='Received' && oldMap.get(mrn.Id).Stage__c != mrn.Stage__c){ 
                mrnIdSet.add(mrn.id);
                System.debug('mrnid------ '+mrn.id);
            }       
        }
        
        if(!mrnIdSet.isempty()) 
        {
            MrnLineItemList = [SELECT Id,MRN__c,MRN__r.MRN_Type__c,MRN__r.Ware_House__c,Part_Number__c,Stock__c,Condition__c,Received_QTY__c,Bill_QTY__c  FROM MRN_Line_Item__c where MRN__c IN: mrnIdSet];
            if(!MrnLineItemList.isempty()) 
            { 
                System.debug('MrnLineItemList------ '+MrnLineItemList.size());
                for(MRN_Line_Item__c mli :MrnLineItemList) {
                    setProductId.add(mli.Part_Number__c);
                }
                
                map<string,Stock__c> mapIdRelatedStock = new map<string,Stock__c>();
                map<string, Stock__c> mapWareHouseProductbasedQuantity = new map<string, Stock__c>();
                for(Stock__c objStock : [select id,Name,Product_Part__c,Quantity__c,Ware_House__c,Product_Out__c,Product_IN__c  from Stock__c where Product_Part__c IN: setProductId])
                {
                    mapWareHouseProductbasedQuantity.put(objStock.Ware_House__c+'-'+objStock.Product_Part__c,objStock);
                    mapIdRelatedStock.put(objStock.Id,objStock);
                }
                
                if(!setProductId.isempty()) 
                {
                    for(MRN_Line_Item__c mli : MrnLineItemList){
                        Stock__c objStock = new Stock__c();
                        
                        if(mapWareHouseProductbasedQuantity.get(mli.MRN__r.Ware_House__c+'-'+mli.Part_Number__c) != null){
                            objStock = mapWareHouseProductbasedQuantity.get(mli.MRN__r.Ware_House__c+'-'+mli.Part_Number__c);
                            Decimal stockamount =0;
                            System.debug('objStock------ '+objStock);
                            if(objStock.Product_IN__c !=null){
                                stockamount=objStock.Product_IN__c;
                            }
                            if(mli.MRN__r.MRN_Type__c=='Sales Return'){
                                if(mli.Received_QTY__c!= null){
                                    objStock.Product_IN__c = objStock.Product_IN__c+mli.Received_QTY__c;
                                    mapIdRelatedStock.put(objStock.Id,objStock);}
                            }
                            else{
                                if(mli.Bill_QTY__c!= null){
                                    objStock.Product_IN__c = objStock.Product_IN__c+mli.Received_QTY__c;
                                    mapIdRelatedStock.put(objStock.Id,objStock);}
                            }
                        }
                        
                    }
                }
                if(!mapIdRelatedStock.isempty()) 
                    Update mapIdRelatedStock.values();
            }
        }
    }    
}