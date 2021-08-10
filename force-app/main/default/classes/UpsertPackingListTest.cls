/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1          17-06-2021                   santosh Rathour            Initial Version
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
2         23-06-2021                    Rameshwar                      Update
--------------------------------------------------------------------------------------
*/
@isTest
public class UpsertPackingListTest
{
    @isTest
    static void ValidateproductOnLoad()
    {
        
        
        clsUtility.testDataCustomSetting();
        
        //insert Account
        Account acc = New Account();
        acc.Name = 'Test Supplier';
        acc.Print_Name__c = 'test';
        acc.PAN_NO__c = 'ghtid8739I';
        acc.BillingCity = 'Noida';
        acc.BillingStreet ='NRF road';
        acc.Region__c = 'East';
        acc.BillingState= 'Uttar Pradesh';
        acc.BillingPostalCode='256314';
        acc.BillingCountry='India';
        acc.Billing_State_Code__c='09';	
        
        insert acc;
        System.debug('accId--- '+acc.Id); 
        
        // insert Contact
        Contact c = new Contact();
        c.AccountId= acc.id; 
        c.FirstName = 'TestedFirstName';
        c.LastName = 'TestedContact0021';
        c.isPrimary__c =true;
        insert c;
        
        //insert wareHouse
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Kolkata Warehouse';
        insert wHouse;
        
        // insert SalesOrder
        Sales_Order__c sOrder = new Sales_Order__c();
        sOrder.Ware_House__c = wHouse.Id;
        sOrder.Contact_Person__c = c.id;
        sOrder.Customer_Name__c = acc.id;
        sOrder.Shipping_Account__c = acc.id;
        insert sOrder;
        System.debug('sOrder--- '+sOrder.Id); 
        
        //insert Delivery Note
        Sales_Order_Dispatch_Delivery_Note__c objdispatchnote = new Sales_Order_Dispatch_Delivery_Note__c();
        objdispatchnote.Sales_Order__c = sOrder.Id;        
        insert objdispatchnote;
        System.debug('objdispatchnote--- '+objdispatchnote.Id);
        
        //insert Packing List
        Packing_List__c objpaclist = new Packing_List__c();
        objpaclist.Delivery_Note__c = objdispatchnote.Id;
        objpaclist.Date__c = date.today();
        insert objpaclist;
        System.debug('objpaclist---- '+objpaclist.Id);   
        
        //insert product/part
        Part__c p = new Part__c();
        p.Name = 'CH10929';
        p.Active__c = true; 
        p.List_Price_Standard_price__c = 3232.22;
        insert p;
        
        //	insert Delivery Note Line Item
        Delivery_Note_Line_Item__c dNLItems = new Delivery_Note_Line_Item__c();
        dNLItems.Sales_Order_Dispatch_Delivery_Note__c = objdispatchnote.Id;
        dNLItems.Ware_House__c = wHouse.Id;
        dNLItems.Product_Part__c = p.Id;
        dNLItems.Quantity__c = 1;
        dNLItems.HSN_Code__c = '84212300';
        insert dNLItems; 
        
        //insert Packing List Line Item
        Packing_List_Line_Item__c pLItem = new Packing_List_Line_Item__c();
        pLItem.Packing_List__c = objpaclist.Id;
        pLItem.Length_Inches_CMS__c = '10';
        pLItem.Width_Inches_CMS__c = '10';
        pLItem.Height_Inches_CMS__c = '10';
        pLItem.Gross_Weight_Kgs__c = '50';
        insert pLItem;
        
        String JsonMainwrap = UpsertPackingList.productOnLoad(objpaclist.Id);
        UpsertPackingList.WrappMain mainWrap = (UpsertPackingList.WrappMain)Json.deserialize(JsonMainwrap, UpsertPackingList.WrappMain.class);
        for(UpsertPackingList.innerWrp wc :mainWrap.inrWrap){
            wc.BOXNo = 'test1';
            wc.decHeight = 5.0;
            wc.decLength = 5.0;
            wc.decWeight = 5.0;
            wc.decWidth = 5.0;
            wc.isSelected = true;
            wc.strBoxType = 'Wooden';
            wc.strRemark = 'Test';
        }
        JsonMainwrap = Json.serialize(mainWrap);
        UpsertPackingList.addRecord(JsonMainwrap, objpaclist.Id);
        
        
    }
}