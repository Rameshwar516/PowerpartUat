// Test Class for classCreateDeliveryNoteLIghtngComp Apex Class
// Created Date :  24 June 2021 
// Created By   :  Rameshwar
// Last Modified Date :  24 June 2021 
// Last Modified by   :  Rameshwar
// 
@isTest
public class MRNCmpControlerV2_TestClass {
    @isTest
    static void Method()
    {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='uniqueUserName@gmail.com');
        
        
        clsUtility.testDataCustomSetting();
        Id RecordTypeIdAcc = Schema.SObjectType.account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account a= new account();
        a.RecordTypeId = RecordTypeIdAcc;
        a.Name='TestAccount';
        a.Industry='Service Provider';
        a.Lead_Type__c='Sales';
        a.Email__c='abhi@orientindia.com';
        a.Type='Customer';
        a.Print_Name__c= 'printname2';
        a.Shipping_GSTIN_No__c='07AABCI2726B2Z4';
        a.GSTIN_No__c='07AABCI2726B2Z4';
        a.Is_Upload_From_Excel__c = true;
        a.BillingCity='city';
        a.BillingState='stste';
        a.BillingCountry='country';
        a.BillingStreet='strrtt';
        a.BillingPostalCode='135055';
        a.ShippingCity='scity';
        a.ShippingState='sstate';
        a.ShippingCountry='scountry';
        a.ShippingStreet='sstreet';
        a.ShippingPostalCode='2345667';
        a.Description='description';
        a.Phone='3556678789';
        insert a;
        system.debug('account '+a);
        // Id RecordTypeIdQuote = Schema.SObjectType.account.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        Account ashipping= new account();
        ashipping.Name='TestAccount2';
        ashipping.Industry='Service Provider';
        ashipping.Lead_Type__c='Sales';
        ashipping.Is_Upload_From_Excel__c = true;
        ashipping.Email__c='abhi@orientindia.com';
        ashipping.Type='Customer';
        ashipping.Shipping_GSTIN_No__c='07AABCI2726B2Z4';
        ashipping.GSTIN_No__c='07AABCI2726B2Z4';
        ashipping.BillingCity='city';
        ashipping.BillingState='stste';
        ashipping.Print_Name__c= 'printname';
        ashipping.BillingCountry='country';
        ashipping.BillingStreet='strrtt';
        ashipping.BillingPostalCode='135055';
        ashipping.ShippingCity='scity';
        ashipping.ShippingState='sstate';
        ashipping.ShippingCountry='scountry';
        ashipping.ShippingStreet='sstreet';
        ashipping.ShippingPostalCode='2345667';
        ashipping.Description='description';
        ashipping.Phone='3556678789';
        insert ashipping;
        system.debug('account ashipping '+ashipping);
        
        
        
        Id SupRecordTypeIdAcc = Schema.SObjectType.account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Account Supplier= new account();
        Supplier.RecordTypeId = SupRecordTypeIdAcc;
        Supplier.Name='Supplier';
        Supplier.Industry='Service Provider';
        Supplier.Lead_Type__c='Sales';
        Supplier.Email__c='abhi@orientindiSupplier.com';
        Supplier.Type='Supplier';
        Supplier.Print_Name__c= 'printname2';
        Supplier.Shipping_GSTIN_No__c='07AABCI2726B2Z4';
        Supplier.GSTIN_No__c='07AABCI2726B2Z4';
        Supplier.Is_Upload_From_Excel__c = true;
        Supplier.BillingCity='city';
        Supplier.BillingState='stste';
        Supplier.BillingCountry='country';
        Supplier.BillingStreet='strrtt';
        Supplier.BillingPostalCode='135055';
        Supplier.ShippingCity='scity';
        Supplier.ShippingState='sstate';
        Supplier.ShippingCountry='scountry';
        Supplier.ShippingStreet='sstreet';
        Supplier.ShippingPostalCode='2345667';
        Supplier.Description='description';
        Supplier.Phone='3556678789';
        insert Supplier;
        
        contact Supplierc= new contact() ;
        Supplierc.LastName='Supplier';
        Supplierc.FirstName='fname';
        Supplierc.Email='Supplier@cccinfotech.com';
        Supplierc.Phone='7898765645';
        Supplierc.MobilePhone='2345668765';
        Supplierc.isPrimary__c = true;
        Supplierc.AccountId=Supplier.id;
        insert Supplierc;
        
        //asset
        Asset__c ast = new Asset__c();
        ast.End_Customer__c= a.Id;
        ast.OEM__c = a.Id;
        ast.Name= '12345';
        ast.Engine_Model__c='D3.152';
        ast.Engine_Family_List__c ='3.152 Series Engine' ;
        ast.Current_Running_Hours__c = 10;
        ast.Running_Hours_Captured_Date__c= system.today();
        ast.Under_AMC__c= 'No';
        insert ast;
        
        system.debug('asset ast '+ast);
        
        contact c= new contact() ;
        c.LastName='lname';
        c.FirstName='fname';
        c.Email='krishan@cccinfotech.com';
        c.Phone='7898765647';
        c.MobilePhone='2345678765';
        c.isPrimary__c = true;
        c.AccountId=a.id;
        insert c;
        
