-- FOREIGN KEYs

use gosuslugi;

ALTER TABLE services 
  ADD CONSTRAINT services_category_id_fk
    FOREIGN KEY (category_id) REFERENCES categories(id)
      ON DELETE CASCADE;
     
ALTER TABLE services
  ADD CONSTRAINT services_responsible_id_fk
	FOREIGN KEY (responsible_id) REFERENCES responsible(id)
	  ON DELETE CASCADE;

ALTER TABLE users 
  ADD CONSTRAINT users_access_level_id_fk
    FOREIGN KEY (access_level_id) REFERENCES access_levels(id)
      ON DELETE CASCADE;

ALTER TABLE profiles 
  ADD CONSTRAINT profiles_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;

ALTER TABLE access_levels_services 
  ADD CONSTRAINT access_levels_services_access_level_id_fk
    FOREIGN KEY (access_level_id) REFERENCES access_levels(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT access_levels_services_service_id_fk
    FOREIGN KEY (service_id) REFERENCES services(id)
      ON DELETE CASCADE;   

ALTER TABLE orders 
  ADD CONSTRAINT orders_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT orders_service_id_fk
    FOREIGN KEY (service_id) REFERENCES services(id)
      ON DELETE CASCADE;
     
ALTER TABLE emails 
  ADD CONSTRAINT emails_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
ALTER TABLE payments   
  ADD CONSTRAINT payments_order_id_fk
    FOREIGN KEY (order_id) REFERENCES orders(id)
      ON DELETE CASCADE;
     
ALTER TABLE articles 
  ADD CONSTRAINT articles_category_id_fk
    FOREIGN KEY (category_id) REFERENCES categories(id)
      ON DELETE CASCADE;
     
-- INDEXes

CREATE INDEX profiles_first_name_last_name_idx 
  ON profiles(first_name, last_name); 
 
CREATE INDEX services_name_idx
  ON services(name);
 
CREATE INDEX profiles_car_number_idx
  ON profiles(car_number);
 
CREATE INDEX responsible_name_idx
  ON responsible(name);

-- JOIN
-- 10 самых активных пользователей сервиса 

SELECT DISTINCT
  users.id,
  CONCAT_WS(' ', profiles.first_name, profiles.last_name) AS firstname_lastname,
  COUNT(orders.id) OVER(PARTITION BY users.id) AS services_requested
  FROM users
    LEFT JOIN profiles 
      ON profiles.user_id = users.id 
    LEFT JOIN orders 
      ON orders.user_id = profiles.user_id 
    LEFT JOIN services 
      ON services.id = orders.service_id 
  ORDER BY services_requested DESC
  LIMIT 10;
 
 
 -- информационное сообщение пользователю о статусе платежа
 SELECT 
   CONCAT_WS(' ', profiles.first_name, profiles.last_name) AS 'Плательщик',
   CONCAT(
     'Статус вашего платежа №',
     payments.id,
     ' по услуге "',
     services.name,
     ' :" ',
     payments.payment_status,
     ' (in progess - обрабатывается, confirmed - подтвержден, rejected - отклонен, обратитесь в службу поддержки)'
   ) AS 'Информационное сообщение об оплате услуги'
   FROM payments 
     JOIN orders 
       ON orders.id = payments.order_id 
     JOIN services 
       ON services.id = orders.service_id 
     JOIN users 
       ON orders.user_id = users.id
     JOIN profiles 
       ON profiles.user_id = users.id
  ORDER BY users.id 
  LIMIT 10;
 
 -- Кого больше: пользователей-мужчин или женщин? 
 
SELECT gender, COUNT(*) AS users_quantity
  FROM profiles 
GROUP BY gender; 

-- Кто больше запросил услуг: мужчины или женщины?

SELECT 
  (SELECT gender FROM profiles WHERE profiles.user_id = orders.user_id) as gender,
  COUNT(orders.id) AS total_orders
  FROM orders
  GROUP BY gender
  ORDER BY total_orders DESC;


-- Возрастной состав пользователей 

SELECT 
  ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday, NOW()))) AS average_user_age
FROM 
  profiles;


SELECT DISTINCT 
  LEFT(birthday, 3) AS decade_of_birth, 
  COUNT(user_id) OVER w AS total_users
    FROM profiles
      WINDOW w AS (PARTITION BY LEFT(birthday, 3)) 
    ORDER BY decade_of_birth;


