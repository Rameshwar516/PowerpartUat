public  without sharing class clsServiceReport {
    
    @AuraEnabled
    public static string doInit(string recordId)
    {
        wrapper objwrap = new wrapper();
        objwrap.objSR =  new Service_Request__c();
        objwrap.objAsset = new Asset__c();
        objwrap.objContact = new contact();
        objwrap.serviceRequestTeam = '';
        objwrap.serviceRequestOwner = '';
        objwrap.lstContentDoc = new List<ContentDocument>();
        objwrap.success = false;
        objwrap.showFeedBackForm = false;
        objwrap.strError ='';
        objwrap.todayDate = System.today();
        
        System.debug('---recordId---'+recordId);
        try
        {
            if(!String.isEmpty(recordId))
            {
                
                DescribeSObjectResult describeResult = Service_Request__c.getSObjectType().getDescribe();     
                List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
                String query =' SELECT ' + String.join( fieldNames, ',' ) + ',Depute_Engineer__r.Name FROM Service_Request__c Where Id =: recordId Limit 1';
                list<Service_Request__c> lstSR = Database.query(query);
                if(lstSR.size()>0){
                    objwrap.objSR = lstSR[0];
                }
                
                if(objwrap.objSR.ESN__c != null)
                {
                    string strAssId = objwrap.objSR.ESN__c;
                    DescribeSObjectResult assDescribeResult = Asset__c.getSObjectType().getDescribe();     
                    List<String> assFieldNames = new List<String>( assDescribeResult.fields.getMap().keySet() );
                    String assQuery =' SELECT ' + String.join( assFieldNames, ',' ) + ' FROM Asset__c Where Id =: strAssId Limit 1';
                    list<Asset__c> lstass = Database.query(assQuery);
                    if(lstass.size()>0){
                        objwrap.objAsset = lstass[0];
                    } 
                }
                
                if(objwrap.objAsset.End_Customer__c != null)
                {
                    string strAccId = objwrap.objAsset.End_Customer__c;
                    DescribeSObjectResult conDescribeResult = contact.getSObjectType().getDescribe();     
                    List<String> conFieldNames = new List<String>( conDescribeResult.fields.getMap().keySet() );
                    String conQuery =' SELECT ' + String.join( conFieldNames, ',' ) + ' FROM contact Where AccountId =: strAccId AND isPrimary__c  = true Limit 1';
                    list<contact> lstcon = Database.query(conQuery);
                    if(lstcon.size()>0){
                        objwrap.objContact = lstcon[0];
                    } 
                    system.debug('Contact--'+ objwrap.objContact);
                }
                List<ContentDocumentLink> lstCDL = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId];
                if(lstCDL.size() > 0)
                {
                    set<Id> setOfPreviousContentDoc = new set<Id>();
                    for(ContentDocumentLink objCDL : lstCDL)
                    {
                        setOfPreviousContentDoc.add(objCDL.ContentDocumentId);
                    }
                    if(setOfPreviousContentDoc.size() > 0)
                    {
                        objwrap.lstContentDoc = [select Id, LatestPublishedVersionId, Title, FileExtension from ContentDocument where (FileExtension = 'jpg' OR FileExtension = 'png' OR FileExtension='jpeg') AND Id =: setOfPreviousContentDoc]; 
                    } 

                    
                }
                
                list<Feedback__c> lstFeedback = [select id, showFeedBackCMP__c, Service_Request__c  from Feedback__c where Service_Request__c =:recordId Limit 1];
                if(lstFeedback.size() > 0)
                    objwrap.showFeedBackForm = lstFeedback[0].showFeedBackCMP__c;

                List<Powerparts_Service_Request_Team__c> lstSRT  = [Select id,Engineer1__c,Engineer1__r.Name,Engineer2__c,Engineer2__r.Name,Engineer3__c,Engineer3__r.Name,Engineer4__c,Engineer4__r.Name, Service_Request__c FROM Powerparts_Service_Request_Team__c where Service_Request__c =: recordId];
                if(lstSRT.size() > 0)
                {
                    if(lstSRT[0].Engineer1__c != null)
                    {
                        objwrap.serviceRequestTeam = lstSRT[0].Engineer1__r.Name;
                        objwrap.serviceRequestOwner = lstSRT[0].Engineer1__r.Name;
                        if(lstSRT[0].Engineer2__c != null)
                            objwrap.serviceRequestTeam = objwrap.serviceRequestTeam +' , '+lstSRT[0].Engineer2__r.Name;
                        if(lstSRT[0].Engineer3__c != null)
                            objwrap.serviceRequestTeam = objwrap.serviceRequestTeam +' , '+lstSRT[0].Engineer3__r.Name;
                        if(lstSRT[0].Engineer4__c != null)
                            objwrap.serviceRequestTeam = objwrap.serviceRequestTeam +' , '+lstSRT[0].Engineer4__r.Name;
                    }
                    
                }
                
                objwrap.success = true;
                System.debug('-----objwrap.objSR-----'+objwrap.objSR);
                System.debug('-----objwrap.objAsset----'+objwrap.objAsset);
                System.debug('------objwrap.lstContentDoc----'+objwrap.lstContentDoc);
                
            }
        }
        catch(DMLException de)
        {
            objwrap.success = false;
            objwrap.strError =de.getDmlMessage(0);
        }
        return Json.serialize(objwrap);
        
    }
    
    @AuraEnabled
    public static string Submit(string strmainWrap)
    {
        wrapper objwrap = (wrapper)JSON.deserialize(strmainWrap, wrapper.class);
        try
        {
            objwrap.success = true;
            objwrap.objSR.showServiceReqCMP__c = true; 
            Update objwrap.objSR;
        }
        catch(DMLException de)
        {
           objwrap.success = false; 
           objwrap.strError = de.getDmlMessage(0);
        }
        return JSON.serialize(objwrap);
    }
    
    public class wrapper
    {
        public Service_Request__c objSR;
        public Asset__c objAsset;
        public contact objContact;
        public List<ContentDocument> lstContentDoc;
        public String serviceRequestTeam;
        public String serviceRequestOwner;
        public boolean showFeedBackForm;
        public boolean success; 
        public string strError;
        public Date todayDate;
    }

}