drop procedure if exists average_loss_status_regiom_proc;

delimiter //
create procedure average_loss_status_regiom_proc (in param1 varchar(10), in param2 varchar(100), out param3 varchar(20))
begin
  declare avg_loss_region float default 0.0;
  declare zone varchar(20) default "";
  
  select round((sum(amount) - sum(payments))/count(*), 2) into avg_loss_region
  from (
    select a.account_id, d.A2 as district, d.A3 as region, l.amount, l.payments, l.status
    from bank.account a
    join bank.district d
    on a.district_id = d.A1
    join bank.loan l
    on l.account_id = a.account_id
    where l.status COLLATE utf8mb4_general_ci = param1
    and d.A3 COLLATE utf8mb4_general_ci = param2
  ) sub1;

  select avg_loss_region;

  case
    when avg_loss_region > 50000 then
      set zone = 'PLATINUM';
    when avg_loss_region <= 50000 AND avg_loss_region > 10000 then
      set zone = 'GOLD';
  else
    set zone = 'SILVER';
  end case;

  select zone into param3;
end;
//
delimiter ;

call average_loss_status_regiom_proc("A", "Prague", @x);
select @x as Zone_type;