public class SafetyRuleController {
    
    @AuraEnabled 
    public static string saveSafetyRules(string ids,string Radiobutton1,string Radiobutton2,string Radiobutton3,string Radiobutton4,string Radiobutton5,string otherSafety){
        wrapper objwrap = new wrapper();
        try{
            Safety_rules__c srObj=new Safety_rules__c();
            srObj.Breakdown_equipment__c=Radiobutton2;
            srObj.Electrical_hazard__c=Radiobutton3;
            srObj.Service_Request__c=ids;
            srObj.Fire_Hazard__c=Radiobutton4;
            srObj.General_Housekeeping__c=Radiobutton5;
            srObj.Personal_Protection_Equipment__c=Radiobutton1;
            srObj.Other_Safety_Hazard__c=otherSafety;
            insert srObj;
                }
        catch(Exception ex){
            objwrap.success = false;
            objwrap.ErrorMessage = ex.getMessage();
        }
        return 'Success';
    }
    
    public class wrapper{
        public boolean success;
        public boolean feedAlready;
        public String SuccessMessage;
        public String ErrorMessage;
        
    }
}