select * from ets_ticket  t ,ets_coupon c   where t.ticketnumber='7844028032417' and t.ticketid=c.ticketid


    select t.ticketnumber,c.couponNumber,c.status,p.internationalsale,f.flightno,f.flightdate,c.settlementauthoration,c.involuntary,c.ISSUEDINEXCHANGEFOR,c.farebasis,c.transfer,c.mconumber,f.* 
         from ets_flight f,ets_coupon c,ets_ticket t ,ets_pricing p
         where  t.ticketid= c.ticketid  
         and c.couponid = f.couponid   
         and t.ticketid= p.ticketid
         and c.status='A' 
         and f.carrier='CZ'  
       -- and p.internationalsale='D'
         --and f.flightno='6304'
         and f.originairport='WUH'
        and f.flightdate >= to_date('2015-11-20-00-00-00','YYYY-MM-DD-HH24-MI-SS')  
       and f.flightdate < to_date('2015-12-10-23-59-59','YYYY-MM-DD-HH24-MI-SS') 
