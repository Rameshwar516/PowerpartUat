@isTest
public class ServiceRequestTeamHandler_Test {
    
    @isTest
    static void methodOne() {
        Profile objProfile = [Select Id, Name from Profile where Name='Service Engineer'];
        
        User objUser = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer1234234234@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser;
        
        User objUser1 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer1234234@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser1;
        
        User objUser2 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer123@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser2;
        
        User objUser4 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer12343655465@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser4;
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        
        Powerparts_Service_Request_Team__c objPSR = new Powerparts_Service_Request_Team__c();
        objPSR.Service_Request__c = lstServiceRequest[0].Id;
        objPSR.Engineer1__c = objUser4.Id;
        objPSR.Engineer2__c = objUser.Id;
        objPSR.Engineer3__c = objUser1.Id;
        objPSR.Engineer4__c = objUser2.Id;
        insert objPSR;
        list<Powerparts_Service_Request_Team__c> lstPPT = new list<Powerparts_Service_Request_Team__c>();
        lstPPT.add(objPSR);
        try{
            ServiceRequestTeamHandler.onafterInsert(lstPPT);
        }catch(exception ex){
        
        }
        
        
        //clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        clsUtility.testDataContentDoc(lstServiceRequest, 5); 
        List<Powerparts_Service_Request_Team__c> lstSRT = [Select id, Service_Request__c ,Engineer1__c, Engineer2__c ,Engineer3__c,Engineer4__c 
                                                           from Powerparts_Service_Request_Team__c
                                                           where Service_Request__c =:lstServiceRequest[0].id ];
        lstSRT[0].Engineer4__c = null;
        update lstSRT;
        
        try{
            ServiceRequestTeamHandler.onafterInsert(lstPPT);
        }catch(exception ex){
        
        }
    }
    
    @isTest
    static void methodTwo() {
        Profile objProfile = [Select Id, Name from Profile where Name='Service Engineer'];
        
        User objUser = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer1234234234@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser;
        
        User objUser1 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer1234234@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser1;
        
        User objUser2 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer123@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser2;
        
        User objUser4 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer12343655465@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser4;
        
        User objUser5 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer12343655465900909@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser5;
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        
        Powerparts_Service_Request_Team__c objPSR = new Powerparts_Service_Request_Team__c();
        objPSR.Service_Request__c = lstServiceRequest[0].Id;
        objPSR.Engineer1__c = objUser4.Id;
        objPSR.Engineer2__c = objUser.Id;
        objPSR.Engineer3__c = objUser1.Id;
        objPSR.Engineer4__c = objUser2.Id;
        insert objPSR;
        
        objPSR.Engineer2__c = objUser5.Id;
        update objPSR;
        
        
        //clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        clsUtility.testDataContentDoc(lstServiceRequest, 5); 
        List<Powerparts_Service_Request_Team__c> lstSRT = [Select id, Service_Request__c ,Engineer1__c, Engineer2__c ,Engineer3__c,Engineer4__c 
                                                           from Powerparts_Service_Request_Team__c
                                                           where Service_Request__c =:lstServiceRequest[0].id ];
        lstSRT[0].Engineer4__c = null;
        update lstSRT;
    }
    
    @isTest
    static void methodThree() {
        Profile objProfile = [Select Id, Name from Profile where Name='Service Engineer'];
        
        User objUser = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer1234234234@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser;
        
        User objUser1 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer1234234@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser1;
        
        User objUser2 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer123@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser2;
        
        User objUser4 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer12343655465@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser4;
        
        User objUser5 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer12343655465900909@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser5;
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        
        Powerparts_Service_Request_Team__c objPSR = new Powerparts_Service_Request_Team__c();
        objPSR.Service_Request__c = lstServiceRequest[0].Id;
        objPSR.Engineer1__c = objUser4.Id;
        objPSR.Engineer2__c = objUser.Id;
        objPSR.Engineer3__c = objUser1.Id;
        objPSR.Engineer4__c = objUser2.Id;
        insert objPSR;
        
        objPSR.Engineer3__c = objUser5.Id;
        update objPSR;
        
        
        //clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        clsUtility.testDataContentDoc(lstServiceRequest, 5); 
        List<Powerparts_Service_Request_Team__c> lstSRT = [Select id, Service_Request__c ,Engineer1__c, Engineer2__c ,Engineer3__c,Engineer4__c 
                                                           from Powerparts_Service_Request_Team__c
                                                           where Service_Request__c =:lstServiceRequest[0].id ];
        lstSRT[0].Engineer4__c = null;
        update lstSRT;
    }
    
    @isTest
    static void methodFour() {
        Profile objProfile = [Select Id, Name from Profile where Name='Service Engineer'];
        
        User objUser = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer1234234234@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser;
        
        User objUser1 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer1234234@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser1;
        
        User objUser2 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer123@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser2;
        
        User objUser4 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer12343655465@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser4;
        
        User objUser5 = new User(ProfileId = objProfile.Id,
                                        LastName = 'TestEngineer ',
                                        Email = 'TestEngineer@test.com',
                                        Username = 'TestEngineer12343655465900909@test.com',
                                        CompanyName = 'Test Pvt Ltd',
                                        Alias = 'TEngi',
                                        TimeZoneSidKey = 'America/Los_Angeles',
                                        EmailEncodingKey = 'ISO-8859-1',
                                        LocaleSidKey = 'en_US',
                                        LanguageLocaleKey = 'en_US');
                //lstUser.add(objUser);
        
        insert objUser5;
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        
        Powerparts_Service_Request_Team__c objPSR = new Powerparts_Service_Request_Team__c();
        objPSR.Service_Request__c = lstServiceRequest[0].Id;
        objPSR.Engineer1__c = objUser4.Id;
        objPSR.Engineer2__c = objUser.Id;
        objPSR.Engineer3__c = objUser1.Id;
        objPSR.Engineer4__c = objUser2.Id;
        insert objPSR;
        
        objPSR.Engineer4__c = objUser5.Id;
        update objPSR;
        
        
        //clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        clsUtility.testDataContentDoc(lstServiceRequest, 5); 
        List<Powerparts_Service_Request_Team__c> lstSRT = [Select id, Service_Request__c ,Engineer1__c, Engineer2__c ,Engineer3__c,Engineer4__c 
                                                           from Powerparts_Service_Request_Team__c
                                                           where Service_Request__c =:lstServiceRequest[0].id ];
        lstSRT[0].Engineer4__c = null;
        update lstSRT;
    }
}