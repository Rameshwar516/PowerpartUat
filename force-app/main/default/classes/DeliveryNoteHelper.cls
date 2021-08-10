public class DeliveryNoteHelper 
{
    public static void delLineItems(list<Sales_Order_Dispatch_Delivery_Note__c> lstdn)
    {
        list<Delivery_Note_Line_Item__c> deldli= new list<Delivery_Note_Line_Item__c>();
       set<ID> sid = new set<ID>();
        for(Sales_Order_Dispatch_Delivery_Note__c dn : lstdn)
        {
                sid.add(dn.id);
            
        }
		system.debug('delNoteId-- '+ sid);
        list<Delivery_Note_Line_Item__c> dnli = [select id ,Sales_Order_Dispatch_Delivery_Note__c from Delivery_Note_Line_Item__c where Sales_Order_Dispatch_Delivery_Note__c =: sid];
        system.debug('inQuery----  '+ dnli.size());
        if(dnli.size() > 0 ){
		for(Delivery_Note_Line_Item__c dlItem : dnli){
		deldli.add(dlItem);
		}
		}
		System.debug('lstSizeItem--- '+deldli.size());
		if(deldli.size() > 0){
		system.debug('------DELETED====');
		delete deldli;
        
		}
        
    }
}