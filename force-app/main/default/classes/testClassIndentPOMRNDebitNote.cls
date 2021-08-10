@istest
public class testClassIndentPOMRNDebitNote {
    public static testmethod void testpdfs(){
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
            
            Map<id,MRN__c> mapMrn= new Map<id,MRN__c>();
            
            MRN__c mr = new MRN__c();
            mr.Ware_House__c = wh.id;
            mr.MRN_Type__c = 'Purchase Order';
            mr.OEM_Customer__c = a.Id;
            mr.Contact_Name__c = c.id;
            mr.Stage__c = 'Draft';
            mr.Shipping_Account__c = ashipping.Id;
            mr.MRN_Delivery_Type__c = 'Domestic';
            insert mr;
            mapMrn.put(mr.id, mr);
            
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
            list<MRN__c> lstmrn = new LIst<MRN__c>();
            MRN__c mrReceive = new MRN__c();
            mrReceive.id= mr.id;
            mrReceive.Stage__c = 'Received';
            update mrReceive;
            lstmrn.add(mrReceive);
            
            Charges__c ch= new Charges__c();
            ch.CGST__c= 10;
            ch.Charge_Percentage__c=10;
            ch.SGST__c = 10;
            ch.MRN__c = mr.Id;
            //ch.Delivery_Note__c = sdn.id;
            ch.Total_Amount__c= 100000;
            //ch.Opportunity__c =oo.Id;
            insert ch;
            
            
            Id debitnoterecordtyp = schema.SObjectType.DC_Note__c.getRecordTypeInfosByDeveloperName().get('Debit_Note').getRecordTypeId();
            DC_Note__c dcn = new DC_Note__c ();
            dcn.RecordTypeId = debitnoterecordtyp;
            //dcn.Sales_Order_Return__c  = sor.Id;
            dcn.Customer_Party__c= a.id;
            dcn.Shipping_Account__c = ashipping.id;
            dcn.Bill_To_Customer_Name__c = c.id;
            dcn.MRN__c = mr.id;
            dcn.Dispatch_To_Customer_Name__c= cship.id;
            //dcn.Invoice__c = inv.Id;
            insert dcn;
            
            DC_Note_Line_Item__c dcli = new DC_Note_Line_Item__c();
            dcli.Doc_No__c= dcn.Id;
            dcli.Part_Number__c = pt.Id;
            dcli.Quantity__c = 10;
            dcli.Unit_Price__c = 10;
            insert dcli;
            
            //for mrn pdf
            PageReference pageRefMrnpdf = Page.MrnPdf;
            Test.setCurrentPage(pageRefMrnpdf);
            pageRefMrnpdf.getParameters().put('id', String.valueOf(mr.Id));        
            ApexPages.StandardController scmrn = new ApexPages.StandardController(mr);
            MrnPurchanseOrderExt objmrnpdfs = new MrnPurchanseOrderExt(scmrn);
            
            //for indent pdf
            PageReference pageRefcreditnotepdf = Page.IndentPdf;
            Test.setCurrentPage(pageRefcreditnotepdf);
            pageRefcreditnotepdf.getParameters().put('id', String.valueOf(pi.Id));        
            ApexPages.StandardController sccreditnote = new ApexPages.StandardController(pi);
            PurchaseIndentCtrl objcreditnotepdfs=new PurchaseIndentCtrl(sccreditnote);
            
            //for purchase order pdf
            PageReference pageRefpopdf = Page.IndentPdf;
            Test.setCurrentPage(pageRefpopdf);
            pageRefpopdf.getParameters().put('id', String.valueOf(po.Id));        
            ApexPages.StandardController scpo = new ApexPages.StandardController(po);
            PurchaseOrderInvoice objpopdfs=new PurchaseOrderInvoice(scpo);
            
            //for debit note pdf
            PageReference pageRefdebitnotepdf = Page.DebitNotePdf;
            Test.setCurrentPage(pageRefdebitnotepdf);
            pageRefdebitnotepdf.getParameters().put('id', String.valueOf(dcn.Id));        
            ApexPages.StandardController scdebitnote = new ApexPages.StandardController(dcn);
            classPdfDebitNote objdebitnotepdfs=new classPdfDebitNote(scdebitnote);
            
            Stock_Quantity_Update_onMRN_Handler.updatestock(lstmrn, mapMrn);
            
        }
    }
}