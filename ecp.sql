

--select count(*),sum(fr.fare * r.sellingrate) 
select d.documentnumber,C.Reasonsubcode,fl.originairport,fl.destinationAIRPORT,pr.agentid as priagentId ,pr.*   
                 from emd_document d,emd_issuingagent i,emd_fare fr,emd_transaction tr,emd_passenger p,
                 emd_pricing pr ,emd_coupon c ,emd_flightcontent fl,emd_rate r
                  where  d.firstdocumentid = i.documentid and d.firstdocumentid = fr.documentid(+) 
                  and d.documentid = tr.documentid     
                  and c.couponid=fl.couponid
                  AND  fR.currency = r.currencyname
                  and d.documentid = c.documentid and d.firstdocumentid = p.documentid 
                  and d.firstdocumentid = pr.documentid(+)     
                  and tr.transactiondate >= to_date('2015-5-01','yyyy-MM-dd')     
                  and tr.transactiondate < to_date('2015-12-31','yyyy-MM-dd')+1    
                  and tr.action = 'I'  
                  and tr.systemid = 'ecp'     
                  --and pr.internationalsale= 'I'
                  and c.reasonsubcode='0B5'
                 and tr.agentid ='CAN011' 
                 -- and pr.internationalsale= 'I'
                  order by d.documentnumber desc
