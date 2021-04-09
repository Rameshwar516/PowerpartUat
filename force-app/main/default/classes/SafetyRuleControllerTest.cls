@isTest
public class SafetyRuleControllerTest {
@isTest
    public static void testcreateSaftyRules(){
                clsUtility.testDataCustomSetting();
            Asset__c objAss = new Asset__c(Name ='test',Account_Number__C  = 1,Company__c = 'Test Company');

        Service_Request__c sf=new Service_Request__c();
        sf.Issue_Reported__c='test';
        sf.Complaint_Type__c='Breakdown';
        sf.ESN__c=objAss.Id;
        insert sf;
        SafetyRuleController.saveSafetyRules(sf.Id,'test','test','test','test','test','test');
    }
}