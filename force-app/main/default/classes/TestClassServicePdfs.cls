@isTest
public class TestClassServicePdfs {
    
    public static testmethod void createAccountsWithOppsService() {
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
            a.Lead_Type__c='Service';
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
            ashipping.Lead_Type__c='Service';
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
            
            
            
            
            Id RecordTypeIdQuoteAMC = Schema.SObjectType.Quote__c.getRecordTypeInfosByName().get('AMC').getRecordTypeId();
            Id RecordTypeIdQuoteService = Schema.SObjectType.Quote__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
            
            
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
            
            
            //service invoice
            Id RecordTypeIdInvoiceService = schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Service_Invoice').getRecordTypeId();
            Invoice__c inv= new Invoice__c();
            inv.Place_of_Supply__c = wh.Id;
            inv.Bank__c = 'ICICI';
            inv.Quote__c = qService.Id;
            //inv.DC_No__c= sdn.Id;
            inv.Reverse_Charge__c= 'No';
            inv.Type__c='Service';
            inv.Status__c = 'Approved';
            inv.Customer_Name__c = a.id;
            inv.Contact_Person__c = c.id;
            inv.Shipping_Account__c = ashipping.Id;
            inv.RecordTypeId = RecordTypeIdInvoiceService;
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
            // line item sales
            
            
            
            //for Service Quote pdf
            PageReference pageRefSQuote = Page.ServiceQuote;
            Test.setCurrentPage(pageRefSQuote);
            pageRefSQuote.getParameters().put('id', String.valueOf(qService.Id));        
            ApexPages.StandardController scServiceQuote = new ApexPages.StandardController(qService);
            ClsAMCQuote objServiceQuot=new ClsAMCQuote(scServiceQuote);
            
            //for AMC Quote pdf
            PageReference pageRefAMCQuote = Page.AMCQuote;
            Test.setCurrentPage(pageRefAMCQuote);
            pageRefAMCQuote.getParameters().put('id', String.valueOf(qAMC.Id));        
            ApexPages.StandardController scAMCQuote = new ApexPages.StandardController(qAMC);
            ClsAMCQuote objAMCQuot=new ClsAMCQuote(scAMCQuote);
            
            //for Service Invoice pdf
            PageReference pageRefServiecInvoice = Page.ServiceInvoicePDF;
            Test.setCurrentPage(pageRefServiecInvoice);
            pageRefAMCQuote.getParameters().put('id', String.valueOf(inv.Id));        
            ApexPages.StandardController scInvService = new ApexPages.StandardController(inv);
            TaxCumServiceInvoicePDF objServiceInvoice=new TaxCumServiceInvoicePDF(scInvService);
            
            //ApexPages.currentPage().getParameters().put('id', String.valueOf(o.Id));
            //PerformanceInvoice  testAccPlan = new PerformanceInvoice();
        }	        
    }
}