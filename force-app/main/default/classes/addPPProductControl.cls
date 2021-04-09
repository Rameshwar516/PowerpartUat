public class addPPProductControl {
    public static WrappMain recordlist {get;set;}
    
    @AuraEnabled 
    public static string productOnLoad(string RecordId)
    {
        System.debug('QuoteRecordId---- '+RecordId);
        string objname =findObjectNameFromRecordIdPrefix(RecordId);
        System.debug('object is '+ objname);
        Boolean IGST=false;
        set<string> stateset = new set<string>();
        list<Ware_House__c> whlist=[SELECT State_Code__c,State_Province__c FROM Ware_House__c];
        for(Ware_House__c wh:whlist) stateset.add(wh.State_Province__c);
        String state='';
        if(objname  =='Quote__c')
            state=[SELECT Id,Customer_Party__r.ShippingState From Quote__c WHERE id=:RecordId].Customer_Party__r.ShippingState;
        if(objname  =='Opportunity__c')
            state=[SELECT Id,OEM_Customer__r.ShippingState From Opportunity__c WHERE id=:RecordId].OEM_Customer__r.ShippingState;
        
        if(stateset.contains(state)) IGST =true;
        
        recordlist = new WrappMain();
        recordlist.lstWrapp = new list<prodwrapp>(); 
        List<prodwrappChild> lstWrappTwoNew = new List<prodwrappChild>();
        recordlist.lstWrappTwo = lstWrappTwoNew;
        recordlist.lineitemid = new set<id>();
        recordlist.quoteId = new set<Id>();
        recordlist.isSelectedProduct = false;
        recordlist.quoteId.add(RecordId);
        recordlist.objectname = objname;
        recordlist.success = true;
        recordlist.igstvalue =IGST;
        System.debug('------- '+IGST);
        system.debug('....recordlist...'+recordlist);
        return json.serialize(recordlist);
    }
    
    @AuraEnabled
    public static string onselectPick(string strWrap)
    {
        System.debug('Select pick method called');
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        try
        { 
            for(Part__c objP : [select id, name, List_Price_Standard_price__c, Product_Family__c  from Part__c limit 10]) 
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
                    objOppPro.ProductName__c = lstWrappNew[i].objProd.name; 
                    objOppPro.List_Price__c = lstWrappNew[i].objProd.List_Price_Standard_price__c;
                    objOppPro.Sales_Price__c = lstWrappNew[i].objProd.List_Price_Standard_price__c;
                    objOppPro.Quantity__c = 1;
                    objOppPro.HSN_Code__c = lstWrappNew[i].objProd.HSN_CODE__c;
                    objOppPro.Product_Part__c = lstWrappNew[i].objProd.id;
                    if(objwrap.igstvalue){
                        objOppPro.IGST__c=lstWrappNew[i].objProd.GST__c;
                        objOppPro.CGST__c=0;
                        objOppPro.SGST__c=0;
                    }
                    else{
                        objOppPro.IGST__c=0;
                        objOppPro.CGST__c=lstWrappNew[i].objProd.GST__c;
                        objOppPro.SGST__c=lstWrappNew[i].objProd.GST__c;
                    }
                    objchild.objProdchild = objOppPro;
                    if(objwrap.lineitemid == null)
                    {
                        lstWrappTwoNew.add(objchild);
                        lineitemids.add(objOppPro.Product_Part__c);  
                        objwrap.lineitemid = lineitemids;
                    }
                    else
                    {
                        if(objwrap.lineitemid.contains(objOppPro.Product_Part__c) == False)
                        {
                            lstWrappTwoNew.add(objchild); 
                            lineitemids.add(objOppPro.Product_Part__c);  
                            objwrap.lineitemid.addall(lineitemids);
                        }                   
                    }  
                }
            }
            objwrap.success = true;
            if(objwrap.lstWrappTwo == null)
            {
                objwrap.lstWrappTwo = lstWrappTwoNew;
            }
            else
            {
                objwrap.lstWrappTwo.addall(lstWrappTwoNew);
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
    public static string saveRecord(string strWrap, string RecordId)
    {
        string objname =findObjectNameFromRecordIdPrefix(RecordId);
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
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
                    insertOppProduct.add(objOppProduct);
                }
            }
            if(!insertOppProduct.isEmpty())
            {
                objwrap.success = true;
                database.insert(insertOppProduct,false);
                objwrap.strMessage = system.label.Add_Product_Success_Msg;
            }
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage = e.getMessage();
        }
        return json.serialize(objwrap);
    }    
    
    public class WrappMain
    {    
        @AuraEnabled public list<prodwrapp> lstWrapp {get;set;}
        @AuraEnabled public list<prodwrappChild> lstWrappTwo {get;set;}
        @AuraEnabled public set<Id> lineitemid {get;set;}
        @AuraEnabled public set<Id> quoteId {get;set;}
        @AuraEnabled public boolean igstvalue {get;set;} 
        @AuraEnabled public string objectname {get;set;}
        @AuraEnabled public Boolean isSelectedProduct {get; set;}
        @AuraEnabled public boolean success;       
        @AuraEnabled public string strMessage;
    }
    public class prodwrapp
    {    
        @AuraEnabled public Part__c objProd{get;set;}
        @AuraEnabled public Boolean isSelected {get; set;}
    }
    public class prodwrappChild
    {
        @AuraEnabled public Line_Item__c objProdchild{get;set;}
        @AuraEnabled public integer  total{get;set;}
        @AuraEnabled public Boolean isSelected {get; set;}
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
                
                //if (!sObj.contains('__')) to exclude managed package objects
                
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
}