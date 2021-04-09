@isTest
public class clsGetIP_Test {
    
    @isTest
    Static void MethodOne() {
        ApexPages.CurrentPage().getHeaders().put('X-Salesforce-SIP', '245.245.245.245');
        Test.startTest();
        clsGetIP objGetIP = new clsGetIP();
        Test.stopTest();
    }
    
    @isTest
    Static void MethodTwo() {
        ApexPages.CurrentPage().getHeaders().put('X-Forwarded-For', '245.245.245.245');
        Test.startTest();
        clsGetIP objGetIP = new clsGetIP();
        Test.stopTest();
    }

}