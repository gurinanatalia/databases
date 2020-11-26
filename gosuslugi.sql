use gosuslugi;

DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(128) NOT NULL COMMENT "Название категории"
) COMMENT "Категории услуг";

INSERT INTO categories (name)
  VALUES 
    ('Услуги в разделе "паспорт"'),
    ('Услуги в разделе "транспорт"'),
    ('Услуги в разделе "работа"');

DROP TABLE IF EXISTS services;

CREATE TABLE services (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(128) NOT NULL COMMENT "Название услуги",
  price DECIMAL(10,2) COMMENT "Стоимость",
  days TINYINT UNSIGNED COMMENT "Срок выполнения",  
  category_id INT UNSIGNED NOT NULL COMMENT "Название категории",
  responsible VARCHAR(128) NOT NULL COMMENT "Название ведомства",
  is_online BOOLEAN COMMENT "Может ли услуга быть полностью оказана online"
) COMMENT "Справочник услуг"; 

ALTER TABLE services 
  ADD CONSTRAINT services_category_id_fk
    FOREIGN KEY (category_id) REFERENCES categories(id)
      ON DELETE CASCADE;


INSERT INTO services (name, price, days, category_id, responsible, is_online)
  VALUES 
    ('Замена паспорта РФ в связи с достижением возраста 20 или 45 лет', 200, 10, 1, 'Министерство внутренних дел Российской Федерации', 0),
    ('Загранпаспорт нового поколения гражданам от 18 лет', 3500, 90, 1, 'Министерство внутренних дел Российской Федерации', 0),
    ('Регистрация гражданина по месту жительства', 0, 3, 1, 'Министерство внутренних дел Российской Федерации', 1),
    ('Проверка автомобильных и дорожных штрафов', 0, 1, 2, 'База ГИБДД', 1),
    ('Замена водительского удостоверения при истечении срока его действия', 1400, 3, 2, 'Министерство внутренних дел Российской Федерации', 0),
    ('Регистрация нового транспортного средства, ранее не зарегистрированного в ГИБДД', 1400 + 350 + 560, 3, 2, 'Министерство внутренних дел Российской Федерации', 0),
    ('Постановка на учет в центре занятости', 0, 11, 3, 'Центр занятости населения', 1),
    ('Поиск работы и трудоустройство', 0, 1, 3, 'Портал "Работа в России"', 1),
    ('Получение пособия по безработице', 0, 11, 3, 'Центр занятости населения', 0);
   
SELECT * FROM services; 

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  `password` VARCHAR(100) NOT NULL COMMENT "Пароль",
  access_level_id VARCHAR(100) NOT NULL COMMENT "Тип учетной записи",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  snils VARCHAR(100) NOT NULL UNIQUE COMMENT "СНИЛС",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи"; 

ALTER TABLE users 
  MODIFY COLUMN access_level_id INT UNSIGNED NOT NULL COMMENT "Тип учетной записи";

ALTER TABLE users 
  ADD CONSTRAINT users_access_level_id_fk
    FOREIGN KEY (access_level_id) REFERENCES access_levels(id)
      ON DELETE CASCADE;

DESC users;

DROP TABLE IF EXISTS profiles; 
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",  
  gender ENUM('Женский', 'Мужской') NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  address_of_registration VARCHAR(180) NOT NULL COMMENT "Адрес по месту регистрации",
  address_actual VARCHAR(180) NOT NULL COMMENT "Адрес проживания",
  citizenship ENUM('Российская Федерация', 'Казахстан', 'Белоруссия', 'Армения', 'Киргизия', 'иное') NOT NULL COMMENT "Гражданство",
  passport_number VARCHAR(30) COMMENT "Номер паспорта",
  tax_number VARCHAR(30) COMMENT "Номер ИНН",
  car_number VARCHAR(30) COMMENT "Гос. номер автомобиля",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили";

ALTER TABLE profiles 
  ADD CONSTRAINT profiles_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;

