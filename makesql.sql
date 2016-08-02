 select /* IssueTransationSet */
      pl.pnrno ControlNumber,
      (select pm.bankgatewaycode from payment pm where pm.orderno='" + this.orderno + "' and pm.paystatus='P') as bankgateway,
      od.campaignscriptid,od.enterpricetype,od.bookuser, 
      --TICKET.GetEndor(pl.orderno) AS ENDOR,
      od.contact,
      /* TravelerGroup */

          cursor (select to_char(pb.bankacktime, 'YYMMDD') DateOfIssue,
                     /* TravelerSegment */
                     pi.mobilephone,
                     PS.psgname,
                     PS.type,
                     PS.age,
                     PS.birthdate,
                     decode(PS.idtype,'P','PP',PS.idtype) idtype , --//暂时解决证件类型导致无法值机的故障
                     PS.idcard,
                     PS.fpcompany,
                     PS.fpcardno,
                     PS.LARGECLIENTID,ps.isfeedback,--//added by qjc
                     --ticket.GetMaxSeg(pl.orderno) totalsegments,
                     ticket.GetTicketCountOfOnePassenger(pl.orderno, pl.pnrno) totaltickets,
                     (select f.tourcode from flightpricedomestic f where f.orderno = pl.orderno) tourcode,
                     (select al.city from segment seg, airportslist al where seg.ORDERNO = PS.ORDERNO and seg.segorder = 1 and seg.depairport = al.code and al.locale = 'en') as depCity,
                     --(select al.city from segment seg, airportslist al where seg.orderno = PS.ORDERNO and seg.segorder = ticket.GetMaxSeg(pl.orderno) and seg.arrairport = al.code and al.locale = 'en') as arrCity,
                     /* Price(FareSegment, TaxSegment, CommissionFeeSegment) */
                     cursor (SELECT SG.SEGORDER,SG.CABIN,   
                         cursor (select i.taxtype,i.taxamount From inteltaxtoorders i where
                         i.psgtype = PS.TYPE and i.taxtype is not null and i.taxtype != 'XT' and i.orderno = pl.orderno order by i.taxindex desc)  as detailtax,
                                     DECODE(PS.TYPE,0,FP.TAX1TYPE, DECODE(PS.TYPE,1,FP.CHILDTAX1TYPE,FP.INFANTTAX1TYPE)) AS TAXCODE1,
                                     DECODE(PS.TYPE,0,FP.ADULTTAX1, DECODE(PS.TYPE,1,FP.CHILDTAX1,FP.INFANTTAX1)) AS TAX1,
                                     DECODE(PS.TYPE,0,FP.TAX2TYPE, DECODE(PS.TYPE,1,FP.CHILDTAX2TYPE,FP.INFANTTAX2TYPE)) AS TAXCODE2,
                                     DECODE(PS.TYPE,0,FP.ADULTTAX2, DECODE(PS.TYPE,1,FP.CHILDTAX2,FP.INFANTTAX2)) AS TAX2,
                                     DECODE(PS.TYPE,0,FP.TAX3TYPE, DECODE(PS.TYPE,1,FP.CHILDTAX3TYPE,FP.INFANTTAX3TYPE)) AS TAXCODE3,
                                     DECODE(PS.TYPE,0,FP.ADULTTAX3, DECODE(PS.TYPE,1,FP.CHILDTAX3,FP.INFANTTAX3)) AS TAX3,
                                    DECODE(PS.TYPE, 0, SP.ADULTCOST, DECODE(PS.TYPE, 1, SP.CHILDCOST, SP.INFANTCOST)) AS FARECOST,
                                    DECODE(PS.TYPE, 0, SP.ADULTPRICE, DECODE(PS.TYPE, 1, SP.CHILDPRICE, SP.INFANTPRICE)) AS FAREPRICE,    
                               DECODE(PS.TYPE,0,SP.ADULTFAREBASIS,
                                      DECODE(PS.TYPE,1,SP.CHILDFAREBASIS,
                                             DECODE(PS.TYPE,2,SP.INFANTFAREBASIS))) AS FAREBASIS,
                               SP.ADULTFEERATE AS FEERATE,
                               SG.DEPAIRPORT,
                               SG.ARRAIRPORT,
                               to_char(SG.DEPTIME, 'DDMONYY', 'nls_date_language=AMERICAN') DepTime,    
                               SG.CARRIER, 
                               SG.COUPONNO,
                               SP.TRANSFERINDICATE,
                               0 BASICFEERATE,
                               0 XFEERATE,
                               0 PHASEFEERATE,
                               0 APPENDFEERATE,
                               DECODE(PS.TYPE,0,FP.ADULTEQUIVFARE,DECODE(PS.TYPE,1,FP.CHILDEQUIVFARE,FP.INFANTEQUIVFARE)) EQUIVFARE,
                               decode(PS.TYPE, 0, sp.adultbaggageallow, decode(PS.TYPE, 1, sp.childbaggageallow, sp.infantbaggageallow)) baggage,
                               FP.ROE,
                               FP.BSR,
                               0 BBR,
                               DECODE(PS.TYPE,0,FP.ADULTFC,DECODE(PS.TYPE,1,FP.CHILDFC,FP.INFANTFC)) FC,
                               NVL(FP.ORIGINALFARECURRENCY,'CNY') ORIGINALFARECURRENCY,
                               NVL(FP.EQUIVFARECURRENCY,'CNY') EQUIVFARECURRENCY,
                               SP.SEGTYPE
                               FROM SEGMENTPRICE SP, SEGMENT SG, FLIGHTPRICEDOMESTIC FP
                              where sp.orderno = pl.orderno and
                                    sg.orderno = pl.orderno and
                                    sp.segorder = sg.segorder and 
                                    fp.orderno = sp.orderno
                              order by sp.segorder) Prices,
                     /* TicketSegment */
                     cursor (select pt.ticketno,
                                    decode(od.groupflag,0,'F','G') groupflag,
                                    decode(od.domesticindicate,1,'D','I') tickettype,
                                    /* CouponSegment */
                                    cursor (select SEG.SEGORDER,
                                                   TO_CHAR(SEG.DEPTIME, 'HH24MI') DEPTIME,
                                                   TO_CHAR(SEG.ARRTIME, 'HH24MI') ARRTIME,
                                                   SEG.DEPTIME FLIGHTDATE,
                                                   SEG.CABIN,
                                                   SEG.FLIGHTNO,
                                                   SEG.CARRIER,
                                                   SEG.OC,
                                                   SEG.OCFLIGHTNO,
                                                   SEG.DEPAIRPORT,
                                                   SEG.ARRAIRPORT,
                                                   SEG.COUPONNO,
                                                   SP.ADULTNOTVALIDBEFORE,
                                                   SP.ADULTNOTVALIDAFTER
                                              from psgticket pt0, segment seg,segmentprice sp
                                             where pt0.orderno = seg.orderno and seg.orderno = sp.orderno and
                                                   pt0.segorder = seg.segorder and seg.segorder=sp.segorder and
                                                   pt0.ticketno = pt.ticketno order by SEG.SEGORDER) as Coupons
                               from psgticket pt
                              where pt.orderno = pl.orderno and
                                    pt.psgname = PS.Psgname
                              group by pt.ticketno
                              order by pt.ticketno) as Tickets

                  from passenger PS,payment pm,paybill pb ,passengerinfo pi
                 where PS.orderno = pl.orderno and PS.Pnrno = pl.pnrno and PS.orderno=pm.orderno and pm.billno=pb.billno 
                  and ps.orderno = pi.orderno(+) and ps.psgname = pi.psgname(+) and pb.paystatus='P') as TravelerGroups
       from pnrlist pl, orders od
      where pl.orderno = 'B1509140021305' and pl.pnrno = 'MFS4SZ' and
            od.orderno = pl.orderno
