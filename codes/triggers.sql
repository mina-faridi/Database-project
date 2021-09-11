#triggers

drop trigger if exists notify_borrow;
delimiter $$
create trigger notify_borrow before insert
on borrow_history
for each row begin
	if new.success=true then
		select ('successful borrow');
        select new;
	end if;
end$$

drop trigger if exists notify_return;
delimiter $$
create trigger notify_return before update
on borrow_history
for each row begin
	if new.success=true then
		select ('return');
		select new;
	end if;

end$$