public class UtilityClass {
    
    public static List<String> getAllFields(String strObject){
        SObjectType schemaType = Schema.getGlobalDescribe().get(strObject);
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        List<String> accessableFields = new List<String>();
        for (String field : fields.keySet())
            if(fields.get(field).getDescribe().isAccessible()) {
                accessableFields.add(field.trim());   
            }
        return accessableFields;
    }
    
    public static string NoToWord(Integer no)
    {       
        String ru='';
        String[] word = new List<String>{'','One','Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten','Eleven','Twelve','Thirteen','Fourteen','Fifteen','Sixteen','Seventeen','Eighteen','Nineteen'};
            String[] tens1 = new List<String>{'','','Twenty ','Thirty ','Forty ','Fifty ','Sixty ','Seventy ','Eighty ','Ninety '};
                Integer n1,n2;
        n1 = math.mod(no,100);
        if(n1 > 0)
        {
            if(n1 <= 19)
            {
                ru = word.get(n1) + ' ';
            }
            else if(n1 > 19)
            {
                ru = tens1.get(n1/10) + word.get(math.mod(n1,10)) + ' ';
            }
        }
        n1 = math.mod((no/100),10);
        system.debug('n1___hundrad:: '+n1);
        
        if(n1 > 0)
        {
            if(n1 <= 19)
            {
                ru = word.get(n1) + ' Hundred ' + ru;
            }
        }
        
        n1 = math.mod((no/1000),100);
        system.debug('n1___thousand:: '+n1);
        
        if(n1 > 0)
        {
            if(n1<=19)
            {
                ru = word.get(n1) + ' Thousand ' + ru;
            }
            else if(n1>19)
            {
                ru = tens1.get(n1/10) + ' ' + word.get(math.mod(n1,10)) + ' Thousand ' + ru;
            }
        }
        
        n1 = math.mod((no/100000),100);
        system.debug('n1___lakh:: '+n1);
        if(n1>0)
        {
            if(n1<=19)
            {
                ru = word.get(n1) + ' Lakh ' + ru;
            }
            else if(n1>19)
            {
                ru = tens1.get(n1/10) + ' ' + word.get(math.mod(n1,10)) + ' Lakh ' + ru;
            }
        }
        
        n1 = math.mod((no/10000000),1000);
        system.debug('n1___Crore:: '+n1);
        if(n1 > 0)
        {
            if(n1 <= 19)
            {
                ru = word.get(n1) + ' Crore ' + ru;
            }
            else if(n1 > 19 && n1 <= 99)
            {
                ru = tens1.get(n1/10)+' ' + word.get(math.mod(n1,10)) + ' Crore ' + ru;
            }
            else if(n1 > 99)
            {
                string word2 = NoToWord(n1);
                ru = word2 + ' Crore ' + ru;
            }
        }
        
        return ru;
    }
    
}