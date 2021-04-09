({
    onLoad : function(component, event, helper){
        component.set('v.spinnerIsVisibile', true);
        var action = component.get('c.convertLead');
        action.setParams({
            'strleadrecordid' : component.get('v.recordId')
        });
        action.setCallback(this, function (res) {
            if(res.getState() === 'SUCCESS'){
                var allval = res.getReturnValue();
                component.set("v.wrapmain", JSON.parse(allval));
                component.set("v.RecordTypeAccName", JSON.parse(allval).PicklistAccountRecord);
                component.set("v.RecordTypeName", JSON.parse(allval).PicklistContactRecord);
                component.set("v.RecordTypeDealName", JSON.parse(allval).PicklistDealRecord);
                component.set("v.isShowRecord", JSON.parse(allval).ShowAccRecord);
                component.set("v.isShowConRecord", JSON.parse(allval).ShowConRecord);
                component.set("v.isShowDealRecord", JSON.parse(allval).ShowDealRecord);
               // alert(' '+(JSON.parse(allval).PicklistAccountRecord[0].id));
                component.set("v.companyname", JSON.parse(allval).objlead.Company__c);
                var accountname = component.get("v.companyname");
                if(accountname !== "undefined")
                {
                    component.set("v.selectedRecord", component.get("v.wrapmain.selectedRecord"));
                    component.set("v.errorMessage", '');
                    component.set('v.isConvertedLead',false);
                    component.set('v.isNonConvertedLead',true);
                }
                else
                {
                    var msg = $A.get("$Label.c.Company_name_not_blank_on_lead_object");
                    component.set("v.errorMessage", msg);
                    component.set('v.isConvertedLead',false);
                    component.set('v.isNonConvertedLead',true);
                }
                
                if(JSON.parse(allval).errorMSG != null){
                    component.set('v.convertedMessage', JSON.parse(allval).errorMSG);
                    component.set('v.isConvertedLead',true); 
                    component.set('v.isNonConvertedLead',false);
                    component.set('v.errorMessage', '');
                    component.set('v.successMessage', '')
                }else{
                    component.set('v.errorMessage', '');
                }
                component.set('v.spinnerIsVisibile', false);
            }else{
                component.set('v.spinnerIsVisibile', false);
            } 
                
        });
        
        $A.enqueueAction(action);
    },
    
    saveconvertedrec : function(component, event, helper){
        component.set('v.spinnerIsVisibile', true);
        var action = component.get('c.saveconvertrecord');
        //var leadstatus       = component.find('leadstatusid').get('v.value');
        action.setParams({
            'strLeadid' : component.get('v.recordId'),
            'AccountId' : component.get('v.AccName.Id'),
            'OpportunityId' : component.get('v.OppName.Id'),
            'ContactId' : component.get('v.ConName.Id'),
            'CreateOpp' : component.get('v.CreateOpp'),
           // 'EnquryStatus': leadstatus,
            'IsDeleteConverted' : component.get('v.isDeleteLead'),
            'AccountName': component.get('v.wrapmain.objlead.Company__c'),
            'strRecordType' : component.get('v.selectedValue')
            
        });
        
        action.setCallback(this, function (res){
            var state = res.getState();
            
            if(state === 'SUCCESS'){
                var allval = JSON.parse(res.getReturnValue());
                var accid = JSON.parse(res.getReturnValue()).AccName.Id;
                
                var errorMsg = JSON.parse(res.getReturnValue()).errorMSG;
                
                if(errorMsg.length > 0){
                    if(errorMsg == 'List index out of bounds: 0')
                    {
                        var msg = $A.get("$Label.c.LeadConvert_Account_ErrorMsg");
                        component.set('v.errorMessage', msg);
                        component.set('v.successMessage', '');
                    }
                    else{
                        component.set('v.errorMessage', errorMsg);
                        component.set('v.successMessage', '');  
                    }
                   
                }else{
                    component.set("v.wrapmain", allval);
                    var msg = $A.get("$Label.c.Lead_Convert_Success_Message");
                    component.set('v.errorMessage', '');
                    component.set('v.successMessage', msg);
                }
                component.set('v.spinnerIsVisibile', false);
            }
            else{
                component.set('v.errorMessage', JSON.parse(res.getReturnValue()).errorMSG);
                component.set('v.spinnerIsVisibile', false);
            }
            
        });
        
        $A.enqueueAction(action);
    },
})