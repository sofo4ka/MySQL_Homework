-- јдминистрирование MySQL
-- 1. —оздайте двух пользователей которые имеют доступ к базе данных shop.
-- ѕервому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop Ч любые операции в пределах базы данных shop.
use shop;
drop user if exists 'shop'@'localhost';
create user 'shop'@'localhost';
grant all on shop.* to 'shop'@'localhost';

create user if not exists 'shop_read'@'localhost';
grant select on shop.* to 'shop_read'@'localhost';
