use homework;
-- Оптимизация запросов
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
drop table logs;
create table if not exists logs(
	created_at datetime not null, -- время и дата создания записи 
	table_name varchar(255) not null, --  название таблицы 
	id bigint not null, -- идентификатор первичного ключа 
	name_value varchar(255) not null -- содержимое поля name 
) engine=archive default charset=utf8;

-- при каждом создании записи в таблицах users, catalogs и products
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
values ('Андрей', '2020-01-01');
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
