CREATE OR REPLACE PROCEDURE RATE_EMD
(
  BEGINDATE IN VARCHAR2  
, ENDDATE IN VARCHAR2  
) AS 

v_currency varchar2(3);
v_systemID varchar2(12);
     
v_start_time date;
v_end_time date;    

v_sqlcode number;
v_sqlerrm varchar2(200); 

curdate varchar2(20);
nextdate varchar2(20);

TYPE iatanumber_array IS TABLE OF varchar2(12)
INDEX BY BINARY_INTEGER;

systemid iatanumber_array;


cursor C1 is
  select /*+ordered use_nl(t,f)*/ distinct f.currency
     from emd_transaction t, emd_fare f
     where f.documentid =t.documentid 
     and t.action = 'I'
     and t.transactiondate >= to_date(curdate,'YYYY-MM-DD')
     and t.transactiondate < to_date(nextdate,'YYYY-MM-DD')
     order by f.currency asc;   

begin    
     --³õÊ¼»¯
     
     v_start_time := sysdate;
     if beginDate is null or beginDate = '' then
        curdate := to_char(sysdate -1 ,'YYYY-MM-DD');
     else
        curdate := beginDate;     
     end if;
     
     if endDate is null or beginDate = '' then 
        nextdate := to_char(sysdate ,'YYYY-MM-DD');
     else
        nextdate := endDate;
     end if;
    
    
    --curdate := to_char(sysdate -1 ,'YYYY-MM-DD');
    --nextdate := to_char(sysdate ,'YYYY-MM-DD');    
    
    systemid(1) := 'CZECS';  --??
    systemid(2) := 'CZ'; --??    
    --SELLSTATISTICPREDATE_EMD('2013-01-23','2013-01-24','CZ','CNY');                      
      
     for I in C1 loop

         if I.currency is not null then
            v_currency := I.currency;    

            FOR k IN 1..systemid.count LOOP
                v_systemID := systemid(k);
                SELLSTATISTICPREDATE_EMD(curdate,nextdate,v_systemID,v_currency);


            END LOOP;  
         end if;

     end loop;
         
     if C1%isopen then
        close C1;
     end if;
     v_end_time := sysdate;
     
     
     --write log success
     insert into EMD_INSERTDATA_LOG (PROCESS_DATE,PROCESS_NAME,START_TIME,
                                  END_TIME,PROCESSED_RECORDS)values
                                  (trunc(sysdate),'RateTest',v_start_time,v_end_time,'');
     commit;

EXCEPTION
WHEN OTHERS
THEN
     ROLLBACK;
     v_sqlcode := sqlcode;
     v_sqlerrm := sqlerrm;
     
     --write log failure
     insert into EMD_INSERTDATA_LOG (PROCESS_DATE,PROCESS_NAME,START_TIME,END_TIME,
                                     ERR_SEQUENCE,ERR_TICKETNO,sql_code,sql_SQLERRM)values
                                    (trunc(sysdate),'RateTest',v_start_time,v_end_time,
                                     v_currency,v_systemID,v_sqlcode,v_sqlerrm);
     commit;
     
     if C1%isopen then
        close C1;
     end if;
     
     
END RATE_EMD;
/
