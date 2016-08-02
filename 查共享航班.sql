select * from ets_ticket t,ets_coupon c ,ets_flight f
where t.ticketid=c.ticketid
and c.couponid=f.couponid
--and f.originairport='XMN'
and f.flightdate>=to_date('2016-05-05','YYYY-MM-DD')
and f.flightdate<to_date('2016-05-05','YYYY-MM-DD')+1
--and f.marketingflightno='5238'
and c.couponnumber=2
and  T.ticketnumber in(

select * from ets_ticket t,ets_coupon c ,ets_flight f
where t.ticketid=c.ticketid
and c.couponid=f.couponid
and f.originairport='CAN'
and f.destinationairport='XMN'
and f.flightdate>=to_date('2016-05-05','YYYY-MM-DD')
and f.flightdate<to_date('2016-05-05','YYYY-MM-DD')+1
--and f.marketingflightno='5238'
and f.carrier='MF'
and f.marketingcarrier='CZ'
and t.totalsegments=1
and c.couponnumber=1
and f.departuretime>'1200'
)

--and t.ticketnumber='7312387644226'
--AND ROWNUM < 30

