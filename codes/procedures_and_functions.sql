#defining functions and procedu
drop procedure if exists make_account;
delimiter $$
create procedure make_account(in username varchar(30), in password varchar(30), 
								in address varchar(30), in phone varchar(30), in name varchar(30),
                                in lastname varchar(30), in national_id int, in usertype int,
                                in faculty_id int, in university_name varchar(30),
                                in student_id int, in job varchar(30), in usertype int)
 begin
	if length(username) >=6 and not(username regexp '[^[:alnum:]]+') then
		set @register_date = curdate();
        set @balance = 0;
        set @hashed = SHA1(concat(username,password));
        
		insert into account values(null,username, @hashed, @register_date, @balance, national_id, name, lastname, address, phone, usertype);
        set @account_id = LAST_INSERT_ID();
        #type: 1:professor 2:student 3:regular
        if usertype=1 then
			insert into professor values(null, @account_id, faculty_id, university_name);
		elseif usertype=2 then 
			insert into student values(null, @account_id, student_id, university_name);
		elseif usertype=3 then 
			insert into normal_person values(null, @account_id, job);
		end if;
        select 'success';
	else 
		select 'unsuccess';
	end if;
end$$
delimiter ;

drop procedure if exists login;
delimiter $$       
create procedure login(in usernamee varchar(30), in password varchar(30), out session_tag varchar(300))
begin
	set @input_pass=SHA1(concat(usernamee,password));
    
	if exists( select *
				from account acc
				where acc.username = usernamee  and acc.password =  @input_pass )
		then
			set session_tag=sha1(concat(usernamee,password,current_time()));
            insert into session values (null, session_tag, usernamee, true);
			select('login successful');
			#select @tag;
            #select * from account;
	else 
		select('wrong password or username');
	end if;
    
end $$
delimiter ;

drop procedure if exists get_account_info;
delimiter $$
create procedure get_account_info(in session_tag varchar(300))
begin
		select * 
        from account a
        where exists (select * from session s where a.username=s.username and
					s.session_hashed_tag=session_tag and s.logged_in=1);
end $$
delimiter ;

drop procedure if exists search_book;
delimiter $$
create procedure search_book(in session_tag varchar(300), in title varchar(30), 
							in author varchar(30), in publish_date date,
							in version varchar(10))
begin
		if exists(select * from session s where s.session_hashed_tag=session_tag  and s.logged_in=1)then
			select *
			from book b
			where ((b.title=title or title='') and (b.author=author or author='') and
					(b.publish_date=publish_date or publish_date='0000.00.00') and (b.version=version or version=''))
			order by b.title;
		else
			select('who are you?');
		end if;
end $$
delimiter ;

drop procedure if exists get_book;
delimiter $$
create procedure get_book(in session_tag varchar(300), in title varchar(30))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		select('0');
		set @bookprice=(select b.price from book b where b.title=title);
		set @book_id=(select b.book_id from book b where b.title=title);
		 if not(isnull(@book_id))then #book exists
			select('0.1');
            set @booktype=(select b.booktype from book b where b.title=title);
			select('0.2');
            set @usertype=(select a.usertype from account a where a.username=@username);
			select('0.3');
            set @account_id=(select a.account_id from account a where a.username=@username);
            select('0.4');
           
            select('1');
            set @copy_id=1;#(select c.copy_id from copy c where c.book_id=@book_id and c.copy_id=(select min(copy_id) where c.book_id=@book_id));
            if exists(select * from eligible_user_book_type e where e.user_type=@usertype and e.book_type=@booktype)then #user eligible to get the book
				select('2');
                if exists (select * from account a where a.username=@username and a.balance > @bookprice/20.0)then #account has enough money
                    insert into borrow_history values(null,@account_id,@copy_id, curdate(), '0.0.0', 10, @bookprice/20,true,null);
                    delete from copy c where c.copy_id=@copy_id;
				else
					select('3');
					insert into borrow_history values(null,@account_id,@copy_id, curdate(), null, 10, @bookprice/20,false,'low balance');
					select('low balance');
				end if;
			else
				insert into borrow_history values(null,@account_id,@copy_id, curdate(), null, 10, @bookprice/20,false,'user type not eligible to get the book');
				select('user not eligible to get the book');
            end if;
		 else
			insert into borrow_history values(null,@account_id,@copy_id, curdate(), null, 10, @bookprice/20,false, 'book not exists');
			select('book not exists');
		end if;
    else
		select('who are you?');
	end if;
end $$
delimiter ;



drop procedure if exists return_book;
delimiter $$
create procedure return_book(in session_tag varchar(300), in title varchar(30))
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then #if the user is logged in
		set @book_id=(select b.book_id from book b where b.title=title);
        set @account_id=(select a.account_id from account a where a.username=@username);
		update borrow_history b set b.returndate=curdate() where b.account_id=@account_id and b.returndate='0.0.0' 
																and b.success=true and b.copy_id in 
                                                                (select * from copy c, book bb where b.copy_id=c.copy_id and c.book_id=bb.book_id and bb.title=title);
	else
		select('who are you?');
	end if;
end $$
delimiter ;

drop procedure if exists increase_balance;
delimiter $$
create procedure increase_balance(in session_tag varchar(300), in amount int)
begin
	set @username = (select s.username from session s where s.session_hashed_tag=session_tag  and s.logged_in=1);
    select @username;
	if not(isnull(@username)) then
		if amount>0 then
			update account a set a.balance=a.balance+amount where a.username=@username;
            select('success');
        else
			select ('amount less than zero');
        end if;
	else
			select('who are you?');
	end if;
end $$
delimiter ;

       