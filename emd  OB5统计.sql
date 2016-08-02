--emd  OB5Í³¼Æ 
select count(*),sum(fr.fare * r.sellingrate),min(tr.transactiondate),max(tr.transactiondate),max(tr.transactiondate)-min(tr.transactiondate)
 --select d.documentnumber,tr.*,c.couponnumber,c.status, fc.carrier,fr.fare,fr.currency , fr.fare * r.sellingrate 
   --select tr.transactiondate
    from  emd_document d,emd_coupon c, emd_fare fr ,emd_transaction tr,emd_rate r,emd_flightcontent fc,emd_association ea
  --  emd_coupontransaction ct
        where  d.documentid = tr.documentid         
          and  d.firstdocumentid = fr.documentid
          and  fr.currency = r.currencyname
          and c.couponid = fc.couponid 
          and c.couponid = ea.couponid 
          and tr.transactiondate >=to_date('2015-4-28' ,'yyyy-MM-dd')   
          and tr.transactiondate <to_date('2016-7-22','yyyy-MM-dd')+1               
          and tr.action ='I'          
          and (tr.systemid in('ecp','EMT')
                 or  (tr.agentid ='CAN011' and tr.systemid = 'CZ'))         
          and d.documentid = c.documentid 
          and c.reasonsubcode='0B5'
          ;
        
--¾É£¬ecp
select count(*),sum(fr.fare * r.sellingrate),max(tr.transactiondate),min(tr.transactiondate)
    from  emd_document d,emd_coupon c, emd_fare fr ,emd_transaction tr,emd_rate r,emd_flightcontent fc,emd_association ea,
    emd_coupontransaction ct
        where  d.documentid = tr.documentid         
          and  d.firstdocumentid = fr.documentid
          and  fr.currency = r.currencyname
          and c.couponid = fc.couponid 
          and c.couponid = ea.couponid 
          and tr.transactiondate >=to_date('2015-01-01' ,'yyyy-MM-dd')   
          and tr.transactiondate <to_date('2015-12-31','yyyy-MM-dd')+1           
          and tr.action ='I'          
          and tr.systemid in('ecp','EMT')                   
          and d.documentid = c.documentid 
          and ct.documentid = c.documentid   
          and ct.couponnumber = c.couponnumber ;
          

--ĞÂ
select count(*),sum(fr.fare * r.sellingrate),max(tr.transactiondate),min(tr.transactiondate)
    from  emd_document d,emd_coupon c, emd_fare fr ,emd_transaction tr,emd_rate r,emd_flightcontent fc,emd_association ea,
    emd_coupontransaction ct
        where  d.documentid = tr.documentid         
          and  d.firstdocumentid = fr.documentid
          and  fr.currency = r.currencyname
          and c.couponid = fc.couponid 
          and c.couponid = ea.couponid 
          and tr.transactiondate >=to_date('2015-5-28' ,'yyyy-MM-dd')   
          and tr.transactiondate <to_date('2016-7-22','yyyy-MM-dd')+1  
          and tr.systemid='CZ'
          and tr.action ='I'          
          and tr.agentid ='CAN011' 
          and tr.systemid = 'CZ'                 
          and d.documentid = c.documentid 
          and ct.documentid = c.documentid   
          and ct.couponnumber = c.couponnumber ;
                   
 
