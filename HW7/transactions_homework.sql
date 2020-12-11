use shop;
show TABLES;
insert into categories (id, name, description) values (1, 'Ibex', 'Capra ibex');
insert into categories (id, name, description) values (2, 'Ox, musk', 'Ovibos moschatus');
insert into categories (id, name, description) values (3, 'Turtle (unidentified)', 'unavailable');
insert into categories (id, name, description) values (4, 'Gonolek, burchell''s', 'Laniaurius atrococcineus');
insert into categories (id, name, description) values (5, 'Phascogale, red-tailed', 'Phascogale calura');
insert into categories (id, name, description) values (6, 'Goose, greylag', 'Anser anser');
insert into categories (id, name, description) values (7, 'Fox, savanna', 'Dusicyon thous');
insert into categories (id, name, description) values (8, 'Lion, mountain', 'Felis concolor');
insert into categories (id, name, description) values (9, 'Crowned hawk-eagle', 'Spizaetus coronatus');
insert into categories (id, name, description) values (10, 'Bird, bare-faced go away', 'Lorythaixoides concolor');
insert into categories (id, name, description) values (11, 'Eurasian red squirrel', 'Sciurus vulgaris');
insert into categories (id, name, description) values (12, 'Ibis, puna', 'Plegadis ridgwayi');
insert into categories (id, name, description) values (13, 'Burmese brown mountain tortoise', 'Manouria emys');
insert into categories (id, name, description) values (14, 'Common zorro', 'Dusicyon thous');
insert into categories (id, name, description) values (15, 'Dabchick', 'Tachybaptus ruficollis');
insert into categories (id, name, description) values (16, 'Ibex', 'Capra ibex');
insert into categories (id, name, description) values (17, 'Moose', 'Alces alces');
insert into categories (id, name, description) values (18, 'Alpaca', 'Lama pacos');
insert into categories (id, name, description) values (19, 'Arctic hare', 'Lepus arcticus');
insert into categories (id, name, description) values (20, 'Three-banded plover', 'Charadrius tricollaris');
insert into categories (id, name, description) values (21, 'Marshbird, brown and yellow', 'Pseudoleistes virescens');
insert into categories (id, name, description) values (22, 'Tyrant flycatcher', 'Myiarchus tuberculifer');
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
-- (PS буду использовать другие таблицы, т.к. они уже были созданы на одном из вебинаров и сути задания не поменяют)
create database if not exists sample; 
use sample;
create table if not exists sample.categories AS SELECT * FROM shop.categories;
create table if not exists sample.goods AS SELECT * FROM shop.goods;
create table if not exists sample.orders AS SELECT * FROM shop.orders;
create table if not exists sample.orders_has_goods AS SELECT * FROM shop.orders_has_goods;

truncate table categories;
ALTER TABLE sample.categories MODIFY COLUMN id int auto_increment NOT null PRIMARY KEY;
insert into categories (name, description) values ('Painted stork', 'Mycteria leucocephala');
insert into categories (name, description) values ('Paca', 'Agouti paca');
insert into categories (name, description) values ('Chickadee, black-capped', 'Parus atricapillus');
insert into categories (name, description) values ('Common mynah', 'Acridotheres tristis');
insert into categories (name, description) values ('Elk, Wapiti', 'Cervus canadensis');
insert into categories (name, description) values ('Galapagos sea lion', 'Zalophus californicus');
insert into categories (name, description) values ('Albatross, galapagos', 'Diomedea irrorata');
insert into categories (name, description) values ('Starling, superb', 'Lamprotornis superbus');
insert into categories (name, description) values ('Lapwing (unidentified)', 'Vanellus sp.');
insert into categories (name, description) values ('Porcupine, crested', 'Hystrix cristata');

start transaction;
insert into sample.categories (name, description) 
	select name, description from shop.categories where shop.categories.id = 1;
commit;

-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

use shop;
insert into goods (name, description, quantity, price, categories_id) 
values ('dfghj', 'lalalalala', 8, 100500, 13);

CREATE OR REPLACE VIEW goodswithcategories(id, name, description, categories_name) as
	SELECT 
		g.id, g.name, g.description, c.name as categories_id
		
	FROM goods as g
	left join categories as c
	on g.categories_id = c.id;
select * from goodswithcategories;







