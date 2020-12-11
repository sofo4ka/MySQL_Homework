-- ����������������� MySQL
-- 1. �������� ���� ������������� ������� ����� ������ � ���� ������ shop.
-- ������� ������������ shop_read ������ ���� �������� ������ ������� �� ������ ������, ������� ������������ shop � ����� �������� � �������� ���� ������ shop.
use shop;
drop user if exists 'shop'@'localhost';
create user 'shop'@'localhost';
grant all on shop.* to 'shop'@'localhost';

create user if not exists 'shop_read'@'localhost';
grant select on shop.* to 'shop_read'@'localhost';
