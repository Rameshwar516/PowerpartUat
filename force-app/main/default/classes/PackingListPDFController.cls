public class PackingListPDFController
{
    public Sales_Order__c objSO{get;set;}
    public Sales_Order_Dispatch_Delivery_Note__c objSODN{get;set;}
    public Packing_List__c objPck{get;set;}
    public list<Packing_List_Line_Item__c> Litem{get;set;}
      public Pdf_Header__mdt pdfheader{get;set;}
    public contact con{get;set;}
    public Account acc{get;set;}
    public Account shippingAcc{get;set;}
    
    public string strBillingAddress{get;set;}
    public string strShippingAddress{get;set;}
    
    public string strBillingState{get;set;}
    public string strBillingCode{get;set;}
    public string strShippingState{get;set;}
    public string strShippingCode{get;set;}
    
    public PackingListPDFController(ApexPages.StandardController controller)      
    {
        objPck = new Packing_List__c();
        Litem=new list<Packing_List_Line_Item__c>();
        objSO=new Sales_Order__c();
        objSODN=new Sales_Order_Dispatch_Delivery_Note__c();
        con=new contact();
        Acc=new Account();
        
         pdfheader=new Pdf_Header__mdt();
        
        id queryString = ApexPages.currentPage().getParameters().get('id');
        
        List<String> lstSalesOrderField = UtilityClass.getAllFields('Sales_Order__c');
        List<String> lstDNField = UtilityClass.getAllFields('Sales_Order_Dispatch_Delivery_Note__c');
        List<String> lstDNLIField = UtilityClass.getAllFields('Packing_List_Line_Item__c');
        List<String> lstPck = UtilityClass.getAllFields('Packing_List__c');
      
        String strpckg = 'Select ' +String.Join(lstPck, ',')+' '+ ',Delivery_Note__r.Sales_Order__r.Ware_House__r.Branch__c  From Packing_List__c where Id =: queryString';
        List<Packing_List__c> lstPL =  Database.query(strpckg);
        if(lstPL.size() > 0 && lstPL[0] != null)
            objPck = lstPL[0];
            
          ApexPages.currentPage().getHeaders().put('content-disposition', 'filename=' +' Package List - '+objPck.Packing_List_Number__c+'.PDF');
                system.debug('strfileName '+' Package List - '+objPck.Packing_List_Number__c);  
        id striPckdn=   objPck.Delivery_Note__c;
        
        String strSalesOrderQuery = 'Select ' +String.Join(lstDNField, ',')+' '+ ' From Sales_Order_Dispatch_Delivery_Note__c where Id =: striPckdn';
        
        String strSalesOrderItemQuery = 'Select ' +String.Join(lstDNLIField, ',')+ ',Part_No__r.Name,Part_No__r.Part_Name__c,Part_No__r.uom__c,Part_No__r.Specification__c From Packing_List_Line_Item__c where Packing_List__c =: queryString';
        
       string branch = objPck.Delivery_Note__r.Sales_Order__r.Ware_House__r.Branch__c ;
            List<String> pdfheaderField = UtilityClass.getAllFields('Pdf_Header__mdt');
            String pdfHeaderQuery = 'Select ' +String.Join(pdfheaderField, ',')+ ' From Pdf_Header__mdt WHERE Branch__c =:branch Order by Effected_Date__c ASC LIMIT 1';
            pdfheader =  Database.query(pdfHeaderQuery);
        
       List<Sales_Order_Dispatch_Delivery_Note__c> lstDN =  Database.query(strSalesOrderQuery);
       if(lstDN.size() > 0 && lstDN[0] != null)
            objSODN = lstDN[0];
            
        id soId = objSODN.Sales_Order__c;
            
        String strSalesOrder = 'Select ' +String.Join(lstSalesOrderField, ',')+' '+ ' From Sales_Order__c where Id =: soId';
    
            
        list<Sales_Order__c> lstSO = new list<Sales_Order__c>();    
        lstSO = Database.query(strSalesOrder);
        if(lstSO.size()>0 && lstSO[0] != null)
            objSO = lstSO[0];
       
       Litem =  Database.query(strSalesOrderItemQuery);
        list<Account> acclist = [select id,GSTIN_No__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingAddress,BillingPostalCode,ShippingCountry,
             ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState,ShippingAddress, name,Billing_State_Code__c,Shipping_State_Code__c from Account where id =:objSO.Customer_Name__c];
       if(!acclist.isempty())
        Acc= acclist[0];
        list<contact> conlist = [select id,Name,Email,MobilePhone,Accountid from contact where Accountid=:Acc.Id limit 1];
            if(!conlist.isempty())
            con = conlist[0];
        system.debug('contact'+con.id);
        
        strBillingAddress = '';
        strBillingAddress = Acc?.BillingStreet;
        if(strBillingAddress != null && strBillingAddress !='' && Acc.BillingCity != null && Acc.BillingCity !='')
            strBillingAddress = strBillingAddress+', '+Acc.BillingCity;
        else if(Acc.BillingCity != null && Acc.BillingCity !='')
            strBillingAddress = Acc.BillingCity;
            
        if(strBillingAddress != null && strBillingAddress !='' && Acc.BillingState != null && Acc.BillingState !='')
            strBillingAddress = strBillingAddress+', '+Acc.BillingState ;
        else if(Acc.BillingState != null && Acc.BillingState !='')
            strBillingAddress = Acc.BillingState;
        
        if(strBillingAddress != null && strBillingAddress !='' && Acc.BillingPostalCode != null && Acc.BillingPostalCode !='')
            strBillingAddress = strBillingAddress+', '+Acc?.BillingPostalCode  ;
        else if(Acc.BillingPostalCode != null && Acc.BillingPostalCode !='')
            strBillingAddress = Acc.BillingPostalCode ;
            
        if(strBillingAddress != null && strBillingAddress !='' && Acc.BillingCountry != null && Acc.BillingCountry !='')
            strBillingAddress = strBillingAddress+', '+Acc.BillingCountry  ;
        else if(Acc.BillingCountry != null && Acc.BillingCountry !='')
            strBillingAddress = Acc.BillingCountry ;
        
        
        /*
        Billing State And Billing Code, Shipping State and Shipping Code
        */
        shippingAcc = new Account();
        shippingAcc = [select id ,GSTIN_No__c,BillingCity,BillingCountry,BillingState,BillingStreet,BillingAddress,BillingPostalCode,ShippingCountry,
             ShippingCity,ShippingPostalCode,ShippingStreet,ShippingState,ShippingAddress,
                       name,Billing_State_Code__c,Shipping_State_Code__c from Account where id =:objSODN.Shipping_Account__c];
        
        strBillingState = '';
        strBillingCode = '';
        strShippingState = '';
        strShippingCode = '';
        
        strBillingState = shippingAcc?.BillingState ;
        strBillingCode = shippingAcc?.Billing_State_Code__c ;
        
        strShippingAddress = '';
        strShippingAddress = shippingAcc?.ShippingCity;
        if(strShippingAddress != null && strShippingAddress !='' && shippingAcc.ShippingCity != null && shippingAcc.ShippingCity !='')
            strShippingAddress = strShippingAddress+', '+shippingAcc.ShippingCity;
        else if(shippingAcc.ShippingCity != null && shippingAcc.ShippingCity != '')
            strShippingAddress = shippingAcc.ShippingCity;
            
        if(strShippingAddress != null && strShippingAddress !='' && shippingAcc.ShippingState != null && shippingAcc.ShippingState != '')
            strShippingAddress = strShippingAddress+', '+shippingAcc?.ShippingState ;
        else if(shippingAcc.ShippingState != null && shippingAcc.ShippingState != '')
            strShippingAddress = shippingAcc.ShippingState;
        
        if(strShippingAddress != null && strShippingAddress !='' && shippingAcc.ShippingPostalCode != null && shippingAcc.ShippingPostalCode != '')
            strShippingAddress = strShippingAddress+', '+shippingAcc.ShippingPostalCode  ;
        else if(shippingAcc.ShippingPostalCode != null && shippingAcc.ShippingPostalCode != '')
            strShippingAddress = shippingAcc.ShippingPostalCode ;
            
        if(strShippingAddress != null && strShippingAddress !='' && shippingAcc.ShippingCountry != null && shippingAcc.ShippingCountry != '')
            strShippingAddress = strShippingAddress+', '+shippingAcc.ShippingCountry  ;
        else if(shippingAcc.ShippingCountry != null && shippingAcc.ShippingCountry != '')
            strShippingAddress = shippingAcc.ShippingCountry ; 
        
            strShippingState = shippingAcc?.ShippingState;
            strShippingCode = shippingAcc?.Shipping_State_Code__c;
        
        if(strShippingAddress == null || strShippingAddress =='')
        {
            strShippingAddress = strBillingAddress;
            strShippingState = Acc?.BillingState;
            strShippingCode = Acc?.Billing_State_Code__c;
        }
        
    }  
    
}