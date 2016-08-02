select d.documentnumber,a.ticketnumber ,f.fare,f.origincurrency,d.dateofissue,c.reasonsubcode
from emd_document d ,emd_association a ,emd_coupon c,emd_fare f,emd_transaction tr
where d.documentid=c.documentid
and d.documentid=f.documentid
and c.couponid=a.couponid
and d.documentid = tr.documentid

and c.couponnumber='1'

and  tr.systemid='CZ'
and c.reasonsubcode='0B5'
and tr.agentid ='CAN011'
and  d.dateofissue>='151228'
and  d.dateofissue<='160103'
order by d.dateofissue asc
--select * from emd_coupon c where 
--c.couponnumber='2'
--c.couponid='5602'
