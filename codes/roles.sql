#roles and users


create role 'customer', 'librarian', 'admin';
grant execute on procedure add_book to 'librarian';
grant execute on procedure add_copy to 'librarian';
grant execute on procedure get_succesfull_borrows to 'librarian';
grant execute on procedure get_delayed_borrows to 'librarian';
grant execute on procedure get_a_book_borrows to 'librarian';
grant execute on procedure user_search to 'librarian';
grant execute on procedure get_user_info to 'librarian';

grant execute on procedure make_account to 'customer';
grant execute on procedure login to 'customer';
grant execute on procedure get_account_info to 'customer';
grant execute on procedure search_book to 'customer';
grant execute on procedure return_book to 'customer';
grant execute on procedure get_book to 'customer';
grant execute on procedure increase_balance to 'customer';

create user 'user_mina'@'localhost'  identified by 'secret_123';
grant 'customer' to 'user_mina'@'localhost' ;