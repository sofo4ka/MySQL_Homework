-- Хранимые процедуры и функции, триггеры
-- 1.Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу 
-- "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

drop function if exists `hello`;
delimiter //
create function `hello`()
returns text not deterministic
begin
	declare currenttime TIME; -- VARCHAR(255);
	set currenttime = curtime(); -- DATE_FORMAT(NOW(), "%H:%i:%s");
	case
		when currenttime between '06:00:01' and  '12:00:00' then return "Доброе утро";
		when currenttime between '12:00:01' and  '18:00:00' then return "Добрый день";
		when currenttime between '18:00:01' and  '00:00:00' then return "Добрый вечер";
		when currenttime between '00:00:01' and  '06:00:00' then return "Доброй ночи";
	end case;	
end//
select hello()//
delimiter ;
-- не работает, пробовала разные варианты, все время ошибки
-- SQL Error [1418] [HY000]: This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)


-- 2.В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное
-- значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.
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