#defining functions and procedu
drop procedure if exists make_account;
delimiter $$
create procedure make_account(in username varchar(30), in password varchar(30), 
								in address varchar(30), in phone varchar(30), in name varchar(30),
                                in lastname varchar(30), in national_id int, in usertype int,
                                in faculty_id int, in university_name varchar(30),
                                in student_id int, in job varchar(30))
 begin
	if length(username) >=6 and not(username regexp '[^[:alnum:]]+') then
		set @register_date = curdate();
        set @balance = 0;
        set @hashed = SHA1(concat(username,password));
        
		insert into account values(null,username, @hashed, @register_date, @balance, national_id, name, lastname, address, phone, usertype   );
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
