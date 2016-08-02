CREATE OR REPLACE PROCEDURE CLICS
( CURDATE IN VARCHAR2  
, NEXTDATE IN VARCHAR2  
, STYLE IN VARCHAR2  
, EXCURRENCY IN VARCHAR2  
, BUSINESSTYPE IN VARCHAR2  
) AS 

--????
TYPE ref_type_name IS REF CURSOR;

v_cursor1 ref_type_name;
v_cursor2 ref_type_name;

--????????
  type emp_type is record
  (emp_date varchar(6),
   emp_style varchar2(15),
   emp_count number(10),
   emp_fare number(12,2),
   emp_tax number(11,2),
   emp_total number(12,2),
   emp_departure number(12),
   emp_site varchar2(5),
   emp_currency varchar2(3),
   emp_businesstype varchar2(30));
MyEmp emp_type;
 
   
--??table
  type testarray is 
  table of emp_type
  index by binary_integer;
MyArray testarray;

--??TAX
TempCNTax number(12,2) := 0 ;
TempYQTax number(12,2) := 0 ;
TempOtherTax number(12,2) := 0 ;
Rate number(12,2) := 0;
TempFare number(12,2) := 0;
v_date date;

v_acount number(10):= 0;
v_ticketamount number(12,2):= 0;
v_ticketid varchar2(10);
v_fare number(12);
v_sellingrate varchar2(10);
v_businesstype varchar2(30);
v_style varchar2(128);
v_i number(10):=0;
--????
Error_Modify_failure exception;

begin
  v_businesstype :='%'||BUSINESSTYPE||'%';
  dbms_output.put_line('CL..begin');
  dbms_output.put_line('v_businesstype is: '||v_businesstype);

    for v_cursor1 in (
        select /*+ordered use_nl(t,f,tt,c)*/ count(*) acount,sum(f.documentamount) ticketamount 
      from emd_transaction t, emd_fare f,emd_document tt,emd_coupon c
      where f.documentid =t.documentid 
      and c.documentid = t.documentid
      and c.couponnumber=1
      and lower(c.businesstype) like v_businesstype
      and t.documentid = tt.documentid
      and f.currency = excurrency
      and t.action = 'I'
      and t.systemid in ('CZ','CA','1E')
      and tt.documentnumber like '784%'
      and t.transactiondate >= to_date(curdate,'YYYY-MM-DD')
      and t.transactiondate < to_date(nextdate,'YYYY-MM-DD')
      
      )
   loop
     v_i:=v_i+1; 
     v_acount:= v_cursor1.acount;
     v_ticketamount:=v_cursor1.ticketamount;       
     dbms_output.put_line('v_acount is '||v_acount);
        --??C1????????
        if v_acount <= 0 then
            dbms_output.put_line('return..');
           return;
        end if; 
       
       --??middleRate 判断是否有该汇率
        select count(*) into Rate from emd_rate r where r.currencyname = excurrency;
       
        dbms_output.put_line(Rate);
       
        if (Rate != 0) then
           select r.sellingrate into Rate from emd_rate r where r.currencyname = excurrency;
        else
           Myemp.emp_departure := 0;     --???????0??????????????
        end if;
        dbms_output.put_line('Rate is '||Rate);
        v_date := to_date(curdate,'YYYY-MM-DD');
        Myemp.emp_date:=to_char(v_date,'yymmdd');
        Myemp.emp_style:= style;
        Myemp.emp_count:=v_acount;
        Myemp.emp_total:=v_ticketamount * Rate;
        MyEmp.emp_currency := excurrency;
        MyEmp.emp_businesstype:=businesstype;
          
        if (Rate != 0 ) then           --?????????0????????
          for v_cursor2 in (
                      select /*+ordered use_nl(t,f,tt,r,c)*/ f.documentid,f.fare,r.sellingrate
                from emd_transaction t,emd_fare f,emd_rate r,emd_document tt,emd_coupon c
                where t.documentid = f.documentid
                and c.documentid = t.documentid
                and c.couponnumber=1
                and lower(c.businesstype) like v_businesstype
                and t.documentid = tt.documentid
                and f.origincurrency = r.currencyname  
                and f.currency = excurrency
                and t.action = 'I'
                and t.systemid in ('CZ','CA','1E')
                and tt.documentnumber like '784%'
                and t.transactiondate >= to_date(curdate,'YYYY-MM-DD')
                and t.transactiondate < to_date(nextdate,'YYYY-MM-DD')
                 )
          loop
          
          v_ticketid := v_cursor2.documentid;
          dbms_output.put_line('v_ticketid is '||v_ticketid);
          v_fare := v_cursor2.fare;
          v_sellingrate := v_cursor2.sellingrate;
          
          TempFare := TempFare + v_fare * v_sellingrate;
          end loop;
          Myemp.emp_fare:=TempFare;
          
         end if;
     
        MyArray(v_i):= Myemp;
       
   --exit when v_cursor1%NOTFOUND;
   end loop;
--????
  dbms_output.put_line('end..');
--????????
    delete from EMD_BUSINESSDATA st
    where st.statdate = to_char(v_date,'yymmdd') 
    and st.currency = excurrency;
  dbms_output.put_line('end...');
--?? Ets_Statistics ?
    for i in 1..MyArray.count loop
      dbms_output.put_line('end...');
        insert into EMD_BUSINESSDATA values(
               Myarray(i).emp_date,Myarray(i).emp_style,Myarray(i).emp_count,Myarray(i).emp_fare,
               Myarray(i).emp_tax,Myarray(i).emp_total,Myarray(i).emp_departure,Myarray(i).emp_currency,
               Myarray(i).emp_businesstype);
                
    end loop;
    
    commit;

exception
when others 
then
     rollback;

      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(sqlcode);
      
     if v_cursor2%isopen then
        close v_cursor2;
     end if;
     
     if v_cursor1%isopen then
        close v_cursor1;
     end if;
  
END CLICS;
/
