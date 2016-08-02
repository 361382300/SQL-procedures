
select d.documentnumber,
       d.dateofissue,
       d.reasoncode,
       c.couponid,
       c.reasonsubcode,
       c.settlementauthoration,
       c.involuntary,
       c.couponnumber,
       c.status,
       fc.marketingcarrier,
       fc.flightno,
       fc.carrier,
       fc.flightdate,
       fc.originairport,
       fc.destinationairport,
       ct.documentid ,
       c.documentid  
  from emd_document             d,
       emd_coupon               c,
       emd_transaction          tr,
       emd_coupontransaction    ct,
       emd_flightcontent        fc,
       emd_advanceseatcontent   a,
       --emd_excessbaggagecontent   e,
       emd_issuingagent         i,
       emd_pricing              p,
      emd_fare                 fr
     
 where d.documentid = tr.documentid
   and tr.transactionid = ct.transactionid
   and c.couponid = fc.couponid
    and
    
     c.couponid = a.couponid
    --or c.couponid = e.couponid
   
    and d.firstdocumentid = i.documentid 
    and d.firstdocumentid = p.documentid(+) 
    and d.firstdocumentid = fr.documentid 
    and c.status in('F','G','R','V','E','X') 
    and tr.action ='I'
    and fc.carrier = 'CZ' 
    and ct.documentid = c.documentid   
    and ct.couponnumber = c.couponnumber 
          
 --  and d.documentnumber ='7844551264657'
  and d.documentnumber ='7844562502648'
 --and d.documentid ='324472'
