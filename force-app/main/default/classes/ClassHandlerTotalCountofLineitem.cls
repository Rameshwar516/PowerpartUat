public class ClassHandlerTotalCountofLineitem {
    //on insert
    public static void onInsertCheckNoOfLineItem(list<line_item__c> lits){
        set<id> oppid=new set<id>();
        map<id,opportunity__c> mopp=new map<id,opportunity__c>();
        list<opportunity__c> opp=new list<opportunity__c>();
        for(line_item__c li:lits ){
            if(li.Opportunity__c!=null && li.Quote__c==null){
                oppid.add(li.Opportunity__c);
            }
            system.debug('insert li.Opportunity__c'+li.Opportunity__c);
        }
        if(oppid.size()>0){
            for(aggregateResult ar:[select count(id)lids,sum(net_amount__c) amt,Opportunity__c from line_item__c where Opportunity__c=:oppid group by Opportunity__c]){
                
                
                Opportunity__c op=new Opportunity__c();
                op.Id=(id)ar.get('opportunity__c');
                system.debug('insert (integer)ar.get(lids)++++++++++++'+(integer)ar.get('lids'));
                op.Total_Line_Items__c=(integer)ar.get('lids');
                system.debug('insert (integer)ar.get(lids)'+(integer)ar.get('lids'));
                op.Total_Net_Line_Items_Amount__c=(decimal)ar.get('amt');
                mopp.put(op.id,op);
                // opp.add(op);
            }
            
            system.debug('insert mopp'+mopp);
        }
        if(mopp!=null && mopp.size()>0){
            update mopp.values();
        }
        
    }
    
    public static void onInsertQuoteLineItem(list<line_item__c> lits){
        set<id> quoteid=new set<id>();
        map<id,Quote__c> mapQuote=new map<id,Quote__c>();
        for(line_item__c li:lits ){
            if(li.Quote__c!=null){
                quoteid.add(li.Quote__c);
            }
            system.debug('insert li.Quote__c'+li.Quote__c);
        }
        if(quoteid.size()>0){
            for(aggregateResult ar:[select count(id)lids,max(Discount__c) amt,Quote__c from line_item__c where Quote__c IN: quoteid group by Quote__c]){
                Quote__c objQuote=new Quote__c();
                objQuote.Id=(id)ar.get('Quote__c');
                system.debug('insert (integer)ar.get(lids)++++++++++++'+(integer)ar.get('lids'));
                system.debug('insert (integer)ar.get(lids)'+(integer)ar.get('lids'));
                objQuote.Quote_Percentage_Max__c = (decimal)ar.get('amt');
                mapQuote.put(objQuote.id,objQuote);
            }
            system.debug('insert mapQuote'+mapQuote);
        }
        if(mapQuote!=null && mapQuote.size()>0){
            update mapQuote.values();
        }  
    }
    
    
    //on update
    
    public static void onUpdateCheckNoOfLineItem(List<line_item__c> newli,map<id,line_item__c> oldmapli){
        system.debug('Update handle '+oldmapli.size());
        set<id> oppid=new set<id>();
        map<id,opportunity__c> mopp=new map<id,opportunity__c>();
        for(line_item__c li:newli ){
            if(li.Opportunity__c!=null && oldmapli.get(li.Id).net_amount__c != li.net_amount__c &&
               oldmapli.get(li.Id).net_amount__c!=null){
                   oppid.add(li.Opportunity__c);
               }

        }
        system.debug('OppId'+oppid);
        if(oppid.size()>0){
            for(aggregateResult ar:[select count(id)lids,sum(net_amount__c) amt,Opportunity__c from line_item__c where Opportunity__c IN:oppid group by Opportunity__c]){
                Opportunity__c op=new Opportunity__c();
                if((id)ar.get('opportunity__c') !=null){
                op.Id=(id)ar.get('opportunity__c');
                op.Total_Line_Items__c=(integer)ar.get('lids');
                op.Total_Net_Line_Items_Amount__c=(decimal)ar.get('amt');
                mopp.put(op.id,op);
                    }
            }
            system.debug('update mopp'+mopp);
        }
        if(mopp!=null && mopp.size()>0){
            update mopp.values();
        }
    }
    
    
    
    public static void onUpdateQuoteLineItem(list<line_item__c> lits,map<id,line_item__c> oldmapli){
        set<id> quoteid=new set<id>();
        map<id,Quote__c> mapQuote=new map<id,Quote__c>();
        for(line_item__c li:lits ){
            if(li.Quote__c!=null && oldmapli.get(li.Id).Discount__c != li.Discount__c){
                quoteid.add(li.Quote__c);
            }
            system.debug('insert li.Quote__c'+li.Quote__c);
        }
        if(quoteid.size()>0){
            for(aggregateResult ar:[select count(id)lids,max(Discount__c) amt,Quote__c from line_item__c where Quote__c IN: quoteid group by Quote__c]){
                Quote__c objQuote=new Quote__c();
                objQuote.Id=(id)ar.get('Quote__c');
                objQuote.Quote_Percentage_Max__c = (decimal)ar.get('amt');
                mapQuote.put(objQuote.id,objQuote);
            }
            system.debug('insert mapQuote'+mapQuote);
        }
        if(mapQuote!=null && mapQuote.size()>0){
            update mapQuote.values();
        }  
    }
    
    
    //on delete
    public static void onDeleteCheckNoOfLineItem(list<line_item__c> lits)
    {
        set<id> oppid=new set<id>();
        system.debug('delete trigger');
        map<id,opportunity__c> mopp=new map<id,opportunity__c>();
        for(line_item__c li:lits ){
            if(li.Opportunity__c!=null){
                oppid.add(li.Opportunity__c);
            }
            system.debug('delete li.Opportunity__c'+li.Opportunity__c);
        }
        if(oppid.size()>0)
        {
            list<opportunity__c> lstOpp = new list<Opportunity__c>();
            map<string,decimal> mapOppRelatedAmount = new map<string,decimal>();
            if(oppid.size()>0)
            {
                for(opportunity__c opp : [SELECT id ,name,Total_Net_Line_Items_Amount__c,(select Id, net_amount__c, Opportunity__c from line_items__r ) from opportunity__c where id in: oppid]){
                    Decimal amount=0;
                    opportunity__c ooprec = new opportunity__c();
                    ooprec.id = opp.id;
                    for(line_item__c objln: opp.line_items__r){
                        amount=amount+objln?.Net_Amount__c;
                    }
                    ooprec.Total_Net_Line_Items_Amount__c=amount;
                    ooprec.Total_Line_Items__c=opp?.line_items__r.size();
                    lstOpp.add(ooprec);
                    
                }
                if(!lstOpp.isempty()) 
                    Update lstOpp;
           
            }
        }
    }
    
    
    public static void onDeleteQuoteLineItem(list<line_item__c> lits)
    {
        set<id> quoteId=new set<id>();
        system.debug('delete trigger');
        map<id,Quote__c> mopp=new map<id,Quote__c>();
        for(line_item__c li:lits ){
            if(li.Quote__c!=null){
                quoteId.add(li.Quote__c);
            }
            system.debug('delete li.Quote__c'+li.Quote__c);
        }
        if(quoteId.size()>0)
        {
            list<Quote__c> lstOpp = new list<Quote__c>();
            map<string,decimal> mapOppRelatedAmount = new map<string,decimal>();
            if(quoteId.size()>0)
            {
                for(Quote__c opp : [SELECT id ,name,Quote_Percentage_Max__c,(select Id, Discount__c, Quote__c from line_items__r ) from Quote__c where id in: quoteId]){
                    Decimal maxDec=0;
                    Quote__c ooprec = new Quote__c();
                    ooprec.id = opp.id;
                    for(line_item__c objln: opp.line_items__r){
                        if(objln.Discount__c > maxDec)
                            maxDec = objln.Discount__c;
                    }
                    ooprec.Quote_Percentage_Max__c=maxDec;
                    lstOpp.add(ooprec);
                    
                }
                if(!lstOpp.isempty()) 
                    Update lstOpp;
           
            }
        }
    }
}