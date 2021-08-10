@isTest
public class AddproductControllerTest {
    @isTest static void firstMethod(){
        
        clsUtility.testDataCustomSetting();
        clsUtility.testDataAccountContact(20,20,true);
        
        List<Account> accId = [Select id, Name,Billing_State_Code__c from Account where Name = 'Test Account1'];
        System.debug('accId-- '+accId[0].Id+' ----BillingStateCodeInSOQL---- '+accId);
        Account a = new Account();
        a.Name='Test Account1';
        a.Id = accId[0].id;
        a.Billing_State_Code__c= '6';
        update a;
        // insert Contact
        Contact c = new Contact();
        c.AccountId= a.id; 
        c.isPrimary__c = true;
        c.LastName = 'Test0021';
        insert c;
        
        Ware_House__c wHouse = new Ware_House__c();
        wHouse.Name = 'Gurugram Warehouse';
        wHouse.City__c = 'Gurugram';
        wHouse.Branch__c='Gurugram';
        wHouse.State_Code__c='09';
        Insert wHouse;
        
         //insert product/part
        Part__c p = new Part__c();
        p.Name = 'CH10929';
        p.Part_Name__c = 'test product';
        p.Active__c = true;
        p.List_Price_Standard_price__c = 3232.22;
        p.GST__c=18;
        p.HSN_CODE__c='7987987';
        insert p;
        
        Part__c p2 = new Part__c();
        p2.Name = 'CH109292';
        p2.Part_Name__c = 'test product2';
        p2.Active__c = true;
        p2.List_Price_Standard_price__c = 3232.22;
        p2.GST__c=18;
        p2.HSN_CODE__c='7987987';
        insert p2;
        
        //insert Stock 
        list<Stock__c> slist = [SELECT id FROM stock__c WHERE Product_Part__c =:p.Id];
        if(!slist.isempty()){
            Stock__c s = slist[0];
            //s.Product_Part__c = p.Id;
            s.Ware_House__c = wHouse.Id;
            s.Product_In__c = 20;
            s.Product_Out__c = 10;
            Upsert s;
        }
        else{
            Stock__c s = new Stock__c();
            s.Product_Part__c = p.Id;
            s.Ware_House__c = wHouse.Id;
            s.Product_In__c = 20;
            s.Product_Out__c = 10;
            Upsert s;
        }
        
         list<Stock__c> slist2 = [SELECT id FROM stock__c WHERE Product_Part__c =:p2.Id];
        if(!slist.isempty()){
            Stock__c s = slist2[0];
            s.Product_In__c = 20;
            s.Product_Out__c = 10;
            Upsert s;
        }
        else{
            Stock__c s = new Stock__c();
            s.Product_Part__c = p2.Id;
            s.Ware_House__c = wHouse.Id;
            s.Product_In__c = 20;
            s.Product_Out__c = 10;
            Upsert s;
        }
       
        
        // insert Opportunity
        Opportunity__c o = new Opportunity__c();
        o.Contact_Person__c = c.Id;
        o.OEM_Customer__c = a.Id;
        o.Stage__c = 'New';
        o.Opportunity_Close_Date__c = date.today()+1;
        o.Ware_House__c = wHouse.Id;
        insert o;
        
        // insert Quote
        Quote__c q =  new Quote__c();
        q.Payment_Method__c = 'Cash';
        q.Customer_Party__c = a.Id;
        q.Contact_Name__c = c.Id;
        q.Opportunity__c = o.Id; 
        insert q; 
        
        
        
        //insert Tax
        Tax__c tx = new Tax__c();
        tx.Name = 'Test Tax';
        tx.Tax_Percentage__c = 7.00;
        insert tx;
        
        //insert Tax
        Tax__c tx2 = new Tax__c();
        tx2.Name = 'Test Tax2';
        tx2.Tax_Percentage__c = 7.00;
        insert tx2;
        
        //insert Charge
        charges__c ch = new charges__c();
        ch.Opportunity__c = o.Id;
        ch.Quote__c = q.Id;
        ch.Charges__c = tx.Id;
        ch.Total_Amount__c = 400;
        ch.Charge_Percentage__c=7.00;
        insert ch;
        
        //insert lineItems
        Set<Id> lineItemIdSet = New Set<Id>();
        Line_Item__c lItems =  new Line_Item__c();
        lItems.Product_Part__c = p.id;
        lItems.Application__c = 'Industrial';
        lItems.Opportunity__c = o.Id;
        lItems.Quote__c = q.Id;
        lItems.Quantity__c = 1;
        lItems.Sales_Price__c = 200.3;
        lItems.Discount__c=0;
        lItems.SGST__c=0;
        lItems.CGST__c=0;
        lItems.IGST__c=0;
        insert lItems;
        lineItemIdSet.add(lItems.Id);
        
        
        
        
       
 
        //insert WrapperItems
        List<AddproductController.prodwrappChild> proWrapChildList = new List<AddproductController.prodwrappChild>();
        AddproductController.prodwrappChild pWCIns = new AddproductController.prodwrappChild();
        pWCIns.objProdchild = lItems;
         pWCIns.objProdchild.Product_Part__c = p2.id;
        pWCIns.objProdchild.SGST__c = 0;
        pWCIns.objProdchild.CGST__c = 0;
        pWCIns.objProdchild.IGST__c = 0;
        pWCIns.objProdchild.Discount__c = 0;
        pWCIns.isSelected = true;
        pWCIns.isLineItem = true;
        proWrapChildList.add(pWCIns);
        
        //insert ProductWrappers
        List<AddproductController.prodwrapp> prodWrapLst = new List<AddproductController.prodwrapp>();
        AddproductController.prodwrapp proWrap = new AddproductController.prodwrapp();
        proWrap.isSelected = true;
        proWrap.objProd = p2;
        prodWrapLst.add(proWrap);
        Set<Id> addQuoteId = new Set<Id>();
        addQuoteId.add(q.Id);
        
        List<AddproductController.TaxType> tTypeLst = new List<AddproductController.TaxType>();
        AddproductController.TaxType tTypeIns = new AddproductController.TaxType();
        tTypeIns.id = tx.Id;
        tTypeLst.add(tTypeIns);
        
        List<AddproductController.TaxDetails> tDetailLst = new List<AddproductController.TaxDetails>();
        AddproductController.TaxDetails tDetailIns = new AddproductController.TaxDetails();
        tDetailIns.objTax = tx2;
        //tDetailIns.objcharge = ch;
        tDetailIns.strTaxId = tx2.Id;
        tDetailIns.strTaxName = tx2.name;
        tDetailIns.ischargeItem = false;
        tDetailIns.TaxPercentage = 9;
        tDetailIns.decTaxAmount = 200.4;
        tDetailIns.CGST = 0;
        tDetailIns.SGST = 0;
        tDetailIns.IGST = 0;
        tDetailLst.add(tDetailIns);
        
        AddproductController.TaxDetails tDetailIns2 = new AddproductController.TaxDetails();
        tDetailIns2.objTax = tx;
        tDetailIns2.objcharge = ch;
        tDetailIns2.strTaxId = tx.Id;
        tDetailIns2.strTaxName = tx.name;
        tDetailIns2.ischargeItem = true;
        tDetailIns2.TaxPercentage = 9;
        tDetailIns2.decTaxAmount = 200.4;
        tDetailIns2.CGST = 0;
        tDetailIns2.SGST = 0;
        tDetailIns2.IGST = 0;
        tDetailLst.add(tDetailIns2);
        
        //for exception
         AddproductController.TaxDetails tDetailIns3 = new AddproductController.TaxDetails();
        tDetailIns3.objTax = tx2;
        tDetailIns.objcharge = ch;
        tDetailIns3.strTaxId = ch.Id;
        tDetailIns3.strTaxName = ch.name;
        tDetailIns3.ischargeItem = true;
        tDetailIns3.TaxPercentage = 9;
        tDetailIns3.decTaxAmount = 200.4;
        tDetailIns3.CGST = 0;
        tDetailIns3.SGST = 0;
        tDetailIns3.IGST = 0;
        tDetailLst.add(tDetailIns3);
        
        AddproductController.WrappMain mWrap = new AddproductController.WrappMain();
        mWrap.lstWrapp = prodWrapLst;
        mWrap.lstWrappTwo = proWrapChildList;
        mWrap.isSelectedProduct = true;
        mWrap.igstvalue = false;
        mWrap.closed = true;
        mWrap.statecode = true;
        mWrap.isService = false;
        mWrap.quoteId = addQuoteId;
        mWrap.lstTaxType = tTypeLst;
        mWrap.lstTaxDetails = tDetailLst;
        mWrap.lineitemid = lineItemIdSet;
        System.debug('QuoteIdInSet----- '+mWrap.quoteId);         
      
        String jsonMainWrap = Json.serialize(mWrap);
        String JsonProductWrap = Json.serialize(proWrap);
        String JsonTaxDetailsWrap = Json.serialize(tDetailLst);
        System.debug('TaxDetailSerialize---- '+JsonTaxDetailsWrap);
        
        //Calling all Methods
        AddproductController.productOnLoad(q.Id);
        AddproductController.productOnLoad(o.Id);
        String sObjName = p.Id.getSObjectType().getDescribe().getName();
        System.debug('ObjectName--- '+sObjName);
        
        
        AddproductController.getSearchProduct(sObjName, p.Name, jsonMainWrap, q.Id);
        AddproductController.getSearchProduct(sObjName, p.Name, jsonMainWrap, o.Id);
        AddproductController.onselectPick(jsonMainWrap);
        AddproductController.onselectPick(JsonProductWrap);
        AddproductController.removeRecord(jsonMainWrap, JsonProductWrap);
        AddproductController.addRecord(jsonMainWrap);
        AddproductController.addRecord(JsonProductWrap);
        AddproductController.saveRecord(jsonMainWrap, q.Id, JsonTaxDetailsWrap, 400.20);
        AddproductController.saveRecord(jsonMainWrap, o.Id, JsonTaxDetailsWrap, 400.20);
        AddproductController.deleteRecord(jsonMainWrap);
        AddproductController.deltecharges(jsonMainWrap);
    } 
}