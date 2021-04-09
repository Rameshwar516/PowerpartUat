@isTest
public class CheckOutcls_Test {
    
    @isTest
    Static List<Service_Request__c> TestData() {
        
        clsUtility.testDataCustomSetting();
        Account EndCustom = clsUtility.testDataEndCustomerAcc(1);
        Account OEMAcc = clsUtility.testDataOEMAcc(1);
        
        List<Asset__c> lstAsset = clsUtility.testDataCustomerAsset(OEMAcc, EndCustom, 1);
        List<Service_Request__c> lstServiceRequest = clsUtility.testDataServiceRequest(1, false, lstAsset);
        clsUtility.testDataAddServiceTeam(lstServiceRequest, true);
        
        return lstServiceRequest;
    }
    
    @isTest
    Static void MethodOne(){
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();
        
        Test.startTest();
        User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 1'];
        System.runAs(objUser) {
          string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id); 
          string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
          strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();
        
    }
    
    @isTest    
    Static void MethodTwo(){
        
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();

        Test.startTest();
        User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 2'];
        System.runAs(objUser) {
         string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id); 
         string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
         strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();
    }
    
    @isTest    
    Static void MethodThree(){
        
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();

        Test.startTest();
            User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 3'];
            System.runAs(objUser) {
            string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id);  
           string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
           strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();  
    }
   
    @isTest    
    Static void MethodFour(){
        
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();
        
        Test.startTest();
        User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 4'];
        System.runAs(objUser) {
             string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id);  
            string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
            strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();  
    } 
    
    @isTest    
    Static void MethodFive(){
        
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();
        
        Test.startTest();
        User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 4'];
        System.runAs(objUser) {
             //string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id);  
            string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();  
    }
    
    @isTest    
    Static void MethodSix(){
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();
        
        Test.startTest();
        User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 3'];
        System.runAs(objUser) {
             //string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id);  
            string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();  
    }
    
    @isTest    
    Static void MethodSeven(){
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();
        
        Test.startTest();
         User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 2'];
        System.runAs(objUser) {
             //string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id);  
            string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();  
    }
    
    @isTest    
    Static void MethodEight(){
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();
        
        Test.startTest();
        User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 1'];
        System.runAs(objUser) {
             //string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id);  
            string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();  
    }
    
    @isTest    
    Static void MethodNine(){
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();
        lstServiceRequest[0].Status__c = 'On Hold';
        update lstServiceRequest[0];
        Test.startTest();
        User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 1'];
        System.runAs(objUser) {
             //string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id);  
            string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();  
    }
    
    @isTest    
    Static void MethodTen(){
        List<Service_Request__c> lstServiceRequest = CheckOutcls_Test.TestData();
        lstServiceRequest[0].Status__c = 'Closed';
        update lstServiceRequest[0];
        Test.startTest();
        User objUser = [Select id, LastName, Email from User where LastName = 'TestEngineer 1'];
        System.runAs(objUser) {
             //string strwrap = CheckIncls.updateCheckIn(lstServiceRequest[0].Id);  
            string strwrapCheckOut = CheckOutcls.updateCheckOut(lstServiceRequest[0].Id); 
        }
        Test.stopTest();  
    }
}