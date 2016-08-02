select t.ticketnumber,
       t.totaltickets,
       t.dateofissue,
       c.couponnumber,
       c.status,
       i.iatacode,
       tr.userid,
       f.originairport,
       f.destinationairport,
       f.departuretime,
       pr.internationalsale,
       p.name,
       f.carrier,
       f.flightno,
       f.flightdate,
       f.flightclass,
       i.systemid,
       tr.userid,
       i.agentcity,
       i.iatacode,
       c.farebasis,
       p.type,
       t.tourcode
  from ets_ticket       t,
       ets_coupon       c,
       ets_passenger    p,
       ets_issuingagent i,
       ets_transaction  tr,
        ets_flight f,
        ets_pricing pr
 where t.firstticketid = c.ticketid
   and t.firstticketid = p.ticketid
   and t.firstticketid = i.ticketid
   and t.firstticketid = tr.ticketid
   and f.couponid = c.couponid
   and pr.ticketid=t.ticketid
  -- and t.totaltickets = 2
   and tr.action = 'I'
   and tr.transactiondate > to_date('20160501', 'YYMMDD')
   and tr.transactiondate < to_date('20160720', 'YYMMDD') + 1
   and c.status = 'F'
  -- and p.type = 0

