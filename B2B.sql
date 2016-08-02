select * from orders o where  o.orderno='B1509140021305'

select * from PAYMENT PM where  pm.orderno='C1509170014302'

select * from PNRLIST PNR where  PNR.orderno='C1509170014302'

select * from B2CORDER_CHANNEL CHANNEL where  CHANNEL.orderno='C1509170014302'

select pm.paystatus,pnr.*,o.* from PNRLIST PNR ,PAYMENT PM,orders o 
where  PNR.orderno='C1509170014302' and pnr.orderno=pm.orderno and o.orderno=pnr.orderno

select * from TRACEOFPROCESS t where  t.itemno='B1509140021305'

select * from REPAYBILL r where  r.repaybillno='R14103107850'    R14103107850   R15032602118

select * from USERPROFILE u where u.userguid='shatzjun'   shatzjun

select * from  segmentprice s where s.orderno='B1509140021305'

select * from flightpricedomestic f  where f.orderno='B1509140021305'

select max(u.id) from userloginhistory u;

select * from userloginhistory u where u.id>229903837-1200000 and u.id<229903837-900000 and u.userguid='shatzjun'   order by u.id desc;

select * from reportrequest;

select * from reportconfig ff where ff.reportid='6'

select * from orders o ,segmentprice s where o.domesticindicate='1' and s.segorder=2 and o.orderno=s.orderno and rownum >1 and rownum<50000