-- PROCEDURES AND FUNCTIONS 

DELIMITER // 

CREATE PROCEDURE most_popular_services()
BEGIN
  SELECT DISTINCT services.name, 
  COUNT(orders.id) OVER(PARTITION BY orders.service_id) AS service_requested_times
     FROM orders
       JOIN services
         ON orders.service_id = services.id
     ORDER BY service_requested_times DESC
     LIMIT 3;	
END//

DELIMITER ; 

CALL most_popular_services();


-- не работает функция

DROP FUNCTION IF EXISTS passport_reminder;

DELIMITER //

CREATE FUNCTION passport_reminder(birthday, citizenship)
RETURNS TINYTEXT NO SQL
BEGIN
  DECLARE age INT;
  SET age = TIMESTAMPDIFF(YEAR, birthday, NOW());
  CASE
    WHEN (age BETWEEN 13 AND 14) AND (citizenship = 'Российская Федерация') THEN
      RETURN 'Подайте заявление на получение паспорта гражданина РФ';  
    WHEN ((age BETWEEN 19 AND 20) AND (citizenship = 'Российская Федерация')) 
     OR 
         ((age BETWEEN 44 AND 45) AND (citizenship = 'Российская Федерация')) THEN
      RETURN 'Срок действия вашего паспорта РФ заканчивается, обратитесь за переоформлением';
  END CASE;
END//

DELIMITER ;

SELECT passport_reminder('2001-01-01', 'Российская Федерация');
SELECT passport_reminder('1950-01-01', 'Российская Федерация');
SELECT passport_reminder('2001-01-01', 'Казахстан');

-- VIEWs

CREATE OR REPLACE VIEW articles_for_services AS 
SELECT 
  articles.subject AS article_subject, 
  articles.body AS article_body, 
  services.id AS service_id, 
  services.name AS service_name, 
  articles.updated_at AS article_updated
  FROM services  
    LEFT JOIN articles 
      ON articles.category_id = services.category_id
    ORDER BY services.id, articles.updated_at;
   
SELECT * FROM articles_for_services WHERE service_name LIKE 'загран%';

CREATE OR REPLACE VIEW services_available_for_user AS  
SELECT
  services.name AS available_services,
  users.id,
  profiles.first_name AS first_name,
  profiles.last_name AS last_name,
  access_levels.name AS access_type  
  FROM services 
    JOIN access_levels_services 
      ON services.id = access_levels_services.service_id 
    JOIN access_levels 
      ON access_levels.id = access_levels_services.access_level_id
    JOIN users 
      ON users.access_level_id = access_levels.id 
    JOIN profiles 
      ON profiles.user_id = users.id
  ORDER BY users.id;
     
DESC services_available_for_user;

SELECT * 
  FROM services_available_for_user
  WHERE id IN (1, 2, 3);


-- TRIGGERS

DELIMITER //

DROP TRIGGER IF EXISTS passport_number_tax_number_fill_in_check_for_insert //
CREATE TRIGGER passport_number_tax_number_fill_in_check_for_insert BEFORE INSERT ON profiles
FOR EACH ROW 
BEGIN 
	IF NEW.passport_number IS NULL OR NEW.tax_number IS NULL THEN 
	  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT CANCELLED, please fill in passport number and tax number';
	END IF;
END//

DELIMITER ;

INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) 
  VALUES (101, 'Derek', 'Gerlach', 'Женский', '1920-12-03', '69958 Dicki Lock Suite 472\nSchneiderhaven, CA 90674', '321 Gulgowski Route Apt. 367\nNorth Augusta, OH 53263-8575', 'Казахстан', NULL , '727518938347', '37 uo', '2015-01-20 06:38:25', '2012-01-23 05:47:25');

DELIMITER //

DROP TRIGGER IF EXISTS total_users //
CREATE TRIGGER total_users AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	SELECT COUNT(*) INTO @total_users
	  FROM users;
END//

DELIMITER ;

DELETE FROM users WHERE id = 100;
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (100, 'cf687699f830488e8b2d311cde177dcc0f217a43d58daa717ad1606934ec2f15', 1, 'mhodkiewicz@example.net', '(519)982-9272x65528', '10552934771', '2019-01-30 23:12:26', '2016-12-15 13:32:08');
SELECT @total_users;















 
 
 
 
 

 


		 
      
     










 


 






   
