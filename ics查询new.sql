select count(*),sum(fr.fare * r.sellingrate),max(tr.transactiondate),min(tr.transactiondate)
 --select *-- d.documentnumber,tr.*,c.couponnumber,c.status, fc.carrier,fr.fare,fr.currency , fr.fare * r.sellingrate 
   --select tr.transactiondate

    from  emd_document d,emd_coupon c, emd_fare fr ,emd_transaction tr,emd_rate r,emd_flightcontent fc,emd_association ea
  --,emd_coupontransaction ct
        where  d.documentid = tr.documentid
         -- and  documentnumber='7844562000209'
          and  d.firstdocumentid = fr.documentid
          and  fR.origincurrency = r.currencyname
          and c.couponid = fc.couponid 
          and c.couponid = ea.couponid 
          and tr.transactiondate >=to_date('2016-03-17' ,'yyyy-MM-dd')   
          and tr.transactiondate <to_date('2016-03-23','yyyy-MM-dd')+1
        --and fc.carrier = 'CZ' 
          and tr.systemid='CZ'
          and tr.action ='I'
      -- and c.status='R'   --¶ÎÓÀÌÎ²éÑ¯
          --and c.status  not in('F','G','R','V','E','X')   
          --and tr.action not in('B','RF','X','E','V','G')   
          and c.reasonsubcode='0B5'
         -- and tr.agentid £¡='CAN011'   ---¶ÎÓÀÌÎ  officeºÅ Çø·Ö¹ÙÍøºÍº½ĞÅÏúÊÛÔ¤¸¶·ÑÑ¡×ù 
          and tr.agentid ='CAN011'  --ÃÀÁáµÄ ²éÑ¯
          and d.documentid = c.documentid 
        --  and ct.documentid = c.documentid       ´íÎó
         -- and ct.couponnumber = c.couponnumber   ´íÎó
        
        
          
          
 
