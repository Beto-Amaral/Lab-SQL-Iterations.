drop procedure if exists update_account_table;

delimiter //
create procedure update_account_table (in param1 int, in param2 int, in param3 varchar(100), in param4 int, out param5 int)
begin
  declare continue handler for sqlexception
  select 'This account already exists in the database' message;
  insert into bank.account values(param1, param2, param3, param4);
  select 1 into param5;  
  -- we are using param 5 to check if the query is being executed or not. 
  -- Later when we call the stored procedure, we will try to print the value of this variable
end;
//
delimiter ;

call update_account_table(1,1,"131313", 31, @x);
select @x;