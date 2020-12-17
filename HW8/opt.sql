use homework;
-- ����������� ��������
-- 1. �������� ������� logs ���� Archive. ����� ��� ������ �������� ������ � �������� users, catalogs � products � ������� logs ���������� ����� � ���� �������� ������, �������� �������, ������������� ���������� ����� � ���������� ���� name.
drop table logs;
create table if not exists logs(
	created_at datetime not null, -- ����� � ���� �������� ������ 
	table_name varchar(255) not null, --  �������� ������� 
	id bigint not null, -- ������������� ���������� ����� 
	name_value varchar(255) not null -- ���������� ���� name 
) engine=archive default charset=utf8;

-- ��� ������ �������� ������ � �������� users, catalogs � products
drop trigger if exists create_log_on_insert;

delimiter //

create trigger create_log_on_insert before insert on users
for each row
begin 
	insert into logs(created_at, table_name, id, name_value)
	values (now(), 'users', new.id, new.name);
end//

delimiter ;

insert into users (name, birthday_at)
values ('������', '2020-01-01');
select * from logs;

delimiter //

create trigger create_log_on_insert2 before insert on catalogs
for each row
begin 
	insert into logs(created_at, table_name, id, name_value)
	values (now(), 'catalogs', new.id, new.name);
end//

create trigger create_log_on_insert3 before insert on products
for each row
begin 
	insert into logs(created_at, table_name, id, name_value)
	values (now(), 'products', new.id, new.name);
end//
delimiter ;
