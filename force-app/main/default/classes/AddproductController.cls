public class AddproductController {
    
    public static WrappMain recordlist {get;set;}
    @AuraEnabled 
    public static string productOnLoad(string RecordId)
    {
        string warehouse = '';
        string warehousename = '';
        recordlist = new WrappMain();
        Boolean booleantrue = true;
        string objname =findObjectNameFromRecordIdPrefix(RecordId);
        Boolean IGST=false;
        Boolean service=false;
        list<charges__c> chargeslist = new list<charges__c>();
        list<Line_Item__c> lineitemonrecord  = new  list<Line_Item__c>();
        set<string> stateset = new set<string>();
        list<Ware_House__c> whlist=[SELECT State_Code__c,State_Province__c FROM Ware_House__c];
        for(Ware_House__c wh:whlist) stateset.add(wh.State_Code__c);
        list<TaxDetails> TaxDetailslist = new list<TaxDetails>();
        Quote__c Quoteobj = new Quote__c();
        Opportunity__c oppobj = new Opportunity__c();
        String state='';
        //Getting line item from current record
        //Getting State from account  to know IGST will apply or not
        if(objname  =='Quote__c'){
            Quoteobj=[SELECT Id,Opportunity__r.stage__c,Customer_Party__r.Billing_State_Code__c,Opportunity__r.Ware_House__r.State_Code__c,Opportunity__r.Office__c,Opportunity__r.Ware_House__c,Opportunity__r.isService__c From Quote__c WHERE id=:RecordId];
            state=Quoteobj.Customer_Party__r.Billing_State_Code__c;
            warehouse =Quoteobj.Opportunity__r.Ware_House__c;
            warehousename=Quoteobj.Opportunity__r.Ware_House__r.State_Code__c;
            if(Quoteobj.Opportunity__r.stage__c == 'Closed Won'||Quoteobj.Opportunity__r.stage__c == 'Closed Lost'){
                recordlist.closed =booleantrue;
            } 
            service = Quoteobj?.Opportunity__r.isService__c; 
            lineitemonrecord = [SELECT Amount_Formula__c,Application__c,CGST_Amount_Formula__c,CGST__c,CreatedById,
                                CreatedDate,Delivery_Date__c,Description__c,DiscountN__c,Discount_Amount__c,Discount__c,
                                Expected_date__c,HSN_Code__c,Id,IGST_Amount_Formula__c,IGST__c,IsDeleted,LastActivityDate,
                                LastModifiedById,LastModifiedDate,List_Price__c,Name,Net_Amount__c,Opportunity__c,OwnerId,
                                Part_Name__c,ProductName__c,Product_Part__c,Quantity__c,Quote__c,Remark__c,Saleable_Stock__c,
                                Sales_Order__c,Sales_Price__c,SGST_Amount_Formula__c,SGST__c,Specification__c,SystemModstamp,
                                Taxable_Amount_Formula__c,Total_Amount_Formula__c,Unit_Price__c,Unit__c, Product_Part__r.Part_Name__c,
                                Product_Part__r.name FROM Line_Item__c where Quote__c =:RecordId];
            chargeslist =[SELECT CGST__c,Charges__c,Charge_Percentage__c,Charge_Amount__c,CreatedById,CreatedDate,Id,IGST__c,IsDeleted,LastModifiedById,
                          LastModifiedDate,MRN__c,Name,Net_Amount__c,Opportunity__c,OwnerId,Quote__c,SGST__c,SystemModstamp,Total_Amount__c,
                          Charges__r.name FROM Charges__c Where Quote__c =:RecordId ];
        }
        if(objname  =='Opportunity__c'){
            oppobj=[SELECT Id,OEM_Customer__r.Billing_State_Code__c,Ware_House__c,stage__c, Ware_House__r.State_Code__c, Office__c,isService__c From Opportunity__c WHERE id=:RecordId];
            state=oppobj.OEM_Customer__r.Billing_State_Code__c;
            System.debug('BillingStateCodeOnOpportunity----- '+state);
            warehouse =oppobj.Ware_House__c;
            service = oppobj?.isService__c; 
            System.debug('warehouse----- '+warehouse);
            warehousename=oppobj.Ware_House__r.State_Code__c;
            if(oppobj.stage__c == 'Closed Won'||oppobj.stage__c == 'Closed Lost'){
                recordlist.closed =booleantrue;
            } 
            lineitemonrecord = [SELECT Amount_Formula__c,Application__c,CGST_Amount_Formula__c,CGST__c,CreatedById,
                                CreatedDate,Delivery_Date__c,Description__c,DiscountN__c,Discount_Amount__c,Discount__c,
                                Expected_date__c,HSN_Code__c,Id,IGST_Amount_Formula__c,IGST__c,IsDeleted,LastActivityDate,
                                LastModifiedById,LastModifiedDate,List_Price__c,Name,Net_Amount__c,Opportunity__c,OwnerId,
                                Part_Name__c,ProductName__c,Product_Part__c,Quantity__c,Quote__c,Remark__c,Saleable_Stock__c,
                                Sales_Order__c,Sales_Price__c,SGST_Amount_Formula__c,SGST__c,Specification__c,SystemModstamp,
                                Taxable_Amount_Formula__c,Total_Amount_Formula__c,Unit__c,Product_Part__r.Part_Name__c,
                                Product_Part__r.name FROM Line_Item__c where Opportunity__c =:RecordId];
            chargeslist =[SELECT CGST__c,Charges__c,Charge_Percentage__c,Charge_Amount__c,CreatedById,CreatedDate,Id,IGST__c,IsDeleted,LastModifiedById,
                          LastModifiedDate,MRN__c,Name,Net_Amount__c,Opportunity__c,OwnerId,Quote__c,SGST__c,SystemModstamp,Total_Amount__c,
                          Charges__r.name FROM Charges__c Where Opportunity__c =:RecordId ];
            
        }
        list<tax__c> taxlist =[SELECT Basic_Percentage__c,CreatedById,CreatedDate,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,
                               LastReferencedDate,LastViewedDate,Name,OwnerId,SystemModstamp,Tax_Percentage__c FROM Tax__c];
        map<id,tax__c> taxmap = new map<id,tax__c>();
        if(!taxlist.isEmpty())taxmap.putall(taxlist);
        
        if(!String.isblank(state) && !String.isblank(warehouse) ){
            recordlist.statecode = true;
            
            if(!chargeslist.isEmpty()){
                for(Charges__c ch:chargeslist){
                    TaxDetails objTD = new TaxDetails();
                    objTD.objTax = taxmap.get(ch.Charges__c);
                    objTD.strTaxId = ch.Charges__c;
                    objTD.strTaxName = ch.Charges__r.Name;
                    String decstr = string.valueof(ch.Charge_Percentage__c);
                    String nstr='';
                    if(decstr.contains('.')){
                       integer pos = decstr.indexOf('.');
                       nstr=decstr.substring(0, pos+2);
                    }
                     //objTD.TaxPercentage = Decimal.valueof(nstr);
                    objTD.TaxPercentage = ch.Charge_Percentage__c.setscale(2);
                    
                    objTD.CGST = ch.CGST__c ;
                    objTD.SGST = ch.SGST__c;
                    objTD.IGST = ch.IGST__c;
                    objTD.objcharge = ch;
                    objTD.decTaxAmount =  ch.Charge_Amount__c;
                    system.debug('-- '+ch.Total_Amount__c);
                    objTD.NetAmount =  ch.Net_Amount__c;
                    system.debug('-- '+ch.Net_Amount__c);
                        objTD.ischargeItem = booleantrue;
                    TaxDetailslist.add(objTD);
                } 
            }
            // making same wraper list we using in add part component with line item recod which is on quote/opportunity
            // 
            set<string> partidset = new set<string>();
            if(!lineitemonrecord.isempty()){
                for(Line_Item__c objOppPro:lineitemonrecord){
                    partidset.add(objOppPro.Product_Part__c);
                }
            }
            list<Stock__c> stlist = [SELECT Id, Total_Quantity__c, Ware_House__r.City__c, Ware_House__r.State_Code__c,Product_Part__c,Total_Unbooked_Quantity__c from Stock__c WHERE Product_Part__c IN:partidset and Ware_House__c =:warehouse];
            map<string,decimal> stcountmap = new map<string,decimal>();
            for(Stock__c st:stlist){
                stcountmap.put(st.Product_Part__c,st.Total_Unbooked_Quantity__c);
            }
            // 
            list<prodwrappChild> lineitemlist = new list<prodwrappChild>();
            if(!lineitemonrecord.isempty()){
                for(Line_Item__c objOppPro:lineitemonrecord){
                    prodwrappChild objchild = new prodwrappChild();
                    objchild.DiscountAmount=objOppPro.Discount_Amount__c; 
                    objchild.totalAmount =objOppPro.Total_Amount_Formula__c ;
                    objchild.TotalAfterDiscount =objOppPro.Taxable_Amount_Formula__c ;
                    objOppPro.SGST__c=objOppPro.SGST__c ;
                    objOppPro.CGST__c=objOppPro.CGST__c ;  
                    objOppPro.IGST__c=objOppPro.IGST__c ;
                    objchild.CGSTAmount=objOppPro.CGST_Amount_Formula__c ;
                    objchild.SGSTAmount=objOppPro.SGST_Amount_Formula__c ;
                    objchild.IGSTAmount=objOppPro.IGST_Amount_Formula__c ; 
                    objchild.NetTotalAmount = objOppPro.Net_Amount__c ;
                    objchild.objProdchild = objOppPro;
                    objchild.PartName = objOppPro.Product_Part__r.Part_Name__c ;
                    objchild.Partnumber= objOppPro.Product_Part__r.name ;
                    objchild.isSelected = booleantrue;
                    objchild.isLineItem = booleantrue;
                    objchild.stockamount = stcountmap.get(objOppPro.Product_Part__c);
                    lineitemlist.add(objchild);
                }
            }
           
            
            if(warehousename !=state) IGST=true;
            
            recordlist.lstWrapp = new list<prodwrapp>(); 
            List<prodwrappChild> lstWrappTwoNew = new List<prodwrappChild>();
            recordlist.Lineitemonrecord = lineitemlist; 
            recordlist.lstTaxDetailsAvailable = TaxDetailslist;
            recordlist.lstWrappTwo = lineitemlist;
            recordlist.lineitemid = new set<id>();
            recordlist.quoteId = new set<Id>();
            recordlist.isSelectedProduct = false;
            recordlist.quoteId.add(RecordId);
            recordlist.igstvalue=IGST;
            recordlist.success = true;
            recordlist.lstTaxType = new list<TaxType>();
            recordlist.lstTaxDetails = new List<TaxDetails>();
            recordlist.lstCharges = new List<TaxDetails>();
            recordlist.wrname = warehousename;
            recordlist.isService = service;
            for(Tax__c objTax : [Select Id,Name,Tax_Percentage__c,Basic_Percentage__c,CGST__c,SGST__c,IGST__c from Tax__c]){
                TaxType objTaxT = new TaxType();
                objTaxT.value = objTax.Name;
                objTaxT.id = objTax.id;
                recordlist.lstTaxType.add(objTaxT);
                TaxDetails objTD = new TaxDetails();
                objTD.objTax = objTax;
                objTD.strTaxId = objTax.Id;
                objTD.strTaxName = objTax.Name;
                objTD.TaxPercentage = objTax.Tax_Percentage__c;
                objTD.decTaxAmount = 0.00;
                if(recordlist.igstvalue){
                    objTD.CGST = 0;
                    objTD.SGST = 0;
                    objTD.IGST = objTax.IGST__c;
                }
                else{
                    objTD.CGST = objTax.CGST__c;
                    objTD.SGST = objTax.SGST__c;
                    objTD.IGST = 0;  
                }
                
                objTD.NetAmount =0.00;
                recordlist.lstTaxDetails.add(objTD);
            }
        }
        else{
            recordlist.statecode = false;
        }
        system.debug('....recordlist...'+recordlist);
        return json.serialize(recordlist);
    } 
    
    @AuraEnabled
    public static String getSearchProduct(string objectName, string queryText,String objwrap,String recordId)
    {
        Set<id> wrapproductId = New Set<Id>();
        
        System.debug('recordId');
        WrappMain oldwrap = new WrappMain();
        
        
        oldwrap = (WrappMain)Json.deserialize(objwrap, WrappMain.class);
        System.debug('oldwrap.lstWrapp '+oldwrap.lstWrappTwo);
        if(oldwrap.lstWrappTwo != null){
            for(prodwrappChild prdwrp : oldwrap.lstWrappTwo){
                System.debug('prdwrp.isSelected'+prdwrp.isSelected);
                if(prdwrp.isSelected = true){
                    wrapproductId.add(prdwrp.objProdchild.Product_Part__c);
                }
            }
        }
        string objname =findObjectNameFromRecordIdPrefix(recordId);
        system.debug('recordId '+recordId);
        system.debug('obj '+objname);
        list<prodwrappChild> prodwrap = new list<prodwrappChild>();
        String lineitemquery = 'SELECT Application__c,CGST_Amount_Formula__c,CGST__c,Delivery_Date__c,HSN_Code__c,Id,';
        lineitemquery = lineitemquery + 'IGST_Amount_Formula__c,IGST__c,List_Price__c,Name,Net_Amount__c,';
        lineitemquery = lineitemquery + ' Opportunity__c,Product_Part__c,Quantity__c,Quote__c,';
        lineitemquery = lineitemquery + 'Remark__c,Saleable_Stock__c,Sales_Price__c,SGST_Amount_Formula__c,';
        lineitemquery = lineitemquery + 'SGST__c,Specification__c,Taxable_Amount_Formula__c,Total_Amount_Formula__c,';
        if(objname == 'Quote__c'){
            lineitemquery = lineitemquery + 'Unit__c FROM Line_Item__c Where  Quote__c =:  recordId';
            
        }
        else if(objname == 'Opportunity__c'){
            lineitemquery = lineitemquery + 'Unit__c FROM Line_Item__c Where  Opportunity__c =: recordId' ;
        }
        
        List<Line_Item__c> prelineitemrecord = database.query(lineitemquery);
        Set<id> lineitemset = New Set<Id>();
        if(!prelineitemrecord.isEmpty()){
            System.debug('Lineitem available');
            
            for(Line_Item__c lnt : prelineitemrecord )
            {
                lineitemset.add(lnt.Product_Part__c);
                wrapproductId.add(lnt.Product_Part__c); 
            }
            
            
        } 
        
        recordlist = new WrappMain();
        recordlist.lstWrapp = new list<prodwrapp>();
        list<prodwrapp> listproduct= new list<prodwrapp>();
        try
        {
            string filter = '';
            set<Id> setProductId = new set<Id>(); 
            if(queryText != null && queryText.trim() !='')
                filter = ' \''+ string.escapeSingleQuotes(queryText) + '%\'';
            map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
            Schema.sObjectType sObjType = globalDescription.get(objectName);
            Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
            List<string> leadfieldNames = new List<String>(describeResult.fields.getMap().keySet()); 
            
            for(Part__c prdObj :  [select id, name, List_Price_Standard_price__c, Product_Family__c from Part__c limit 10])
            {
                setProductId.add(prdObj.id);
            }
            System.debug('setProductId---- '+setProductId);
            /* Adding the object and filter by name to the soql */
            string soql = 'select ' + string.join(leadfieldNames, ', ') +',(SELECT Id,Product_Part__c, Total_Quantity__c, Ware_House__r.City__c,Total_Unbooked_Quantity__c from Stocks__r) from ' + objectName ; 
            system.debug('......'+soql);
            if(filter.trim() != ''){
                
                if(wrapproductId.size() > 0 ){
                    soql += ' where id NOT IN : wrapproductId and ( name Like ' + filter + ' or Part_Name__c LIKE ' + filter + ') AND Stock_Available__c != 0';
                }
                else{
                    soql += ' where ( name Like ' + filter + ' or Part_Name__c LIKE ' + filter + ') AND Stock_Available__c != 0';
                }
            }   
            system.debug('====='+soql);
            soql += 'order by Name limit 10';
            for(Part__c pr :Database.query(soql)){
                prodwrapp prdwrap = new prodwrapp(); 
                prdwrap.objProd = pr;
                if(!pr.stocks__r.isempty()){
                    for(Stock__c st:pr.stocks__r){
                        if(st.Ware_House__r.City__c == 'Gurugram'){
                         prdwrap.Grwr = Integer.valueOf(st.Total_Unbooked_Quantity__c);   
                        }
                        if(st.Ware_House__r.City__c == 'Kolkata'){
                         prdwrap.Klwr = Integer.valueOf(st.Total_Unbooked_Quantity__c);   
                        }
                        
                    }
                }
                
                prdwrap.isSelected = false; 
                listproduct.add(prdwrap);
            }
            if(lineitemset.size() > 0){
                wrapproductId.removeall(lineitemset);
            } 
            
            if(wrapproductId.size() > 0 ){
                string soql2 = 'select ' + string.join(leadfieldNames, ',') +',(SELECT Id,Product_Part__c, Total_Quantity__c, Ware_House__r.City__c,Total_Unbooked_Quantity__c from Stocks__r) from ' + objectName ; 
                if(filter.trim() != ''){    
                    soql2 += ' where id IN : wrapproductId and ( name Like ' + filter + ' or Part_Name__c LIKE ' + filter + ') AND Stock_Available__c != 0';
                } 
                soql2 += 'order by Name limit 10';
                for(Part__c pr :Database.query(soql2)){
                    prodwrapp prdwrap = new prodwrapp(); 
                    prdwrap.objProd = pr;
                    if(!pr.stocks__r.isempty()){
                    for(Stock__c st:pr.stocks__r){
                        if(st.Ware_House__r.City__c == 'Gurugram'){
                         prdwrap.Grwr = Integer.valueOf(st.Total_Unbooked_Quantity__c);   
                        }
                        if(st.Ware_House__r.City__c == 'Kolkata'){
                         prdwrap.Klwr = Integer.valueOf(st.Total_Unbooked_Quantity__c);   
                        }
                        
                    }
                }
                    prdwrap.isSelected = true; 
                    listproduct.add(prdwrap);
                }}
            set<string> partid = new set<string>();
            for(prodwrapp pd:listproduct){
                partid.add(pd.objProd.id);
            }
            
            list<Part__History> parthistory = [SELECT Field,NewValue,OldValue,ParentId FROM Part__History WHERE ParentId IN: partid Order by createddate ASC];
            
            map<string,string> partoldfieldvalue = new map<string,string>();
            if(!parthistory.isempty())
                for(Part__History ph :parthistory){
                    if(ph.Field =='name'){
                        if(partoldfieldvalue ==null || !partoldfieldvalue.containskey(ph.ParentId) ){
                            String odval = String.valueOf(ph.OldValue);
                            partoldfieldvalue.put(ph.ParentId,odval);
                        }
                        else{
                            String odval = partoldfieldvalue.get(ph.ParentId)+', '+String.valueOf(ph.OldValue);
                            partoldfieldvalue.put(ph.ParentId,odval);
                        }
                    }
                }
            list<prodwrapp> listproductwitholdpart= new list<prodwrapp>();
            for(prodwrapp pd:listproduct){
                pd.oldPartName = partoldfieldvalue.get(pd.objProd.id);
                listproductwitholdpart.add(pd);
            }
            
            recordlist.lstWrapp=listproductwitholdpart;
            recordlist.isSelectedProduct = false;
            recordlist.success = true;
            System.debug('End Search '+json.serialize(recordlist));
            return json.serialize(recordlist);
        }
        catch(Exception ex)
        {
            system.debug('Exception---- '+ex.getMessage());
            return null;
        }
    }
    
    
    @AuraEnabled
    public static string onselectPick(string strWrap)
    {
        System.debug('Select pick method called');
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        try
        { 
            for(Part__c objP : [select id, name, List_Price_Standard_price__c, Product_Family__c,GST__c,Service_Price__c,(SELECT Id,Total_Quantity__c,Ware_House__r.city__c FROM Stocks__r ) from Part__c limit 10]) 
            {
                prodwrapp objwrapp = new prodwrapp(); 
                objwrapp.objProd = objP;
                objwrapp.isSelected = false;
                objwrap.lstWrapp.add(objwrapp);
            }   
            objwrap.isSelectedProduct = true;
            objwrap.success = true;
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage=e.getMessage();
        }
        system.debug('..........'+json.serialize(objwrap));
        return json.serialize(objwrap);  
    }   
    
    @AuraEnabled
    public static string removeRecord(string strWrap, string prodwrappstr)
    {
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class); 
        if(prodwrappstr != null && prodwrappstr != ''){
			prodwrappChild prodwrappobj = (prodwrappChild)Json.deserialize(prodwrappstr, prodwrappChild.class);
			List<prodwrappChild> lstWrapplineItem = objwrap.lstWrappTwo;
			List<prodwrapp> lstWrappProduct = objwrap.lstWrapp;
			List<prodwrapp> updatedlstWrappProduct = new List<prodwrapp>();
			Set<id> lineitemids = objwrap.lineitemid;
			integer i=0;
			integer x=0;
			for(prodwrappChild prodchild : lstWrapplineItem){
				if(prodchild.objProdchild.Product_Part__c == prodwrappobj.objProdchild.Product_Part__c){
					i=lstWrapplineItem.indexOf(prodchild);
					System.debug('integer i '+i);
				}           
			}
			for(id prodchild : lineitemids){
				if(prodchild == prodwrappobj.objProdchild.Product_Part__c){
					lineitemids.remove(prodchild);
				}           
			}
			for(prodwrapp prodchild : lstWrappProduct){
				
				if(prodchild.objProd.id == prodwrappobj.objProdchild.Product_Part__c){
					x=lstWrappProduct.indexOf(prodchild);
					prodchild.isSelected = false;
					System.debug('integer x '+x);
				}   
				updatedlstWrappProduct.add(prodchild);
			}
			System.debug('size '+lstWrapplineItem.size());
			lstWrapplineItem.remove(i);
			objwrap.lstWrapp = updatedlstWrappProduct;
			objwrap.lstWrappTwo =  lstWrapplineItem;	
        }
        return json.serialize(objwrap);
    }
    
    @AuraEnabled
    public static string addRecord(string strWrap)
    {
        System.debug('add Record method called');
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        try
        {
            List<prodwrapp> lstWrappNew = objwrap.lstWrapp;
            List<prodwrappChild> lstWrappTwoNew = new List<prodwrappChild>();
            Set<id> lineitemids = new set<id>();
            System.debug('lstWrappNewSz---- '+lstWrappNew.size());
            for( integer i = 0 ; i<lstWrappNew.size();  i++)
            {
                if(lstWrappNew[i].isSelected)
                {
                    prodwrappChild objchild = new prodwrappChild();
                    objchild.isSelected = true;
                    Line_Item__c objOppPro = new Line_Item__c();
                    if(objwrap?.isService){
                        objOppPro.List_Price__c = lstWrappNew[i].objProd.Service_Price__c;
                    objOppPro.Sales_Price__c = lstWrappNew[i].objProd.Service_Price__c;
                    }
                    else{
                      objOppPro.List_Price__c = lstWrappNew[i].objProd.List_Price_Standard_price__c;
                    objOppPro.Sales_Price__c = lstWrappNew[i].objProd.List_Price_Standard_price__c;  
                    }
                    
                    objOppPro.Quantity__c = 1;
                    objOppPro.HSN_Code__c = lstWrappNew[i].objProd.HSN_CODE__c;
                    objOppPro.Product_Part__c = lstWrappNew[i].objProd.id; 
                    objOppPro.Discount__c=0;
                    objchild.DiscountAmount=0; 
                    objchild.totalAmount = Integer.valueOf(objOppPro.Quantity__c*objOppPro.Sales_Price__c);
                    System.debug('totalAmount----- '+objchild.totalAmount);
                    objchild.TotalAfterDiscount = Integer.valueOf(objOppPro.Quantity__c*objOppPro.Sales_Price__c);
                    System.debug('TotalAfterDiscount----- '+objchild.TotalAfterDiscount);
                    
                    if(objwrap.igstvalue){
                        objOppPro.SGST__c=0;
                        objOppPro.CGST__c=0;
                        if(lstWrappNew[i].objProd.GST__c != null) objOppPro.IGST__c= lstWrappNew[i].objProd.GST__c;
                        if(lstWrappNew[i].objProd.GST__c == null) objOppPro.IGST__c= 0;
                    }
                    else{
                        if(lstWrappNew[i].objProd.GST__c != null)  objOppPro.SGST__c=(lstWrappNew[i].objProd.GST__c)/2;
                        if(lstWrappNew[i].objProd.GST__c != null)  objOppPro.CGST__c=(lstWrappNew[i].objProd.GST__c)/2;
                        if(lstWrappNew[i].objProd.GST__c == null)  objOppPro.SGST__c=0;
                        if(lstWrappNew[i].objProd.GST__c == null)  objOppPro.CGST__c=0;
                        objOppPro.IGST__c=0;
                    }
                    objchild.CGSTAmount=(Integer.valueOf(objOppPro.Quantity__c*objOppPro.Sales_Price__c)*objOppPro.CGST__c)/100;
                    objchild.SGSTAmount=(Integer.valueOf(objOppPro.Quantity__c*objOppPro.Sales_Price__c)*objOppPro.SGST__c)/100;
                    objchild.IGSTAmount=(Integer.valueOf(objOppPro.Quantity__c*objOppPro.Sales_Price__c)*objOppPro.IGST__c)/100; 
                    objchild.NetTotalAmount = Integer.valueOf(objOppPro.Quantity__c*objOppPro.Sales_Price__c)+objchild.CGSTAmount+objchild.SGSTAmount+objchild.IGSTAmount;
                    objchild.objProdchild = objOppPro;
                    objchild.PartName = lstWrappNew[i].objProd.Part_Name__c;
                    objchild.Partnumber= lstWrappNew[i].objProd.name;
                    if(objwrap.wrname == '06'){
                        objchild.stockamount = lstWrappNew[i].GrWr;
                    }
                    if(objwrap.wrname == '19'){
                        objchild.stockamount = lstWrappNew[i].Klwr;
                    }
                    System.debug('-idset---'+objwrap.lineitemid);
                    if(objwrap.lineitemid == null)
                    {
                        System.debug('If ProductId---- '+objwrap.lineitemid);
                        lstWrappTwoNew.add(objchild);
                        lineitemids.add(objOppPro.Product_Part__c);  
                        objwrap.lineitemid = lineitemids;
                        System.debug('If Complete--- ');
                        System.debug('contain1 list---- '+objwrap.lineitemid);
                    }
                    else
                    {
                        System.debug('else ProductId---- '+objOppPro.Product_Part__c);
                        if(objwrap.lineitemid.contains(objOppPro.Product_Part__c) == False)
                        {
                            lstWrappTwoNew.add(objchild); 
                            lineitemids.add(objOppPro.Product_Part__c);  
                            objwrap.lineitemid.addall(lineitemids);
                            System.debug('contain2 list---- '+objwrap.lineitemid);
                        }                   
                    }
                    System.debug('After---- '+lstWrappTwoNew);   
                }
            }
            objwrap.success = true;
            if(objwrap.lstWrappTwo == null)
            {
                objwrap.lstWrappTwo = lstWrappTwoNew;
                objwrap.isSelectedProduct =true;
                System.debug('Null Add list---- ');
            }
            else
            {
                objwrap.lstWrappTwo.addall(lstWrappTwoNew);
                objwrap.isSelectedProduct =true;
                System.debug('merge list---- ');
            }    
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage = e.getMessage();
        }
        system.debug('..........'+json.serialize(objwrap));
        return json.serialize(objwrap); 
    }   
    
    @AuraEnabled
    public static string saveRecord(string strWrap, string RecordId,string lstCharges, Decimal decTotalAmount)
    {
        System.debug('---------'+lstCharges);
        system.debug('Save method called'+'quoteId----- '+RecordId);
        string objname =findObjectNameFromRecordIdPrefix(RecordId);
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        List<TaxDetails> lstTaxDetails = (List<TaxDetails>)Json.deserialize(lstCharges, List<TaxDetails>.Class);
        try
        {
            List<prodwrappChild> OppLineChild = objwrap.lstWrappTwo;
            List<Line_Item__c> insertOppProduct = new List<Line_Item__c>();
            for(prodwrappChild obj : OppLineChild)
            {
                Line_Item__c objOppProduct = obj.objProdchild;
                if(objOppProduct.Quantity__c > 0 && objOppProduct.Sales_Price__c >0)
                {
                    if(objname  =='Quote__c')
                        objOppProduct.Quote__c = RecordId;
                    if(objname  =='Opportunity__c')
                        objOppProduct.Opportunity__c = RecordId;
                    System.debug('productsId---- '+objOppProduct.Quote__c);
                    insertOppProduct.add(objOppProduct);
                }
            }
            
            System.debug('insertedLineItemsSz--- '+!insertOppProduct.isEmpty());
            if(!insertOppProduct.isEmpty())
            {
                objwrap.success = true;
                database.upsert(insertOppProduct,false);
                objwrap.strMessage = system.label.Add_Product_Success_Msg;
            }
            System.debug('lstTaxDetails---- '+lstTaxDetails.size());
            List<Charges__c> lstCharge = new List<Charges__c>();
            if(!lstTaxDetails.isempty()){
                for(TaxDetails td : lstTaxDetails){
                    Charges__c objCharges = new Charges__c();
                    if(td.ischargeItem) objCharges.id = td.objcharge.id;
                    objCharges.Charges__c = td.strTaxId;
                    objCharges.Charge_Percentage__c = td.TaxPercentage;
                    objCharges.Total_Amount__c = decTotalAmount;
                    objCharges.IGST__c =td.IGST ;
                    objCharges.SGST__c =td.SGST ;
                    objCharges.CGST__c =td.CGST ;
                    if(objname  =='Quote__c') objCharges.Quote__c = RecordId;
                   if(objname  =='Opportunity__c')objCharges.Opportunity__c = RecordId; 
                    lstCharge.add(objCharges);                   
                    system.debug(td.strTaxName+'...strTaxName....'+td.TaxPercentage);
                }
            }
            upsert lstCharge;
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage = e.getMessage();
        }
        
        return json.serialize(objwrap);
    }
    
     @AuraEnabled
    public static string deleteRecord(string strWrap)
    {      
        prodwrappChild objwrap = (prodwrappChild)Json.deserialize(strWrap, prodwrappChild.class);
        try{
           Delete objwrap.objProdchild;
        }
         catch(exception ex){
                system.debug('error---------------------'+ex.getMessage());
            }
        return null;
    }
    
     @AuraEnabled
    public static string deltecharges(string strWrap)
    {      
        TaxDetails objwrap = (TaxDetails)Json.deserialize(strWrap, TaxDetails.class);
        try{
           Delete objwrap.objcharge;
        }
         catch(exception ex){
                
            }
        return null;
    }
    //This Method get object name base of recordid
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
            
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
            
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){   
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();         
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();    
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
    
    public class WrappMain
    {    
        @AuraEnabled public list<prodwrapp> lstWrapp {get;set;}
        @AuraEnabled public list<prodwrappChild> lstWrappTwo {get;set;}
        @AuraEnabled public list<prodwrappChild> Lineitemonrecord {get;set;}
        @AuraEnabled public set<Id> lineitemid {get;set;}
        @AuraEnabled public set<Id> quoteId {get;set;}
        @AuraEnabled public Boolean isSelectedProduct {get; set;}
        @AuraEnabled public boolean igstvalue {get;set;} 
        @AuraEnabled public string objectname {get;set;}
        @AuraEnabled public boolean success;    
        @AuraEnabled public boolean statecode;
        @AuraEnabled public string strMessage;
        @AuraEnabled public list<TaxType> lstTaxType;
        @AuraEnabled public list<TaxDetails> lstTaxDetails;
        @AuraEnabled public list<TaxDetails> lstTaxDetailsAvailable;
        @AuraEnabled public list<TaxDetails> lstCharges;
        @AuraEnabled public boolean closed; 
        @AuraEnabled public string wrname;
        @AuraEnabled public boolean isService; 
    }
    
    public class prodwrapp
    {    
        @AuraEnabled public Part__c objProd{get;set;}
        @AuraEnabled public Integer Klwr {get;set;}
        @AuraEnabled public Integer GrWr {get;set;}
        @AuraEnabled public Boolean isSelected {get; set;}
        @AuraEnabled public string oldPartName {get; set;}
    }
    public class prodwrappChild
    {
        // public Deal_Product__c objProdchild{get;set;}
        @AuraEnabled public Line_Item__c objProdchild{get;set;}
        @AuraEnabled public decimal  totalAmount{get;set;}
        @AuraEnabled public decimal  DiscountAmount{get;set;}
        @AuraEnabled public decimal  TotalAfterDiscount{get;set;}
        @AuraEnabled public decimal  CGSTAmount{get;set;}
        @AuraEnabled public decimal  SGSTAmount{get;set;}
        @AuraEnabled public decimal  IGSTAmount{get;set;}
        @AuraEnabled public decimal  NetTotalAmount{get;set;}
        @AuraEnabled public Boolean isSelected {get; set;}
        @AuraEnabled public Boolean isLineItem {get; set;}
        @AuraEnabled public String Partnumber {get; set;}
        @AuraEnabled public String PartName {get; set;}
        @AuraEnabled public decimal  stockamount{get;set;}
        
    }
    public class TaxType{
        @AuraEnabled public string id;
        @AuraEnabled public string value;
    }
    public class TaxDetails{
        @AuraEnabled public Tax__c objTax;
        @AuraEnabled public Charges__c objcharge;
        @AuraEnabled public string strTaxId;
        @AuraEnabled public string strTaxName;
        @AuraEnabled public decimal TaxPercentage;
        @AuraEnabled public decimal decTaxAmount;
        @AuraEnabled public decimal CGST;
        @AuraEnabled public decimal SGST;
        @AuraEnabled public decimal IGST;
        @AuraEnabled public decimal NetAmount;
        @AuraEnabled public Boolean ischargeItem {get; set;}
        
    }
    
    
    
    
}