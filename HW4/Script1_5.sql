create database if not exists homework;
use homework;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '�������� �������',
  UNIQUE unique_name(name(10))
) COMMENT = '������� ��������-��������';

INSERT INTO catalogs VALUES
  (NULL, '����������'),
  (NULL, '����������� �����'),
  (NULL, '����������'),
  (NULL, '������� �����'),
  (NULL, '����������� ������');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����������';

INSERT INTO users (name, birthday_at) VALUES
  ('��������', '1990-10-05'),
  ('�������', '1984-11-12'),
  ('���������', '1985-05-20'),
  ('������', '1988-02-14'),
  ('����', '1998-01-12'),
  ('�����', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  description TEXT COMMENT '��������',
  price DECIMAL (11,2) COMMENT '����',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = '�������� �������';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 7890.00, 1),
  ('Intel Core i5-7400', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 12700.00, 1),
  ('AMD FX-8320E', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 4780.00, 1),
  ('AMD FX-8320', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', '����������� ����� ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', '����������� ����� Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', '����������� ����� MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '������';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT '���������� ���������� �������� �������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ ������';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT '�������� ������ �� 0.0 �� 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = '������';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT '����� �������� ������� �� ������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ �� ������';


-- ������������ ������� �� ���� ����������, ����������, ���������� � �����������
-- 1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.

INSERT INTO users (name, birthday_at,created_at, updated_at) VALUES
  ('�������', '1999-10-05', null, null),
  ('������', '1998-10-05', null, null),
  ('����������', '1970-10-05', null, null);
 SELECT * from users;

UPDATE users
    SET created_at = NOW() where created_at is null;
UPDATE users   
	set updated_at = NOW() where updated_at is null;

SELECT * from users;


-- 2.������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� 20.10.2017 8:10. ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.

 
ALTER TABLE users
	CHANGE COLUMN `created_at` `created_at` VARCHAR(256),
    CHANGE COLUMN `updated_at` `updated_at` VARCHAR(256);
   
-- describe users; 
-- SELECT `created_at`, `updated_at` from users;

ALTER TABLE users 
    CHANGE COLUMN `created_at` `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHANGE COLUMN `updated_at` `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

describe users; 
SELECT * from users;


-- 3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. ������ ������� ������ ������ ���������� � �����, ����� ���� �������. 
describe storehouses_products; 

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
    (1, 8, 0),
    (1, 9, 2500),
    (1, 29, 0),
    (1, 34, 30),
    (1, 4, 500),    
    (1, 1, 1);
-- SELECT * from storehouses_products;
select value from storehouses_products 
	order by if(value > 0, 0, 1), value;

-- 4.  �� ������� users ���������� ������� �������������, ���������� � ������� � ���. ������ ������ � ���� ������ ���������� �������� (may, august)
-- INSERT INTO users (name, birthday_at,created_at, updated_at) VALUES
  -- ('Cjamz', '1999-08-05', null, null),
  -- ('������', '1998-05-08', null, null);
 -- SELECT * from users;


SELECT name, birthday_at from users 
where date_format(birthday_at, '%m') = 05 or date_format(birthday_at, '%m') = 08;
	
SELECT name, birthday_at, 
	case 
		when date_format(birthday_at, '%m') = 05 then 'may' 
		when date_format(birthday_at, '%m') = 08 then 'august'	
	end as `month`
	from users 
		where date_format(birthday_at,'%m') = '05' or date_format(birthday_at,'%m') = '08'
	order by `month`;


-- 5.�� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.

SELECT * from catalogs 
where id IN (5, 1, 2)
order by FIELD(id, 5, 1, 2);

