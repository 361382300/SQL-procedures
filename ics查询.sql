select count(*),sum(fr.fare * r.sellingrate) 
 --select d.documentnumber,tr.*,c.couponnumber,c.status, fc.carrier,fr.fare,fr.currency , fr.fare * r.sellingrate 
    

    from  emd_document d,emd_coupon c, emd_fare fr ,emd_transaction tr,emd_rate r,emd_flightcontent fc,emd_association ea,
    emd_coupontransaction ct
        where  d.documentid = tr.documentid
         -- and  documentnumber='7844562000209'
          and  d.firstdocumentid = fr.documentid
          and  fr.currency = r.currencyname
          and c.couponid = fc.couponid 
          and c.couponid = ea.couponid 
          and tr.transactiondate >=to_date('2015-12-1' ,'yyyy-MM-dd')   
          and tr.transactiondate <to_date('2015-12-03','yyyy-MM-dd')+1
          --and fc.carrier = 'CZ' 
          and tr.systemid='CZ'
          and tr.action ='I'
       and c.status='R'   --段用涛查询
          --and c.status  not in('F','G','R','V','E','X')   
          --and tr.action not in('B','RF','X','E','V','G')   
          and c.reasonsubcode='0B5'
          and tr.agentid ！='CAN011'   --- office号 区分官网销售预付费选座
          ---and tr.agentid ='CAN011'  美玲的 查询
          and d.documentid = c.documentid 
          and ct.documentid = c.documentid   
          and ct.couponnumber = c.couponnumber 
          ---	1128	295699.930145

          --refund	38	18837.553376
