select d.documentNumber from emd_document d,emd_coupon c,emd_transaction tr 
         where d.documentid=c.documentid 
         and d.documentid=tr.documentid 
         and c.status in ('F', 'G', 'R', 'V', 'E', 'X') 
         and tr.action in ('B', 'G', 'RF', 'X', 'E', 'V') 
         and tr.transactiondate>=to_date(?,'yyyy-MM-dd') 
         and tr.transactiondate<to_date(?,'yyyy-MM-dd') 
