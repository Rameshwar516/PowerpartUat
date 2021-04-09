public class clsPartRequest {
    
    @AuraEnabled
    public static string doInit(string strParentRecId)
    {
        wrapper objWrap = initialValue();
        List<Service_Request__c> lstSR = [select id,Status__c from Service_Request__c where id =: strParentRecId];
        if(lstSR[0].Status__c == 'Closed')
            objWrap.isClosed = true;
            
        objWrap.success = true;
        
        // Insert Picklist Value Into List
        
        Schema.DescribeFieldResult fieldResultPT = Part_Request__c.Part_Type__c.getDescribe();
        List<Schema.PicklistEntry> plePT = fieldResultPT.getPicklistValues();
        for( Schema.PicklistEntry f : plePT)
        {
            option objOption = new option();
            objOption.label = f.getLabel();
            objOption.value = f.getValue();
            objOption.isDisable = false;
            objWrap.partTypePick.add(objOption);
        }
        
        Schema.DescribeFieldResult fieldResultWT = Part_Request__c.Warranty_Type__c.getDescribe();
        List<Schema.PicklistEntry> pleWT = fieldResultWT.getPicklistValues();
        for( Schema.PicklistEntry f : pleWT)
        {
            objWrap.warrantytypePick.add(f.getValue());
        }
        
        // Add Previous created Part Request.
        List<Part_Request__c> lstPartReq = [Select id, Part_Type__c,Warranty_Type__c,Part__c,Quantity__c,Remark__c, Service_Request__c, Old_Part_Number__c from Part_Request__c where Service_Request__c =: strParentRecId];
        if(lstPartReq.size() > 0)
        {
            for(Part_Request__c tempObjPartReq : lstPartReq)
            {
                partReqWrapper objPartReqWrap = new partReqWrapper();
                objPartReqWrap.objPartReq = tempObjPartReq;
                if(tempObjPartReq.Part__c != null)
                    objPartReqWrap.objPart = [select Id, Name,Part_Name__c from Part__c where id =: tempObjPartReq.Part__c];
                else
                    objPartReqWrap.objPart = new Part__c();
                objPartReqWrap.isEdit = false;
                objPartReqWrap.isExist = true;
                objPartReqWrap.strPartTypeErr = '';
                objPartReqWrap.strWarrentyTypeErr = '';
                objPartReqWrap.strPartErr ='';
                //objPartReqWrap.strOldPartNumErr = '';
                objPartReqWrap.strQuantityErr = '';
                objPartReqWrap.boolShowError = false;
                objWrap.lstPartReqWrap.add(objPartReqWrap);
            }           
        }
        else
        {
            //Add a New Part Request row.
            partReqWrapper objPartReqWrap = new partReqWrapper();
            objPartReqWrap.objPartReq = new Part_Request__c();
            objPartReqWrap.objPart = new Part__c();
            objPartReqWrap.isEdit = true;
            objPartReqWrap.isExist = false;
            objPartReqWrap.strPartTypeErr = '';
            objPartReqWrap.strWarrentyTypeErr = '';
            objPartReqWrap.strPartErr ='';
            //objPartReqWrap.strOldPartNumErr = '';
            objPartReqWrap.strQuantityErr = '';
            objPartReqWrap.boolShowError = false;
            objWrap.lstPartReqWrap.add(objPartReqWrap); 
        }
        return Json.serialize(objWrap);
    }
    
    @AuraEnabled
    public static string submit(string strPartReqWrap, string recordId)
    {
        wrapper objWrap = initialValue();
        System.debug(strPartReqWrap+'---');
        List<partReqWrapper> lstTempPartReqwrap = (List<partReqWrapper>)Json.deserialize(strPartReqWrap, List<partReqWrapper>.class);
        system.debug(lstTempPartReqwrap);
        List<Part_Request__c> lstPartReq = new List<Part_Request__c>();
        try
        {
            if(lstTempPartReqwrap.size() > 0)
            {
                for(partReqWrapper tempPartReq : lstTempPartReqwrap)
                {
                    system.debug('....tempPartReq...'+tempPartReq.objPartReq);
                    
                    if(tempPartReq.objPartReq != null && tempPartReq.objPart != null && tempPartReq.objPart.Id != null)
                    {
                        tempPartReq.objPartReq.Part__c = tempPartReq.objPart.Id;
                        //tempPartReq.objPartReq.Name = tempPartReq.objPart.Name;
                        tempPartReq.objPartReq.Service_Request__c = recordId;
                        lstPartReq.add(tempPartReq.objPartReq);
                    }   
                }
                system.debug('lstPartReq----'+lstPartReq);
                if(lstPartReq.size() > 0)
                {
                    upsert lstPartReq;
                    objWrap = (wrapper)Json.deserialize(doInit(recordId), wrapper.class);
                    objWrap.success = true;
                    objWrap.strSuccess = 'Record Saved Successfully';
                }
            }             
        }
        catch(DMLException de)
        {
            objWrap.success = false;
            objWrap.strError = de.getDmlMessage(0);
        }
        
        return Json.serialize(objWrap);
    }
    
    @AuraEnabled
    public static string deletePR(string recordId, string partReqRecordId)
    {
        wrapper objWrap = (wrapper)Json.deserialize(doInit(recordId), wrapper.class);
        try
        {
            if(partReqRecordId != '' && partReqRecordId != null)
            {
                delete [select id from Part_Request__c  where id =: partReqRecordId];
                objWrap = (wrapper)Json.deserialize(doInit(recordId), wrapper.class);
                objWrap.success = true;
                objWrap.strSuccess = 'Record Delete Successfully.';
            }
            
        }
        catch(DMLException de)
        {
            objWrap.success = false;
            objWrap.strError = de.getDmlMessage(0);
        }

        return Json.serialize(objWrap);
    }
    
    
    private static wrapper initialValue()
    {
        wrapper objWrap = new wrapper();
        objWrap.strError = '';
        objWrap.strSuccess ='';
        objWrap.success= false;
        objWrap.isClosed = false;
        objWrap.partTypePick = new List<option>();
        objWrap.warrantytypePick = new List<string>();
        objWrap.lstPartReqWrap = new List<partReqWrapper>();
        return objWrap;
    }
    
    public class wrapper
    {
        public string strError;
        public string strSuccess;
        public boolean success;
        public boolean isClosed;
        public List<option> partTypePick;
        public List<string> warrantytypePick;
        public List<partReqWrapper> lstPartReqWrap;
    }
    
    public class partReqWrapper 
    {
        public Part__c objPart;
        public Part_Request__c objPartReq;
        public boolean isEdit;
        public boolean isExist;
        public string strPartTypeErr;
        public string strWarrentyTypeErr;
        Public string strPartErr;
        public string strOldPartNumErr;
        public string strQuantityErr;
        public boolean boolShowError;
        
    }
    
    public class option
    {
        public string value;
        public string label;
        public boolean isDisable;
    }
}