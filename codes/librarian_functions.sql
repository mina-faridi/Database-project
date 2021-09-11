#librarian functions

drop procedure if exists add_book;
delimiter $$
create procedure add_book(in session_tag varchar(300), in title varchar(30),in subject varchar(30),in pages int,in price int,in publisher varchar(30),
                    in author varchar(30),in publish_date date,in version varchar(10))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		 insert into book values (null, title, subject, pages, price, publisher, author, publish_date, version);
         select('success');
	else
			select('who are you?');
	end if;
	
end $$
delimiter ;

drop procedure if exists add_copy;
delimiter $$
create procedure add_copy(in session_tag varchar(300), in title varchar(30))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		set @book_id=(select b.book_id from book b where b.title=title);
		if not(isnull(@book_id))then    
			insert into copy values (null, title, subject, pages, price, publisher, author, publish_date, version);
            select('success');
		else
			select('book doesnt exist');
        end if;
	else
			select('who are you?');
	end if;
	
end $$
delimiter ;


drop procedure if exists get_succesfull_borrows;
delimiter $$
create procedure get_succesfull_borrows(in session_tag varchar(300))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		 select * from borrow_history b where b.success=true;
	else
			select('who are you?');
	end if;
	
end $$
delimiter ;
 
drop procedure if exists get_delayed_borrows;
delimiter $$
create procedure get_delayed_borrows(in session_tag varchar(300))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		 select * from borrow_history b where curdate()>=b.startdate+b.permited_days;
         set @delay=b.curdate()-b.startdate+b.permited_days;
        # order by @delay;
	else
			select('who are you?');
	end if;
	
end $$
delimiter ;
 


drop procedure if exists get_a_book_borrows;
delimiter $$
create procedure get_a_book_borrows(in session_tag varchar(300), in title varchar(30))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		 select * from borrow_history bh where bh.copy_id in (select * from copy c, book b where c.book_id=b.book_id and b.title=title);
	else
			select('who are you?');
	end if;
	
end $$
delimiter ;
 
drop procedure if exists user_search;
delimiter $$
create procedure user_search(in session_tag varchar(300), in username varchar(30))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		 select * from account a where a.username=username order by a.lastname;
	else
			select('who are you?');
	end if;
	
end $$
delimiter ;
 

drop procedure if exists get_user_info;
delimiter $$
create procedure get_user_info(in session_tag varchar(300), in username varchar(30))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		 select * from account a where a.username=username order by a.lastname;
	else
			select('who are you?');
	end if;
	
end $$
delimiter ;
 

drop procedure if exists get_user_history;
delimiter $$
create procedure get_user_history(in session_tag varchar(300), in username varchar(30))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		 select * from borrow_history b where b.username=username order by b.startdate;
	else
			select('who are you?');
	end if;
	
end $$
delimiter ;
 