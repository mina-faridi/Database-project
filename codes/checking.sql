#checking functions and procedures

call make_account('mina1234', '123', '3 street', '34141', 
		'mina', 'faridi', '2452', 2, 0 , 'amirkabir',
                                '45267', 0);

                             
call login('mina1234','123', @tag);
call login('afgdgdadg', '123', @tag);
select @tag;
select * from session;

call search_book('4c0459abec2d75bb17b3ab898e509ccb7eef81b6', 'aaa', '','0000.00.00', '');
 call get_book('4c0459abec2d75bb17b3ab898e509ccb7eef81b6', 'bbb3');

insert into book values(null, 'aaa', 'subj', '32', '323', 'pub', 'aut', '1999.9.9', '3.2');


call make_account('librarian', '123', '3 street', '34141', 
		'mina', 'faridi', '2452', 2, 0 , 'amirkabir',
                                '45267', 0);
call login('librarian', '123', @tag);
call login('mina1234','123', @tag_st);
call get_book(@tag_st, 'aaa1' );
call increase_balance(@tag_st, 90);
call get_a_book_borrows(@tag, 'aaa1');



