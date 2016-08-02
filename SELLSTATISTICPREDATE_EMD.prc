CREATE OR REPLACE PROCEDURE SELLSTATISTICPREDATE_EMD
( CURDATE IN VARCHAR2  
, NEXTDATE IN VARCHAR2  
, STYLE IN VARCHAR2  
, EXCURRENCY IN VARCHAR2  
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
   emp_currency varchar2(3));
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

v_acount number(10);
v_ticketamount number(12,2);
v_ticketid varchar2(10);
v_fare number(12);
v_sellingrate varchar2(10);

--????
Error_Modify_failure exception;

begin

    open v_cursor1 for      
      select /*+ordered use_nl(t,f,tt)*/ count(*) acount,sum(f.documentamount) ticketamount 
    from emd_transaction t, emd_fare f,emd_document tt
    where f.documentid =t.documentid 
    and t.documentid = tt.documentid
    and f.currency = excurrency
    and t.action = 'I'
    and t.systemid = style
    and tt.documentnumber like '784%'
    and t.transactiondate >= to_date(curdate,'YYYY-MM-DD')
    and t.transactiondate < to_date(nextdate,'YYYY-MM-DD');    
      
    -- AUSWEB???
    open v_cursor2 for
      select /*+ordered use_nl(t,f,tt,r)*/ f.documentid,f.fare,r.sellingrate
    from emd_transaction t,emd_fare f,emd_rate r,emd_document tt
    where t.documentid = f.documentid
    and t.documentid = tt.documentid
    and f.origincurrency = r.currencyname  
    and f.currency = excurrency
    and t.action = 'I'
    and t.systemid = style
    and tt.documentnumber like '784%'
    and t.transactiondate >= to_date(curdate,'YYYY-MM-DD')
    and t.transactiondate < to_date(nextdate,'YYYY-MM-DD');
    
  
   loop
   fetch v_cursor1 into v_acount,v_ticketamount;
       exit when v_cursor1%NOTFOUND;
       
        --??C1????????
        if v_acount <= 0 then
           return;
        end if; 
       
       --??middleRate
        select count(*) into Rate from emd_rate r where r.currencyname = excurrency;
        
        if (Rate != 0) then
           select r.sellingrate into Rate from emd_rate r where r.currencyname = excurrency;
        else
           Myemp.emp_departure := 0;     --???????0??????????????
        end if;
        
        v_date := to_date(curdate,'YYYY-MM-DD');
        
        Myemp.emp_date:=to_char(v_date,'yymmdd');
        Myemp.emp_style:= style;
                
        Myemp.emp_count:=v_acount;
        Myemp.emp_total:=v_ticketamount * Rate;
        MyEmp.emp_currency := excurrency;
        
        
         
        if (Rate != 0 and v_cursor2%isopen) then           --?????????0????????
          loop
          fetch v_cursor2 into v_ticketid,v_fare,v_sellingrate;
            -- fare
            TempFare := TempFare + v_fare * v_sellingrate;
      
                     
            
            exit when v_cursor2%NOTFOUND;
          end loop;
          
          
          Myemp.emp_fare:=TempFare;
          
            end if;
         if v_cursor2%isopen then
            close v_cursor2;
         end if;
        
        MyArray(v_cursor1%rowcount):= Myemp;
        
   --exit when v_cursor1%NOTFOUND;
   end loop;
--????
    if v_cursor1%isopen then
        close v_cursor1;
     end if;

--????????
    delete from emd_statistics st
    where st.statdate = to_char(v_date,'yymmdd') 
    and st.currency = excurrency;

--?? Ets_Statistics ?
    for i in 1..MyArray.count loop
    
        insert into emd_statistics values(
               Myarray(i).emp_date,Myarray(i).emp_style,Myarray(i).emp_count,Myarray(i).emp_fare,
               Myarray(i).emp_tax,Myarray(i).emp_total,Myarray(i).emp_departure,Myarray(i).emp_currency);
                
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
  
END SELLSTATISTICPREDATE_EMD;
/
