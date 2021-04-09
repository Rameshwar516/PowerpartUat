public class UploadFilesController {
    
    @AuraEnabled
    public static string InitValue(string recordId)
    {
       wrapper objWrap = initialize();
        
       if(recordId != null && recordId != '')
       {
           List<ContentDocumentLink> lstCDL = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId];
           set<Id> setOfPreviousContentDoc = new set<Id>();
           if(lstCDL.size() > 0)
           {
               for(ContentDocumentLink objCDL : lstCDL)
               {
                   setOfPreviousContentDoc.add(objCDL.ContentDocumentId);
               }
               if(setOfPreviousContentDoc.size() > 0)
               {
                   objWrap.lstContentDocOld = [select Id, LatestPublishedVersionId, Title from ContentDocument where Id IN:setOfPreviousContentDoc];
               }
             objWrap.success = true;
           }
       }
       return Json.serialize(objWrap);
    }
    
    @AuraEnabled
    public static string UpdateFiles(string documentId, string recordId, string strwrap)
    {
        set<String> setOfContentDocument = new set<String>();
        wrapper objWrap = (wrapper)Json.deserialize(strwrap, wrapper.Class);
        try
        {
            if(recordId != null && recordId != '')
            {
                if(documentId != '' && documentId != null)
                {
                    if(documentId.contains(','))
                    {
                        list<string> idList = documentId.split(',');
                        for(string strId : idList)
                        {
                            setOfContentDocument.add(strId);
                        }
                    }
                    else
                        setOfContentDocument.add(documentId);
                    
                    System.debug('----setOfContentDocument----'+setOfContentDocument);
                }
                
                if(setOfContentDocument.size() > 0)
                {
                    objWrap.lstContentDocNew = [select Id, LatestPublishedVersionId, Title from ContentDocument where Id IN:setOfContentDocument];
                }
                objWrap.success = true;
            }
        }
        catch(Exception ex)
        {
            objWrap.success = false;
            objWrap.strErrorMsg = ex.getMessage();
        }
        
        return Json.serialize(objWrap);
    }
        
    @AuraEnabled
    public static string RenameFiles(string strwrap)
    {
        wrapper objWrap = (wrapper)Json.deserialize(strwrap, wrapper.Class);
        try
        {
            List<string> sameFilesName = new List<string>();
            if(objWrap.lstContentDocNew.size() > 0 && objWrap.lstContentDocOld.size() > 0)
            {
                List<string> oldFilesName = new List<string>();
                for(ContentDocument objCDOld: objWrap.lstContentDocOld)
                {
                    oldFilesName.add(objCDOld.Title);
                }
                
                for(ContentDocument objCDNew: objWrap.lstContentDocNew)
                {
                   if(oldFilesName.contains(objCDNew.title))
                       sameFilesName.add(objCDNew.title);
                }
                
            }
            System.debug('------sameFilesName'+sameFilesName);
            if(sameFilesName.size() > 0 )
                {
                  	objWrap.success = false;
                    if(sameFilesName.size() == 1)
                        objWrap.strErrorMsg = 'The file name '+sameFilesName[0]+' already exist. ';
                    else
                    {
                        //sameFilesName.remove(null);
                        string allstring = string.join(sameFilesName,',');
                        objWrap.strErrorMsg = 'These files name '+allstring+' already exist. ';
                    }
                }
                else
                {
                    Update objWrap.lstContentDocNew;
                    objWrap.success = true;
                }
            
        }
        catch(DMLException ex)
        {
            objWrap.success = false;
            objWrap.strErrorMsg = ex.getDmlMessage(0);
        }
        
        return Json.serialize(objWrap);
    }
    
    private static wrapper initialize()
    {
        wrapper objWrap = new wrapper();
        objWrap.lstContentDocNew = new List<ContentDocument>();
        objWrap.lstContentDocOld = new List<ContentDocument>();
        objWrap.success = true;
        objWrap.strErrorMsg ='';        
        return objWrap;
    }
    
    public class wrapper
    {
        List<ContentDocument> lstContentDocNew ;
        List<ContentDocument> lstContentDocOld ;
        boolean success;
        string strErrorMsg;
    }
}