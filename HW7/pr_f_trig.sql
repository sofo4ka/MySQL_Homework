-- �������� ��������� � �������, ��������
-- 1.�������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� �������� ������� �����.
-- � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", � 12:00 �� 18:00 ������� ������ ���������� ����� 
-- "������ ����", � 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 � "������ ����".

drop function if exists `hello`;
delimiter //
create function `hello`()
returns text not deterministic
begin
	declare currenttime TIME; -- VARCHAR(255);
	set currenttime = curtime(); -- DATE_FORMAT(NOW(), "%H:%i:%s");
	case
		when currenttime between '06:00:01' and  '12:00:00' then return "������ ����";
		when currenttime between '12:00:01' and  '18:00:00' then return "������ ����";
		when currenttime between '18:00:01' and  '00:00:00' then return "������ �����";
		when currenttime between '00:00:01' and  '06:00:00' then return "������ ����";
	end case;	
end//
select hello()//
delimiter ;
-- �� ��������, ��������� ������ ��������, ��� ����� ������
-- SQL Error [1418] [HY000]: This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)


-- 2.� ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������. 
-- ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� ��������� ��������������
-- �������� NULL �����������. ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������.
-- ��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.
use homework;

delimiter //
create trigger null_trigger BEFORE INSERT ON products
FOR EACH ROW BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'NULL-alert';
	END IF;
END//
delimiter ;

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 100500, 8);