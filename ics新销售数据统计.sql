--新销售数据统计
select count(*),
       sum(fr.fare * r.sellingrate),
       max(tr.transactiondate),
       min(tr.transactiondate)
  from emd_document      d,
       emd_coupon        c,
       emd_fare          fr,
       emd_transaction   tr,
       emd_rate          r,
       emd_flightcontent fc,
       emd_association   ea
 where d.documentid = tr.documentid      
   and d.firstdocumentid = fr.documentid
   and fR.origincurrency = r.currencyname
   and c.couponid = fc.couponid
   and c.couponid = ea.couponid      
   and tr.transactiondate >= to_date('2016-03-17', 'yyyy-MM-dd')
   and tr.transactiondate < to_date('2016-03-27', 'yyyy-MM-dd') + 1      
   and tr.systemid = 'CZ'
   and tr.action = 'I'      
   and c.reasonsubcode = '0B5'
   and tr.agentid = 'CAN011'
   and d.documentid = c.documentid;
   
-------------------
--select count(*),   sum(fr.fare )
select *
  from emd_document      d,
       emd_coupon        c,
       emd_fare          fr,      
       --emd_rate          r,
     --  emd_flightcontent fc,    
       emd_issuingagent  i       
 where
    i.documentid= d.documentid
   and d.firstdocumentid = fr.documentid
   --and fR.origincurrency = r.currencyname
  -- and c.couponid = fc.couponid
   and d.dateofissue >= '160317'
   and d.dateofissue < '160328'   
   and i.systemid  = 'CZ'  
   and c.reasonsubcode = '0B5'         
   and i.agentid = 'CAN011'
   and d.documentid = c.documentid;
