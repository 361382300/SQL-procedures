select d.documentnumber,
a.ticketnumber,
       c.status,
       f.originairport,
       f.destinationairport,
       fr.fare,
       fr.origincurrency,
       fr.equivfarepd,
       fr.currency,
       c.reasonsubcode,       
       d.dateofissue,
       f.carrier,
       f.flightno
  from emd_document d, emd_coupon c, emd_flightcontent f,emd_association a,emd_fare fr
 where d.documentid = c.documentid
   and c.couponid = f.couponid
   and d.documentid=fr.documentid
   and c.couponid=a.couponid
   and c.reasonsubcode = '0DG' 
   and d.dateofissue>=160701
   and d.dateofissue<=160712
