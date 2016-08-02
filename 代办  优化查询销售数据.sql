 select c.*,tr.*,fc.flightdate
 from  emd_coupon c  ,emd_document d,emd_transaction tr,emd_flightcontent fc
  where c.reasonsubcode='0AA'      
  and d.documentid=c.documentid
 and tr.documentid=d.documentid
 and fc.couponid=c.couponid
 and tr.action='I'
  and tr.transactiondate >=to_date('2015-12-1' ,'yyyy-MM-dd')            
   and tr.transactiondate <to_date('2016-1-31','yyyy-MM-dd')+1
