use sakila; 


drop procedure if exists store_payments;
delimiter //
create procedure store_payments (in id int, out total_sales_value float)
begin 
#declare total_sales_value float default 0.0;

select sum(p.amount) into total_sales_value 

from store as s
join staff as st
	on s.store_id=p.staff_id
join payment as p
	on st.staff_id=p.staff_id
group by s.store_id
having store_id = id ; 
#select total_sales_value;
#set total_sales_value = 0.0 ;
end
//
delimiter ;

call store_payment(2, @x)

select @x as storerevenue; 

 drop procedure if exists store_flag;
delimiter //
create procedure store_flag(in store_input integer, out flag varchar(20))
begin
declare total_sales_value float default 0.0;
declare fla varchar(20) default "";
select sum(p.amount) into total_sales_value
from store as s
join staff as st
	on s.store_id=st.store_id
join payment as p
	on st.staff_id=p.staff_id
where s.store_id = store_input
group by s.store_id;
case
	when total_sales_value > 30000 then
		set flag = 'green';
	else
		set flag = 'red';
  end case;  
  select flag into flag;
select flag;    
end;
//
delimiter ;

call store_flag(1, @x);






