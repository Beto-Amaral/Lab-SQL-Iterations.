use bank;

drop procedure if exists average_loss_status_regiom_proc;

delimiter //
create procedure average_loss_status_regiom_proc (in param1 varchar(10), in param2 varchar(100), out param3 varchar(20))
begin
  declare avg_loss_region float default 0.0; -- Declaring variables
  declare zone varchar(20) default "";

  -- Get the average loss of the users in the status "param1" and in the region "param2"
  select round((sum(amount) - sum(payments))/count(*), 2) into avg_loss_region
  from (
    select a.account_id, d.A2 as district, d.A3 as region, l.amount, l.payments, l.status from bank.account as a
    join bank.district as d
    on a.district_id = d.A1
    join bank.loan  as l
    on l.account_id = a.account_id
    where l.status COLLATE utf8mb4_general_ci = param1
    and d.A3 COLLATE utf8mb4_general_ci = param2
  ) as sub1;
  
select avg_loss_region;

  if avg_loss_region > 700000 then
    set zone = 'Red Zone';
  elseif avg_loss_region <= 70000 and avg_loss_region > 40000 then
    set zone = 'Orange Zone';
  else
    set zone = 'Green Zone';
  end if;

  select zone into param3;
end;
//
delimiter ;

call average_loss_status_regiom_proc("A", "Prague", @x);
select round(@x,2) as Average_loss_in_region;