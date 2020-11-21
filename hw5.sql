CREATE DATABASE hw5;
USE hw5;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY, 
  name VARCHAR(255) NOT NULL COMMENT 'Имя пользователя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,  
  updated_at DATETIME
) COMMENT = 'Пользователи';  

INSERT INTO 
  users (name, birthday_at, created_at, updated_at) 
VALUES 
  ('Cielo', '1990-05-05', NULL, NULL),
  ('Marilyne', '1984-08-11', NULL, NULL),
  ('Ardella', '1979-12-05', NULL, NULL),
  ('Greta', '1998-10-09', NULL, NULL),
  ('Douglas', '2002-01-29', NULL, NULL);

DESC users;
SELECT * FROM users;

-- Задание 1
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.

UPDATE 
  users 
SET 
  created_at = NOW(), 
  updated_at = NOW();

-- Задание 2 
-- Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.


ALTER TABLE users MODIFY COLUMN created_at VARCHAR(100);
ALTER TABLE users MODIFY COLUMN updated_at VARCHAR(100);

UPDATE users SET created_at = '20.05.2017 8:12', updated_at = '21.10.2017 8:10' WHERE id=1;
UPDATE users SET created_at = '01.08.2018 18:55', updated_at = '21.10.2018 8:10' WHERE id=2;
UPDATE users SET created_at = '07.10.2019 8:34', updated_at = '21.10.2020 7:10' WHERE id=3;
UPDATE users SET created_at = '19.01.2017 18:42', updated_at = '21.02.2017 8:10' WHERE id=4;
UPDATE users SET created_at = '20.05.2017 8:10', updated_at = '21.06.2020 19:10' WHERE id=5;

UPDATE
  users
SET
  created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
  updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');
 
-- Правильное решение  
-- ALTER TABLE
--   users
-- CHANGE 
--   created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
  
-- ALTER TABLE
--   users
-- CHANGE 
--   updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE users MODIFY COLUMN created_at DATETIME;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME;

DESC users;
SELECT * FROM users;

-- Задание 3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, 
-- чтобы они выводились в порядке увеличения значения value. 
-- Однако нулевые запасы должны выводиться в конце, после всех записей.


DROP TABLE IF EXISTS storehouses_products;

CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY, 
  name VARCHAR(255) NOT NULL COMMENT 'Название продукта',
  value INT UNSIGNED COMMENT 'Количество шт.',
  in_stock VARCHAR(255) DEFAULT NULL COMMENT 'Наличие на складе'
) COMMENT = 'Складские запасы';  

INSERT INTO 
  storehouses_products (name, value) 
VALUES 
  ('Матрица', 132),
  ('Пуансон', 0),
  ('Насос', 11),
  ('Помпа', 0),
  ('Батарейки', 630);
 
UPDATE 
  storehouses_products
SET in_stock = IF(value > 0, 'Есть в наличии', 'Нет в наличии');

DESC storehouses_products;
SELECT * FROM storehouses_products;

SELECT * FROM storehouses_products ORDER BY in_stock, value;

-- SELECT 
--   *
-- FROM
--   storehouses_products
-- ORDER BY 
--    IF(value > 0, 0, 1), value;

-- SELECT 
--   *
-- FROM
--   storehouses_products
-- ORDER BY 
--    value = 0, value;

-- Задание 4
-- Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august)


ALTER TABLE 
  users
ADD COLUMN
  month_of_birth VARCHAR(100) COMMENT 'Месяц рождения';

DESC users;
SELECT * FROM users;
 
 
UPDATE users SET month_of_birth = 'may' WHERE id=1;
UPDATE users SET month_of_birth = 'august' WHERE id=2;
UPDATE users SET month_of_birth = 'december' WHERE id=3;
UPDATE users SET month_of_birth = 'october' WHERE id=4;
UPDATE users SET month_of_birth = 'january' WHERE id=5;

SELECT *
  FROM users
  WHERE month_of_birth = 'may' OR month_of_birth = 'august';

-- SELECT name
--    FROM users
--    WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');
 
 
-- Задание 5
-- Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN.
 
 
 CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY, 
  name VARCHAR(255) NOT NULL COMMENT 'Название продукта'
) COMMENT = 'Каталог товаров';  

INSERT INTO 
  catalogs (name) 
VALUES 
  ('Клавиатура'),
  ('Монитор'),
  ('Компьютерная мышь'),
  ('Матрица'),
  ('Видеокарта');
 
SELECT * FROM catalogs;

SELECT 
  * 
FROM 
  catalogs 
WHERE 
  id IN (5, 1, 2)
ORDER BY 
  FIELD(id, 5, 1, 2);
 
 -- Решение совпало с разбором ДЗ
 
 -- Агрегация Задание 1
 -- Подсчитайте средний возраст пользователей в таблице users.
 
SELECT * FROM users;
 
SELECT 
   name,
   TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS current_age
FROM 
   users;
  
SELECT 
  ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS average_age 
FROM 
  users;
 
 -- Решение совпало с разбором ДЗ
 
 -- Агрегация Задание 2
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 
-- SELECT 
--   DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day, 
--   COUNT(*) AS total
-- FROM 
--   users
-- GROUP BY
--   day 
-- ORDER BY 
--   total DESC;
 
-- Тема Агрегация, задание 3
-- Подсчитайте произведение чисел в столбце таблицы

DROP TABLE IF EXISTS value;

CREATE TABLE value_table (
  value SERIAL PRIMARY KEY 
);  

INSERT INTO 
  value_table (value) 
VALUES 
 (1),
 (2),
 (3),
 (4),
 (5);

SELECT * FROM value_table;

SELECT 
  EXP(SUM(LN(value))) AS multiply_value
FROM 
  value_table; 

 











