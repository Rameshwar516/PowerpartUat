// Test Class for classCreateDeliveryNoteLIghtngComp Apex Class
// Created Date :  24 June 2021 
// Created By   :  Rameshwar
// Last Modified Date :  24 June 2021 
// Last Modified by   :  Rameshwar
@isTest
public class PurchaseOrderCMP_TestClass {
    @isTest
    static void PurchaseIOrder_Direct()
    {
        
        clsUtility.testDataCustomSetting();
        Account acc = New Account();
        acc.Name = 'Test Supplier';
        acc.Print_Name__c = 'Test Supplier';
        acc.PAN_NO__c = 'ghtid8739I';
        acc.BillingCity = 'Noida';
        acc.BillingStreet ='NRF road';
        acc.Region__c = 'East';
        acc.BillingState= 'Uttar Pradesh';
        acc.BillingPostalCode='256314';
        acc.BillingCountry='India';
        acc.Billing_State_Code__c='09';
        acc.ShippingCity = 'Noida';
        acc.ShippingStreet ='NRF road';
        acc.ShippingState= 'Uttar Pradesh';
        acc.ShippingPostalCode='256314';
        acc.ShippingCountry='India';
        acc.Shipping_State_Code__c='09';
        insert acc;
        
        // insert Contact
        Contact c = new Contact();
        c.AccountId= acc.id; 
        c.FirstName = 'TestedFirstName';
        c.LastName = 'TestedContact0021';
        c.isPrimary__c= true;
        insert c;
        
        //insert WareHouse
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Kolkata Warehouse';
        wHouse.City__c = 'Kolkata';
        wHouse.State_Code__c='09';
        wHouse.Branch__c='Kolkata';
        insert wHouse;
        
        //insert product/part
        list<Id> pIdSet = New list<Id>(); 
        Part__c part = new Part__c();
        part.Name = 'CH10929';
        part.Part_Name__c = 'CH10929';
        part.Active__c = true;
        part.List_Price_Standard_price__c = 3232.22;
        insert part;
        pIdSet.add(part.Id);
        
        part__c part2 = new Part__c();
        part2.Name = 'PR2314';
        part2.Part_Name__c = 'PR2314';
        part2.Active__c = true;
        part2.List_Price_Standard_price__c = 3232.22;
        insert part2;
        pIdSet.add(part2.Id);
        
        //insert Stock
        Stock__c stk = new Stock__c();
        stk.Product_Part__c = part.Id;
        stk.Ware_House__c = wHouse.Id;
        stk.Product_In__c = 20;
        stk.Product_Out__c = 10;
        stk.Bin_Number__c='xyz';
        stk.Freeze_Quantity__c =10;
        insert stk; 
        
        //insert Stock
        Stock__c stk2 = new Stock__c();
        stk2.Product_Part__c = part2.Id;
        stk2.Ware_House__c = wHouse.Id;
        stk2.Product_In__c = 20;
        stk2.Product_Out__c = 10;
        stk2.Bin_Number__c='xyz';
        insert stk2; 
        
         Purchase_Order__c po= new Purchase_Order__c();
        po.Ware_House__c = wHouse.id;
        po.Shipping_Ware_House__c = wHouse.id;
        po.Customer_Name_Account__c=acc.id;
        po.Contact_person__c=c.id;
        //po.Shipping_Customer__c = acc.id;
        po.Against__c = 'Direct';
        insert po;
        
        Purchase_Order_Line_Item__c poli= new Purchase_Order_Line_Item__c();
        poli.Product_Part__c=part.id;
        poli.CGST__c=5;
        poli.SGST__c=5;
 poli.Quantity__c= 10;
        poli.Discount__c= 10;
        poli.Sales_Price__c = 10;
        poli.Purchase_Order__c=po.id;
        insert poli;
                //insert Tax
        Tax__c tx = new Tax__c();
        tx.Name = 'Test Tax';
        tx.Tax_Percentage__c = 22.1;
        insert tx;
           //insert Charge
        charges__c chp = new charges__c();
       // chp.Sales_Order__c = sOrder.Id;
        chp.Charges__c = tx.Id;
        chp.Charge_Percentage__c = 10;
        chp.Purchase_Order__c = po.id;
        chp.Total_Amount__c = 400;
        insert chp;
        // Test Method : Hit & Run
        
          String JsonMainwrap = PurchaseOrderCMP.doInit(po.id);
        PurchaseOrderCMP.SavePurchaseOrder(JsonMainwrap);
        PurchaseOrderCMP.getPurchaseIndentItems(po.id,pIdSet);
    }
    
