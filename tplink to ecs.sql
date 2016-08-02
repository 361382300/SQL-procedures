select st.emdno,
       st.seatrefundno,
       st.cost,
       srr.repaymoney,
       sr.currency,
       sr.*,
       (select a.settlementno
          from ecs.agentprofile@ecsrep_link a
         where a.orgunitguid = sr.ticketoutagentid) settlementno
  from ecs.seatrefund@ecsrep_link      sr,
       ecs.seatticket@ecsrep_link      st,
       ecs.seatrefundrepay@ecsrep_link srr,
       ecs.repaybill@ecsrep_link       rb,
       ecs.seatselection@ecsrep_link   seats
 where sr.seatorderno = st.seatorderno
   and seats.seatorderno = st.seatorderno
   and sr.seatrefundno = srr.seatrefundno
   and srr.repaybillno = rb.repaybillno
   and rb.repaystatus = 'Y'
   AND rb.repaydate >= to_date('2016-06-01', 'yyyy-MM-dd')
   AND rb.repaydate < to_date('2016-06-01', 'yyyy-MM-dd') + 1
   and seats.type = 3
   and seats.domesticindicate = 0
   
  
