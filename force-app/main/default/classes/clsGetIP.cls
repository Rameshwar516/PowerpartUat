public class clsGetIP{
    
    public String ipAddress{get; set;}

    public clsGetIP(){
        //this will work if no caching is in place or user is logged in via secure URL
        ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
         
        //this logic will execute if proxy is in use
        if(String.isEmpty(ipAddress)){
           ipAddress = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        }
        
        System.debug('Get Ip address '+ ipAddress);
    }
 }