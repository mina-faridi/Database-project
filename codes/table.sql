#creating tables
 drop table account;
 drop table student;
 drop table professor;
 drop table regular_person;
 drop table borrow_history;
create database library;

create table branch (branch_id int,
					address varchar(60),
                    phone int,
                    primary key (branch_id));
create table storage (storage_id int, 
					  branch_id int,
                      primary key (storage_id),
                      foreign key (branch_id) references branch(branch_id));
                      
create table publication (Name varchar(30),
						 address varchar(60),
                         website varchar(60),
                         primary key (Name)
                         );
				
drop table if exists book;
create table book (
					book_id int AUTO_INCREMENT,
					title varchar(30),
                    subject varchar(30),
                    pages int,
                    price int,
                    publisher varchar(30),
                    author varchar(30),
                    publish_date date,
                    version varchar(10),
                    primary key (book_id),
                    foreign key (publisher) references publication(Name)
                    );
alter table book 
add column booktype int; #1 reference 2.educational 3.other
 
drop table if exists copy;
create table copy (copy_id int AUTO_INCREMENT,
					book_id int,
                    storage_id int,
                    primary key (copy_id),
                    foreign key (book_id) references book(book_id),
					foreign key (storage_id) references storage(storage_id));
 
 

create table account(account_id int AUTO_INCREMENT,
					username varchar(30) not null unique,
                    password varchar(300) not null, #passwords are hashed so  need larger size
                    register_date date,
                    balance int,
                    national_id int, 
                    name varchar(30),
                    lastname varchar(30),
					address  varchar(60),
                    phone varchar(30),
                    usertype int,
                    primary key (account_id));
                      
 
create table professor (
						professor_id int AUTO_INCREMENT,
						account_id int,
						prof_uni_id int, #professor id in university
						university varchar(30),
                        primary key (professor_id),
                        foreign key (account_id) references account(account_id));
				
create table regular_person (
						regular_person_id int AUTO_INCREMENT, 
						account_id int,
						job varchar(30),
                        primary key (regular_person_id),
                        foreign key (account_id) references account(account_id));

create table student(	student_id int AUTO_INCREMENT, 
						account_id int,
						std_uni_id int, #in university
                        university_name varchar(20),
                        primary key (student_id),
                        foreign key (account_id) references account(account_id));

drop table if exists borrow_history;
create table borrow_history (
							borrow_id int AUTO_INCREMENT, 
							account_id int,
                            copy_id int,
                            startdate date,
                            returndate date,
                            permited_days int, 
                            reduced_balance int,
                            success boolean, #true: success false:unsuccess
                            failure_reason varchar(100),
                            primary key (borrow_id),
                            foreign key (account_id) references account(account_id),
                            foreign key (copy_id) references copy(copy_id));
                           
create table session (
					session_id int auto_increment,
                    session_hashed_tag varchar(300),
                    username varchar(30),
                    logged_in boolean,
                    primary key (session_id)
                    );
create table eligible_user_book_type 
			( user_type int,
				book_type int            
            );#1 reference 2.educational 3.other
                    #type: 1:professor 2:student 3:regular