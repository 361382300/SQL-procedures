select tr.systemid, count(*) emdNumber, sum(fr.fare * r.sellingrate) emdFare
                 from emd_document d,emd_issuingagent i,emd_fare fr,emd_transaction tr,emd_passenger p,emd_pricing pr ,emd_coupon c ,
                 emd_flightcontent fc,emd_rate r,emd_flightcontent fl
                  Where  D.Firstdocumentid = I.Documentid And D.Firstdocumentid = Fr.Documentid(+) And D.Documentid = Tr.Documentid      
                  and d.firstdocumentid = p.documentid and d.firstdocumentid = pr.documentid(+)  
                  and c.documentid= d.documentid
                  and c.couponid=fl.couponid
                  AND  fR.origincurrency = r.currencyname
                  and fc.couponid=c.couponid
                  and tr.transactiondate >= to_date('2016-5-5' ,'yyyy-MM-dd')      
                  and tr.transactiondate < to_date('2016-5-11' ,'yyyy-MM-dd')+1  
                  and tr.action = 'I'      
                  and tr.systemid in('1A','1S','1B','1F','1P','1G','1V','K1','1J')
                  and pr.internationalsale= 'I'
                  group by  tr.systemid 



