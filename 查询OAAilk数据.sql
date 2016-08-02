select f1.*,f1.documentamount,t.*,c.couponid,c.couponNumber,c.settlementauthoration,c.status,c.involuntary,c.ISSUEDINEXCHANGEFOR,c.farebasis,c.reasonsubcode,f.*,pi.INTERNATIONALSALE
                         from emd_fare f1,emd_flightcontent f,emd_coupon c,emd_document t, emd_pricing pi 
                        where  t.documentId= c.documentId and t.documentId = f1.documentId and c.couponid = f.couponid 
                         --and c.status='F' 
                         and f.carrier='CZ' 
                        --and f.flightdate >= to_date('2016-01-18','YYYY-MM-DD')
                       -- and f.flightdate < to_date('2016-01-18','YYYY-MM-DD')+1
                        and pi.documentid=t.firstdocumentId  and c.reasonsubcode IN ('0AA') and pi.INTERNATIONALSALE='I'
                       