    @isTest
    static void PurchaseIOrder_PI()
    {
        
        clsUtility.testDataCustomSetting();
        Account acc = New Account();
        acc.Name = 'Test Supplier';
        acc.Print_Name__c = 'Test Supplier';
        acc.PAN_NO__c = 'ghtid8739I';
        acc.BillingCity = 'Noida';
        acc.BillingStreet ='NRF road';
        acc.Region__c = 'East';
        acc.BillingState= 'Uttar Pradesh';
        acc.BillingPostalCode='256314';
        acc.BillingCountry='India';
        acc.Billing_State_Code__c='09';
        acc.ShippingCity = 'Noida';
        acc.ShippingStreet ='NRF road';
        acc.ShippingState= 'Uttar Pradesh';
        acc.ShippingPostalCode='256314';
        acc.ShippingCountry='India';
        acc.Shipping_State_Code__c='09';
        insert acc;
        
        // insert Contact
        Contact c = new Contact();
        c.AccountId= acc.id; 
        c.FirstName = 'TestedFirstName';
        c.LastName = 'TestedContact0021';
        c.isPrimary__c = true;
        insert c;
        
        //insert WareHouse
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Kolkata Warehouse';
        wHouse.City__c = 'Kolkata';
        wHouse.State_Code__c='09';
        wHouse.Branch__c='Kolkata';
        insert wHouse;
        
        //insert product/part
        list<Id> pIdSet = New list<Id>(); 
        Part__c part = new Part__c();
        part.Name = 'CH10929';
        part.Part_Name__c = 'CH10929';
        part.Active__c = true;
        part.List_Price_Standard_price__c = 3232.22;
        insert part;
        pIdSet.add(part.Id);
        
        part__c part2 = new Part__c();
        part2.Name = 'PR2314';
        part2.Part_Name__c = 'PR2314';
        part2.Active__c = true;
        part2.List_Price_Standard_price__c = 3232.22;
        insert part2;
        pIdSet.add(part2.Id);
        
        //insert Stock
        Stock__c stk = new Stock__c();
        stk.Product_Part__c = part.Id;
        stk.Ware_House__c = wHouse.Id;
        stk.Product_In__c = 20;
        stk.Product_Out__c = 20;
        stk.Bin_Number__c='xyz';
        stk.Freeze_Quantity__c =00;
        insert stk; 
        
        //insert Stock
        Stock__c stk2 = new Stock__c();
        stk2.Product_Part__c = part2.Id;
        stk2.Ware_House__c = wHouse.Id;
        stk2.Product_In__c = 20;
        stk2.Product_Out__c = 10;
        stk2.Bin_Number__c='xyz';
        insert stk2; 
        
        Opportunity__c o=new Opportunity__c();
        // o.Name='opportunity';
        o.Stage__c='New';
        o.Opportunity_Close_Date__c = system.today();
        o.OEM_Customer__c = acc.id;
        o.Transporter_Name__c ='trname';
        o.Shipping_Account__c = acc.Id;
        o.Ware_House__c = wHouse.Id;
        o.Description__c = 'description';
        o.Syncquote__c = 'q.id';
        o.Date_of_Supply__c = system.today();
        o.PI_Date__c = system.today();
        o.Reverse_Charges__c = 'NO';
        o.Contact_Person__c = c.id;
        o.LC_Date__c = system.today();
        o.LC_Term__c = '2';
        o.Payment_Terms__c = '2 days';
        
        o.Opportunity_Type__c = 'Sales';
        insert o;
        
        Line_Item__c lit = new Line_Item__c();
        lit.Opportunity__c = o.id;
        lit.Product_Part__c = part.Id;
        lit.Quantity__c = 200;
        lit.Sales_Price__c = 100000;
        lit.CGST__c = 10;
        lit.SGST__c = 10;
        insert lit;
        
        // insert SalesOrder
        Sales_Order__c sOrder = new Sales_Order__c();
        sOrder.Ware_House__c = wHouse.Id;
        sOrder.Customer_Name__c = acc.Id;
        sOrder.Shipping_Account__c = acc.Id;
        sOrder.Packing_Charges__c = 10;
        sOrder.CGST__c = 5;
        sOrder.IGST__c = 5;
        sOrder.SGST__c = 5;
        sOrder.Freight__c =5;
        sOrder.Term_and_Condition__c = 't/c';
        sOrder.Opportunity__c = o.id;
        insert sOrder;
        
        //insert Sales Order Line Item
        Sales_Order_Line_Item__c sOLItem = new Sales_Order_Line_Item__c();
        sOLItem.Sales_Order__c = sOrder.Id;
        sOLItem.Product_Part__c = part.Id;
        sOLItem.Quantity__c = 25;
        sOLItem.CGST__c = 5;
        sOLItem.IGST__c = 5;
        sOLItem.SGST__c = 5;
        sOLItem.Quantity__c =5;
        sOLItem.Unit_Price__c = 10;
        sOLItem.Discount__c = 5;
        sOLItem.Stock__c = stk.id;
        sOLItem.Freeze_Stock__c = stk.id;
        sOLItem.Freeze_Qunatity__c = 10;
        sOLItem.Deliverd_Quantity__c = 10;
        insert sOLItem;
        
        //insert Tax
        Tax__c tx = new Tax__c();
        tx.Name = 'Test Tax';
        tx.Tax_Percentage__c = 22.1;
        insert tx;
        
        //insert Charge
        charges__c ch = new charges__c();
        ch.Sales_Order__c = sOrder.Id;
        ch.Charges__c = tx.Id;
        ch.Charge_Percentage__c = 10;
        ch.Total_Amount__c = 400;
        insert ch;
        
        
        
        Purchase_Indent__c PiRecord = new Purchase_Indent__c();
        PiRecord.Against__c = 'Sales Order';
        PiRecord.Department__c = 'Sales';
        PiRecord.Indent_Date__c = System.today();
        PiRecord.Procurement__c = 'Local';
        PiRecord.Ware_House__c = wHouse.Id;
        PiRecord.Status__c = 'Draft';
        Insert PiRecord;
        
        Purchase_Indent_Line_Item__c PiLineRecord = new Purchase_Indent_Line_Item__c();
        PiLineRecord.Application__c = 'Industrial';
        PiLineRecord.Expected_date__c = System.today();
        PiLineRecord.Product_Part__c = part.Id;
        PiLineRecord.QTY__c = 5;
        PiLineRecord.Remark__c = 'Test Remark';
        PiLineRecord.Specification__c = '1111';
        PiLineRecord.Purchase_Indent__c = PiRecord.id;
        PiLineRecord.Sales_Order_Line_Item__c = sOLItem.id;
        Insert PiLineRecord;
        //adding content
        Purchase_Order__c po= new Purchase_Order__c();
        po.Ware_House__c = wHouse.id;
        po.Shipping_Ware_House__c = wHouse.id;
        po.Customer_Name_Account__c=acc.id;
        po.Contact_person__c=c.id;
       // po.Shipping_Customer__c = acc.id;
        po.Against__c = 'Purchase Indent';
        insert po;
        
        Purchase_Order_Line_Item__c poli= new Purchase_Order_Line_Item__c();
        poli.Product_Part__c=part.id;
        poli.CGST__c=5;
        poli.SGST__c=5;
        poli.Quantity__c= 10;
        poli.Discount__c= 10;
        poli.Sales_Price__c = 10;
        poli.Purchase_Order__c=po.id;
        insert poli;
        
          //insert Charge
        charges__c chp = new charges__c();
       // chp.Sales_Order__c = sOrder.Id;
        chp.Charges__c = tx.Id;
        chp.Charge_Percentage__c = 10;
        chp.Purchase_Order__c = po.id;
        chp.Total_Amount__c = 400;
        insert chp;
        // Test Method : Hit & Run
        
        String JsonMainwrap = PurchaseOrderCMP.doInit(po.id);
           
        PurchaseOrderCMP.SavePurchaseOrder(JsonMainwrap);
        
       
        
        PurchaseOrderCMP.getPurchaseIndentItems(po.id,pIdSet);
        
        
    }
}