DROP TABLE IF EXISTS access_levels; 
CREATE TABLE access_levels (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(100) NOT NULL COMMENT "Название учетной записи"
) COMMENT "Профили";

INSERT INTO access_levels (name)
  VALUES 
  ('Простая учетная запись'),
  ('Стандартная учетная запись'),
  ('Подтвержденная учетная запись');
 
DROP TABLE IF EXISTS access_levels_services;
CREATE TABLE access_levels_services (
  access_level_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип учетной записи",
  service_id INT UNSIGNED NOT NULL COMMENT "Наименование усоуги",
  PRIMARY KEY (access_level_id, service_id) COMMENT "Составной первичный ключ"
) COMMENT "Доступные услуги в зависимости от типа учетной записи (уровня доступа)";

INSERT INTO access_levels_services (access_level_id, service_id)
  VALUES 
     (1, 1),
     (1, 4),
     (1, 7),
     (2, 1),
     (2, 2),
     (2, 4),
     (2, 5),
     (2, 7),
     (2, 8),
     (3, 1),
     (3, 2),
     (3, 3),
     (3, 4),
     (3, 5),
     (3, 6),
     (3, 7),
     (3, 8),
     (3, 9);  
    
SELECT * FROM access_levels_services;

ALTER TABLE access_levels_services 
  ADD CONSTRAINT access_levels_services_access_level_id_fk
    FOREIGN KEY (access_level_id) REFERENCES access_levels(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT access_levels_services_service_id_fk
    FOREIGN KEY (service_id) REFERENCES services(id)
      ON DELETE CASCADE;   


DROP TABLE IF EXISTS orders; 
CREATE TABLE orders (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя", 
  service_id INT UNSIGNED NOT NULL COMMENT "Ссылка на запрашиваемую услугу", 
  status_id ENUM ('requested', 'confirmed', 'rejected') NOT NULL COMMENT "Статус выполнения услуги",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Заявления пользователей на оказание услуг";

ALTER TABLE orders 
  CHANGE status_id status ENUM ('requested', 'confirmed', 'rejected') NOT NULL COMMENT "Статус выполнения услуги";

ALTER TABLE orders 
  ADD CONSTRAINT orders_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT orders_service_id_fk
    FOREIGN KEY (service_id) REFERENCES services(id)
      ON DELETE CASCADE;
     
 SELECT * FROM orders;

DROP TABLE IF EXISTS emails; 
CREATE TABLE emails (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  `from` ENUM ('Почта России', 'Портал "Госуслуги"', 'ГИБДД') NOT NULL COMMENT "Отправитель сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  subject TEXT NOT NULL COMMENT "Тема письма",
  body TEXT NOT NULL COMMENT "Текст письма",
  is_important BOOLEAN COMMENT "Признак важности",
  is_read BOOLEAN COMMENT "Прочитано ли письмо",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сообщения";

ALTER TABLE emails 
  ADD CONSTRAINT emails_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
DROP TABLE IF EXISTS payments; 
CREATE TABLE payments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  order_id INT UNSIGNED NOT NULL UNIQUE COMMENT "Ссылка на заявление на предоставление услуги",
  payment_status ENUM ('in progress', 'confirmed') NOT NULL COMMENT "Статус платежа",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Оплата услуг";

ALTER TABLE payments   
  ADD CONSTRAINT payments_order_id_fk
    FOREIGN KEY (order_id) REFERENCES orders(id)
      ON DELETE CASCADE;
     
DROP TABLE IF EXISTS articles;
CREATE TABLE articles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  category_id INT UNSIGNED NOT NULL COMMENT "Название категории", 
  subject TEXT NOT NULL COMMENT "Название статьи",
  body TEXT NOT NULL COMMENT "Текст статьи",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Статьи";

ALTER TABLE articles 
  ADD CONSTRAINT articles_category_id_fk
    FOREIGN KEY (category_id) REFERENCES categories(id)
      ON DELETE CASCADE;

      
     










 


 






   
