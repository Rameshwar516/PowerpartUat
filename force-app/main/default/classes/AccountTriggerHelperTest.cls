/*
--------------------------------------------------------------------------------------
Version#     Date                           Author                    Description
--------------------------------------------------------------------------------------
1.0          17-Dec-2019                   Deepak Pandey            Initial Version
--------------------------------------------------------------------------------------
*/
@istest
public class AccountTriggerHelperTest{
    @istest
    static void execute(){
        clsUtility.testDataCustomSetting();
        clsUtility.testDataAccountContact(20,20,true);
    }
}