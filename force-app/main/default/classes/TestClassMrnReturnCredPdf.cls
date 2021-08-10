@isTest
public class TestClassMrnReturnCredPdf {
    public static testmethod void MrnReturnCredDebtPdfTest() {
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
            
            MRN__c mr= new MRN__c();
            mr.Delivery_Note__c =sdn.Id ;
            mr.OEM_Customer__c= a.Id;
            mr.Shipping_Account__c=ashipping.Id;
            mr.Contact_Name__c =c.Id;
            mr.Ware_House__c=wh.Id;
            mr.MRN_Type__c='Sales Return';
            insert mr;
            
            MRN_Line_Item__c mrnli= new MRN_Line_Item__c();
            mrnli.Part_Number__c= pt.Id;
            mrnli.Delivery_Note_Line_Item__c = dnli.Id;
            mrnli.Stock__c= stk.id;
            mrnli.MRN__c= mr.id;
            insert mrnli;
            
            Sales_Order_Return__c sor= new Sales_Order_Return__c();
            sor.Customer_Party__c = a.Id;
            sor.Delivery_Note__c = sdn.Id;
            sor.MRN__c = mr.Id;
            sor.Shipping_Account__c = ashipping.Id;
            sor.State__c = 'Return';
            insert sor;
            
            Sales_Order_Return_Line_Item__c sorli = new Sales_Order_Return_Line_Item__c();
            sorli.Doc_No__c=sor.Id;
            sorli.Quantity__c = 10;
            sorli.Unit_Price__c= 10;
            sorli.Part_Number__c = pt.Id;
            sorli.Discount__c = 10;
            insert sorli;
            
            
            Id creditnoterecordtyp = schema.SObjectType.DC_Note__c.getRecordTypeInfosByDeveloperName().get('Credit_Note').getRecordTypeId();
            DC_Note__c dcn = new DC_Note__c ();
            dcn.RecordTypeId = creditnoterecordtyp;
            dcn.Sales_Order_Return__c  = sor.Id;
            dcn.Customer_Party__c= a.id;
            dcn.Shipping_Account__c = ashipping.id;
            dcn.Bill_To_Customer_Name__c = c.id;
            dcn.MRN__c = mr.id;
            dcn.Dispatch_To_Customer_Name__c= cship.id;
            dcn.Invoice__c = inv.Id;
            insert dcn;
            
            DC_Note_Line_Item__c dcli = new DC_Note_Line_Item__c();
            dcli.Doc_No__c= dcn.Id;
            dcli.Part_Number__c = pt.Id;
            dcli.Quantity__c = 10;
            dcli.Unit_Price__c = 10;
            insert dcli;
          
            //for Sales order return pdf
            PageReference pageRefsalesOrdeReturn = Page.SalesOrderReturn_pdf;
            Test.setCurrentPage(pageRefsalesOrdeReturn);
            pageRefsalesOrdeReturn.getParameters().put('id', String.valueOf(sor.Id));        
            ApexPages.StandardController scInvService = new ApexPages.StandardController(sor);
            SalesorderReturnPdf objServiceInvoice=new SalesorderReturnPdf(scInvService);
            
            //for credit note pdf
            PageReference pageRefcreditnotepdf = Page.CreditNotePdf;
            Test.setCurrentPage(pageRefcreditnotepdf);
            pageRefcreditnotepdf.getParameters().put('id', String.valueOf(dcn.Id));        
            ApexPages.StandardController sccreditnote = new ApexPages.StandardController(dcn);
            classPdfCreditNote objcreditnotepdfs=new classPdfCreditNote(sccreditnote);
            
            
        }	
        
        
    }
}