public class ServiceReportPDFController {
    public string strRecord {get; set;}
    public Service_Request__c objSR{get;set;}
    public String serviceRequestTeam{get;set;}
    public String serviceRequestOwner{get;set;}
    public Asset__c objAsset{get; set;}
    public contact objContact{get;set;}
    public Date todayDate{get; set;}
    public List<ContentDocument> lstContentDoc{get;set;}
    
    public ServiceReportPDFController(ApexPages.StandardController controller)
    {
        todayDate = System.today();
        strRecord ='';
        strRecord = ApexPages.currentPage().getParameters().get('id');
        if(strRecord != '' && strRecord != null)
        {
            system.debug('Record Id :'+strRecord);
            DescribeSObjectResult describeResult = Service_Request__c.getSObjectType().getDescribe();     
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            String query =' SELECT ' + String.join( fieldNames, ',' ) + ',Depute_Engineer__r.Name FROM Service_Request__c Where Id =: strRecord Limit 1';
            list<Service_Request__c> lstSR = Database.query(query);
            if(lstSR.size()>0){
                objSR = lstSR[0];
            }

            if(objSR.ESN__c != null)
            {
                objAsset = getAssetDetails(objSR.ESN__c);
            }
            
            if(objAsset != null && objAsset.End_Customer__c != null)
            {
                objContact = getContactDetails(objAsset.End_Customer__c);
            }
            
            
            List<ContentDocumentLink> lstCDL = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: strRecord];
            if(lstCDL.size() > 0)
            {
                set<Id> setOfPreviousContentDoc = new set<Id>();
                for(ContentDocumentLink objCDL : lstCDL)
                {
                    setOfPreviousContentDoc.add(objCDL.ContentDocumentId);
                }
                if(setOfPreviousContentDoc.size() > 0)
                {
                    //lstContentDoc = [select Id, LatestPublishedVersionId, Title from ContentDocument where Id =: setOfPreviousContentDoc];
                    lstContentDoc = [select Id, LatestPublishedVersionId, Title, FileExtension from ContentDocument where (FileExtension = 'jpg' OR FileExtension = 'png' OR FileExtension = 'jpeg') AND Id =: setOfPreviousContentDoc]; 
                
                } 
            }
            
            List<Powerparts_Service_Request_Team__c> lstSRT  = [Select id,Engineer1__c,Engineer1__r.Name,Engineer2__c,Engineer2__r.Name,Engineer3__c,Engineer3__r.Name,Engineer4__c,Engineer4__r.Name, Service_Request__c FROM Powerparts_Service_Request_Team__c where Service_Request__c =: strRecord];
            if(lstSRT.size() > 0)
            {
                if(lstSRT[0].Engineer1__c != null)
                {
                   serviceRequestTeam = lstSRT[0].Engineer1__r.Name;
                   serviceRequestOwner =lstSRT[0].Engineer1__r.Name;
                   if(lstSRT[0].Engineer2__c != null)
                      serviceRequestTeam = serviceRequestTeam +' , '+lstSRT[0].Engineer2__r.Name;
                   if(lstSRT[0].Engineer3__c != null)
                      serviceRequestTeam = serviceRequestTeam +' , '+lstSRT[0].Engineer3__r.Name;
                   if(lstSRT[0].Engineer4__c != null)
                     serviceRequestTeam = serviceRequestTeam +' , '+lstSRT[0].Engineer4__r.Name;
                }
                    
            }
        }
    }
    
    public Contact getContactDetails(String strRecordId)
    {
        contact objCon = new contact();
        DescribeSObjectResult conDescribeResult = contact.getSObjectType().getDescribe();     
        List<String> conFieldNames = new List<String>( conDescribeResult.fields.getMap().keySet() );
        String conQuery =' SELECT ' + String.join( conFieldNames, ',' ) + ' FROM contact Where AccountId =: strRecordId AND isPrimary__c  = true  Limit 1';
        list<contact> lstcon = Database.query(conQuery);
        if(lstcon.size()>0){
            objCon = lstcon[0];
        }
        return objCon;
    }
    
    public Asset__c getAssetDetails(Id recordId)
    {
        Asset__c objAsset = new Asset__c();
        DescribeSObjectResult assDescribeResult = Asset__c.getSObjectType().getDescribe();     
        List<String> assFieldNames = new List<String>( assDescribeResult.fields.getMap().keySet() );
        String assQuery =' SELECT ' + String.join( assFieldNames, ',' ) + ' FROM Asset__c Where Id =: recordId Limit 1';
        list<Asset__c> lstass = Database.query(assQuery);
        if(lstass.size()>0){
            objAsset = lstass[0];
        } 
        return objAsset;
    }
}