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
       i.systemid,
       i.iatacode,
       p.internationalsale,
       e.*,
       fr.fare,
       fr.currency
  from emd_document             d,
       emd_coupon               c,
       emd_flightcontent        fc,
       emd_excessbaggagecontent e,
       emd_issuingagent         i,
       emd_pricing              p,
       emd_fare                 fr,
       emd_transaction          tr,
       emd_coupontransaction    ct
 where d.documentid = tr.documentid
   and tr.transactionid = ct.transactionid
   and c.couponid = fc.couponid
   and c.couponid = e.couponid(+)
   and d.firstdocumentid = i.documentid
   and d.firstdocumentid = p.documentid(+)
   and d.firstdocumentid = fr.documentid
   and tr.transactiondate >= to_date('2016-04-15', 'yyyy-MM-dd')
   and tr.transactiondate < to_date('2016-04-15', 'yyyy-MM-dd') + 1
   and p.internationalsale = 'D'
   and fc.carrier = 'CZ'
   and c.status in ('F', 'G', 'R', 'V', 'E', 'X')
   and tr.action in ('B', 'RF', 'X', 'E', 'V', 'G')
   and ct.documentid = c.documentid
   and ct.couponnumber = c.couponnumber
