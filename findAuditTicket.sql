 --select tr.transactiondate 
 select d.*,i.*,fr.*,tr.*,p.*,pr.agentid as priagentId ,pr.*   
                 from emd_document d,emd_issuingagent i,emd_fare fr,emd_transaction tr,emd_passenger p,emd_pricing pr ,emd_coupon c    
                  where  d.firstdocumentid = i.documentid and d.firstdocumentid = fr.documentid(+) and d.documentid = tr.documentid     
                  and d.documentid = c.documentid and d.firstdocumentid = p.documentid and d.firstdocumentid = pr.documentid(+)     
                  and tr.transactiondate >= to_date('2015-12-10' ,'yyyy-MM-dd')     
                  and tr.transactiondate < to_date('2015-12-10' ,'yyyy-MM-dd')+1    
                  and tr.action = 'I'  
                  and tr.systemid = 'CZ'  
                   and tr.agentid ='CAN011'  --  office号 区分官网销售预付费选座  美玲的
                  and pr.internationalsale= 'I' 
