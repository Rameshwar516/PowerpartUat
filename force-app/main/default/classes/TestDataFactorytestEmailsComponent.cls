@isTest
public class TestDataFactorytestEmailsComponent {
    public static testmethod void TestEmails() {
        
        List<Account> accts = new List<Account>();
        Trigger_Setting__c objCS = new Trigger_Setting__c();
        objCS.Active__c= true;
        objCS.Name='Account';
        insert objCS;
        
         Trigger_Setting__c objCSAsset = new Trigger_Setting__c();
        objCSAsset.Active__c= true;
        objCSAsset.Name='Asset';
        insert objCSAsset;
        
        Generating_Account_Number__c gac = new Generating_Account_Number__c();
        gac.Unique_Number__c=387739;
        gac.Name='Unique Number';
        insert gac;
           
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName='uniqueUserName@gmail.com');
 
        System.runAs(u) {
              // The following code runs as user 'u'
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
       
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
        a.Is_Upload_From_Excel__c = true;
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
        
        Opportunity__c o=new Opportunity__c();
        // o.Name='opportunity';
        o.Stage__c='New';
        o.Opportunity_Close_Date__c = system.today();
        o.OEM_Customer__c = a.id;
        o.Transporter_Name__c ='trname';
        o.Shipping_Account__c = ashipping.Id;
        o.Ware_House__c = wh.Id;
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
        lit.Product_Part__c = pt.Id;
        lit.Quantity__c = 200;
        lit.Sales_Price__c = 100000;
        lit.CGST__c = 10;
        lit.SGST__c = 10;
        insert lit;
        
        
          system.debug('opportunity  '+o);
     
     
        Id RecordTypeIdQuote = Schema.SObjectType.Quote__c.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        
        Id RecordTypeIdQuoteAMC = Schema.SObjectType.Quote__c.getRecordTypeInfosByName().get('AMC').getRecordTypeId();
        Id RecordTypeIdQuoteService = Schema.SObjectType.Quote__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        
        Quote__c q= new Quote__c();
        q.Opportunity__c = o.Id;
        q.Customer_Party__c = a.Id;
        q.Is_Synced__c= true;
        q.Shipping_Account__c = ashipping.Id;
        q.Contact_Name__c = c.id;
        q.RecordTypeId = RecordTypeIdQuote;
        q.Quote_Status__c = 'Approved';
        insert q;
        
          system.debug('Quote sales  '+q);
        
           Line_Item__c litq = new Line_Item__c();
        //lit.Opportunity__c = o.id;
        litq.Product_Part__c = pt.Id;
        litq.Quote__c = q.id;
        litq.Quantity__c = 200;
        litq.Sales_Price__c = 100000;
        litq.CGST__c = 10;
        litq.SGST__c = 10;
        insert litq;
         system.debug('Quote line   '+litq);
        
         opportunity__c oo= new opportunity__c();
        oo.Id = o.Id;
        oo.Stage__c = 'Closed Won';
        update oo;
        
        
           //opportunity service 
        
        Opportunity__c serviceOpp=new Opportunity__c();
       
        serviceOpp.Stage__c='New';
        serviceOpp.Opportunity_Close_Date__c = system.today();
        serviceOpp.OEM_Customer__c = a.id;
        serviceOpp.Transporter_Name__c ='trname';
        serviceOpp.Shipping_Account__c = ashipping.Id;
        serviceOpp.Ware_House__c = wh.Id;
        serviceOpp.Description__c = 'description';
        serviceOpp.Syncquote__c = 'q.id';
        serviceOpp.Date_of_Supply__c = system.today();
        serviceOpp.PI_Date__c = system.today();
        serviceOpp.Reverse_Charges__c = 'NO';
        serviceOpp.Contact_Person__c = c.id;
        serviceOpp.LC_Date__c = system.today();
        serviceOpp.LC_Term__c = '2';
        serviceOpp.Payment_Terms__c = '2 days';
        
        serviceOpp.Opportunity_Type__c = 'Service';
        insert serviceOpp;
        
         Line_Item__c Servicelit = new Line_Item__c();
        Servicelit.Opportunity__c = serviceOpp.id;
        Servicelit.Product_Part__c = pt.Id;
        Servicelit.Quantity__c = 200;
        Servicelit.Sales_Price__c = 100000;
        Servicelit.CGST__c = 10;
        Servicelit.SGST__c = 10;
        insert Servicelit;
        
        //amc quote
        Quote__c qAMC= new Quote__c();
        qAMC.Opportunity__c = serviceOpp.Id;
        qAMC.Customer_Party__c = a.Id;
        qAMC.Shipping_Account__c = ashipping.Id;
        qAMC.Contact_Name__c = c.id;
        qAMC.Is_Synced__c = true;
        qAMC.RecordTypeId = RecordTypeIdQuoteAMC;
        qAMC.Quote_Status__c = 'Approved';
        insert qAMC;
        
         system.debug('Quote AMC  '+qAMC);
        
        // service quote
        Quote__c qService= new Quote__c();
        qService.Opportunity__c = serviceOpp.Id;
        qService.Customer_Party__c = a.Id;
        qService.Shipping_Account__c = ashipping.Id;
        qService.Contact_Name__c = c.id;
        qService.Is_Synced__c = true;
        qService.RecordTypeId = RecordTypeIdQuoteService;
        qService.Quote_Status__c = 'Approved';
        insert qService;
        
        
        Opportunity__c serviceOppUpdate=new Opportunity__c();
        serviceOppUpdate.Id = serviceOpp.Id;
        serviceOppUpdate.Stage__c='Closed Won';
        update serviceOppUpdate;
       
         // stock
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
        
        Sales_Order__c so= new Sales_Order__c();
        system.debug('sales order');
        so.Opportunity__c = oo.Id;
        system.debug('sales order opportunity '+ so.Opportunity__c );
        so.Ware_House__c =wh.Id;
         system.debug('sales order warehouse  '+so.Ware_House__c);
        so.Shipping_Account__c = ashipping.Id;
         system.debug('sales order opportunity shipping acc '+so.Shipping_Account__c);
        so.Shipping_Terms__c = 'Sterms';
         system.debug('sales order opportunity so.Shipping_Terms__c'+so.Shipping_Terms__c);
        //so.Transpotaion_Mode__c = 'By Hand';
        so.Type_SOA__c ='Sales';
         system.debug('sales order opportunity  so.Type_SOA__c'+ so.Type_SOA__c);
        so.Customer_Name__c = a.Id;
         system.debug('sales order opportunity  so.Customer_Name__c '+ so.Customer_Name__c );
        so.Contact_Person__c = c.Id;
         system.debug('sales order opportunity so.Contact_Person__c'+so.Contact_Person__c);
        so.Mode_of_Transport__c= 'By Hand';
        system.debug('sales order opportunity so.Mode_of_Transport__c '+so.Mode_of_Transport__c);
        so.Transporter_Name__c = 'trname';
         system.debug('sales order opportunity so.Transporter_Name__c '+so.Transporter_Name__c);
        insert so;
        
        system.debug(' sales order   '+ so);
        
        Sales_Order_Line_Item__c soli = new Sales_Order_Line_Item__c();
        soli.Product_Part__c = pt.id;
        soli.Sales_Order__c = so.Id;
        soli.Quantity__c = 200;
        soli.CGST__c = 10;
        soli.SGST__c = 10;
        soli.Freeze_Qunatity__c=200;
        soli.Expected_Date__c = system.today()+1;
        soli.Unit_Price__c = 100000;
        insert soli;
        
        
        //delivery note
        Sales_Order_Dispatch_Delivery_Note__c sdn = new Sales_Order_Dispatch_Delivery_Note__c();
        sdn.Customer_Party__c = a.Id;
        sdn.Shipping_Account__c =ashipping.Id;
        sdn.Sales_Order__c = so.id;
        sdn.Type__c = 'Sales';
        sdn.Invoice_Type__c = 'Local';
        sdn.Customer_PO_No__c = 'CPO4444444455';
        sdn.Date__c = system.today();
        sdn.Bank__c = 'ICICI';
        sdn.Invoice_Currency__c = 'USD';
        
        insert sdn;
        
        Delivery_Note_Line_Item__c dnli = new Delivery_Note_Line_Item__c();
        dnli.Product_Part__c = pt.Id;
        dnli.Quantity__c= 200;
        dnli.CGST__c=10;
        dnli.SGST__c= 10;
        //dnli.Ware_House__c = wh.Id;
        dnli.Sales_Order_Line_Item__c = soli.Id;
        dnli.Delivery_Date__c = system.today()+2;
        dnli.Sales_Order_Dispatch_Delivery_Note__c = sdn.Id;
        insert dnli;
        
        Charges__c ch= new Charges__c();
        ch.CGST__c= 10;
        ch.Charge_Percentage__c=10;
        ch.SGST__c = 10;
        ch.Delivery_Note__c = sdn.id;
        ch.Total_Amount__c= 100000;
        ch.Opportunity__c =oo.Id;
        insert ch;
        
        Id RecordTypeIdInvoice = schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Tax_Invoice').getRecordTypeId();
        Invoice__c inv= new Invoice__c();
        inv.Place_of_Supply__c = wh.Id;
        inv.Bank__c = 'ICICI';
        inv.DC_No__c= sdn.Id;
        inv.Reverse_Charge__c= 'No';
        inv.Type__c='Sales';
        inv.Status__c = 'Approved';
        inv.Customer_Name__c = a.id;
        inv.Contact_Person__c = c.id;
        inv.Shipping_Account__c = ashipping.Id;
        inv.RecordTypeId = RecordTypeIdInvoice;
        insert inv;
        
        
        Invoice_Line_Item__c invli = new Invoice_Line_Item__c();
        invli.Invoice__c= inv.Id;
        invli.Part_Number__c = pt.Id;
        invli.Unit_Price__c = 10;
        invli.Discount__c= 10;
        invli.SGST__c = 10;
        invli.CGST__c = 10;
        invli.Quantity__c = 200;
        insert invli;
            
         //service invoice
            Id RecordTypeIdInvoiceService = schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Service_Invoice').getRecordTypeId();
            Invoice__c invservice= new Invoice__c();
            invservice.Place_of_Supply__c = wh.Id;
            invservice.Bank__c = 'ICICI';
            invservice.Quote__c = qService.Id;
            //inv.DC_No__c= sdn.Id;
            invservice.Reverse_Charge__c= 'No';
            invservice.Type__c='Service';
            invservice.Status__c = 'Approved';
            invservice.Customer_Name__c = a.id;
            invservice.Contact_Person__c = c.id;
            invservice.Shipping_Account__c = ashipping.Id;
            invservice.RecordTypeId = RecordTypeIdInvoiceService;
            insert invservice;
            
            
            Invoice_Line_Item__c invliservice = new Invoice_Line_Item__c();
            invliservice.Invoice__c= invservice.Id;
            invliservice.Part_Number__c = pt.Id;
            invliservice.Unit_Price__c = 10;
            invliservice.Discount__c= 10;
            invliservice.SGST__c = 10;
            invliservice.CGST__c = 10;
            invliservice.Quantity__c = 200;
            insert invliservice;
            
        //send email component on enquiry
        ClassOnPIEmailSend.intid(o.Id);
        String sub = 'It is Test';
        String Bodyy = 'Good Night';
        String mailAdd = 'testMail@gmail.com';
        String ccAdd = 'testcc@gmail.com';
        ClassOnPIEmailSend.send(o.Id, sub, Bodyy, mailAdd, ccAdd);
            
            //send email component on sales quote
        ClassOnQuoteEmailSend.intid(q.Id);
        String qsub = 'It is Test';
        String qBodyy = 'Good Night';
        String qmailAdd = 'testMail@gmail.com';
        String qccAdd = 'testcc@gmail.com';
        ClassOnQuoteEmailSend.send(q.Id, qsub, qBodyy, qmailAdd, qccAdd);
            
            //send email component on tax invoice
        classInvoiceSendOnEmail.intid(inv.Id);
        String isub = 'It is Test';
        String iBodyy = 'Good Night';
        String imailAdd = 'testMail@gmail.com';
        String iccAdd = 'testcc@gmail.com';
        classInvoiceSendOnEmail.send(inv.Id, isub, iBodyy, imailAdd, iccAdd);
            
             //send email component on service invoice
        classInvoiceSendOnEmail.intid(invservice.Id);
        String isubService = 'It is Test';
        String iBodyyService = 'Good Night';
        String imailAddService = 'testMail@gmail.com';
        String iccAddService = 'testcc@gmail.com';
        classInvoiceSendOnEmail.send(invservice.Id, isubService, iBodyyService, imailAddService, iccAddService);
            
                 //send email component on amc quote
        ClassOnQuoteEmailSend.intid(qAMC.Id);
        String qamcsub = 'It is Test';
        String qamcBodyy = 'Good Night';
        String qamcmailAdd = 'testMail@gmail.com';
        String qamcccAdd = 'testcc@gmail.com';
        ClassOnQuoteEmailSend.send(qAMC.Id, qamcsub, qamcBodyy, qamcmailAdd, qamcccAdd);
            
                 //send email component on service quote
        ClassOnQuoteEmailSend.intid(qService.Id);
        String qservicesub = 'It is Test';
        String qserviceBodyy = 'Good Night';
        String qservicemailAdd = 'testMail@gmail.com';
        String qserviceccAdd = 'testcc@gmail.com';
        ClassOnQuoteEmailSend.send(qService.Id, qservicesub, qserviceBodyy, qservicemailAdd, qserviceccAdd);
      }	

        
   }
}