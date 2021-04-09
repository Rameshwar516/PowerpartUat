public class UpsertPackingList {
    public static WrappMain recordlist {get;set;}
    
    @AuraEnabled 
    public static string productOnLoad(string RecordId)
    {
        WrappMain objWR = new WrappMain();  
        list<innerWrp> listIW = new list<innerWrp>();
        set<id> prePartId = new set<id>();
        Packing_List__c PLREC = [Select id,Delivery_Note__c FROM Packing_List__c where id =:RecordId ];
        for(Packing_List_Line_Item__c objDNLI : [SELECT BOX_No__c,Box_Type__c,DC_Date__c,Gross_Weight_Kgs__c,Height_Inches_CMS__c,Packing_List__r.Delivery_Note__c,
                                                 Id,Length_Inches_CMS__c,Name,Packing_List__c,Part_Name__c,Part_No__c,Part_No__r.name,Part_No__r.Part_Name__c,
                                                 Quantity__c,Width_Inches_CMS__c,Remark__c FROM Packing_List_Line_Item__c WHERE  Packing_List__c =: RecordId])
        {
            innerWrp objIW = new innerWrp();
            objIW.objDNLI = objDNLI;
            objIW.strBoxType = objDNLI.Box_Type__c; 
            objIW.decLength = Decimal.valueOf(objDNLI.Length_Inches_CMS__c); 
            objIW.decWidth = Decimal.valueOf(objDNLI.Width_Inches_CMS__c);
            objIW.decHeight = Decimal.valueOf(objDNLI.Height_Inches_CMS__c); 
            objIW.decWeight = Decimal.valueOf(objDNLI.Gross_Weight_Kgs__c); 
            objIW.BOXNo = objDNLI.BOX_No__c;
            objIW.recId = objDNLI.id;
            objIW.partname = objDNLI.Part_No__r.Part_Name__c;
            objIW.partnum = objDNLI.Part_No__r.name;
            objIW.partid = objDNLI.Part_No__c;
            objIW.quantity = Integer.valueof(objDNLI.Quantity__c);
            objIW.isSelected= true;
            objIW.strRemark = objDNLI.Remark__c;
            listIW.add(objIW);
        }
        if(!listIW.isempty()) for(innerWrp pl:listIW) prePartId.add(pl.objDNLI.Part_No__c);
        list<Delivery_Note_Line_Item__c> ObjDN =[Select id, Product_Part__c,Product_Part__r.Name,
                                                 Product_Part__r.Part_Name__c, Quantity__c,Sales_Order_Dispatch_Delivery_Note__c
                                                 from Delivery_Note_Line_Item__c where Product_Part__c NOT IN: prePartId 
                                                 AND  Sales_Order_Dispatch_Delivery_Note__c =: PLREC.Delivery_Note__c];
        if(!ObjDN.isempty())
            for(Delivery_Note_Line_Item__c objDNLI : ObjDN){
                innerWrp objIW = new innerWrp();
                //objIW.objDNLI = objDNLI;  
                objIW.partname = objDNLI.Product_Part__r.Part_Name__c;
                objIW.partnum = objDNLI.Product_Part__r.name;
                objIW.partid = objDNLI.Product_Part__c;
                objIW.quantity = Integer.valueof(objDNLI.Quantity__c);
                objIW.isSelected= false;
                listIW.add(objIW);
            }
        
        objWR.inrWrap = listIW;
        system.debug('....objWR...'+objWR);
        return json.serialize(objWR);
    }
    
    
    @AuraEnabled
    public static string addRecord(string strWrap, string recordId)
    {
        //list<Sales_Order_Dispatch_Delivery_Note__c> lstDN = new list<Sales_Order_Dispatch_Delivery_Note__c>();
        //Packing_List__c objPackingList = new Packing_List__c();
        //objPackingList.Delivery_Note__c = recordId;
        //insert objPackingList;
        
        System.debug('add Record method called');
        list<Packing_List_Line_Item__c> lstDNLT = new list<Packing_List_Line_Item__c>();
        WrappMain objwrap = (WrappMain)Json.deserialize(strWrap, WrappMain.class);
        try
        {
            List<innerWrp> lstWrappNew = objwrap.inrWrap;
            System.debug('lstWrappNewSz---- '+lstWrappNew);
            for( integer i = 0 ; i<lstWrappNew.size();  i++)
            {
                if(lstWrappNew[i].isSelected)
                {
                     Packing_List_Line_Item__c objPLItems = new Packing_List_Line_Item__c();
                     objPLItems.Part_No__c = lstWrappNew[i].partid;
                     objPLItems.Quantity__c = lstWrappNew[i].quantity;
                     objPLItems.Box_Type__c = lstWrappNew[i].strBoxType;
                    objPLItems.BOX_No__c = lstWrappNew[i].BOXNo;
                     objPLItems.Length_Inches_CMS__c = string.valueof(lstWrappNew[i].decLength);
                     objPLItems.Width_Inches_CMS__c = string.valueof(lstWrappNew[i].decWidth);
                     objPLItems.Height_Inches_CMS__c = string.valueof(lstWrappNew[i].decHeight);
                     objPLItems.Gross_Weight_Kgs__c = string.valueof(lstWrappNew[i].decWeight);
                     objPLItems.Packing_List__c = recordId;
                     objPLItems.Remark__c = lstWrappNew[i].strRemark;
                     if(!string.isBlank(lstWrappNew[i].recId)) objPLItems.id=lstWrappNew[i].recId;
                     lstDNLT.add(objPLItems);
                }
            }
            if(lstDNLT.size()>0)
                upsert lstDNLT;
            objwrap.success = true;
        }
        catch(exception e)
        {
            objwrap.success = false;
            objwrap.strMessage = e.getMessage();
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
    }
    
    public class innerWrp
    {
        @AuraEnabled public Packing_List_Line_Item__c objDNLI; 
        @AuraEnabled public boolean isSelected; 
        @AuraEnabled public string strBoxType; 
        @AuraEnabled public string BOXNo;
        @AuraEnabled public decimal decLength; 
        @AuraEnabled public decimal decWidth;
        @AuraEnabled public decimal decHeight;
        @AuraEnabled public decimal decWeight;
        @AuraEnabled public integer quantity;
        @AuraEnabled public string rowError;
        @AuraEnabled public string recId;
        @AuraEnabled public string partname;
        @AuraEnabled public string partnum;
        @AuraEnabled public string partid;
        @AuraEnabled public string strRemark;
    }

}