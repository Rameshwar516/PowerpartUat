@isTest
public class SalesOrderHelperTest {
    @istest static void testSalesOrder(){
        //insert WareHouse
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Gurgaon Ware House';
        wHouse.City__c = 'Gurugram';
        insert wHouse; 
        
        //insert Product
        Part__c part = new Part__c();
        part.Name = 'Apart';
        insert part; 
        
        //insert Stock
        Stock__c stk = new Stock__c(); 
        stk.Product_Part__c = part.Id;
        stk.Ware_House__c = whouse.Id;
        stk.Quantity__c = 10;
        stk.Product_Out__c = 10;
        insert stk; 
        
        //insert SalesOrder
        Sales_Order__c sOrder = new Sales_Order__c(); 
        sOrder.Bill_To__c = 'Gurugram';
        insert sOrder;
        
        //insert LineItem
        Sales_Order_Line_Item__c sItem = new Sales_Order_Line_Item__c();
        sItem.Sales_Order__c = sOrder.Id;
        sItem.Product_Part__c = part.Id;
        sItem.Quantity__c = 10;
        insert sItem; 
        //update salesOrder
        sOrder.Status__c = 'Approved';
        update sOrder; 
    }	 
    
}