        system.debug('contact  '+c);
        contact cship = new contact();
        cship.lastname = 'lastname con';
        cship.email= 'krishanaggarwal750@gmail.com';
        cship.phone ='8564345666';
        cship.mobilephone ='3456789678';
        cship.isprimary__c = true;
        cship.AccountId=ashipping.id;
        insert cship;
        Ware_House__c wh= new Ware_House__c();
        wh.Branch__c='Kolkata';
        wh.City__c='Kolkata';
        wh.GSTIN_No__c='06asdfghnbvcxzi';
        wh.Country__c='India';
        wh.E_Mail__c='abc@asd.com';
        wh.Contact_Person__c='person2';
        wh.Contact_No__c='5678765435';
        wh.State_Province__c='West Bengal';
        wh.Zip_Postal_Code__c='234433';
        wh.State_Code__c = '06';
        insert wh;
        
        system.debug('warehouse  '+wh);
        
        //part sub cATEGORY
        Product_Sub_Category__c psc= new Product_Sub_Category__c();
        psc.Product_Group__c = 'ENGINE PARTS';
        psc.Name='partsubcategory';
        psc.Product_Category__c= 'DEEP SEA ELECTRONICS';
        insert psc;
        
        //Part
        Part__c pt= new Part__c();
        pt.Name= '2900';
        pt.Product_Sub_Category__c =psc.Id;
        pt.UOI__c='1212';
        pt.UOM__c ='KG';
        pt.Active__c= true;
        pt.Part_Name__c = 'Screw';
        pt.GST__c= 18 ;
        //pt.Stock_Available__c =
        pt.Product_Make__c = 'PERKINS';
        pt.HSN_CODE__c = '73181500';
        insert pt;
        
        Stock__c stk= new Stock__c();
        stk.Bin_Number__c = '478472982';
        stk.Ware_House__c = wh.id;
        stk.Product_Part__c = pt.id;
        stk.Product_In__c = 20000;
        stk.Minimum_Stock__c = 15000;
        stk.Threshold_Quantity__c = 12000;
        stk.Ware_House__c = wh.Id;
        
        insert stk;
        system.debug(' stock  '+ stk); 
        
        Purchase_Indent__c pi = new Purchase_Indent__c();
        pi.Against__c = 'Direct';
        pi.Ware_House__c = wh.id;
        pi.Procurement__c = 'Import';
        insert pi;
        
        Purchase_Indent_Line_Item__c pili= new Purchase_Indent_Line_Item__c();
        pili.Application__c ='Industrial';
        pili.Product_Part__c=pt.id;
        pili.Purchase_Indent__c  = pi.id;
        insert pili;
        
        
        Purchase_Order__c po= new Purchase_Order__c();
        po.Ware_House__c = wh.id;
        po.Supplier__c = Supplier.id;
        // po.Shipping_Ware_House__c = wh.id;
        po.Customer_Name_Account__c=a.id;
        po.Contact_person__c=c.id;
        po.Shipping_Customer__c = ashipping.id;
        insert po;
        
        Purchase_Order_Line_Item__c poli= new Purchase_Order_Line_Item__c();
        poli.Product_Part__c=pt.id;
        poli.CGST__c=5;
        poli.SGST__c=5;
        poli.Purchase_Order__c=po.id;
        insert poli;
        
        
        
        MRN__c mr = new MRN__c();
        mr.Ware_House__c = wh.id;
        mr.MRN_Type__c = 'Purchase Order';
        mr.OEM_Customer__c = a.Id;
        mr.Contact_Name__c = c.id;
        mr.Shipping_Account__c = ashipping.Id;
        mr.MRN_Delivery_Type__c = 'Domestic';
        insert mr;
        
        MRN_Line_Item__c mrnli = new MRN_Line_Item__c();
        mrnli.Stock__c = stk.id;
        mrnli.Purchase_Order_Line_Item__c = poli.id;
        mrnli.MRN__c = mr.id;
        mrnli.Part_Number__c = pt.id;
        mrnli.Ware_House__c = wh.id;
        mrnli.PO_QTY__c= 5;
        mrnli.Bill_QTY__c = 5;
        mrnli.Received_QTY__c =5;
        mrnli.Item_Price_Unit__c = 5;
        
        insert mrnli;
        
        Charges__c ch= new Charges__c();
        ch.CGST__c= 10;
        ch.Charge_Percentage__c=10;
        ch.SGST__c = 10;
        ch.MRN__c = mr.Id;
        //ch.Delivery_Note__c = sdn.id;
        ch.Total_Amount__c= 100000;
        //ch.Opportunity__c =oo.Id;
        insert ch;
        
        
        String JsonMainwrap =  MRNCmpControlerV2.doInit('');
        JsonMainwrap=MRNCmpControlerV2.fetchData(JsonMainwrap, 'PON', wh.id, a.Id);
        JsonMainwrap=MRNCmpControlerV2.SearchPurchaseOrderLI(JsonMainwrap, 'MRN', po.id, wh.id);
        JsonMainwrap = MRNCmpControlerV2.addRowMethod(JsonMainwrap);
    }
    
}