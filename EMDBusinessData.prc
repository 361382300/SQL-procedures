CREATE OR REPLACE PROCEDURE EMDBusinessData
(
  BEGINDATE IN VARCHAR2  default ''
, ENDDATE IN VARCHAR2  default ''
) AS 

v_currency varchar2(3);
v_systemID varchar2(12);
v_businesstype varchar2(30);
     
v_start_time date;
v_end_time date;    

v_sqlcode number;
v_sqlerrm varchar2(200); 

curdate varchar2(20);
nextdate varchar2(20);

TYPE iatanumber_array IS TABLE OF varchar2(12)
INDEX BY BINARY_INTEGER;

systemid iatanumber_array;

TYPE businesstype_array IS TABLE OF varchar2(30)
INDEX BY BINARY_INTEGER;
businesstype businesstype_array;

cursor C1 is
  select /*+ordered use_nl(t,f)*/ distinct f.currency
     from emd_transaction t, emd_fare f
     where f.documentid =t.documentid 
     and t.action = 'I'
     and t.transactiondate >= to_date(curdate,'YYYY-MM-DD')
     and t.transactiondate < to_date(nextdate,'YYYY-MM-DD')
     order by f.currency asc;   

begin    
     --初始化
     dbms_output.put_line('EMDBusinessData..begin');
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
     --日期
    dbms_output.put_line('curdate is: '||curdate);
    dbms_output.put_line('nextdate is: '||nextdate);
    
    --curdate := to_char(sysdate -1 ,'YYYY-MM-DD');
    --nextdate := to_char(sysdate ,'YYYY-MM-DD');    
    C1.
       systemid(1) := 'ECSEMD';  --??
       systemid(2) := 'ICSEMD'; --??   
       systemid(3) := 'GDSEMD'; --??   
       businesstype(1):='advanceseat';
       businesstype(2):='excessbaggage';
     for I in C1 loop
         if I.currency is not null then
            v_currency := I.currency;  

              FOR b IN 1..businesstype.count LOOP
                  v_businesstype:=businesstype(b);
                  FOR k IN 1..systemid.count LOOP                
                  v_systemID := systemid(k);
                  if v_systemID = 'ECSEMD' then
                    dbms_output.put_line('CL..v_currency'||v_currency||v_systemID);
                    CLECS(curdate,nextdate,v_systemID,v_currency,v_businesstype);
                  end if;
                  if v_systemID = 'ICSEMD' then
                    dbms_output.put_line('CL..v_currency'||v_currency||v_systemID);
                    CLICS(curdate,nextdate,v_systemID,v_currency,v_businesstype);
                  end if;
                  if v_systemID = 'GDSEMD' then
                    dbms_output.put_line('CL..v_currency'||v_currency||v_systemID);
                    CLGDS(curdate,nextdate,v_systemID,v_currency,v_businesstype);
                  end if;
                  
                END LOOP;  
            END LOOP;  
         end if;

     end loop;
     dbms_output.put_line('C1 SIZE: '||cursor_name%ROWCOUNT);
     
         
     if C1%isopen then
        close C1;
     end if;
     v_end_time := sysdate;
     
     
     --write log success
     insert into EMD_INSERTDATA_LOG (PROCESS_DATE,PROCESS_NAME,START_TIME,
                                  END_TIME,PROCESSED_RECORDS)values
                                  (trunc(sysdate),'EMDBusinessData',v_start_time,v_end_time,'');
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
                                    (trunc(sysdate),'EMDBusinessData',v_start_time,v_end_time,
                                     v_currency,v_systemID,v_sqlcode,v_sqlerrm);
     commit;
     
     if C1%isopen then
        close C1;
     end if;
     
     
END EMDBusinessData;
/
