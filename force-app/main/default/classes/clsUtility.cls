public class clsUtility {
    
    public static Void testDataCustomSetting() {
        List<Trigger_Setting__c> lstTriggerSetting = new List<Trigger_Setting__c>();
        List<String> lstName = new List<String>{'Account', 'Asset', 'Service Request', 'Part','Part Request','Service Request Team', 'WarrantyClaim'};
            
            for(String objStr : lstName) {
                Trigger_Setting__c objTS = new Trigger_Setting__c();
                objTS.Name = objStr;
                objTS.Active__c = true;
                lstTriggerSetting.add(objTS);
            }
        insert lstTriggerSetting;
        
        List<Generating_Account_Number__c> lstGAN = new List<Generating_Account_Number__c>();
        Generating_Account_Number__c objGAN = new Generating_Account_Number__c();
        objGAN.Name ='Unique Number';
        objGAN.Unique_Number__c = 0;
        lstGAN.add(objGAN);
        insert lstGAN;
        
    }
    
    public static List<Account> testDataAccountContact(Integer numAcc, Integer numConPerAcc, Boolean hasParent) {
        
        List<Account> lstAccount = new List<Account>();
        for(Integer i=1; i <= numAcc; i++) {
            Account obj = new Account(Name ='Test Account'+i, Type='OEM');
            lstAccount.add(obj);
        }
        insert lstAccount;
        
        List<Contact> lstContact = new List<Contact>();
        for(Account obj : lstAccount) {
            for(Integer i= 1; i <= numConPerAcc; i++) {
                Contact objCon;
                if(i == 1)
                    objCon = new Contact(LastName = 'Test Contact'+i, isPrimary__c = true, AccountId = obj.Id);
                else
                    objCon = new Contact(LastName = 'Test Contact'+i, isPrimary__c = false, AccountId = obj.Id);
                lstContact.add(objCon);
            }
        }
        insert lstContact;
        
        List<Account> lstChildAccount = new List<Account>();
        if(hasParent) {
            for(Account objAcc : lstAccount) {
                integer i = 1;
                Account obj = new Account(Name ='Test Child Account'+i, ParentId =objAcc.Id);
                lstChildAccount.add(obj);
                i++;
            }
            insert lstChildAccount;
            
            List<Contact> lstChildContact = new List<Contact>();
            for(Account obj : lstChildAccount) {
                for(Integer i= 1; i <= numConPerAcc; i++) {
                    Contact objCon;
                    if(i == 1)
                        objCon = new Contact(LastName = 'Test Child Contact'+i, isPrimary__c = true, AccountId = obj.Id);
                    else
                        objCon = new Contact(LastName = 'Test Child Contact'+i, isPrimary__c = false, AccountId = obj.Id);
                    lstChildContact.add(objCon);
                }
            }
            insert lstChildContact;
        }
        
        if(hasParent)
            return lstChildAccount;
        else
            return lstAccount;
    }
    
    //Insert OEM Account
    public static Account testDataOEMAcc(Integer numConPerAcc) {
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        Account objOEMAcc = new Account(Name ='Test OEM Account'+randomInt, Type='OEM',Account_Number__C = 1);
        insert objOEMAcc;
        
        List<Contact> lstContact = new List<Contact>();
        for(Integer i= 1; i <= numConPerAcc; i++) {
            Contact objCon;
            if(i == 1)
                objCon = new Contact(LastName = 'Test OEM Child Contact'+i, isPrimary__c = true, AccountId = objOEMAcc.Id);
            else
                objCon = new Contact(LastName = 'Test OEM Child Contact'+i, isPrimary__c = false, AccountId = objOEMAcc.Id);
            lstContact.add(objCon);
        }
        insert lstContact;
        return objOEMAcc;
    }
    
    //Insert End Customer Account
    public static Account testDataEndCustomerAcc(Integer numConPerAcc) {
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        Account objEndCustAcc = new Account(Name ='Test End Customer Account'+randomInt, Type='OEM\'s Customer');
        insert objEndCustAcc;
        
        List<Contact> lstContact = new List<Contact>();
        for(Integer i= 1; i <= numConPerAcc; i++) {
            Contact objCon;
            if(i == 1)
                objCon = new Contact(LastName = 'Test End Customer Contact'+i, isPrimary__c = true, Email ='EndCustomer'+i+'@test.com', AccountId = objEndCustAcc.Id);
            else
                objCon = new Contact(LastName = 'Test End Customer Contact'+i, isPrimary__c = false,Email ='EndCustomer'+i+'@test.com', AccountId = objEndCustAcc.Id);
            lstContact.add(objCon);
        }
        insert lstContact;
        
        return objEndCustAcc;
    }
    
    //Insert Customer Asset Using ImportWard
    public static List<Asset__c> testDataCustomerAssetImportWard(Account objOEMAcc, Account objEndCustomer , Integer numAsset) {
        
        List<Asset__c> lstAsset = new List<Asset__c>();
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        for(Integer i =1 ; i <= numAsset; i++) {
            String uniqueName = 'Test Asset '+randomInt +i;
            Asset__c objAss = new Asset__c(Name =uniqueName,
                                           Account_Number__C  = 1);
           lstAsset.add(objAss);
        }
        insert lstAsset;
        List<Asset__c> lstAssUpdate = new list<Asset__c>();
        for(Asset__c objAsset : lstAsset)
        {
            objAsset.Account_Number__c  = 2;
            objAsset.Company__c  = 'Test End Customer';
            lstAssUpdate.add(objAsset);
        }
        update lstAssUpdate;
        
        return lstAsset; 
    }
    
    //Insert Customer Asset
    public static List<Asset__c> testDataCustomerAsset(Account objOEMAcc, Account objEndCustomer , Integer numAsset) {
        
        List<Asset__c> lstAsset = new List<Asset__c>();
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        for(Integer i =1 ; i <= numAsset; i++) {
            String uniqueName = 'Test Asset '+randomInt +i;
            Asset__c objAss = new Asset__c(Name =uniqueName,
                                           End_Customer__c = objEndCustomer.Id,
                                           Account_Number__C  = 1,Company__c = 'Test Company');
           lstAsset.add(objAss);
        }
        insert lstAsset;
        
        return lstAsset; 
    }
    
    //Insert Customer Asset
    public static List<Asset__c> testDataCustomerAssetImportWazard(Account objOEMAcc, Account objEndCustomer , Integer numAsset) {
        
        List<Asset__c> lstAsset = new List<Asset__c>();
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        for(Integer i =1 ; i <= numAsset; i++) {
            String uniqueName = 'Test Asset '+randomInt +i;
            Asset__c objAss = new Asset__c(Name =uniqueName,Account_Number__C  = 1,Company__c = 'Test Company');
           lstAsset.add(objAss);
        }
        insert lstAsset;
        
        return lstAsset; 
    }
    
    public Static List<Service_Request__c> testDataServiceRequest(Integer numSR, Boolean hasParent, List<Asset__c> lstAsset) {
        
        List<Service_Request__c> lstServiceRequest = new List<Service_Request__c>();
        
        for(Asset__c objAsset : lstAsset) {
            for(Integer i = 1; i <= numSR; i++) {
                Service_Request__c objSR = new Service_Request__c(Issue_Reported__c = 'Test Service Request'+i,ESN__c = objAsset.Id);
                
                lstServiceRequest.add(objSR);
                
            }
        }
        insert lstServiceRequest;
        Safety_rules__c srObj=new Safety_rules__c();
            srObj.Breakdown_equipment__c='test';
            srObj.Electrical_hazard__c='test';
            srObj.Service_Request__c=lstServiceRequest[0].Id;
            srObj.Fire_Hazard__c='test';
            srObj.General_Housekeeping__c='test';
            srObj.Personal_Protection_Equipment__c='test';
            srObj.Other_Safety_Hazard__c='test';
            insert srObj;
        
        List<Service_Request__c> lstChildSerReq = new List<Service_Request__c>();
        if(hasParent) {
            for(Asset__c objAsset : lstAsset) {
                for(Service_Request__c objSR : lstServiceRequest) {
                    integer i = 1;
                    Service_Request__c objChildSR = new Service_Request__c(Issue_Reported__c = 'Test Child Service Request'+i, 
                                                                           Parent_Service_Request__c = objSR.Id,
                                                                           ESN__c = objAsset.Id);
                    lstChildSerReq.add(objChildSR);
                    i++;
                }
            }
        }
        insert lstChildSerReq;
        
        if(hasParent)
            return lstChildSerReq;
        else   
            return lstServiceRequest;
    }
    
    //Add Service Request Team on Service Request 
    public Static Void testDataAddServiceTeam (List<Service_Request__c> lstSR, Boolean hasServiceEngineer) {
        
        List<Powerparts_Service_Request_Team__c>  lstPSRT = new List<Powerparts_Service_Request_Team__c>();
        List<User> lstUser = new List<User>();
        
        if(hasServiceEngineer) {
            
            //UserRole objRole = new UserRole(DeveloperName = 'ServiceEngineer', Name = 'Service Engineer');
            //insert objRole;
            
            Profile objProfile = [Select Id, Name from Profile where Name='Service Engineer'];
            
            for(Integer i = 1; i <= 4; i++) {
                User objUser = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer '+i,
                                        Email = 'TestEngineer'+i+'@test.com',
                                        Username = 'TestEngineer'+i+'@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi'+i,
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                lstUser.add(objUser);
            }
            insert lstUser;
        }
        for(Service_Request__c objSR : lstSR) {
            if(hasServiceEngineer) {
              Powerparts_Service_Request_Team__c objPSRT = new Powerparts_Service_Request_Team__c(Service_Request__c = objSR.Id,
                                                                                                  Engineer1__c = lstUser[0].Id,
                                                                                                  Engineer2__c = lstUser[1].Id,
                                                                                                  Engineer3__c = lstUser[2].Id,
                                                                                                  Engineer4__c = lstUser[3].Id);
              lstPSRT.add(objPSRT);  
            }
            else {
               Powerparts_Service_Request_Team__c objPSRT = new Powerparts_Service_Request_Team__c(Service_Request__c = objSR.Id);
               lstPSRT.add(objPSRT);
            }
        }
        insert lstPSRT;  
    }
    
    //Add Part Request on Service Request 
    public Static Void testDataAddPartRequest (List<Service_Request__c> lstSR, Integer numPartReq) {
        
        List<Part__c> lstPart = new List<Part__c>();
        List<Part_Request__c> lstPartRequest = new List<Part_Request__c>();
        
        for(Integer i = 1; i<= numPartReq ; i++) {
            Part__c objPart = new Part__c(Part_Name__c = 'TestPart'+i,
                                          Name = 'TP'+i);
            lstPart.add(objPart);
        }
        insert lstPart;
        
        for(Service_Request__c objSR : lstSR) {
            for(Part__c objPart : lstPart) {
                for(integer i = 0;i<3;i++)
                {
                    Part_Request__c objPartReq = new Part_Request__c(Part__c = objPart.Id,Service_Request__c = objSR.Id);
                    lstPartRequest.add(objPartReq);
                }
            } 
        }
        insert lstPartRequest;  
    }
    
    //Insert Content Document for Service Request
    public Static void testDataContentDoc(List<Service_Request__c> lstSR, Integer numContentDoc) {
        
        for(Service_Request__c objSR : lstSR) {
            Integer i = 1;
            List<ContentVersion> lstConVer = new List<ContentVersion>();
            for(Integer j =1; j <= numContentDoc; j++) {
                Blob beforeblob=Blob.valueOf('Unit Test Attachment Body'+i+j);
                ContentVersion objCV = new ContentVersion();
                objCV.title = 'Test content Version'+i+j;      
                objCV.PathOnClient ='test'+i+'.jpg';           
                objCV.VersionData =beforeblob; 
                lstConVer.add(objCV);
            }
            i++; 
            insert lstConVer;
            
            List<ContentDocumentLink> lstCDL = new List<ContentDocumentLink>();
            for(ContentDocument objCD : [SELECT Id, Title, LatestPublishedVersionId, FileExtension FROM ContentDocument]) {
                ContentDocumentLink objCDL = New ContentDocumentLink();
                objCDL.LinkedEntityId = objSR.id;
                objCDL.ContentDocumentId = objCD.Id;
                objCDL.shareType = 'V';
                objCDL.Visibility = 'AllUsers';
                lstCDL.add(objCDL);
            }
            insert lstCDL;
        }
    }
    
    public static void testDataFeedBack(List<Service_Request__c> lstSR) {
        
        List<Feedback__c> lstFeedBack = new List<Feedback__c>();
        for(Service_Request__c objSR : lstSR) {
            Feedback__c objFB = new Feedback__c(Service_Request__c = objSR.Id);
            lstFeedBack.add(objFB);
        }
        insert lstFeedBack;  
    }
    
    public static void testInsertWarrantyCase(List<Service_Request__c> lstSR) {
        
        List<Warranty_Claim__c> lstWarrantyClaim = new List<Warranty_Claim__c>();
        for(Service_Request__c objSR : lstSR) {
            Warranty_Claim__c objFB = new Warranty_Claim__c(Service_Request__c = objSR.Id,End_Customer__c=objSR.Customer__c);
            lstWarrantyClaim.add(objFB);
        }
        insert lstWarrantyClaim;  
    }
}