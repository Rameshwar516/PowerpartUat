public class addPackingListControl {
    public static WrappMain recordlist {get;set;}
    
    @AuraEnabled 
    public static string productOnLoad(string RecordId)
    {
        
        WrappMain objWR = new WrappMain();  
        list<innerWrp> listIW = new list<innerWrp>();
        list<Packing_List_Line_Item__c> prelist = [SELECT BOX_No__c,Box_Type__c,DC_Date__c,Gross_Weight_Kgs__c,Height_Inches_CMS__c,Packing_List__r.Delivery_Note__c,
                                           Id,Length_Inches_CMS__c,Name,Packing_List__c,Part_Name__c,Part_No__c,
                                           Quantity__c,Width_Inches_CMS__c, Remark__c FROM Packing_List_Line_Item__c WHERE Packing_List__r.Delivery_Note__c =:recordid];
        set<id> prePartId = new set<id>();
        if(!prelist.isempty()) for(Packing_List_Line_Item__c pl:prelist) prePartId.add(pl.Part_No__c);
        for(Delivery_Note_Line_Item__c objDNLI : [Select id,Part_Serial__c, Product_Part__c,Product_Part__r.Name,Product_Part__r.Part_Name__c, Quantity__c,Sales_Order_Dispatch_Delivery_Note__c from Delivery_Note_Line_Item__c where Product_Part__c NOT IN: prePartId AND  Sales_Order_Dispatch_Delivery_Note__c =: RecordId])
        {
            innerWrp objIW = new innerWrp();
            objIW.objDNLI = objDNLI;
            objIW.custmnum= objDNLI.Part_Serial__c;
            
            objIW.isSelected= false;
            listIW.add(objIW);
        }
        objWR.inrWrap = listIW;
        objWR.AllDone =  false;
        if(listIW.isempty()) 
        objWR.AllDone =  true;
        system.debug('....objWR...'+objWR);
        return json.serialize(objWR);
    }
    
    
    @AuraEnabled
    public static string addRecord(string strWrap, string recordId)
    {
        list<Sales_Order_Dispatch_Delivery_Note__c> lstDN = new list<Sales_Order_Dispatch_Delivery_Note__c>();
        Packing_List__c objPackingList = new Packing_List__c();
        objPackingList.Delivery_Note__c = recordId;
        objPackingList.Date__c =system.today();
        insert objPackingList;
        
        System.debug('add Record method called');
        list<Packing_List_Line_Item__c> lstDNLT = new list<Packing_List_Line_Item__c>();
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        try
        {
            List<innerWrp> lstWrappNew = objwrap.inrWrap;
            System.debug('lstWrappNewSz---- '+lstWrappNew);
            System.debug('lstWrappNewSz---- '+lstWrappNew.size());
            for( integer i = 0 ; i<lstWrappNew.size();  i++)
            {
                if(lstWrappNew[i].isSelected)
                {
                    Packing_List_Line_Item__c objPLItems = new Packing_List_Line_Item__c();
                    objPLItems.Part_No__c = lstWrappNew[i].objDNLI.Product_Part__c;
                    objPLItems.Quantity__c = lstWrappNew[i].objDNLI.Quantity__c;
                    objPLItems.Box_Type__c = lstWrappNew[i].strBoxType;
                    objPLItems.BOX_No__c = lstWrappNew[i].BOXNo;
                    objPLItems.Length_Inches_CMS__c = string.valueof(lstWrappNew[i].decLength);
                    objPLItems.Width_Inches_CMS__c = string.valueof(lstWrappNew[i].decWidth);
                    objPLItems.Height_Inches_CMS__c = string.valueof(lstWrappNew[i].decHeight);
                    objPLItems.Gross_Weight_Kgs__c = string.valueof(lstWrappNew[i].decWeight);
                    objPLItems.Remark__c = lstWrappNew[i].strRemark;
                    objPLItems.Customer_Part_No__c = lstWrappNew[i].custmnum;
                    
                    objPLItems.Packing_List__c = objPackingList.Id;
                    lstDNLT.add(objPLItems);
                }
            }
            if(lstDNLT.size()>0)
                insert lstDNLT;
            objwrap.success = true;
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage = e.getMessage();
        }
        
        String str = productOnLoad(recordId);
        WrappMain objwrap2 = (WrappMain)Json.deserialize(str, WrappMain.class);
        if(objwrap2.AllDone)
        {
            Sales_Order_Dispatch_Delivery_Note__c DNrecord = new Sales_Order_Dispatch_Delivery_Note__c();
            DNrecord.id = recordId;
            DNrecord.isTaxinvoice__c = true;
            update DNrecord;
        }
        system.debug('..........'+json.serialize(objwrap));
        return json.serialize(objwrap); 
    }   
    
    public class WrappMain
    {   
        @AuraEnabled public list<innerWrp> inrWrap;
        @AuraEnabled public Boolean isSelectedProduct;
        @AuraEnabled public boolean success;       
        @AuraEnabled public string strMessage;
        @AuraEnabled public boolean AllDone;  
    }
    
    public class innerWrp
    {
        @AuraEnabled public Delivery_Note_Line_Item__c objDNLI; 
        @AuraEnabled public boolean isSelected;
        @AuraEnabled public string custmnum;
        @AuraEnabled public string strBoxType;
        @AuraEnabled public string BOXNo;
        @AuraEnabled public decimal decLength; 
        @AuraEnabled public decimal decWidth;
        @AuraEnabled public decimal decHeight;
        @AuraEnabled public decimal decWeight;
        @AuraEnabled public string rowError;
        @AuraEnabled public string strRemark;
    }
}