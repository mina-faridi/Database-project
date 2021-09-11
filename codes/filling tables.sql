#filling the tables

insert into account



insert into branch values ('1','asdfa','1323');
insert into storage values ('1', '1');
insert into publication values('pub', 'street', 'www.adfa');
insert into book values(null, 'aaa', 'subj', '32', '323', 'pub', 'aut', '1999.09.09', '3.2');
insert into book values(null, 'aaad', 'subj', '32', '323', 'pub', 'aut', '0.0.0', '3.2',3);
update book set booktype='1' where title='aaa';
insert into copy values(null, 6, 1);
insert into copy values(null, 6, 1);
insert into copy values(null, 6, 1);

insert into book values(null, 'bbb3', 'subj', '32', '323', 'pub', 'aut', '1999.09.09', '3.2',3);
insert into book values(null, 'aaa2', 'subj', '32', '323', 'pub', 'aut', '1999.09.09', '3.2',2);
insert into book values(null, 'aaa1', 'subj', '32', '323', 'pub', 'aut', '1999.09.09', '3.2',1);

select * from book;

insert into copy values(null, 9, 1);


insert into eligible_user_book_type values(1,1);
insert into eligible_user_book_type values(1,2);
insert into eligible_user_book_type values(1,3);
insert into eligible_user_book_type values(2,2);
insert into eligible_user_book_type values(2,3);
insert into eligible_user_book_type values(3,3);



delete from book;
select * from book;
select * from copy;