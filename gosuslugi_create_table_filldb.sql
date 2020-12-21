
-- Курсовая работа Гуриной Натальи

-- База данных "Госуслуги" хранит:
-- данные пользователей (учетная запись и профиль), 
-- информационные сообщения, которые получают пользователи от систем, подключенных к сервису, например, от: Почты России, ГИБДД, непосредственно самого портала "Госуслуги",
-- каталог услуг, которые может запросить пользователь, с указанием ответственного ведомства, сроков исполнения и стоимости услуги,
-- услуги также поделены на категории ("паспорт", "транспорт", "работа"),
-- для каждой категории услуг предусмотрены полезные статьи по данной тематике,
-- у каждого пользователя есть определенный уровень учетной записи ("простая", "стандартная", "подтвержденная"),
-- в зависимости от которой пользователю открыт/закрыт доступ к определенным услугам.
-- Также есть таблица, которая содержит список всех услуг, которые запросил пользователь,
-- и таблица с оплатами услуг.

DROP SCHEMA gosuslugi;

CREATE SCHEMA gosuslugi;
use gosuslugi;

#
# TABLE STRUCTURE FOR: access_levels
#

DROP TABLE IF EXISTS `access_levels`;

CREATE TABLE `access_levels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название учетной записи',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Профили';

INSERT INTO `access_levels` (`id`, `name`) VALUES (1, 'Простая учетная запись');
INSERT INTO `access_levels` (`id`, `name`) VALUES (2, 'Стандартная учетная запись');
INSERT INTO `access_levels` (`id`, `name`) VALUES (3, 'Подтвержденная учетная запись');

SELECT * FROM access_levels;

#
# TABLE STRUCTURE FOR: categories
#

DROP TABLE IF EXISTS `categories`;

CREATE TABLE `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название категории',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Категории услуг';

INSERT INTO `categories` (`id`, `name`) VALUES (1, 'Услуги в разделе \"паспорт\"');
INSERT INTO `categories` (`id`, `name`) VALUES (2, 'Услуги в разделе \"транспорт\"');
INSERT INTO `categories` (`id`, `name`) VALUES (3, 'Услуги в разделе \"работа\"');

SELECT * FROM categories;

#
# TABLE STRUCTURE FOR: services
#

DROP TABLE IF EXISTS `services`;

CREATE TABLE `services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название услуги',
  `price` decimal(7,2) DEFAULT NULL COMMENT 'Стоимость',
  `days` tinyint(3) unsigned DEFAULT NULL COMMENT 'Срок выполнения',
  `category_id` int(10) unsigned NOT NULL COMMENT 'Название категории',
  `responsible_id` int(10) unsigned NOT NULL COMMENT 'Идентификатор ведомства',
  `is_online` tinyint(1) DEFAULT NULL COMMENT 'Может ли услуга быть полностью оказана online',
  PRIMARY KEY (`id`),
  KEY `services_category_id_fk` (`category_id`),
  CONSTRAINT `services_category_id_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  KEY `services_responsible_id_fk` (`responsible_id`),
  CONSTRAINT `services_responsible_id_fk` FOREIGN KEY (`responsible_id`) REFERENCES `responsible` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Справочник услуг';

INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (1, 'Замена паспорта РФ в связи с достижением возраста 20 или 45 лет', '200.00', 10, 1, 1, 0);
INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (2, 'Загранпаспорт нового поколения гражданам от 18 лет', '3500.00', 90, 1, 1, 0);
INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (3, 'Регистрация гражданина по месту жительства', '0.00', 3, 1, 1, 1);
INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (4, 'Проверка автомобильных и дорожных штрафов', '0.00', 1, 2, 2, 1);
INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (5, 'Замена водительского удостоверения при истечении срока его действия', '1400.00', 3, 2, 1, 0);
INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (6, 'Регистрация нового транспортного средства, ранее не зарегистрированного в ГИБДД', '2310.00', 3, 2, 1, 0);
INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (7, 'Постановка на учет в центре занятости', '0.00', 11, 3, 3, 1);
INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (8, 'Поиск работы и трудоустройство', '0.00', 1, 3, 4, 1);
INSERT INTO `services` (`id`, `name`, `price`, `days`, `category_id`, `responsible_id`, `is_online`) VALUES (9, 'Получение пособия по безработице', '0.00', 11, 3, 3, 0);

SELECT * FROM services;

#
# TABLE STRUCTURE FOR: responsible 
#


DROP TABLE IF EXISTS `responsible`;

CREATE TABLE `responsible` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название ведомства',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Ответственные ведомства';

INSERT INTO `responsible` (`id`, `name`) VALUES (1, 'Министерство внутренних дел Российской Федерации');
INSERT INTO `responsible` (`id`, `name`) VALUES (2, 'База ГИБДД');
INSERT INTO `responsible` (`id`, `name`) VALUES (3, 'Центр занятости населения');
INSERT INTO `responsible` (`id`, `name`) VALUES (4, 'Портал \"Работа в России\"');

SELECT * FROM responsible;



#
# TABLE STRUCTURE FOR: access_levels_services
#

DROP TABLE IF EXISTS `access_levels_services`;

CREATE TABLE `access_levels_services` (
  `access_level_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на тип учетной записи',
  `service_id` int(10) unsigned NOT NULL COMMENT 'Наименование усоуги',
  PRIMARY KEY (`access_level_id`,`service_id`) COMMENT 'Составной первичный ключ',
  KEY `access_levels_services_service_id_fk` (`service_id`),
  CONSTRAINT `access_levels_services_access_level_id_fk` FOREIGN KEY (`access_level_id`) REFERENCES `access_levels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `access_levels_services_service_id_fk` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Доступные услуги в зависимости от типа учетной записи (уровня доступа)';

INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (1, 1);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (1, 4);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (1, 7);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (2, 1);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (2, 2);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (2, 4);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (2, 5);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (2, 7);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (2, 8);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 1);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 2);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 3);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 4);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 5);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 6);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 7);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 8);
INSERT INTO `access_levels_services` (`access_level_id`, `service_id`) VALUES (3, 9);

SELECT * FROM access_levels_services;

#
# TABLE STRUCTURE FOR: articles
#

DROP TABLE IF EXISTS `articles`;

CREATE TABLE `articles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `category_id` int(10) unsigned NOT NULL COMMENT 'Название категории',
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название статьи',
  `body` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Текст статьи',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `articles_category_id_fk` (`category_id`),
  CONSTRAINT `articles_category_id_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Статьи';

INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (1, 1, 'Nulla maiores dignissimos est voluptates quisquam adipisci reiciendis.', 'Queen. \'I never said I didn\'t!\' interrupted Alice. \'You did,\' said the Caterpillar. \'Well, I\'ve tried banks, and I\'ve tried to fancy what the next verse,\' the Gryphon said, in a moment. \'Let\'s go on.', '2015-12-28 19:07:32', '2014-09-22 10:02:12');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (2, 2, 'Beatae ipsum quam et odio odit qui illo corporis.', 'While she was quite tired of being upset, and their curls got entangled together. Alice laughed so much contradicted in her French lesson-book. The Mouse did not venture to ask help of any good.', '2018-10-18 07:16:43', '2018-08-28 15:26:40');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (3, 3, 'Accusantium at sunt odio eius ab tenetur laborum.', 'Mock Turtle recovered his voice, and, with tears again as quickly as she had plenty of time as she spoke, but no result seemed to listen, the whole pack rose up into the air, mixed up with the tea,\'.', '2017-11-08 07:52:32', '2012-04-16 11:51:45');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (4, 1, 'Laudantium numquam numquam aut ratione aperiam occaecati qui.', 'Alice remarked. \'Oh, you can\'t help it,\' said Alice, \'but I haven\'t been invited yet.\' \'You\'ll see me there,\' said the Mock Turtle sighed deeply, and began, in a dreamy sort of idea that they had a.', '2011-06-23 02:27:23', '2011-07-26 04:41:53');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (5, 2, 'Et rerum consequatur quo voluptatem quos est.', 'Queen to-day?\' \'I should have liked teaching it tricks very much, if--if I\'d only been the right size, that it had VERY long claws and a pair of white kid gloves: she took up the other, and making.', '2012-05-12 07:13:01', '2018-03-11 03:27:13');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (6, 3, 'Aut ea quibusdam corporis qui illum.', 'King replied. Here the other guinea-pig cheered, and was just saying to herself \'This is Bill,\' she gave a sudden leap out of a tree in the act of crawling away: besides all this, there was a.', '2013-09-24 20:14:57', '2018-10-02 11:59:16');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (7, 1, 'Commodi earum quo voluptate a consequatur.', 'Alice began, in a Little Bill It was all very well without--Maybe it\'s always pepper that makes you forget to talk. I can\'t show it you myself,\' the Mock Turtle went on, looking anxiously round to.', '2017-07-20 04:20:09', '2012-08-14 18:26:23');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (8, 2, 'Aut alias recusandae odit repellendus autem.', 'King said to herself, as she spoke; \'either you or your head must be a person of authority among them, called out, \'First witness!\' The first thing she heard something splashing about in all.', '2014-08-10 02:11:06', '2013-08-28 05:12:19');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (9, 3, 'Et voluptas qui consequuntur ab voluptatem possimus voluptatem qui.', 'Bill\'s place for a dunce? Go on!\' \'I\'m a poor man, your Majesty,\' said the Hatter. Alice felt a violent shake at the number of executions the Queen was silent. The King looked anxiously at the end.', '2013-03-30 21:07:25', '2015-02-13 07:44:48');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (10, 1, 'Molestiae aperiam autem doloribus iure est repellendus aut.', 'I know is, it would be the right house, because the chimneys were shaped like ears and the happy summer days. THE.', '2018-07-30 01:25:33', '2015-11-07 05:07:28');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (11, 2, 'Labore voluptas aut doloribus quia.', 'Forty-two. ALL PERSONS MORE THAN A MILE HIGH TO LEAVE THE COURT.\' Everybody looked at Alice. \'I\'M not a VERY unpleasant state of mind, she turned to the conclusion that it might appear to others.', '2013-11-26 19:51:45', '2015-06-21 17:46:19');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (12, 3, 'Debitis consequatur animi odio magni quae.', 'King, \'unless it was impossible to say \'I once tasted--\' but checked herself hastily, and said to herself how she would gather about her and to her ear, and whispered \'She\'s under sentence of.', '2020-03-15 02:12:47', '2013-10-23 06:37:13');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (13, 1, 'Ut provident nihil ipsum quo aut repellat ad laboriosam.', 'Gryphon, \'that they WOULD not remember ever having heard of such a dreadful time.\' So Alice began to tremble. Alice looked down at them, and all of them at last, more calmly, though still sobbing a.', '2017-10-21 18:12:59', '2015-01-06 20:53:21');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (14, 2, 'Cum voluptatem sit tenetur ullam voluptate necessitatibus.', 'The Antipathies, I think--\' (for, you see, as well as pigs, and was looking at Alice for protection. \'You shan\'t be able! I shall only look up in a rather offended tone, \'so I should like to show.', '2020-07-21 14:27:38', '2012-07-28 00:39:03');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (15, 3, 'Quidem quibusdam et occaecati reiciendis saepe fugit natus.', 'Alice was only sobbing,\' she thought, and it was as steady as ever; Yet you finished the guinea-pigs!\' thought Alice. The poor little feet, I wonder who will put on her spectacles, and began an.', '2016-05-10 09:30:47', '2017-10-10 06:07:04');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (16, 1, 'Non voluptatem sed cum doloremque et.', 'Lory, with a sigh: \'he taught Laughing and Grief, they used to read fairy-tales, I fancied that kind of serpent, that\'s all the jelly-fish out of court! Suppress him! Pinch him! Off with his head!\'.', '2017-04-17 22:50:34', '2020-05-12 05:12:23');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (17, 2, 'Omnis eaque earum perspiciatis expedita aut dolorem laborum.', 'March Hare said to herself in the middle, nursing a baby; the cook and the baby--the fire-irons came first; then followed a shower of saucepans, plates, and dishes. The Duchess took her choice, and.', '2014-07-07 20:30:17', '2017-06-14 14:20:16');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (18, 3, 'Magni perspiciatis ab non omnis.', 'I hadn\'t mentioned Dinah!\' she said to the Caterpillar, and the Queen shrieked out. \'Behead that Dormouse! Turn that Dormouse out of the others all joined in chorus, \'Yes, please do!\' pleaded Alice..', '2014-09-29 20:22:00', '2011-11-24 12:32:43');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (19, 1, 'Earum officiis quis vero.', 'I\'m mad?\' said Alice. \'Why, there they are!\' said the March Hare interrupted in a natural way. \'I thought it would be QUITE as much right,\' said the Mock Turtle Soup is made from,\' said the Queen..', '2015-04-10 16:20:08', '2016-08-04 04:27:42');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (20, 2, 'Asperiores voluptatem neque unde debitis.', 'YOUR adventures.\' \'I could tell you his history,\' As they walked off together. Alice laughed so much about a foot high: then she heard the Rabbit in a low, timid voice, \'If you do. I\'ll set Dinah at.', '2014-01-10 17:45:48', '2016-05-13 12:56:57');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (21, 3, 'Tempora fugiat sed dolore enim magni molestiae accusamus sit.', 'The March Hare interrupted, yawning. \'I\'m getting tired of being such a hurry that she began thinking over other children she knew, who might do something better with the Queen, the royal children;.', '2020-06-12 14:27:51', '2012-05-02 17:46:15');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (22, 1, 'Quas velit quo rerum quo asperiores harum libero.', 'She went in search of her childhood: and how she would catch a bat, and that\'s very like having a game of croquet she was quite out of the e--e--evening, Beautiful, beautiful Soup!\' CHAPTER XI. Who.', '2018-11-28 12:04:24', '2017-12-24 10:27:34');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (23, 2, 'Cupiditate et ut dolorem inventore non necessitatibus.', 'Some of the jury asked. \'That I can\'t show it you myself,\' the Mock Turtle Soup is made from,\' said the Hatter. \'You MUST remember,\' remarked the King, and the whole party swam to the puppy;.', '2019-01-12 13:00:27', '2014-02-11 22:51:38');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (24, 3, 'Quasi labore sit et quibusdam doloribus voluptate.', 'Hatter. \'You MUST remember,\' remarked the King, going up to the seaside once in her lessons in the air, I\'m afraid, but you might do something better with the grin, which remained some time without.', '2011-04-03 17:10:23', '2013-11-29 13:21:00');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (25, 1, 'Consectetur placeat corrupti cum libero.', 'I\'ve tried to beat time when she had forgotten the Duchess was VERY ugly; and secondly, because they\'re making such a neck as that! No, no! You\'re a serpent; and there\'s no meaning in it,\' but none.', '2013-10-04 21:48:27', '2020-08-06 04:30:27');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (26, 2, 'Soluta nam rerum non neque minima quis.', 'When they take us up and rubbed its eyes: then it chuckled. \'What fun!\' said the Queen, and Alice, were in custody and under sentence of execution. Then the Queen never left off when they liked, and.', '2017-01-15 17:34:59', '2016-01-16 09:25:07');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (27, 3, 'Sunt molestiae quam quos ipsa veniam sit corporis harum.', 'King replied. Here the other was sitting between them, fast asleep, and the arm that was linked into hers began to tremble. Alice looked all round the court with a T!\' said the King, the Queen,.', '2014-01-05 01:55:32', '2016-03-25 23:27:04');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (28, 1, 'Corrupti occaecati ea magni itaque inventore libero animi sed.', 'Alice thought), and it put the Lizard as she went round the thistle again; then the different branches of Arithmetic--Ambition, Distraction, Uglification, and Derision.\' \'I never heard it before,\'.', '2013-06-22 12:27:46', '2015-04-21 04:18:48');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (29, 2, 'Explicabo sapiente voluptas itaque.', 'White Rabbit as he said to herself; \'I should like to see you any more!\' And here poor Alice in a VERY good opportunity for making her escape; so she turned to the company generally, \'You are all.', '2010-12-13 16:05:16', '2010-12-26 13:18:55');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (30, 3, 'Eos ea rerum qui officia omnis.', 'But if I\'m not used to read fairy-tales, I fancied that kind of sob, \'I\'ve tried every way, and nothing seems to like her, down here, that I should like to be two people! Why, there\'s hardly enough.', '2016-01-18 19:24:29', '2015-03-23 11:11:08');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (31, 1, 'Et id et quos sit expedita molestiae.', 'I beg your pardon!\' said the Queen, who was talking. \'How CAN I have done that?\' she thought. \'I must be a comfort, one way--never to be treated with respect. \'Cheshire Puss,\' she began, rather.', '2019-06-22 23:20:22', '2012-03-30 19:45:06');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (32, 2, 'Dolorum officiis rerum tenetur optio consectetur aut.', 'Caterpillar angrily, rearing itself upright as it was in the distance. \'And yet what a Gryphon is, look at the proposal. \'Then the eleventh day must have been changed in the sea. The master was an.', '2015-09-06 01:24:59', '2017-03-24 23:02:52');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (33, 3, 'Aut consequatur voluptatem qui repellendus.', 'Alice was too dark to see it trot away quietly into the air. Even the Duchess was VERY ugly; and secondly, because she was peering about anxiously among the branches, and every now and then at the.', '2016-05-16 08:07:59', '2018-04-20 02:20:26');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (34, 1, 'Voluptatum eaque ut nulla sapiente magni enim.', 'I hadn\'t cried so much!\' said Alice, whose thoughts were still running on the floor, and a long and a Dodo, a Lory and an old Crab took the place of the house till she was beginning to grow larger.', '2020-05-02 08:23:02', '2018-02-17 19:29:14');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (35, 2, 'Neque aut sint saepe est fugit.', 'March Hare. \'He denies it,\' said Five, in a mournful tone, \'he won\'t do a thing before, but she could not help bursting out laughing: and when she had sat down in a minute or two the Caterpillar.', '2011-04-29 18:43:11', '2019-04-03 00:23:05');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (36, 3, 'Excepturi suscipit suscipit voluptatem aut et odit.', 'Pigeon had finished. \'As if I shall never get to the little golden key in the book,\' said the Gryphon: and Alice heard it muttering to himself as he found it so quickly that the Queen jumped up in.', '2017-04-02 10:57:00', '2011-05-22 03:13:47');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (37, 1, 'Sed adipisci et omnis modi possimus non.', 'Queen! The Queen!\' and the words a little, \'From the Queen. \'It proves nothing of the Queen of Hearts were seated on their backs was the Hatter. \'I told you that.\' \'If I\'d been the whiting,\' said.', '2018-09-20 16:13:18', '2014-05-20 04:03:59');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (38, 2, 'Quo ut voluptates eum a quia.', 'And she began thinking over other children she knew the right size, that it might belong to one of them say, \'Look out now, Five! Don\'t go splashing paint over me like that!\' He got behind him, and.', '2019-02-04 13:20:21', '2017-01-21 08:18:45');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (39, 3, 'Temporibus debitis voluptatibus laudantium.', 'Duchess said to Alice, and she crossed her hands up to her in an undertone, \'important--unimportant--unimportant--important--\' as if it began ordering people about like that!\' said Alice to herself,.', '2018-02-07 15:57:00', '2018-04-02 15:28:38');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (40, 1, 'Et dolorum dolores quia error voluptas sit totam fugit.', 'How she longed to change the subject. \'Ten hours the first to speak. \'What size do you like to be said. At last the Mouse, who seemed to quiver all over their heads. She felt that she might as well.', '2019-01-31 06:58:55', '2016-10-13 02:30:52');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (41, 2, 'Sed nisi sequi distinctio repellat ea soluta.', 'As soon as she spoke. (The unfortunate little Bill had left off sneezing by this time, sat down again into its mouth and yawned once or twice, half hoping that they were nice grand words to say.).', '2017-12-02 22:00:52', '2017-08-03 23:03:56');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (42, 3, 'Earum tempora velit dolorem rem pariatur earum.', 'In the very tones of her favourite word \'moral,\' and the pattern on their hands and feet, to make out that she hardly knew what she did, she picked her way through the neighbouring pool--she could.', '2011-10-07 02:55:49', '2015-11-16 03:59:11');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (43, 1, 'Praesentium nobis et nihil.', 'I did: there\'s no use in saying anything more till the eyes appeared, and then a great letter, nearly as she spoke. \'I must be Mabel after all, and I don\'t know,\' he went on, \'you throw the--\' \'The.', '2020-04-27 23:07:17', '2016-01-16 15:06:50');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (44, 2, 'Nihil et officiis ea dicta ut fuga.', 'Her chin was pressed hard against it, that attempt proved a failure. Alice heard it say to itself \'Then I\'ll go round and get ready for your walk!\" \"Coming in a solemn tone, \'For the Duchess. An.', '2018-02-24 13:51:05', '2011-12-29 13:01:43');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (45, 3, 'Ut amet mollitia ut quisquam voluptatem ut accusamus odio.', 'Alice thought she had read about them in books, and she tried hard to whistle to it; but she remembered having seen in her French lesson-book. The Mouse gave a little nervous about it while the rest.', '2012-12-08 18:08:12', '2017-03-20 15:30:44');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (46, 1, 'Cumque corporis aperiam eligendi vel delectus eum.', 'Queen, \'Really, my dear, and that he had to leave off being arches to do such a simple question,\' added the Dormouse. \'Don\'t talk nonsense,\' said Alice to find my way into that lovely garden. I.', '2012-10-21 01:33:04', '2018-04-19 19:14:11');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (47, 2, 'Provident aut nemo provident enim repudiandae mollitia.', 'Mock Turtle, and to stand on your head-- Do you think you can find out the words: \'Where\'s the other was sitting on a little queer, won\'t you?\' \'Not a bit,\' she thought of herself, \'I wonder what.', '2018-03-19 09:17:54', '2012-10-05 16:25:51');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (48, 3, 'Aspernatur libero eos rerum quo itaque sit.', 'Gryphon in an undertone, \'important--unimportant--unimportant--important--\' as if it thought that it was not much like keeping so close to her: first, because the chimneys were shaped like ears and.', '2016-04-18 23:48:32', '2018-12-02 14:57:56');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (49, 1, 'Quos nobis autem et quaerat.', 'Alice, very much at this, she came upon a little pattering of feet in the air, I\'m afraid, but you might knock, and I could shut up like a writing-desk?\' \'Come, we shall have to fly; and the Queen.', '2011-08-14 06:22:09', '2019-07-11 17:51:15');
INSERT INTO `articles` (`id`, `category_id`, `subject`, `body`, `created_at`, `updated_at`) VALUES (50, 2, 'Voluptatem tempora voluptas voluptas provident quidem maxime animi debitis.', 'Alice had no pictures or conversations in it, \'and what is the use of a good way off, panting, with its legs hanging down, but generally, just as if a fish came to ME, and told me you had been.', '2014-01-01 07:21:39', '2013-08-26 07:41:43');

SELECT * FROM articles;

UPDATE articles SET updated_at = NOW() WHERE updated_at < created_at;


#
# TABLE STRUCTURE FOR: users
#

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `password` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Пароль',
  `access_level_id` int(10) unsigned NOT NULL COMMENT 'Тип учетной записи',
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Почта',
  `phone` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Телефон',
  `snils` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'СНИЛС',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `snils` (`snils`),
  KEY `users_access_level_id_fk` (`access_level_id`),
  CONSTRAINT `users_access_level_id_fk` FOREIGN KEY (`access_level_id`) REFERENCES `access_levels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Пользователи';

INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (1, '7e401329936241ea952a69cbc036b1c852bcd0600022f21dd5661f5f7b9bff4d', 1, 'mona.daugherty@example.net', '1-502-583-3148x72232', '17047003959', '2017-06-30 14:28:11', '2010-12-31 16:42:44');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (2, '6049cf6c8e559a12852f2e3c58da0330b8916e46370bca0b4f4774505271bb7a', 2, 'williamson.jovan@example.com', '(030)068-3463', '15689816460', '2019-03-07 04:46:53', '2019-11-21 07:18:40');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (3, '5539931d79c80f5c847e73e0e4b2868c486934643a6bb4cccd7ba518a2a3a3f7', 3, 'ayana.botsford@example.net', '990.451.7477x881', '16520769312', '2012-10-06 23:45:12', '2013-05-08 21:28:42');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (4, 'b5631771aad5874489983c46eccb1c4233855ad99133a56fc92e9e7132ef8da7', 1, 'fmedhurst@example.net', '950.542.0628x727', '18245871942', '2015-03-25 06:01:45', '2012-09-10 20:50:34');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (5, '07d72c88d8fe0958e829edeb57b2d391b9d86b634f1b43a927301c571e1fb70a', 2, 'luigi40@example.org', '+21(5)6475549264', '13565935841', '2016-02-06 00:29:34', '2017-05-02 23:35:31');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (6, '9bfef63dbc25deeb082c1fe541b86fc0a8e7a817d533e97aabe7e300648d1f78', 3, 'moore.mason@example.net', '1-383-129-0536', '19478102512', '2015-05-19 20:01:25', '2012-07-03 20:46:13');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (7, 'be92457e24589f361d02e9fd4a83e25ca192f0b8cf874989eaee4f02bbedc202', 1, 'niko28@example.org', '(545)748-2072x21641', '13396376431', '2015-08-30 20:38:59', '2013-02-04 10:10:36');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (8, '06a3c27e5aa6e82d61b9b132f91535d729974b7e386845c8553e5907d14effe3', 2, 'sporer.clare@example.com', '161.225.0857x8989', '12471623923', '2020-03-24 14:13:49', '2011-07-06 01:28:35');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (9, '9d94101b27d83e647c7ba68cc11efbb5bf02c99943108cbb184aa7443f4bf396', 3, 'talia.williamson@example.org', '04502660009', '18113861321', '2019-09-18 14:33:26', '2017-12-01 01:56:19');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (10, '59eae680248200c67cc0a5b643acab376e7774bb21f4213c429bc5924678f567', 1, 'dewitt.dietrich@example.com', '257-112-8887x9303', '13465795754', '2015-09-05 08:44:17', '2020-09-15 11:52:38');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (11, '7f3661c31a2d3c2721d37ae92c132fe0689235f27eeadb19f6839b6de8cf662e', 2, 'mmayert@example.net', '720.707.2800', '12570118610', '2015-08-19 10:26:00', '2020-10-15 16:03:22');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (12, 'e6a3909984582a04dc3ef996125f083cde197e3da94ef5fea1445042a15505ca', 3, 'mallie.brown@example.com', '853-497-2689x726', '15894611030', '2013-06-16 20:29:29', '2017-03-13 09:02:38');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (13, '87f5096776c3513690169b1f05ba63fc2d2f193f1286c323993092003913610d', 1, 'cummings.jaren@example.org', '347.889.4287', '11431103171', '2019-06-26 07:49:16', '2016-08-08 03:44:25');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (14, '0a4fea4fff149b446df15c9758a1176396346c99699e177089cc913f667c8c0f', 2, 'swill@example.com', '1-022-898-7535', '10804237010', '2020-05-18 08:17:59', '2015-03-21 16:32:41');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (15, '4f554140298e80e1ce729ab7807f3215c3b4dc692ad31a89dc0cc6b4d06787b7', 3, 'gheller@example.org', '135.609.0674x391', '11101369606', '2018-05-16 10:59:54', '2013-07-28 10:43:54');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (16, 'a314c35bf9c2da60e99bc7caa957033396ecec88f47ede763844ae119e5f9a69', 1, 'zkoch@example.org', '774-760-2521x32675', '14092084160', '2011-04-12 14:12:57', '2015-06-11 02:05:56');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (17, 'a490f14daed3aefca400987b98a6f5ae3488d6c1486ed888feba995a05f9e461', 2, 'sawayn.mckayla@example.org', '1-117-129-5869', '14488116223', '2018-05-01 19:01:56', '2013-04-15 15:24:57');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (18, '5fe35d9dab7ed6714df279a1a7ed8607c7449191a403ba5e6ecb7970a48a8fe4', 3, 'theodora.botsford@example.com', '1-749-924-5348x812', '12275725146', '2018-01-17 04:04:07', '2020-04-17 20:24:38');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (19, '1cf6e28853318d3e9ded84e98ac53bfa2b48f7f4252e50f1cf4645e57f951b32', 1, 'hodkiewicz.elda@example.org', '1-236-005-6556', '19188869092', '2015-03-30 18:38:13', '2012-12-19 17:38:01');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (20, 'bce3526d56dfef77c2e24d3b815ea8aecb28db8055e7c12eace6bce3c076e268', 2, 'homenick.orlando@example.net', '014.067.2516x023', '19974042046', '2016-10-24 12:10:06', '2020-01-08 14:00:19');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (21, 'e7d210febbf589a4347504d42c2890c3c9046e53e8c48dc7bc2fcb4ee9b721f9', 3, 'wayne.oberbrunner@example.com', '013.025.4044x93873', '16668773847', '2014-08-24 21:50:27', '2019-06-04 12:27:47');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (22, 'ed7af410688a7c4238d241ff1076d1fde9f478ec12080523ae38f0316639db64', 1, 'dortha.murphy@example.net', '053.255.1867', '12138904617', '2016-10-09 00:17:00', '2011-10-10 12:04:20');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (23, 'ba641d79a28c4a9fc787d2df0de2249761a876f0a1a026dd60cfb641e968729d', 2, 'keagan85@example.net', '(709)439-2222x74209', '19676025612', '2016-07-28 21:51:02', '2019-10-31 14:05:53');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (24, '30db5cd8d33ae311b694fd61df2544159b07342deb1f8506db1941e146232c00', 3, 'huels.vivian@example.net', '618-376-0953x44540', '11667611575', '2018-03-25 06:41:13', '2020-02-21 13:48:31');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (25, '564f673d74eee31d0362ee006fb3ed71e27fb23c56c4a20adf37cbf729f9c984', 1, 'yfritsch@example.net', '131.477.7662x666', '13713161102', '2015-07-31 22:43:33', '2014-01-06 18:54:28');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (26, '10fdfd15bcf8d085f54c124e42acbec5806d919078193bfdd405b1144221b9c2', 2, 'alexa.dickinson@example.com', '1-175-104-3003', '13483230862', '2011-03-05 08:54:26', '2016-06-13 07:37:32');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (27, '3313306b4c8b6a7744cd5c3bdd416e6071c0ace78b576a96bfa46f863c654115', 3, 'harvey.verona@example.net', '1-709-296-1811', '19386543184', '2019-11-14 09:16:43', '2012-02-03 06:58:46');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (28, 'd596d19ea58ce3bd8c7ee90b3a29cd1ad9aeb9733d487388e1a09815a2eb91fc', 1, 'emueller@example.org', '498.338.7360x2012', '14390824632', '2018-05-04 08:30:07', '2012-01-31 13:42:15');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (29, '07b23be72e9f1c0b18c3e064c82ce3fad960b017010ca85739f55faf5ca532c6', 2, 'ghalvorson@example.net', '210.374.8269', '10208975151', '2011-07-20 23:43:48', '2014-04-13 04:33:14');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (30, 'f05acec74eaa41a3a4c94307ad03c368d2f8f4ff9d696ddaee1ac31615b86628', 3, 'josiane.quigley@example.org', '(988)600-2166x29370', '18448602892', '2014-11-29 10:18:01', '2012-05-15 14:38:12');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (31, 'c2091d8568e8a164349b4431cd913261f09036c68e078498cd504b84549986a9', 1, 'bo95@example.org', '769.148.6915x9849', '10148440292', '2019-10-24 02:55:58', '2020-04-02 21:42:23');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (32, '16a539978017725fd18cb7683d4c7645895a325e8c6c2aa77aa03d0ad3faa33e', 2, 'jackeline.dare@example.com', '129-715-7390x718', '13684545345', '2016-08-19 00:12:20', '2011-08-19 01:18:10');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (33, '6d9de527bae000b0e7ccb35caeb5779c211dc98af3713efc26b201a06e34061f', 3, 'marcia.barrows@example.org', '948-349-0110x267', '19657110241', '2013-12-12 05:02:10', '2020-05-24 09:54:03');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (34, 'a5a2a0a899d15e469b0bd19be0698f6dfb1b32ccd2d30f29b5733f71fbb852bc', 1, 'lschimmel@example.com', '1-371-326-8517', '11117247887', '2014-03-30 18:16:34', '2012-09-01 20:13:03');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (35, 'f7a644a18ed8e144dca2fc571e06d971d1023ee943931cd96263b2e8c808d664', 2, 'breitenberg.aditya@example.net', '836.863.1242x586', '11360938632', '2017-07-20 20:18:35', '2012-01-28 07:34:47');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (36, 'b452aa6fa59bcf99a5414b32f4c92f02515d46be5c5a0256940d2ef3a0c57eb1', 3, 'kohler.malcolm@example.com', '285.847.5965', '12439102418', '2011-02-14 05:05:26', '2020-06-06 16:12:36');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (37, '9cffc7ec695de624356836fa3bd37b5b511998f855b0afe9cd47db4e2e431046', 1, 'sigmund03@example.com', '323-343-2696', '15764271458', '2012-12-21 10:37:17', '2019-06-17 00:00:59');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (38, 'd7649ea02d54ba6ecd699136f7b21cafc03c32e837a37d2e97600f7da12ecc1d', 2, 'jessy.wisozk@example.net', '+17(2)3294213787', '11979795605', '2020-05-06 15:19:56', '2011-07-14 18:42:26');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (39, '48443160a6d9df05f758643b7acb08bd78896bdc0d54c7a10c1a498ed7b17f6e', 3, 'mhayes@example.com', '06758384745', '13142552673', '2011-08-09 20:55:43', '2016-01-30 11:28:20');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (40, '4316c208bdccc710c48e0b5f7ba3f2fac6e7061fb078a130e9030847691ed6e5', 1, 'hansen.alanna@example.org', '171.610.4026', '18852967172', '2018-04-13 09:17:55', '2017-12-10 00:28:44');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (41, 'd3954e7ca36e8eb62766866ccd2aa2b1e3e7321d5913b07ef97d899bd3763441', 2, 'katharina48@example.org', '017.601.1598', '18083472433', '2012-02-27 01:16:20', '2015-03-14 01:46:12');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (42, 'b2c47f1415d9852c17f725576aa0cedca7f3288c480cc4019317223fe1180e20', 3, 'hermann.theresia@example.org', '1-987-110-3529x06935', '13758102748', '2018-11-23 19:45:19', '2019-09-07 12:12:26');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (43, 'c7ce09c83700dd403d2247a7989daaff6978afc669087be14deef36e5ec1cdb7', 1, 'gorczany.hermina@example.com', '(492)184-2043x8192', '14174353955', '2012-10-29 08:30:04', '2019-11-09 05:11:25');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (44, '6295e613aab40b19aa6d0215befc4a95315274ad8bbae73c5bcf930ccdc8a714', 2, 'nframi@example.net', '331.178.5227x25584', '18314134241', '2013-03-04 00:06:48', '2016-11-15 00:57:01');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (45, '18c3784b7092c4c1012201bc136eda9aff547cc1d82c1637a6b0f55e8b84d89e', 3, 'geoffrey60@example.net', '+89(0)9797630320', '10704612261', '2020-11-26 10:08:46', '2013-05-05 02:32:42');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (46, 'f03296173d7fd70612111b4911b50547d2a6eb864b9083282dcd55a55daf6f96', 1, 'kailee51@example.com', '399.339.0459', '14895630157', '2019-05-29 11:06:23', '2012-05-29 05:01:09');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (47, '5d12f90d567eb6aeda0fe6a01139f940dec92c2405e75550951930c323da3c6f', 2, 'ike03@example.org', '(332)408-9402x162', '11393167595', '2018-10-25 21:12:57', '2019-12-03 11:22:28');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (48, 'd6b1983b5ef16fea9da80eae1ea7cd0decfb7b94a39f9b85770852c18d53741d', 3, 'minnie.stanton@example.net', '786-673-7052x461', '11477498803', '2014-05-12 16:04:56', '2019-09-25 02:59:26');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (49, '5d7d27cf84b4085059ec99ca812e8d5786940f9f55bfa3ebff7b53170a6ceb3a', 1, 'arjun42@example.com', '04596596423', '17234999798', '2019-05-02 00:59:27', '2014-01-09 09:07:41');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (50, '9e03866317f4007f3fe79bf3f1920c198eda1abb02fe3c8ba379215fd1c63ca7', 2, 'keebler.nickolas@example.com', '1-089-807-6870', '13343557664', '2016-10-25 06:25:03', '2013-07-01 03:41:01');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (51, 'cd7ab91b576c31dd9e105b2974e884acd1ac1f3809d15d4a84aeb9bc2767423c', 3, 'denesik.jay@example.org', '1-447-440-1954x334', '10042785191', '2014-05-15 21:54:43', '2013-06-22 01:47:34');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (52, '0b40f5d3e8d47bca765a4d57e99bf1cb87aa9d8da516004e310aed81b3a8050e', 1, 'ebert.abigale@example.org', '1-226-673-8741x180', '11252455567', '2017-12-03 06:51:52', '2016-07-02 22:37:43');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (53, '6742bd1340723db69ccb13c6a54b26fcac48897f3605d01f5e9a00eeb3593cb0', 2, 'jackie.o\'reilly@example.com', '664.580.7176x517', '17050372264', '2019-02-05 19:08:35', '2018-12-10 02:20:05');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (54, '33813d99de2f791a67567e7403d23e58606fc95aac928fc93ec42b2721ef1889', 3, 'emely.jacobson@example.org', '647-757-2988x7221', '11359825287', '2012-06-13 16:27:04', '2011-06-02 14:00:19');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (55, '7cf180ee9b32b1f45e684b578f8e496569086e7a0b9ff014a1bbccab0c7b0948', 1, 'rosanna.hintz@example.net', '(635)402-7981x7685', '10237374077', '2020-03-24 05:04:40', '2015-04-10 20:20:34');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (56, 'e62a86f5398de9a2e1434d737d4a8688297f9e00ac6536faba4156ae76ff405c', 2, 'torphy.zachary@example.net', '(565)939-1498x9876', '15354059860', '2016-10-19 22:10:40', '2015-02-06 09:26:01');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (57, 'c5323253a702903b5a9fc9fa87c042da65f6a73fca69883585b8fe3d1eaa242d', 3, 'rachael.goyette@example.com', '571.467.6513x89497', '11192546053', '2018-03-28 18:29:21', '2016-02-20 13:26:45');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (58, 'b84369bc7833a9b7f6023317dec819e87f5538d1b37da8708c9454e189be812e', 1, 'gbreitenberg@example.net', '1-499-141-9576', '19414584231', '2012-03-04 04:06:18', '2016-02-02 21:10:17');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (59, '64a2926ed24ff08a74d81cd089045af7249abfffa1ad6bf87dd346e7fb31040b', 2, 'patience.wolf@example.org', '026-359-8524x5249', '12229829588', '2017-08-08 03:24:15', '2018-10-26 16:45:20');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (60, '72a1147b3bec5fb2bba998fe42edc0a5af316931e824377a78690c6681626ca3', 3, 'katrine59@example.org', '1-868-233-2073x1482', '14125892221', '2014-03-02 07:27:14', '2014-06-06 08:07:23');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (61, 'c7c79f665c15392924c5c81264c8742b3db4bb0d9f73b917bd74fd8147069817', 1, 'sasha.stark@example.net', '1-668-790-1374', '16618648245', '2013-06-30 19:48:06', '2011-09-23 20:56:22');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (62, '191291be40d7a2e7748528eea965590d19667e3da6bf423775ba95d0936147c1', 2, 'gusikowski.rhett@example.com', '(337)368-7943', '11348785771', '2016-12-09 02:53:33', '2017-07-03 15:57:23');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (63, '3d51a4b9d5d13f9611ecb1ff83147e05653324eaf59d88cdd6ae8942cd8641ab', 3, 'mortimer.terry@example.net', '(493)961-2732x2457', '11452787751', '2019-02-24 22:11:13', '2011-10-11 21:16:34');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (64, '219f919c3a93957cae8040bbd289a1ce30ad5ca1d77367cd3513d2b63893541c', 1, 'citlalli67@example.com', '807-614-7351x7465', '18963435147', '2018-07-01 11:15:15', '2012-08-23 10:46:07');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (65, 'c7f3037218855bc2c96af8bc7abcef18a099606921682c9589201186494217cf', 2, 'icorkery@example.net', '299.427.9512x7994', '10347272912', '2019-11-27 18:19:24', '2014-11-01 04:03:51');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (66, 'a6d3a9ff0026d3154d5f877f1d0aebfe6b610b4680fcb12db6af81b2311aa739', 3, 'wsauer@example.com', '+14(3)9456759885', '11205212459', '2015-10-28 20:00:33', '2015-10-01 10:29:40');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (67, 'b14acb92a7a3fb8fce80de60b40171d320f410ea7e46ab2c311563456b12c349', 1, 'estrella.nicolas@example.org', '720-448-1963x99915', '11507570021', '2011-01-05 12:29:35', '2018-07-24 06:31:34');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (68, 'b92b3c707e6ae9f646581ce44ec8ddf58917f48c67d920f2837b63658aa7fe53', 2, 'charlotte.lemke@example.net', '777-556-5796x57847', '18399766869', '2019-10-31 09:06:34', '2015-10-18 04:18:03');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (69, '5b34898992feab6552d83c9ee602fd063ed793fc4d55f51dfac9f7d08daa4d47', 3, 'mia.deckow@example.org', '1-722-099-0083', '14537256932', '2014-05-23 10:29:04', '2018-01-20 23:21:10');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (70, 'ddb205552329cfa6dfc7d4a5d95247e2f1310a64a441db688ef3946d91ccb273', 1, 'trinity.kub@example.com', '(133)850-9123x704', '17748992708', '2011-08-29 21:39:03', '2018-05-10 18:24:44');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (71, '0309167f6115f85d5e98dbf07dff21633a9a7f831d313ac8146cd93ebd091be4', 2, 'sally58@example.com', '1-578-994-6599x9831', '18369944179', '2019-09-06 08:49:29', '2020-04-26 20:39:19');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (72, 'eb42a9aa4c561d63e7ed352b1c5d3f33f856f8a3c916d1a5e2fa932566a588b5', 3, 'o\'kon.neal@example.org', '234-252-5270', '10510418587', '2019-08-23 08:44:19', '2014-05-26 12:31:28');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (73, '5c63d1f361a9ebadc16f3d7ef95a60341012124e7049affc1638f4239cd55647', 1, 'reynolds.griffin@example.net', '1-187-239-3143', '11000429750', '2014-08-12 14:05:14', '2012-09-05 07:20:12');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (74, '5b17dc9d6ce6143b0159ccc681bb661735eadd9da366c910c1700ead49a414e4', 2, 'rhea.dietrich@example.com', '599-415-5408x49908', '15400593238', '2011-07-25 00:04:38', '2011-07-23 06:27:50');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (75, '83c0baddbbee2d2b1f20fcfae36f534d549a4a665e6be214817950f369579d60', 3, 'efahey@example.org', '1-717-753-0247', '17592660565', '2014-07-26 20:51:57', '2017-02-14 23:54:38');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (76, '71e97138f85ce41c0a25bec6051452deb1322993f4977c742081c801bd1bb3ab', 1, 'wkassulke@example.com', '09923272319', '19088539979', '2017-08-27 10:14:13', '2015-04-23 18:31:37');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (77, '72432fd0bb46da0c1b80ee84e7a65e8e6416088922ab414506a0be4f8a6903a2', 2, 'hand.tatyana@example.net', '784.604.8618x24389', '18127721701', '2015-03-01 02:13:56', '2016-09-02 14:19:15');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (78, '34dbaea30641b5cb6cf30f43c817f3c7cdd87aeb7dcec2a910ca42b412c8df50', 3, 'ndaugherty@example.org', '413-050-9739x97031', '18793463893', '2014-01-19 02:23:20', '2016-10-15 03:59:55');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (79, 'd28342620034b6fa12745d5a69c66482bd60913aa9bd3321bc168be325489e83', 1, 'lavinia.schumm@example.com', '757.653.2508', '14854430919', '2016-08-30 13:32:18', '2013-03-20 07:18:13');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (80, 'fb410259be8f3f34b94ba2035bf3ed2da56e2e2f002f2e579f9c9d5f3537d6fc', 2, 'ebergnaum@example.net', '630.485.1927', '19610831169', '2020-06-08 00:36:30', '2015-05-02 22:12:24');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (81, '8094c88666332c22cd90a4e193994ced861501e9584b0edb7bd8303adaf7c96d', 3, 'tstokes@example.com', '262.202.2760', '17910925187', '2011-09-09 01:52:43', '2014-04-04 22:22:54');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (82, '2fd176264b0fac161f70380cec474034c2e23ade72633a9370569be67a5bf3da', 1, 'wfeil@example.net', '582.071.6840x388', '16775020691', '2013-06-29 20:29:31', '2015-12-17 10:13:17');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (83, 'd554286333f1aef6c91d299e4114d4375819a3276d072b085b8b9549be63c554', 2, 'laurie.hahn@example.net', '110-797-0128', '15326915537', '2014-06-30 05:42:43', '2011-08-15 12:51:53');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (84, 'e8c6182a8ca9418d0cec2555e1f25b53a66c73d9e1ace06247bbf86d8c0399e5', 3, 'linda.bashirian@example.com', '303-930-4343', '13147010789', '2020-06-23 19:05:05', '2014-07-08 23:51:41');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (85, 'd3b7893dea053b4c8e4c0c253aaddc4484f399c5d4a1edfd0f8fc141430e7956', 1, 'reina40@example.net', '(028)352-3674', '16850082413', '2016-07-06 04:42:36', '2012-07-27 20:54:22');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (86, 'db6990c6b6c1228f837c53414f6a8981e82c2b7c97187b8e41ece7edf79d273a', 2, 'xschmidt@example.net', '398-574-8069x3145', '11817210922', '2019-04-16 12:41:14', '2014-06-17 16:20:15');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (87, '1065f35b463b21ad09f9196b062ecc1535b124b0cbb2673de487e6812c15da49', 3, 'hsipes@example.org', '1-881-585-9879x838', '12953403079', '2015-01-18 18:29:56', '2018-12-24 16:06:01');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (88, 'd3d4d48849e1b29295475df49fecfb7ea71ba31c5e796b7439be278cb19cd4f0', 1, 'noemi.paucek@example.org', '+22(7)2861396154', '13397458037', '2013-11-08 18:03:36', '2014-03-15 00:00:29');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (89, 'be6f69859336a76cfc19731d3de9f9528762e80716186751c64946f50ba37d0c', 2, 'laura45@example.com', '1-001-933-1252x20351', '17738677226', '2015-01-31 12:04:41', '2016-01-05 10:56:27');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (90, 'ee78dbc0e2f1f091dfe4132c5e2463daa718056dfeefd80c2ddcbeee29f66927', 3, 'yhand@example.net', '883-132-1819', '19863905333', '2010-12-20 22:16:33', '2019-02-08 13:22:20');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (91, '5198d415c26c1bd99768a44046c545d200c0446b6059bb77f3a647d0b60b3031', 1, 'tina.abbott@example.net', '03176982615', '15983053739', '2013-08-16 01:15:22', '2018-12-20 16:48:37');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (92, '653134f91f45c18f0e3f852977a736fa1b8a4bcaeb1b0c5a301eb034d00a8e26', 2, 'kurt54@example.com', '125-468-1352', '13176024453', '2020-10-09 12:29:59', '2015-08-07 12:42:30');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (93, '0fba87aaee35e45bc1abded0befa0533fbeecacc68f12c63d401ce15c51b14b8', 3, 'presley.kessler@example.net', '616.251.2566x384', '17795369070', '2014-11-12 19:20:24', '2012-10-07 18:25:54');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (94, '4efe586ed72e81c75bc9731010b996e509a63e75bfdf8dba6c9557c758fbca6c', 1, 'duncan71@example.com', '832-480-4763', '12321337210', '2016-08-20 16:15:42', '2016-11-27 11:54:38');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (95, 'c66bef76555cbcb352090bb64a4dab16b7ffd609ab6c23010425c519a1f55393', 2, 'doris.powlowski@example.org', '232.408.2181', '14462461173', '2016-10-18 12:59:27', '2011-08-30 23:09:18');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (96, 'c40693a92eac3c05c0f45255bf3b8299a81c60ed4e39e977688c2837e10953ab', 3, 'tromp.henderson@example.org', '(184)861-2695x944', '12848412208', '2014-04-29 00:45:32', '2012-03-26 07:19:19');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (97, '7e99f43ef1f922e3c010af35d5b8c81c9a069b40672f61c0cdb65c04e776d42a', 1, 'franz.kuhic@example.net', '(696)302-9038', '15644700229', '2020-06-11 09:18:32', '2015-08-19 04:00:18');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (98, '0deaa4349c392c062c6934c6d29c0ffd4b25b4ba66d6be6292300c29ba21b02d', 2, 'irunolfsson@example.com', '706-579-2488x01774', '11108384975', '2019-05-04 20:16:38', '2015-09-16 04:53:55');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (99, 'a4d7461e7752278048e5b99fef0b8ce2f95cbcce1b5c5f79333d2a9df3f8ed4c', 3, 'mayert.elmira@example.com', '1-239-225-6788x89526', '19790801350', '2013-12-14 15:35:06', '2013-10-29 04:58:10');
INSERT INTO `users` (`id`, `password`, `access_level_id`, `email`, `phone`, `snils`, `created_at`, `updated_at`) VALUES (100, 'cf687699f830488e8b2d311cde177dcc0f217a43d58daa717ad1606934ec2f15', 1, 'mhodkiewicz@example.net', '(519)982-9272x65528', '10552934771', '2019-01-30 23:12:26', '2016-12-15 13:32:08');

SELECT * FROM users LIMIT 10;

UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;

#
# TABLE STRUCTURE FOR: emails
#

DROP TABLE IF EXISTS `emails`;

CREATE TABLE `emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `from` enum('Почта России','Портал "Госуслуги"','ГИБДД') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Отправитель сообщения',
  `to_user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на получателя сообщения',
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Тема письма',
  `body` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Текст письма',
  `is_important` tinyint(1) DEFAULT NULL COMMENT 'Признак важности',
  `is_read` tinyint(1) DEFAULT NULL COMMENT 'Прочитано ли письмо',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `emails_to_user_id_fk` (`to_user_id`),
  CONSTRAINT `emails_to_user_id_fk` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Сообщения';

INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (1, 'Портал \"Госуслуги\"', 1, 'Voluptas eius ad accusantium quos quae pariatur molestias.', 'Quis quo voluptatum ratione occaecati minima sit eaque. Quod dolor impedit ratione. Nihil voluptas est omnis et consequatur cumque sit. Nihil consequatur placeat qui veritatis adipisci repellat.', 0, 0, '2019-02-04 12:56:17', '2014-09-01 05:05:30');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (2, 'Почта России', 2, 'Ut porro ducimus provident qui et est delectus.', 'Ullam id ut deleniti esse. Molestiae ea facilis dolorem recusandae laborum non voluptas. Non enim architecto et. Sint enim dolorem porro dolor est veritatis.', 1, 0, '2012-02-12 19:26:15', '2017-06-09 04:06:06');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (3, 'ГИБДД', 3, 'Sequi veniam consequatur optio nam quisquam.', 'Aut qui eaque voluptas doloribus. Eligendi sit ea consequatur facere voluptate repudiandae iure. Itaque eveniet voluptates eveniet porro voluptate et et. Dicta maiores aut eum quibusdam dolorum.', 1, 1, '2016-02-11 00:10:01', '2014-11-27 20:49:54');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (4, 'Почта России', 4, 'Rerum eum accusamus et quibusdam unde assumenda incidunt voluptatem.', 'Debitis corporis incidunt aliquam repellat sequi. Ex voluptatem velit ducimus delectus eum et.', 0, 0, '2012-11-08 19:38:02', '2014-09-16 14:10:55');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (5, 'ГИБДД', 5, 'Aliquid quia voluptate tempore velit cum ex nesciunt.', 'Qui ut perferendis libero maiores et nam. Quas omnis eveniet dolorum magni modi quo rerum. Pariatur mollitia est beatae veritatis suscipit iste magnam et. Qui provident nesciunt at possimus ad.', 0, 0, '2015-02-09 21:17:38', '2014-09-13 03:18:14');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (6, 'Портал \"Госуслуги\"', 6, 'Iusto qui quam alias optio a expedita consectetur labore.', 'Quis iusto totam dolor eum possimus libero voluptate. Eaque delectus qui accusantium illo qui quos blanditiis. Eligendi quis eum voluptates iste quae. Optio praesentium nihil est reiciendis sit doloribus et tempore.', 0, 0, '2019-05-21 17:06:03', '2020-03-01 08:52:17');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (7, 'ГИБДД', 7, 'Aliquid vero cum rerum doloribus veritatis debitis.', 'Dolorum est et ipsam. Voluptatibus voluptate provident velit minima voluptas. Soluta voluptatibus quae iusto minima quia. Est corrupti labore velit numquam consequatur. Sit et molestiae eos optio nesciunt quia.', 1, 0, '2014-09-07 06:22:16', '2019-11-14 14:47:47');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (8, 'Портал \"Госуслуги\"', 8, 'Dolores aut eum atque animi qui inventore ut.', 'Dolorem ullam architecto molestiae aut deserunt quo beatae. Cum qui dolores voluptates. Tenetur id id at qui natus ut. Iusto inventore illum sapiente commodi corporis voluptas.', 0, 0, '2016-11-06 02:30:41', '2011-08-05 20:56:01');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (9, 'ГИБДД', 9, 'Voluptatem temporibus delectus fugiat dolorem sed qui.', 'Incidunt facilis minima voluptas voluptatem velit. Animi porro saepe et numquam quam et esse fuga. Numquam magnam sint et est.', 1, 1, '2012-01-14 22:32:32', '2013-01-27 23:09:16');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (10, 'ГИБДД', 10, 'Voluptate aut dolorem quam expedita corrupti ex delectus.', 'Voluptatem quasi distinctio dolores. Quia sapiente quis commodi fugit autem cumque et. Qui animi nihil ab eum. Ratione ut ex soluta enim et et.', 0, 0, '2020-06-12 07:13:56', '2017-09-11 19:22:27');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (11, 'Почта России', 11, 'Et quis dolorem voluptas ut sit aspernatur.', 'Quae sunt illum ut enim ut vel. Sunt commodi asperiores qui aut ullam. Vel iusto voluptatem reiciendis vitae vero autem. Nostrum sit voluptatem quia blanditiis non.', 0, 1, '2017-11-09 11:36:37', '2016-11-06 16:36:25');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (12, 'Почта России', 12, 'Et ex sunt quis accusantium nostrum.', 'Tenetur quas a ullam eos incidunt odit. Temporibus numquam sed ipsa consequatur rerum placeat. Tempora aut facilis impedit voluptatem aliquam sit aperiam qui. Culpa reiciendis et voluptatem aut cum dicta. Fugit et quis velit quisquam et expedita libero.', 1, 1, '2013-06-16 22:06:30', '2019-09-12 07:16:04');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (13, 'Портал \"Госуслуги\"', 13, 'Quis culpa provident reprehenderit aspernatur sequi quae quidem.', 'Voluptatem et ut pariatur totam eaque. Ea odio quibusdam alias ducimus aut veritatis. Odio dolore aperiam magni aliquid officiis.', 1, 0, '2019-06-27 14:08:43', '2012-12-04 22:54:42');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (14, 'Портал \"Госуслуги\"', 14, 'Harum sed temporibus harum id alias.', 'Beatae aut esse est ullam est qui reprehenderit. Quis et laborum maxime molestias et provident necessitatibus. Temporibus quibusdam atque ipsa excepturi ea.', 1, 1, '2011-06-21 12:27:20', '2016-05-26 11:37:26');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (15, 'Портал \"Госуслуги\"', 15, 'Ullam voluptatibus eos cupiditate.', 'Et cum nemo quibusdam corporis itaque sit similique. Est qui architecto rerum rem et voluptas nemo. Necessitatibus quo cum ex dolor nobis aut et itaque. Cumque temporibus fuga eligendi.', 0, 1, '2018-04-30 08:29:07', '2011-08-03 02:08:07');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (16, 'ГИБДД', 16, 'Sint sed exercitationem perspiciatis est blanditiis qui blanditiis.', 'Esse perferendis est repellat in. Hic quo architecto necessitatibus sapiente atque. Autem modi dignissimos tempora ipsum voluptatum voluptas.', 0, 0, '2013-02-16 16:59:24', '2015-12-13 11:07:57');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (17, 'ГИБДД', 17, 'Et consequatur ut dignissimos qui.', 'Dolor sapiente ut et autem quo. Earum ipsam dolorem voluptatem quam. Voluptatibus et dicta quia ut atque. Ullam ut molestiae consequuntur culpa sequi.', 0, 0, '2019-04-25 15:55:23', '2011-04-02 20:24:33');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (18, 'Портал \"Госуслуги\"', 18, 'Eum aliquid numquam dolore itaque molestiae deserunt.', 'Sit facilis vel et quia illum et. Nemo est et officia culpa.', 0, 0, '2016-03-29 23:48:31', '2020-05-14 19:52:13');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (19, 'Почта России', 19, 'Ex dolorem facere magni ut.', 'Ipsam quia sequi quia explicabo. Sapiente et qui nihil. Et officia cumque placeat ea. Aut consequuntur quia ducimus iusto veniam ullam neque earum.', 1, 0, '2020-01-25 18:08:30', '2020-09-01 07:08:54');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (20, 'Почта России', 20, 'Soluta aut omnis vel et.', 'Aut repudiandae excepturi in quidem. Amet quo totam sapiente a porro excepturi.', 1, 0, '2017-02-26 09:02:48', '2018-01-11 18:05:26');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (21, 'ГИБДД', 21, 'Molestias ab dignissimos eaque enim commodi quidem ab.', 'Nostrum soluta officiis alias alias. Harum iste consequatur omnis veniam nihil laudantium cumque recusandae. Qui accusantium ut laudantium voluptatum odio.', 1, 0, '2017-07-17 02:38:15', '2020-02-14 15:39:01');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (22, 'Почта России', 22, 'Velit ratione quis sapiente ut at explicabo adipisci.', 'Et magni unde facere fugit debitis labore voluptas. Incidunt quis facere incidunt quidem alias vel consequatur. Provident sed aliquid non autem sed. Est non quo sequi distinctio accusantium et amet. Hic sapiente consectetur amet quibusdam esse hic nesciunt.', 1, 0, '2018-04-06 00:52:59', '2012-08-26 02:17:21');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (23, 'Почта России', 23, 'Et enim praesentium et est pariatur ratione saepe recusandae.', 'Possimus eveniet ut sit consectetur dolores quae. Quia possimus occaecati ut aut sit nisi dolore. Consequatur et officiis vero.', 0, 1, '2011-07-20 20:03:47', '2012-02-20 00:34:51');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (24, 'Портал \"Госуслуги\"', 24, 'Et vel voluptates aliquam enim sed quibusdam ut dolorum.', 'Inventore nisi est qui occaecati perferendis cumque commodi est. Aut voluptatem officiis sint.', 0, 1, '2012-08-28 08:23:30', '2014-05-19 22:26:03');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (25, 'Почта России', 25, 'Et qui quae occaecati quam rerum.', 'Nobis magni voluptas et voluptatum. Fugiat fuga cum quis fuga magni. Omnis voluptate aut quis accusamus.', 0, 1, '2014-09-11 03:49:41', '2018-04-24 04:42:24');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (26, 'Почта России', 26, 'Dolorem et provident ut rerum.', 'Sint voluptas sed atque aut non. Quo numquam et sit temporibus. Libero qui autem officiis repellat.', 1, 1, '2016-06-06 22:13:04', '2015-08-20 14:29:37');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (27, 'Почта России', 27, 'Omnis ex eaque fugiat eum sed doloribus.', 'Reiciendis molestiae ut asperiores. Facilis at voluptate dolore non et. Suscipit reprehenderit accusamus sit ab debitis maxime et facilis.', 0, 1, '2015-04-07 05:17:59', '2015-10-16 03:51:27');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (28, 'Портал \"Госуслуги\"', 28, 'Illo laudantium beatae impedit labore.', 'Nemo corporis nulla et harum. Alias cumque et ipsa sed omnis ut. Quaerat nobis dignissimos id voluptatum eos architecto.', 0, 0, '2018-10-07 05:53:20', '2012-09-27 19:30:16');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (29, 'ГИБДД', 29, 'Consequuntur provident explicabo pariatur et laudantium.', 'Ducimus neque quam rerum dolor ad. Libero ad eos qui.', 1, 0, '2019-10-16 18:56:23', '2019-05-04 19:45:17');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (30, 'Почта России', 30, 'Sequi molestias rerum dolor accusantium est velit.', 'Asperiores et id est rerum quas non ratione. Ab mollitia assumenda nihil molestiae accusantium. Consectetur voluptatem doloremque ex consequatur.', 1, 0, '2013-04-10 20:03:39', '2014-10-17 06:31:03');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (31, 'ГИБДД', 31, 'Voluptatem dolor officiis tenetur ab animi.', 'Aut tempora aliquid qui ut. Sint unde vitae eius repellendus distinctio. Inventore voluptas rerum sed exercitationem.', 0, 0, '2011-10-23 05:58:29', '2016-03-22 02:55:07');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (32, 'ГИБДД', 32, 'Beatae magnam doloremque libero tenetur.', 'Quasi placeat rem ut ratione. Mollitia voluptas sint consequatur alias eos error ut. Ea amet eum tempora dignissimos. Voluptas quia in et consectetur non illo quasi.', 1, 1, '2019-08-09 10:54:14', '2013-04-01 00:51:40');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (33, 'Портал \"Госуслуги\"', 33, 'Nihil qui voluptatem dolore quasi molestiae sunt voluptatum.', 'Nihil at delectus numquam deserunt illum quis. Libero voluptatem corporis accusamus eum eius officiis. Iure nulla quas quasi animi error at sed.', 0, 0, '2011-09-03 22:50:10', '2012-02-24 13:12:56');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (34, 'ГИБДД', 34, 'Fuga asperiores ducimus accusamus.', 'Sapiente sit assumenda sit cumque. Iste quasi illum nisi quidem placeat dignissimos. Facere ea nisi ducimus voluptas dolorem minus distinctio. Est rerum asperiores velit deleniti quisquam sint enim.', 0, 0, '2019-06-25 20:14:59', '2011-03-06 17:57:32');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (35, 'Почта России', 35, 'Tempora quod dolore consequatur.', 'Id et odio qui nihil qui adipisci. Exercitationem exercitationem sint ut ipsam nihil tempore delectus. Sed enim fuga beatae incidunt modi.', 1, 0, '2017-12-31 01:34:00', '2015-03-29 15:42:22');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (36, 'ГИБДД', 36, 'Autem aspernatur impedit modi vero delectus.', 'Autem mollitia inventore incidunt temporibus neque voluptate. Consectetur soluta modi voluptates accusamus aspernatur. Maiores omnis autem velit et ratione nisi vel. Asperiores enim aut sequi. Hic aut culpa iure cum.', 0, 0, '2015-10-11 02:37:19', '2011-07-21 10:24:20');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (37, 'ГИБДД', 37, 'Quo voluptates et vero voluptatem.', 'Quo eius et repellat error consequatur. Dicta animi et recusandae est molestiae aliquid quasi. Dolorum excepturi voluptatem voluptatem nihil quia occaecati est. Sunt dicta vitae saepe velit facilis omnis.', 0, 0, '2012-04-02 04:28:47', '2020-02-04 15:25:00');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (38, 'ГИБДД', 38, 'Ut voluptatem asperiores dolores omnis.', 'Explicabo quia mollitia non ipsam. Voluptatem velit odio repellendus qui et repellat rem. Dolor occaecati est ratione vel quia eum explicabo.', 1, 1, '2015-01-10 03:43:14', '2011-07-12 21:13:10');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (39, 'Портал \"Госуслуги\"', 39, 'Inventore veniam sit et reiciendis maiores.', 'Est ad minus sit voluptatem corrupti quaerat. Esse sed impedit modi blanditiis nesciunt sunt. Sapiente quos quia a recusandae quaerat quia explicabo. Aut quaerat ut et.', 1, 1, '2014-12-21 04:29:25', '2013-01-25 13:26:18');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (40, 'Почта России', 40, 'Omnis sit et occaecati facilis sequi et ex est.', 'Eos aspernatur minus nihil consequuntur. Fuga amet qui nam deleniti culpa odit. Reiciendis maxime totam minus itaque dolore.', 0, 1, '2011-07-04 19:03:02', '2013-05-27 15:55:05');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (41, 'ГИБДД', 41, 'Consequatur esse doloremque laborum minima.', 'Vel exercitationem non deserunt minima dolor cumque ea. Vitae explicabo sit est sit voluptates quo aspernatur.', 1, 0, '2020-11-17 02:22:02', '2018-09-28 12:03:11');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (42, 'ГИБДД', 42, 'Rerum ratione blanditiis repudiandae ex.', 'Modi consequuntur explicabo velit tempora et. Et voluptatibus explicabo voluptatem sit ullam voluptatibus recusandae. Dolore velit aut debitis id architecto similique. Omnis reiciendis reiciendis placeat maiores dolores et. Eveniet explicabo totam rerum iusto facere tenetur.', 1, 0, '2016-07-19 06:17:56', '2014-12-07 06:36:59');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (43, 'Портал \"Госуслуги\"', 43, 'Voluptas itaque optio incidunt quas.', 'Sed est voluptatem quis fugit. Dolores nam aut natus amet dolorem quo. Optio debitis minus omnis porro velit alias ab. Est est enim reprehenderit totam omnis minus.', 0, 1, '2013-02-28 20:37:27', '2020-02-09 00:19:30');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (44, 'Почта России', 44, 'Consequatur laboriosam labore voluptates accusantium nulla.', 'Modi enim et quas consectetur consectetur. Est excepturi quidem sint est commodi aut. Eveniet autem impedit molestiae fuga vel. Ipsa sapiente occaecati laborum voluptas.', 1, 0, '2014-03-17 07:25:57', '2014-07-26 07:17:17');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (45, 'Портал \"Госуслуги\"', 45, 'Eum eius earum error enim accusamus laudantium consequatur.', 'Autem molestias non atque id. Ut molestias est unde unde sapiente. Necessitatibus explicabo eos rem qui nesciunt qui.', 0, 0, '2012-06-18 02:03:16', '2020-01-07 01:26:33');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (46, 'Портал \"Госуслуги\"', 46, 'Libero consequuntur nisi facere omnis mollitia sit.', 'Est illo rerum amet voluptate assumenda eaque aut. Dignissimos corrupti corrupti voluptatem nihil corrupti minus consequatur aut. Omnis sunt aut asperiores. Excepturi consectetur dignissimos veniam iure.', 0, 1, '2020-06-11 12:12:04', '2014-04-12 22:03:48');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (47, 'Почта России', 47, 'Repellendus ipsa ullam vitae optio eos neque dolorum necessitatibus.', 'Aperiam voluptas necessitatibus quis quos dolore qui commodi. Autem tempora dicta et minus aliquam natus sint corporis. Et neque quisquam exercitationem totam.', 0, 0, '2019-01-16 19:33:23', '2013-11-29 20:54:21');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (48, 'Почта России', 48, 'Similique quia quam aperiam numquam incidunt rerum in.', 'Quasi et earum voluptas sed quia. Nesciunt repellat dolorum dolorem eos. Et autem nostrum numquam id rerum minima.', 0, 1, '2013-12-10 21:14:47', '2019-02-01 10:30:47');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (49, 'Почта России', 49, 'Dolores aperiam consequatur accusantium veniam.', 'Natus dignissimos blanditiis consequuntur neque nam nostrum et. Quasi a rem sit est a aperiam veniam. Nisi voluptatum hic praesentium ad nostrum modi consequatur.', 1, 0, '2012-08-13 07:52:51', '2016-08-24 06:32:11');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (50, 'ГИБДД', 50, 'Expedita omnis corrupti ut et quis.', 'Sed unde repudiandae placeat perspiciatis accusamus eum commodi architecto. Sed aut laboriosam delectus voluptas. Autem enim accusamus esse ea vel quibusdam.', 0, 1, '2011-03-13 12:41:28', '2014-09-20 04:54:22');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (51, 'Почта России', 51, 'Optio adipisci qui ex aut ut aut.', 'Est fuga ullam dolores numquam. Vel ipsa eos quia earum culpa doloremque explicabo. Atque quae labore et tempora incidunt velit accusantium.', 1, 1, '2013-10-22 10:08:59', '2017-03-17 18:20:58');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (52, 'ГИБДД', 52, 'Blanditiis magnam adipisci qui qui neque sed.', 'Veniam sit enim optio quae voluptatibus deleniti eligendi. Id occaecati sunt perspiciatis reiciendis molestias est dolor commodi. Voluptatem possimus sit veniam optio placeat voluptas iste. Fugit facilis odio laudantium earum non corrupti earum.', 1, 0, '2019-07-29 13:32:48', '2011-11-17 03:14:00');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (53, 'Почта России', 53, 'Sapiente voluptatem libero itaque fuga culpa sit.', 'Dolor placeat qui molestias accusamus nobis amet. Harum ipsam voluptas quis quibusdam sit. Voluptates quo saepe aut sed omnis porro reiciendis. Voluptas at et velit a ex.', 1, 1, '2013-05-26 13:37:23', '2013-12-10 18:44:24');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (54, 'ГИБДД', 54, 'Voluptatem omnis in corrupti molestiae.', 'Et voluptatem distinctio et modi at. Consequatur perspiciatis ab dolor et. Natus et distinctio ut ea ducimus velit. Corrupti nihil quia deleniti est et. Cumque perferendis hic mollitia exercitationem.', 0, 0, '2016-03-29 04:13:56', '2016-01-27 06:10:34');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (55, 'ГИБДД', 55, 'Aperiam est laborum consequatur quasi distinctio optio ratione laudantium.', 'Magni harum reiciendis quia necessitatibus nam maiores incidunt non. Iste aut et sed. Ab repellat fuga doloremque consequuntur corporis qui. Cupiditate ea eveniet amet quae sed fuga.', 0, 1, '2019-04-29 13:43:08', '2011-04-05 21:31:14');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (56, 'ГИБДД', 56, 'Eos placeat sunt ut et est.', 'Eaque fugiat ut non facere et optio. Similique consequatur natus laboriosam accusantium architecto aut labore. Aut molestiae est rerum quas. Ex error ipsa aspernatur recusandae enim.', 0, 1, '2015-11-07 21:47:33', '2016-08-30 01:28:08');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (57, 'Почта России', 57, 'Earum suscipit sed autem ut nihil.', 'Ducimus expedita et et perferendis. Similique exercitationem id sint velit quos iste at. Dolorum fuga qui eos facilis modi sit.', 1, 0, '2014-12-30 20:36:45', '2011-01-06 10:08:39');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (58, 'ГИБДД', 58, 'Assumenda omnis minima molestiae laudantium in.', 'Maiores aliquam nisi nemo sit voluptatem repellendus. Ut quibusdam nam sunt possimus at a. Quibusdam blanditiis et eligendi excepturi incidunt inventore animi.', 1, 1, '2018-10-19 22:50:30', '2020-05-11 17:46:27');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (59, 'ГИБДД', 59, 'Aspernatur iste ut quidem assumenda exercitationem aliquam inventore.', 'Optio nostrum quibusdam sint exercitationem nihil eveniet. Et aut ratione reprehenderit sed nostrum aliquid. Quidem nisi non maxime asperiores voluptatem aut. Nam voluptatibus non praesentium.', 0, 1, '2018-07-27 15:03:35', '2015-08-16 01:13:09');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (60, 'ГИБДД', 60, 'Repellat veniam rem quia modi nihil.', 'Unde beatae reiciendis voluptate voluptas exercitationem voluptatem voluptatem et. Explicabo sunt necessitatibus praesentium voluptatum ea suscipit. Ratione beatae et est.', 0, 0, '2017-08-05 03:34:39', '2014-07-25 22:25:00');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (61, 'Почта России', 61, 'Id aut aut minima ut sit quidem porro laboriosam.', 'Asperiores quia ducimus assumenda quae. Doloremque molestiae minima qui aut. Fuga voluptatem quasi tempora nostrum incidunt cumque.', 0, 1, '2016-03-14 10:35:34', '2020-03-08 05:21:59');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (62, 'ГИБДД', 62, 'Eveniet alias quis quae in odit.', 'Dignissimos quibusdam quod et omnis ab fugiat. Aut quos qui sit dolor quos soluta dolor. Occaecati quibusdam repellat quis tempore aut perspiciatis.', 1, 1, '2011-03-30 23:07:58', '2016-10-10 22:20:16');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (63, 'Почта России', 63, 'Impedit exercitationem vel voluptatem odio.', 'Quo molestiae adipisci labore corrupti nesciunt nulla. Iste vero voluptas provident eius quas eligendi. Dicta rem optio nihil voluptas.', 0, 0, '2016-06-06 06:22:57', '2017-05-08 11:50:23');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (64, 'ГИБДД', 64, 'Id unde quo minus aut voluptas.', 'Corrupti et numquam repudiandae. Nisi fuga rerum vero sit. Aut delectus illum qui consequuntur. Aliquid est laudantium et dolorem minima sit.', 1, 0, '2013-02-21 07:12:59', '2016-05-23 20:38:14');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (65, 'ГИБДД', 65, 'Voluptatibus dolores modi nihil sint neque ea in quis.', 'Eum dolorem sequi totam possimus autem eum. Aliquam totam facilis enim nesciunt est laborum. Harum cupiditate sed rerum facilis voluptatem. At eveniet blanditiis ut dolor ad ut.', 1, 1, '2011-08-12 01:02:11', '2018-03-04 03:39:21');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (66, 'Портал \"Госуслуги\"', 66, 'Sunt temporibus rerum voluptate enim reiciendis.', 'Aperiam doloremque dolorem assumenda facere ex vero. Voluptas voluptatum a porro molestiae hic veritatis. Et ipsam porro ipsum mollitia ipsam pariatur provident. Unde consequatur distinctio deserunt facere natus.', 0, 0, '2013-12-28 14:03:29', '2017-02-02 15:17:34');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (67, 'ГИБДД', 67, 'Et quibusdam voluptate pariatur modi eveniet expedita rerum.', 'Id rerum unde consequatur voluptatem quibusdam. Molestias atque ut in aut maiores minima cupiditate. Itaque eveniet consequuntur est commodi velit ipsam.', 0, 1, '2019-08-29 03:31:01', '2014-07-04 17:50:37');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (68, 'ГИБДД', 68, 'Voluptatibus nemo in quod quia sapiente ut nisi.', 'Quia soluta reiciendis facilis doloribus autem ut ut. Error praesentium quisquam corrupti voluptates id. Mollitia optio dolorem sapiente laboriosam consequuntur aliquid rerum.', 1, 0, '2013-02-21 06:22:59', '2014-07-08 11:39:48');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (69, 'Портал \"Госуслуги\"', 69, 'Ex eum facilis sint nam pariatur accusantium.', 'Officiis maiores dolorem odit praesentium quis dolor quia. Sint est quod ab ut aut cum dolorum. Occaecati accusamus mollitia beatae consequatur.', 1, 1, '2012-08-05 19:51:12', '2011-10-07 21:27:27');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (70, 'Почта России', 70, 'Ratione blanditiis fugiat voluptatem et.', 'Fuga libero voluptatem quos doloribus ut aut et at. Deserunt quidem voluptas esse ut. Eveniet quaerat ut enim numquam.', 1, 1, '2014-06-27 16:11:03', '2015-11-08 21:39:35');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (71, 'ГИБДД', 71, 'Et doloribus qui ullam sit deserunt.', 'Odit iure laborum quae dolores. Dolorem quisquam earum provident eos nemo.', 1, 1, '2018-08-11 02:14:55', '2014-01-16 17:21:52');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (72, 'Почта России', 72, 'Ea fugit rerum et amet vitae.', 'Unde dolores et in. Ipsum rem non eveniet ab tempora. Nostrum et placeat quia aut vel velit exercitationem. Et ipsam voluptatem expedita nesciunt.', 0, 1, '2014-02-28 04:18:55', '2020-05-23 01:29:54');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (73, 'ГИБДД', 73, 'Sint sunt aut eligendi illum.', 'Enim exercitationem et nostrum libero dolore. Ut rem unde aliquam aspernatur a aut. Itaque et cum assumenda ea tenetur placeat praesentium. Non hic culpa magnam aut excepturi ab perferendis.', 1, 1, '2011-12-19 20:40:34', '2016-05-26 14:38:51');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (74, 'Портал \"Госуслуги\"', 74, 'Voluptas sunt minima velit fugit et et eveniet libero.', 'Doloremque voluptates est voluptas. Veniam omnis est quam est voluptatem minus. Rerum omnis officiis sit. Dolor quae nam quos.', 0, 1, '2014-01-27 01:43:47', '2020-02-11 22:26:28');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (75, 'ГИБДД', 75, 'Ipsa ea cumque ex sed dolorum.', 'Veritatis expedita fugit dolores qui possimus nihil. Minima voluptas assumenda architecto ratione impedit. Expedita molestiae voluptatibus molestiae nostrum repudiandae sed voluptatem.', 1, 1, '2011-05-10 12:32:14', '2011-08-14 14:38:44');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (76, 'ГИБДД', 76, 'Adipisci exercitationem quia et qui officia.', 'Iste ipsa ea officia dignissimos et optio dolor. Et nihil consequatur rerum deleniti ea. Aut ea officia ipsa natus culpa qui. Debitis sunt voluptatum sit.', 1, 0, '2018-12-30 22:46:48', '2017-02-03 05:29:04');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (77, 'Портал \"Госуслуги\"', 77, 'Consequatur rerum qui nesciunt et nisi nihil adipisci.', 'Odit laboriosam ut impedit alias. Quia id eaque tempore repudiandae quos et. Quas animi voluptatem cupiditate omnis. Quidem deserunt labore cumque accusantium.', 1, 1, '2015-09-27 13:49:05', '2013-04-16 07:20:31');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (78, 'Портал \"Госуслуги\"', 78, 'Vel omnis explicabo deleniti quo.', 'Voluptatibus inventore quam consequatur quia. Rerum officia consectetur ipsam sit unde dolores. Non hic voluptates omnis labore est quam. Qui nihil voluptatem in quis.', 0, 0, '2017-07-11 21:43:02', '2013-07-08 17:05:24');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (79, 'Портал \"Госуслуги\"', 79, 'Inventore odio voluptatum at eum sit quia quo.', 'Quis in molestiae perspiciatis commodi dolores id qui. Odio debitis provident saepe eaque. Fugit iure consectetur in accusamus.', 1, 1, '2017-12-13 19:22:51', '2018-07-25 04:22:40');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (80, 'Почта России', 80, 'Ab illo distinctio aliquam voluptas et qui.', 'Ut at consequatur libero culpa. Est possimus quo eum aut minus. Quod dolores velit provident natus voluptatem assumenda voluptatem. Facere autem neque error eum laudantium.', 1, 1, '2017-07-30 03:32:11', '2018-10-11 08:15:35');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (81, 'ГИБДД', 81, 'Ea aut ullam aut.', 'Magni quidem dicta voluptatum ratione recusandae dignissimos. Vero corrupti doloribus aut voluptatem sed laborum. Vero numquam aut laborum. Similique animi alias tenetur cumque.', 0, 1, '2020-04-21 17:08:52', '2014-06-28 11:05:26');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (82, 'Почта России', 82, 'Praesentium quidem libero eligendi a iure non tenetur.', 'Velit debitis culpa vel minima id quia. Libero rerum expedita qui et. Saepe ad quas nulla eum repellendus rem. Ab repudiandae voluptatem dolores repudiandae dolorum.', 1, 1, '2019-09-09 07:14:18', '2017-07-05 13:59:02');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (83, 'Портал \"Госуслуги\"', 83, 'Quia in aperiam et architecto ab quisquam voluptatem.', 'Odit suscipit recusandae ex incidunt est inventore. Magnam officiis libero amet. Qui officia nam voluptatum veritatis. Odit ut vel hic et.', 1, 0, '2020-03-17 09:22:05', '2020-06-11 20:57:54');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (84, 'Почта России', 84, 'Impedit excepturi iste et atque deserunt nobis molestiae.', 'Possimus eius placeat voluptates ea commodi quia. Voluptatem in consequatur libero facere voluptatum delectus commodi porro. Ut quia voluptatem fuga quia.', 1, 0, '2013-12-22 13:40:47', '2015-10-01 14:46:35');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (85, 'Портал \"Госуслуги\"', 85, 'Labore sit nam harum dicta.', 'Quasi nulla vel dolorem perferendis necessitatibus est in numquam. Reprehenderit dignissimos aliquid et. Hic accusantium repellat distinctio omnis iure architecto. Nemo nobis molestias est aut.', 1, 1, '2018-01-13 10:10:45', '2011-05-20 04:46:59');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (86, 'Почта России', 86, 'Atque illum non ullam.', 'Placeat sit rerum nihil culpa repudiandae vitae minima. Ut aut beatae nesciunt. Commodi id laboriosam eveniet sit ad.', 1, 0, '2013-09-08 23:28:13', '2018-03-22 22:32:38');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (87, 'ГИБДД', 87, 'Ad nihil a in voluptatem.', 'Itaque eos et nihil et quam ullam voluptatem. Qui architecto nemo dicta eaque. Asperiores animi accusamus necessitatibus et ipsam modi. Dolorum aut quia facere eveniet.', 1, 1, '2020-05-10 15:33:27', '2017-03-19 15:00:45');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (88, 'ГИБДД', 88, 'Eveniet et praesentium ea dolor voluptatem vel pariatur.', 'Natus adipisci ut unde nesciunt nihil impedit. Nostrum nisi dolorum qui et ipsam dolores delectus. Est dignissimos iure sapiente quaerat suscipit quod perferendis.', 0, 0, '2011-02-10 19:47:01', '2020-08-22 17:38:36');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (89, 'ГИБДД', 89, 'Est quam molestiae est et aspernatur aliquid praesentium.', 'Quis itaque quia rerum rem. Aliquid laudantium quis et nulla dolor sunt harum. Itaque culpa sint quisquam est.', 0, 0, '2020-08-23 23:25:14', '2011-06-20 15:17:08');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (90, 'Почта России', 90, 'Ut quia dignissimos expedita ea aut qui quisquam quae.', 'Facere minus est modi sit fugit voluptatem. Voluptatem quo quas recusandae ipsa. Aut rerum iste ut corrupti explicabo. Accusantium beatae accusantium quasi tempore ea nulla voluptatem.', 1, 1, '2015-06-01 13:39:19', '2020-07-22 09:37:35');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (91, 'ГИБДД', 91, 'Numquam qui voluptatem non voluptatibus.', 'Necessitatibus fugiat sunt deleniti autem tenetur doloribus. Beatae dolores eum numquam aspernatur eum ut velit. Aperiam consequatur impedit vero nihil.', 1, 0, '2014-04-24 09:31:59', '2011-07-30 09:40:03');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (92, 'ГИБДД', 92, 'Voluptatem quis quasi quia et eaque magni.', 'Dolorum incidunt veritatis ducimus consequatur iste. Minus est impedit vero. Corporis adipisci aut deserunt consequatur quis eaque consequatur nulla. Sequi dolores qui pariatur totam.', 1, 1, '2020-10-25 15:45:57', '2015-04-01 11:19:23');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (93, 'ГИБДД', 93, 'Nobis ut ut neque magnam.', 'Eum voluptatibus quod et tempore atque natus nisi. Quidem ut quidem similique enim voluptatem earum. Maiores est voluptas sunt. Facere aspernatur ut doloremque eligendi.', 1, 1, '2015-05-21 03:12:10', '2018-02-04 00:20:39');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (94, 'Почта России', 94, 'Aut quasi aliquid eos.', 'Et voluptas animi dignissimos enim tempora. Assumenda ipsum facilis repellat est corrupti a ut. Non debitis assumenda est rerum fugit aliquam inventore.', 1, 0, '2018-06-23 10:46:03', '2017-03-19 12:55:25');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (95, 'Почта России', 95, 'Vero rerum id maxime dolor mollitia facere.', 'Excepturi omnis repudiandae explicabo eligendi. Suscipit non beatae illum excepturi quo dolor. Possimus ratione minima nisi veritatis quod aut. Sint enim debitis voluptas culpa at.', 1, 1, '2015-01-09 06:33:03', '2011-05-21 17:46:25');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (96, 'ГИБДД', 96, 'Eaque aperiam doloribus velit illo perferendis commodi libero.', 'Maiores voluptatem recusandae nesciunt quia adipisci. Quam ratione tempora aut. Nulla aspernatur qui quisquam.', 1, 0, '2019-12-16 20:14:46', '2011-12-17 07:30:09');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (97, 'Почта России', 97, 'Id ea sit perspiciatis cum.', 'Accusantium dolore commodi quam perspiciatis nesciunt deleniti temporibus. Voluptatem culpa voluptatem animi et. Nam doloremque quia nulla cum. Odit sed tempora earum asperiores corrupti iure delectus minus.', 1, 0, '2012-10-17 21:45:25', '2016-05-26 14:58:30');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (98, 'ГИБДД', 98, 'Tenetur quo praesentium facilis dicta.', 'Error molestias amet non vel omnis fugiat aut quod. Dolorum consequuntur adipisci eveniet qui corporis. Totam nihil et est veritatis enim.', 1, 0, '2019-06-20 05:35:25', '2014-04-05 06:25:51');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (99, 'Портал \"Госуслуги\"', 99, 'Quod dolores et consectetur quae necessitatibus velit quidem.', 'Id beatae quia beatae totam tempore est. Non omnis deserunt asperiores consectetur dignissimos. Possimus dolore cumque voluptatibus facilis nesciunt consequatur excepturi cum. Fugiat iure aspernatur excepturi dolorem exercitationem.', 1, 0, '2013-10-12 04:37:41', '2018-10-05 02:58:52');
INSERT INTO `emails` (`id`, `from`, `to_user_id`, `subject`, `body`, `is_important`, `is_read`, `created_at`, `updated_at`) VALUES (100, 'ГИБДД', 100, 'Distinctio itaque veniam eius occaecati illum est quis fugiat.', 'Et pariatur dolore accusamus error et rem quo aut. Dolor reiciendis maxime similique est atque autem quia. Et qui magnam rerum error voluptatem tempore maxime.', 1, 0, '2018-04-09 11:57:49', '2015-08-03 06:07:32');


SELECT * FROM emails;

UPDATE emails SET updated_at = NOW() WHERE updated_at < created_at;
UPDATE emails SET to_user_id = FLOOR(1 + RAND() * 100);

#
# TABLE STRUCTURE FOR: orders
#

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на пользователя',
  `service_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на запрашиваемую услугу',
  `price` decimal(7,2) DEFAULT NULL COMMENT 'Стоимость',
  `status` enum('requested','confirmed','rejected') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Статус выполнения услуги',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `orders_user_id_fk` (`user_id`),
  KEY `orders_service_id_fk` (`service_id`),
  CONSTRAINT `orders_service_id_fk` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  CONSTRAINT `orders_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Заявления пользователей на оказание услуг';

INSERT INTO `orders` VALUES ('1','31','7','6729.10','rejected','2014-05-18 06:02:40','2016-11-11 07:50:09'),
('2','54','2','25197.21','requested','2014-03-28 06:27:10','2018-02-16 11:47:27'),
('3','100','2','99999.99','confirmed','2014-07-16 20:39:12','2015-08-29 11:31:24'),
('4','63','7','0.00','requested','2012-05-27 22:45:33','2011-08-03 21:53:43'),
('5','33','3','99999.99','requested','2019-12-09 03:33:37','2020-04-27 11:48:25'),
('6','24','2','233.47','requested','2014-05-21 22:01:55','2019-09-15 12:45:13'),
('7','80','7','628.32','confirmed','2018-01-10 17:00:08','2012-12-12 01:31:12'),
('8','29','4','99999.99','requested','2019-01-06 00:02:55','2017-07-10 10:51:23'),
('9','19','6','25021.48','rejected','2020-09-02 06:52:36','2011-04-28 04:37:21'),
('10','100','9','99999.99','requested','2020-09-25 14:08:21','2016-07-14 00:45:41'),
('11','62','4','51.59','requested','2011-03-01 22:03:55','2011-05-15 02:22:13'),
('12','66','8','2.16','confirmed','2012-07-30 01:51:53','2017-10-11 12:58:44'),
('13','48','5','0.00','rejected','2014-02-18 19:11:22','2019-12-24 15:47:04'),
('14','72','3','0.00','requested','2014-12-29 01:29:24','2016-02-06 20:12:34'),
('15','64','4','7551.00','confirmed','2012-12-06 09:36:17','2013-09-02 23:03:17'),
('16','47','2','99999.99','requested','2017-06-30 10:58:21','2018-03-10 04:26:54'),
('17','39','1','3059.20','rejected','2020-04-22 12:33:46','2014-05-28 22:48:22'),
('18','2','6','1.80','confirmed','2018-06-20 10:34:22','2017-01-21 23:51:44'),
('19','40','1','99999.99','rejected','2015-05-26 07:47:35','2015-11-11 23:00:53'),
('20','76','2','24.49','requested','2018-03-08 10:06:30','2011-10-20 23:05:41'),
('21','50','3','0.00','requested','2018-02-09 02:19:19','2020-10-08 08:19:22'),
('22','54','5','99999.99','requested','2011-02-21 05:56:11','2013-08-31 10:23:42'),
('23','44','9','99999.99','requested','2014-01-29 02:49:24','2015-12-20 05:38:21'),
('24','82','2','99999.99','confirmed','2015-04-23 05:11:39','2015-02-20 06:40:31'),
('25','61','7','3.72','confirmed','2012-04-05 09:47:29','2020-10-02 23:13:56'),
('26','46','5','99999.99','requested','2012-04-22 21:28:43','2020-05-08 23:29:16'),
('27','98','4','99999.99','rejected','2020-01-26 00:53:47','2011-12-25 12:23:27'),
('28','85','4','7.00','rejected','2019-12-14 19:38:44','2010-12-29 03:40:23'),
('29','4','3','3.14','rejected','2018-10-15 02:17:22','2020-12-04 10:31:23'),
('30','35','4','12.18','confirmed','2012-09-14 12:41:34','2019-03-31 00:01:14'),
('31','24','8','15.60','rejected','2016-06-16 00:05:40','2017-10-11 22:03:53'),
('32','72','7','0.00','rejected','2012-04-20 16:18:24','2013-04-04 21:28:07'),
('33','20','2','0.00','requested','2012-08-06 00:42:15','2018-08-07 00:53:59'),
('34','27','5','3648.34','requested','2011-03-03 16:49:26','2014-08-14 04:06:21'),
('35','68','2','99999.99','confirmed','2020-09-05 21:14:15','2019-01-24 23:36:30'),
('36','57','1','99999.99','requested','2014-04-13 18:37:00','2018-03-13 16:31:32'),
('37','96','8','35014.98','rejected','2019-02-11 09:39:46','2014-03-26 16:05:08'),
('38','100','3','1.08','confirmed','2015-01-27 18:37:45','2013-01-27 12:06:00'),
('39','48','1','0.00','confirmed','2016-03-04 00:46:58','2020-03-13 21:22:59'),
('40','23','8','286.52','requested','2014-08-12 17:35:37','2011-03-31 07:15:30'),
('41','57','9','23.33','rejected','2018-10-15 03:01:12','2014-11-01 18:50:46'),
('42','25','9','0.00','confirmed','2015-05-02 00:54:42','2018-03-11 08:57:50'),
('43','5','2','0.00','requested','2018-12-18 23:45:33','2017-08-21 07:18:56'),
('44','86','9','51885.91','confirmed','2017-08-07 13:26:05','2014-09-27 16:47:15'),
('45','21','7','0.00','rejected','2019-07-05 16:25:37','2020-10-05 20:00:42'),
('46','16','6','99999.99','requested','2018-04-05 14:38:57','2014-11-19 17:07:10'),
('47','92','6','99999.99','requested','2012-01-17 22:46:28','2011-11-01 01:19:56'),
('48','69','3','0.69','requested','2019-03-13 18:12:53','2019-02-20 17:19:01'),
('49','22','6','4291.08','rejected','2013-02-04 00:54:00','2015-08-22 04:42:32'),
('50','84','2','99999.99','requested','2020-03-20 03:35:47','2015-06-02 07:42:16'),
('51','73','7','99999.99','confirmed','2019-11-13 11:04:21','2013-02-28 01:57:15'),
('52','3','4','0.14','rejected','2015-02-14 22:12:09','2012-10-11 18:03:36'),
('53','23','2','13891.47','confirmed','2012-03-15 20:41:30','2013-01-31 19:32:44'),
('54','81','5','99999.99','requested','2014-12-02 10:01:30','2019-03-17 08:09:52'),
('55','93','4','93764.01','confirmed','2014-08-23 12:55:45','2013-03-30 06:23:45'),
('56','76','8','99999.99','requested','2013-11-25 11:54:17','2011-05-26 08:25:04'),
('57','27','8','99999.99','requested','2012-05-22 22:22:13','2016-01-03 00:59:24'),
('58','69','5','0.00','rejected','2017-02-21 20:01:30','2015-06-08 08:43:18'),
('59','8','5','99999.99','confirmed','2015-05-28 15:51:20','2012-04-29 09:08:32'),
('60','24','8','6.24','rejected','2011-06-10 03:25:46','2014-12-19 20:13:52'),
('61','46','4','0.00','rejected','2020-10-25 10:57:36','2020-07-14 23:36:54'),
('62','11','9','512.29','rejected','2011-02-08 17:11:07','2014-06-18 06:30:00'),
('63','58','3','156.18','confirmed','2012-01-08 06:05:29','2012-12-31 09:28:52'),
('64','98','9','61933.68','rejected','2016-05-21 21:42:49','2020-05-20 01:23:08'),
('65','80','7','46.60','rejected','2013-11-28 07:14:24','2020-05-04 04:43:04'),
('66','56','2','99999.99','rejected','2016-04-23 19:46:58','2017-10-01 13:55:16'),
('67','29','3','99999.99','confirmed','2019-05-09 15:34:29','2011-05-30 07:43:27'),
('68','57','2','99999.99','rejected','2013-05-01 03:21:17','2019-09-28 16:21:06'),
('69','78','2','53121.40','requested','2011-03-19 19:59:47','2016-02-09 04:56:00'),
('70','63','2','99999.99','rejected','2020-07-02 22:57:24','2017-01-17 15:56:20'),
('71','6','8','15769.16','confirmed','2014-06-09 09:45:56','2020-04-26 03:21:57'),
('72','25','6','5.53','rejected','2013-08-02 21:04:25','2015-06-16 11:23:34'),
('73','33','3','0.73','requested','2011-02-20 01:56:42','2020-10-31 01:57:06'),
('74','60','7','1401.84','rejected','2018-09-07 00:00:42','2018-04-23 13:05:14'),
('75','33','8','494.07','requested','2020-06-16 22:47:42','2017-08-30 19:33:00'),
('76','95','7','99999.99','rejected','2019-10-28 14:12:07','2015-07-20 17:41:00'),
('77','83','9','99999.99','requested','2014-04-21 09:50:49','2011-09-02 03:55:03'),
('78','17','8','99999.99','requested','2012-05-14 20:01:20','2015-08-10 19:55:59'),
('79','67','6','2.20','confirmed','2012-10-07 19:00:30','2018-08-20 15:28:27'),
('80','93','4','99999.99','requested','2019-11-22 14:39:45','2013-08-11 17:24:33'),
('81','82','8','14.10','requested','2014-07-10 08:58:07','2017-09-28 02:24:51'),
('82','71','6','76.08','requested','2013-05-21 17:15:47','2019-07-08 11:08:32'),
('83','35','9','49.07','requested','2014-02-25 16:58:05','2017-09-21 06:56:43'),
('84','78','2','163.20','rejected','2019-06-11 21:52:17','2017-05-19 02:12:20'),
('85','41','1','212.57','requested','2019-05-09 14:20:50','2017-09-30 23:53:53'),
('86','37','5','99999.99','rejected','2013-04-24 09:21:06','2017-04-12 13:22:13'),
('87','43','8','1409.85','rejected','2018-12-31 01:59:04','2019-06-17 13:24:11'),
('88','57','9','2.00','requested','2017-02-22 11:38:04','2011-03-20 11:23:25'),
('89','40','6','21.00','confirmed','2012-05-21 17:29:17','2020-04-10 03:58:38'),
('90','25','8','6239.40','rejected','2012-06-22 13:15:32','2014-05-20 08:20:51'),
('91','54','8','33.07','rejected','2017-02-21 11:05:51','2011-12-24 23:52:18'),
('92','11','7','99999.99','rejected','2017-02-17 17:42:13','2017-06-11 05:58:35'),
('93','49','7','68.84','requested','2019-06-02 22:28:59','2016-09-30 14:23:30'),
('94','58','1','0.00','requested','2011-07-28 03:08:38','2015-02-20 05:12:34'),
('95','48','4','798.72','rejected','2019-08-11 17:42:44','2019-05-06 21:37:38'),
('96','55','3','2.00','requested','2016-08-24 11:08:57','2011-12-18 11:58:00'),
('97','19','3','62.44','requested','2020-12-01 04:00:53','2020-10-14 21:48:55'),
('98','44','9','0.00','confirmed','2011-05-31 23:27:39','2015-02-03 12:32:58'),
('99','28','3','99999.99','requested','2018-11-17 06:56:52','2019-01-26 17:18:25'),
('100','45','8','99999.99','confirmed','2020-01-02 15:27:29','2015-11-02 21:18:07'),
('101','45','8','0.00','rejected','2013-10-25 04:58:18','2011-01-24 11:03:15'),
('102','34','9','2117.40','rejected','2017-09-19 20:17:23','2017-09-24 14:13:32'),
('103','65','2','99999.99','confirmed','2018-12-12 13:25:27','2011-10-20 15:55:02'),
('104','78','7','0.00','confirmed','2018-06-10 15:17:00','2011-03-10 19:11:18'),
('105','3','9','99999.99','confirmed','2012-03-24 18:38:35','2014-09-04 09:17:08'),
('106','49','3','349.37','requested','2012-11-15 22:32:48','2019-02-14 01:19:26'),
('107','48','3','8410.84','rejected','2016-09-13 23:08:26','2012-04-25 13:32:11'),
('108','73','6','13401.74','confirmed','2012-06-15 14:28:50','2015-01-15 22:39:36'),
('109','42','4','97.17','confirmed','2020-03-06 05:48:58','2020-07-21 16:41:36'),
('110','100','8','47027.68','requested','2017-04-08 00:32:17','2020-08-04 17:59:03'),
('111','41','8','7.41','confirmed','2020-03-06 08:07:52','2013-11-12 23:23:39'),
('112','24','5','0.00','confirmed','2020-08-09 01:05:32','2012-11-09 13:45:38'),
('113','56','1','99999.99','rejected','2012-03-16 23:40:26','2015-09-29 18:15:13'),
('114','4','6','99999.99','requested','2014-06-08 10:15:44','2017-07-22 12:19:39'),
('115','70','4','99999.99','requested','2020-02-09 08:59:24','2018-10-27 01:48:49'),
('116','44','3','769.83','rejected','2018-02-21 10:41:37','2013-05-15 13:17:48'),
('117','4','1','99999.99','confirmed','2016-11-12 09:36:56','2012-06-20 08:54:09'),
('118','91','8','57.49','requested','2011-10-25 00:54:13','2013-09-09 03:56:31'),
('119','78','3','99999.99','requested','2011-05-06 06:20:54','2019-08-29 20:38:38'),
('120','29','7','0.00','requested','2020-05-14 15:47:42','2014-09-25 02:13:12'),
('121','48','4','99999.99','requested','2015-09-05 20:31:16','2018-11-23 08:25:32'),
('122','51','3','12.67','confirmed','2017-01-09 02:39:02','2017-02-25 19:39:15'),
('123','12','6','99999.99','requested','2013-12-16 10:36:43','2018-03-27 15:20:58'),
('124','64','6','99999.99','requested','2017-11-12 18:56:18','2016-11-06 11:48:00'),
('125','39','3','290.84','confirmed','2019-11-09 00:06:26','2017-03-25 19:43:13'),
('126','12','1','99999.99','confirmed','2015-05-16 18:56:26','2014-08-02 10:40:34'),
('127','84','4','46.00','confirmed','2013-04-14 14:22:00','2012-06-17 06:02:41'),
('128','36','6','0.00','confirmed','2013-05-07 04:01:50','2016-01-10 09:16:31'),
('129','56','2','1.29','rejected','2013-02-06 01:05:19','2013-10-13 04:52:58'),
('130','42','5','217.30','confirmed','2017-03-31 02:44:40','2016-09-29 03:13:17'),
('131','65','4','99999.99','rejected','2017-05-19 02:20:38','2014-12-27 21:57:14'),
('132','74','9','0.40','confirmed','2011-06-07 06:04:36','2012-03-18 21:37:20'),
('133','6','1','4.93','requested','2015-04-03 15:18:58','2013-09-27 15:04:11'),
('134','36','8','0.00','rejected','2020-09-01 22:01:36','2013-11-12 20:13:32'),
('135','59','6','99999.99','requested','2020-02-25 14:59:56','2014-03-29 09:51:26'),
('136','41','9','1.00','rejected','2016-04-15 16:59:53','2012-06-14 05:59:04'),
('137','29','7','236.70','requested','2011-01-25 02:32:16','2013-11-25 03:00:47'),
('138','93','4','99999.99','confirmed','2016-12-23 17:44:08','2013-02-10 06:10:56'),
('139','96','5','99999.99','requested','2013-04-27 15:18:46','2018-10-13 19:24:39'),
('140','13','4','3.34','requested','2019-05-03 23:57:39','2011-08-02 19:12:52'),
('141','5','9','99999.99','requested','2018-01-30 00:30:46','2017-02-08 12:54:29'),
('142','44','9','99999.99','confirmed','2019-11-11 12:21:55','2016-12-26 14:37:17'),
('143','41','4','156.70','rejected','2018-02-24 15:48:44','2012-04-05 21:45:27'),
('144','49','9','34776.44','rejected','2011-05-19 01:00:11','2015-07-23 19:33:28'),
('145','64','5','0.48','rejected','2018-09-06 10:39:35','2013-03-31 18:07:49'),
('146','46','3','99999.99','rejected','2013-05-20 10:44:37','2013-03-08 04:34:07'),
('147','59','6','99999.99','confirmed','2011-01-12 21:01:21','2012-10-30 22:39:09'),
('148','56','3','541.61','requested','2019-02-06 15:37:39','2020-05-11 23:13:30'),
('149','53','2','11134.08','requested','2011-07-28 16:41:00','2014-12-12 23:19:56'),
('150','75','6','3566.85','requested','2018-01-11 08:41:45','2011-06-06 07:39:30'),
('151','76','5','99999.99','requested','2015-04-24 18:21:51','2020-06-22 02:27:56'),
('152','30','7','90.90','rejected','2020-02-19 12:20:54','2011-09-03 18:12:38'),
('153','56','9','23214.66','requested','2020-02-25 04:52:14','2011-05-21 08:47:44'),
('154','76','6','99999.99','requested','2016-11-19 03:51:24','2020-02-02 03:19:02'),
('155','99','4','99999.99','requested','2013-12-02 12:26:34','2019-11-08 11:54:54'),
('156','43','1','99999.99','requested','2013-01-20 09:32:28','2011-03-09 15:38:06'),
('157','81','4','1.60','requested','2019-12-31 14:50:26','2013-08-03 18:12:31'),
('158','59','9','99999.99','rejected','2017-05-01 19:19:01','2012-05-29 14:31:18'),
('159','75','2','4.15','rejected','2014-10-05 08:20:11','2018-03-08 16:05:52'),
('160','15','7','1126.21','requested','2015-01-03 07:44:19','2014-04-29 22:20:07'),
('161','98','8','99999.99','rejected','2016-07-24 22:52:51','2020-05-11 13:31:34'),
('162','29','6','693.37','confirmed','2018-09-21 23:04:55','2019-09-25 19:24:48'),
('163','12','7','1720.35','confirmed','2014-12-01 06:06:48','2020-06-18 03:03:28'),
('164','55','4','99999.99','rejected','2013-04-22 20:52:41','2020-01-20 06:25:57'),
('165','7','4','7823.39','requested','2020-07-21 20:00:37','2014-07-27 08:00:42'),
('166','82','5','47224.65','requested','2012-02-21 23:38:00','2012-11-08 20:20:38'),
('167','54','8','99999.99','requested','2015-01-17 05:24:13','2016-10-02 13:20:20'),
('168','54','4','378.63','confirmed','2019-03-26 23:13:02','2020-05-14 09:57:34'),
('169','19','7','23740.88','requested','2018-08-27 21:42:24','2017-12-26 17:53:31'),
('170','7','1','39260.53','rejected','2012-04-10 18:21:25','2013-04-04 08:15:22'),
('171','63','9','485.40','requested','2016-06-10 01:50:09','2018-01-13 23:33:49'),
('172','1','6','5748.82','requested','2019-02-11 09:13:49','2013-09-07 06:37:43'),
('173','85','3','15968.30','confirmed','2012-11-30 20:43:42','2015-11-30 20:03:26'),
('174','7','9','382.27','requested','2018-07-15 04:02:29','2020-05-20 18:30:48'),
('175','28','5','99999.99','requested','2012-02-08 10:52:34','2016-12-21 10:07:30'),
('176','18','3','99999.99','confirmed','2013-05-06 02:48:33','2019-08-27 07:00:02'),
('177','26','6','99999.99','rejected','2012-08-12 03:22:54','2017-10-31 07:55:14'),
('178','54','7','99999.99','rejected','2020-07-24 11:12:11','2013-03-03 10:31:04'),
('179','46','9','191.24','requested','2011-07-27 08:34:47','2014-08-23 03:25:53'),
('180','80','7','99999.99','confirmed','2018-12-15 02:05:36','2018-01-02 16:34:32'),
('181','38','6','96.25','requested','2020-10-25 15:18:30','2015-03-29 17:06:49'),
('182','8','5','99999.99','rejected','2015-01-03 11:25:35','2020-09-13 01:20:10'),
('183','26','3','4.39','confirmed','2014-02-05 17:29:06','2017-01-22 20:21:51'),
('184','37','3','359.76','requested','2013-12-12 06:01:33','2020-03-12 06:33:43'),
('185','79','7','6612.92','rejected','2017-02-18 12:25:21','2011-02-10 06:45:24'),
('186','71','7','1091.86','rejected','2015-05-08 06:19:30','2012-04-22 23:08:06'),
('187','4','2','154.49','rejected','2020-09-16 03:55:30','2016-05-25 05:09:23'),
('188','82','3','99999.99','rejected','2016-10-13 23:56:02','2013-07-25 01:20:35'),
('189','60','8','0.00','confirmed','2018-09-21 01:47:13','2013-03-22 09:12:13'),
('190','75','5','0.00','requested','2012-09-18 21:22:40','2012-08-08 11:13:33'),
('191','92','7','0.00','requested','2020-02-29 15:20:23','2013-06-22 02:39:30'),
('192','56','2','34.90','rejected','2014-02-16 10:25:31','2018-05-10 10:23:34'),
('193','90','7','99999.99','rejected','2020-04-20 20:59:14','2013-04-30 22:22:21'),
('194','46','8','0.00','confirmed','2015-12-24 18:31:51','2019-03-02 15:02:29'),
('195','39','9','99999.99','confirmed','2011-07-17 13:05:58','2017-07-07 20:24:57'),
('196','66','9','354.08','confirmed','2014-12-25 10:07:55','2012-04-09 05:42:09'),
('197','20','7','166.78','confirmed','2019-11-03 02:00:04','2016-08-20 16:25:23'),
('198','92','3','99999.99','requested','2020-06-17 17:27:26','2018-03-10 08:53:47'),
('199','98','5','48.50','confirmed','2020-11-29 13:21:05','2011-06-25 01:42:46'),
('200','57','9','9.00','requested','2014-10-06 02:48:24','2016-07-25 16:31:38'); 

SELECT * FROM orders LIMIT 10;
UPDATE orders SET user_id = FLOOR(1 + RAND() * 100);
UPDATE orders SET service_id = FLOOR(1 + RAND() * 9);
UPDATE orders SET updated_at = NOW() WHERE updated_at < created_at;


#
# TABLE STRUCTURE FOR: payments
#

DROP TABLE IF EXISTS `payments`;

CREATE TABLE `payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `order_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на заявление на предоставление услуги',
  `price` decimal(7,2) DEFAULT NULL COMMENT 'Стоимость',
  `payment_status` enum('in progress','confirmed','rejected') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Статус платежа',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  CONSTRAINT `payments_order_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Оплата услуг';

INSERT INTO `payments` VALUES ('1','115','575.61','in progress','2019-11-04 11:02:09','2018-06-30 04:54:33'),
('2','13','6.06','rejected','2016-04-03 09:54:10','2020-10-12 00:29:26'),
('3','98','99999.99','confirmed','2013-08-11 20:25:39','2018-12-02 11:57:08'),
('4','99','606.77','in progress','2015-12-20 00:01:50','2014-02-25 04:33:22'),
('5','45','99999.99','in progress','2012-07-17 22:05:35','2014-04-08 19:27:26'),
('6','87','132.00','in progress','2012-05-13 02:09:10','2017-06-01 13:21:52'),
('7','179','99999.99','rejected','2016-02-06 09:51:52','2013-06-28 03:51:23'),
('8','64','20140.61','confirmed','2018-08-22 08:22:40','2013-03-21 01:39:31'),
('9','126','0.00','in progress','2018-09-09 04:54:22','2012-01-25 00:10:35'),
('10','81','7043.12','in progress','2015-09-09 00:32:25','2010-12-27 13:03:35'),
('11','42','6.94','rejected','2013-01-06 02:32:39','2018-10-30 06:02:10'),
('12','27','1785.40','in progress','2017-02-06 23:37:31','2016-03-19 09:38:11'),
('13','38','499.92','rejected','2017-02-12 17:45:24','2015-06-20 22:15:57'),
('14','134','99999.99','rejected','2016-05-16 01:28:56','2015-12-20 23:39:07'),
('15','82','99999.99','confirmed','2015-12-24 10:21:18','2011-02-05 23:47:09'),
('16','113','10075.58','in progress','2018-01-28 15:57:31','2020-06-29 00:02:42'),
('17','90','5592.60','confirmed','2015-01-03 07:39:49','2012-12-10 21:30:42'),
('18','149','0.26','rejected','2020-10-31 17:15:08','2020-02-16 22:19:11'),
('19','118','70066.50','confirmed','2020-06-26 08:10:27','2011-01-13 04:18:28'),
('20','68','99999.99','rejected','2017-05-04 23:24:38','2013-10-06 21:58:43'),
('21','62','3694.73','in progress','2016-02-17 05:59:14','2016-02-04 06:37:45'),
('22','199','1145.21','rejected','2020-10-06 00:49:44','2013-04-13 14:22:34'),
('23','107','0.00','in progress','2016-07-16 09:54:46','2011-04-20 15:34:29'),
('24','194','7.82','confirmed','2012-07-27 05:00:42','2016-10-30 10:46:26'),
('25','185','32468.26','confirmed','2017-05-16 05:44:54','2017-12-19 11:59:00'),
('26','145','0.00','confirmed','2018-11-10 18:28:11','2019-09-02 09:09:53'),
('27','140','29863.74','rejected','2011-02-26 13:35:35','2018-01-19 03:14:40'),
('28','47','1878.76','confirmed','2018-09-15 00:26:26','2016-11-11 00:18:49'),
('29','102','26718.66','confirmed','2017-09-30 08:17:45','2012-07-24 01:19:31'),
('30','23','3.00','in progress','2014-01-14 13:07:01','2013-11-13 09:41:55'),
('31','143','99999.99','in progress','2012-09-25 03:20:01','2019-06-28 12:45:21'),
('32','31','99999.99','in progress','2012-06-26 04:49:10','2018-10-07 23:06:02'),
('33','172','38.29','in progress','2012-10-03 06:01:33','2012-05-16 15:41:37'),
('34','160','5.66','in progress','2012-05-08 08:38:38','2019-06-21 02:41:13'),
('35','85','99999.99','rejected','2015-05-05 06:44:26','2012-04-19 19:57:54'),
('36','173','431.18','confirmed','2019-11-14 20:07:36','2020-09-30 08:30:35'),
('37','120','1070.38','confirmed','2017-05-30 23:19:19','2013-07-06 07:47:46'),
('38','190','99999.99','rejected','2017-11-13 18:36:10','2018-11-20 14:43:40'),
('39','195','3.02','rejected','2014-02-03 10:11:04','2012-05-18 01:32:28'),
('40','48','99999.99','rejected','2013-06-22 22:48:30','2020-07-28 22:17:38'),
('41','139','0.00','in progress','2015-05-26 22:47:44','2016-03-04 21:27:36'),
('42','151','99999.99','confirmed','2015-03-18 16:14:14','2020-06-09 17:55:40'),
('43','32','95132.47','confirmed','2015-05-21 23:44:42','2013-06-04 07:52:22'),
('44','103','23009.96','in progress','2015-03-31 05:42:49','2014-06-09 20:23:24'),
('45','10','99999.99','rejected','2017-05-12 03:20:14','2012-05-13 06:35:46'),
('46','198','99999.99','confirmed','2014-10-26 12:52:34','2014-03-20 04:34:18'),
('47','18','44418.09','confirmed','2017-07-17 00:16:13','2018-12-16 18:14:08'),
('48','3','99999.99','in progress','2019-08-15 11:07:08','2012-04-22 02:03:45'),
('49','122','2875.08','in progress','2014-09-20 07:46:43','2018-05-06 01:38:42'),
('50','182','99999.99','in progress','2018-11-29 14:54:43','2015-07-25 11:04:37'),
('51','57','99999.99','confirmed','2013-09-09 12:40:38','2015-06-21 23:04:40'),
('52','138','99999.99','rejected','2020-10-31 15:27:53','2019-08-01 10:56:45'),
('53','15','99999.99','rejected','2015-03-08 06:35:13','2020-01-07 14:56:51'),
('54','92','562.50','rejected','2014-08-16 15:48:44','2018-11-17 15:44:06'),
('55','196','86.79','in progress','2013-08-27 00:56:32','2015-07-18 19:29:30'),
('56','66','99999.99','in progress','2013-07-14 18:07:52','2018-11-22 21:57:17'),
('57','167','8205.40','confirmed','2019-01-05 23:43:19','2015-08-19 18:36:59'),
('58','75','13.00','confirmed','2013-06-12 03:46:36','2018-03-18 13:15:40'),
('59','6','47619.44','rejected','2015-07-07 13:56:26','2019-11-26 22:16:13'),
('60','163','72.95','confirmed','2016-12-25 01:16:05','2018-01-10 07:32:00'),
('61','188','99999.99','confirmed','2014-08-17 17:07:13','2012-04-06 20:19:28'),
('62','130','4144.84','in progress','2020-03-03 06:02:46','2017-07-17 03:33:14'),
('63','91','73823.32','rejected','2011-01-10 19:23:29','2012-01-28 22:05:47'),
('64','58','0.00','confirmed','2013-06-01 19:56:26','2011-10-01 06:04:11'),
('65','169','2.00','rejected','2018-07-17 20:47:09','2020-02-13 20:41:53'),
('66','135','99999.99','rejected','2012-02-17 13:37:36','2013-02-12 03:20:21'),
('67','41','33.31','confirmed','2015-03-13 22:21:51','2014-12-23 04:54:43'),
('68','93','11.97','rejected','2012-01-06 03:51:34','2012-08-26 21:14:05'),
('69','116','99999.99','in progress','2014-02-12 14:20:33','2011-09-21 01:51:14'),
('70','181','8871.00','confirmed','2012-09-10 23:52:25','2016-10-04 17:30:39'),
('71','112','99999.99','in progress','2014-06-22 14:31:41','2020-11-12 10:07:59'),
('72','150','173.95','in progress','2015-12-18 15:06:59','2018-11-12 04:19:44'),
('73','70','0.00','rejected','2019-07-25 04:56:59','2019-12-07 08:36:33'),
('74','164','2031.21','confirmed','2015-11-24 20:36:41','2019-12-14 22:12:16'),
('75','1','99999.99','rejected','2015-11-05 19:29:32','2013-05-27 05:39:18'),
('76','137','99999.99','rejected','2014-06-10 13:38:53','2020-02-24 10:01:05'),
('77','53','50.80','confirmed','2014-04-06 13:09:16','2014-10-26 15:13:17'),
('78','111','3611.67','in progress','2012-08-04 07:33:49','2012-11-25 16:49:52'),
('79','171','99999.99','confirmed','2012-04-29 12:59:39','2017-12-09 11:15:45'),
('80','29','10.38','rejected','2020-07-12 09:23:07','2019-08-02 06:48:53'),
('81','83','14857.00','in progress','2014-04-20 17:39:22','2015-10-11 01:34:43'),
('82','43','99999.99','confirmed','2018-04-12 22:11:25','2016-07-14 12:52:51'),
('83','84','43537.00','rejected','2018-02-08 00:53:25','2011-09-29 23:42:03'),
('84','17','0.70','in progress','2017-04-09 17:11:29','2015-04-21 20:54:51'),
('85','80','62.00','rejected','2018-01-14 04:24:45','2013-05-14 19:31:23'),
('86','52','32.97','rejected','2015-06-12 16:19:31','2011-09-14 10:51:48'),
('87','155','99999.99','confirmed','2011-01-26 05:15:06','2016-12-01 14:18:32'),
('88','121','99999.99','rejected','2019-05-28 18:44:51','2016-06-25 23:31:08'),
('89','16','0.00','confirmed','2013-04-20 20:56:04','2014-04-03 15:12:26'),
('90','86','0.57','in progress','2015-05-17 01:59:49','2019-12-27 09:07:12'),
('91','21','99999.99','in progress','2015-02-08 07:26:04','2017-01-04 00:55:52'),
('92','131','99999.99','rejected','2012-11-23 13:40:39','2020-10-22 19:47:46'),
('93','158','99999.99','in progress','2014-03-05 23:51:58','2016-10-01 10:44:12'),
('94','123','99999.99','confirmed','2018-04-03 13:55:52','2018-03-09 19:10:12'),
('95','184','0.00','confirmed','2016-04-30 16:15:43','2013-10-10 13:45:53'),
('96','161','99999.99','rejected','2020-10-09 11:09:44','2011-08-23 22:04:39'),
('97','148','99999.99','in progress','2018-06-07 23:15:26','2019-11-27 03:45:04'),
('98','100','2753.61','in progress','2013-06-03 00:00:34','2020-11-06 19:44:01'),
('99','101','41961.75','confirmed','2020-11-27 17:40:18','2020-12-07 20:42:54'),
('100','5','4.15','rejected','2018-11-09 08:15:52','2020-01-30 03:38:01'); 



DESC payments;
SELECT * FROM payments;
SELECT * FROM orders ORDER BY id DESC;
UPDATE payments SET order_id = FLOOR(1 + RAND() * 200);
UPDATE payments SET updated_at = NOW() WHERE updated_at < created_at;
UPDATE payments SET price = 100 WHERE price = 0;

#
# TABLE STRUCTURE FOR: profiles
#

DROP TABLE IF EXISTS `profiles`;

CREATE TABLE `profiles` (
  `user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на пользователя',
  `first_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Имя пользователя',
  `last_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Фамилия пользователя',
  `gender` enum('Женский','Мужской') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Пол',
  `birthday` date DEFAULT NULL COMMENT 'Дата рождения',
  `address_of_registration` varchar(180) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Адрес по месту регистрации',
  `address_actual` varchar(180) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Адрес проживания',
  `citizenship` enum('Российская Федерация','Казахстан','Белоруссия','Армения','Киргизия','иное') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Гражданство',
  `passport_number` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Номер паспорта',
  `tax_number` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Номер ИНН',
  `car_number` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Гос. номер автомобиля',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`user_id`),
  CONSTRAINT `profiles_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Профили';

INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (1, 'Derek', 'Gerlach', 'Женский', '1920-12-03', '69958 Dicki Lock Suite 472\nSchneiderhaven, CA 90674', '321 Gulgowski Route Apt. 367\nNorth Augusta, OH 53263-8575', 'Казахстан', '4892443358', '727518938347', '37 uo', '2015-01-20 06:38:25', '2012-01-23 05:47:25');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (2, 'Fred', 'Emmerich', 'Женский', '1987-01-13', '21184 Yvette Corner\nKianashire, MT 27056-4016', '4027 Dicki Estate Suite 179\nEast Silas, MI 36476-1747', 'Казахстан', '4570285418', '825211708695', '86 xq', '2015-05-14 09:03:04', '2015-11-19 18:34:00');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (3, 'Sylvester', 'Anderson', 'Мужской', '1959-02-03', '521 Reichel Stream\nBraunville, MD 22364', '767 Reyna Road\nWhitemouth, ID 59205', 'Белоруссия', '4750163653', '181581720374', '38 wd', '2017-01-09 07:23:48', '2011-04-17 00:41:56');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (4, 'Rosella', 'Klein', 'Мужской', '1957-03-13', '641 Hagenes Drive\nLake Felix, CA 51959', '69840 Rosie Path\nLeuschkeville, MA 14115', 'иное', '4713387463', '337088223956', '33 lg', '2016-02-13 13:45:16', '2015-09-16 14:39:32');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (5, 'Selmer', 'Haley', 'Мужской', '1999-04-20', '23989 Schneider Loop Apt. 599\nPort Kaleb, VA 41826', '773 Kamren Greens\nWest Deltastad, OR 53791-4865', 'Белоруссия', '4601425253', '725081219808', '91 wl', '2019-12-03 02:42:06', '2012-01-18 00:28:01');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (6, 'Jerrell', 'Mertz', 'Женский', '1971-05-05', '223 Connelly Fork\nNorth Wilburnview, ND 38634', '1038 Gleason Isle Suite 393\nKrajcikburgh, CT 51854', 'иное', '4394681793', '247979101967', '', '2013-02-22 12:28:23', '2011-08-05 05:56:30');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (7, 'Jayda', 'Brekke', 'Женский', '1972-05-06', '9394 Julianne Way\nNew Emmanuelfort, OH 09183', '06027 Williamson Court Suite 738\nChristinastad, HI 54069-8873', 'Белоруссия', '4595220507', '288597962204', '81 ko', '2020-09-28 19:26:54', '2016-01-29 20:02:08');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (8, 'Kenna', 'Windler', 'Мужской', '1975-04-07', '6833 Idella Loaf Apt. 955\nLake Gardner, VT 74598-1533', '8488 Lue Greens Suite 798\nDejonside, AZ 53607-2364', 'Казахстан', '4420406398', '151607671389', '61 cg', '2019-09-09 11:41:12', '2019-08-13 22:42:14');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (9, 'Aliza', 'Zemlak', 'Мужской', '1978-01-23', '5409 Amos Hill Apt. 996\nAdeliatown, KS 19525-6642', '86233 Fahey Rapids Suite 300\nEmanuelberg, MS 39718', 'Киргизия', '4454219439', '781650421247', '60 zp', '2018-01-02 20:34:04', '2012-10-08 22:35:17');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (10, 'Constantin', 'Hessel', 'Женский', '1991-02-25', '2115 Miller Street\nHanemouth, NE 10948', '69344 Thompson Road Suite 848\nLindgrenfort, DE 28381', 'Армения', '4639086779', '458597526383', '40 wv', '2016-06-13 23:10:05', '2012-04-08 19:22:38');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (11, 'Allan', 'Lemke', 'Мужской', '1986-03-26', '296 Shanny Spur\nSouth Margotfort, MA 63686', '774 Ari Manor Suite 738\nEast Erna, AK 20898', 'Белоруссия', '4798228568', '110134003642', '00 hx', '2014-05-10 08:42:42', '2015-10-23 15:09:28');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (12, 'Emil', 'Waters', 'Женский', '1947-03-28', '776 Deangelo Locks\nCamrenshire, NE 48982-9521', '9185 Witting Curve Suite 962\nStephanyshire, DE 49926-2673', 'иное', '4852133630', '211922132387', '82 fz', '2017-01-22 01:39:55', '2019-01-11 08:12:16');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (13, 'Jeromy', 'Stiedemann', 'Мужской', '1989-06-17', '50572 Hank Motorway Apt. 592\nJosiahshire, OK 50154-1890', '4269 Schiller Mission\nSchulistview, DC 77516-9952', 'Киргизия', '4485739540', '397640902749', '86 uk', '2014-10-11 02:23:14', '2013-12-17 14:55:06');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (14, 'Ericka', 'Jones', 'Женский', '1932-09-14', '17197 Barton Shoal\nEast Leonelport, NY 98746-5551', '789 Bednar Grove Apt. 629\nHilpertton, VT 15123', 'Российская Федерация', '4300898840', '478688851544', '', '2013-11-27 07:20:17', '2017-04-03 07:55:57');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (15, 'Melvina', 'Turcotte', 'Женский', '1930-08-11', '83281 Geovanny Lake Suite 589\nNorth Darian, AR 14468-4178', '5643 Dolores Plains\nSouth Isai, NV 81397-4791', 'Киргизия', '4879471941', '384688809970', '91 sw', '2015-11-16 15:11:04', '2016-11-22 22:20:16');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (16, 'Amelie', 'Raynor', 'Мужской', '1936-08-10', '8768 Bailey Land\nKlingside, CT 10310', '822 Nikolaus Locks Apt. 857\nPort Justinechester, CO 48317', 'Казахстан', '4324284779', '807289316384', '', '2015-10-03 18:31:02', '2016-11-03 23:29:02');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (17, 'Lenna', 'Bednar', 'Мужской', '1954-07-01', '780 Bradtke Field Apt. 298\nLudwigton, IN 33486-2923', '859 Waters Overpass Apt. 524\nSouth Merl, DC 45381-7685', 'Российская Федерация', '4691015073', '233374085407', '26 cz', '2015-01-13 03:55:55', '2012-09-02 18:57:40');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (18, 'Jewell', 'Langworth', 'Мужской', '1994-12-03', '27234 Dangelo Rest\nTrantowbury, OK 10801-1758', '84972 Kreiger Shores\nTromphaven, TN 39613-4805', 'Киргизия', '4853704702', '836408564356', '', '2012-11-30 10:40:05', '2016-10-02 00:44:53');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (19, 'Grover', 'Mante', 'Мужской', '1958-10-08', '315 Rae Gateway\nPort Mark, RI 29149', '03891 Laverne Mountain Suite 788\nDickensport, NC 96851', 'Казахстан', '4565940221', '266745751891', '34 ee', '2013-06-17 08:19:39', '2018-04-26 17:36:49');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (20, 'Ruthie', 'Rippin', 'Женский', '1985-10-08', '207 Pfannerstill Groves Apt. 322\nNew Eudora, NY 63957-5888', '79424 Hirthe Villages Suite 784\nSauerfurt, FL 93002-9898', 'Белоруссия', '4192436925', '367044718652', '24 no', '2016-06-05 06:47:19', '2018-12-20 11:35:00');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (21, 'Lydia', 'Conn', 'Мужской', '1993-10-09', '2985 Carmen Ports\nPadbergchester, AK 94637', '6298 Nienow Well\nLevimouth, UT 66988-8052', 'иное', '4287258695', '322394370176', '82 yw', '2014-02-19 16:27:38', '2015-09-04 06:28:15');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (22, 'Luisa', 'Parisian', 'Женский', '1947-11-09', '326 Donnie Mountains Suite 151\nJerdemouth, NV 43643-5480', '463 Marquise Ramp Suite 790\nManteshire, GA 11537-1833', 'иное', '4573834007', '233752123001', '04 aw', '2016-11-04 22:51:59', '2016-11-08 11:13:12');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (23, 'Collin', 'Padberg', 'Женский', '1975-11-10', '65655 Taya Well Apt. 937\nLake Mac, NC 97445', '56121 Wehner Drive\nLake Camdenland, OK 49630-3531', 'Киргизия', '4187707763', '565240054773', '28 oj', '2017-09-07 13:17:08', '2015-08-17 22:27:22');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (24, 'Louvenia', 'Wisozk', 'Женский', '1963-11-10', '824 Kirlin Lodge Suite 117\nNew Pedro, AR 26472-2355', '937 Lew Oval Suite 280\nWest Concepcionfort, MN 01391', 'Белоруссия', '4763965067', '324253678010', '', '2019-08-14 05:28:08', '2013-06-18 20:17:26');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (25, 'Chanel', 'Becker', 'Мужской', '1924-10-11', '65876 Cedrick Extension\nCrystelborough, NC 06131-1697', '313 Ortiz Inlet\nPort Caesarside, UT 67696-4387', 'Российская Федерация', '4826332184', '184167249193', '', '2018-12-10 06:06:12', '2014-03-21 00:46:38');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (26, 'Timmothy', 'Auer', 'Женский', '1961-10-11', '47827 Frederick Mews\nEast Michaelaside, VT 97070', '92131 Borer Crescent\nGrimesburgh, ND 86075-1388', 'Армения', '4267624625', '852017461090', '', '2015-02-10 16:29:52', '2014-10-21 04:01:32');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (27, 'Bonnie', 'Crist', 'Женский', '1990-10-12', '06533 Friedrich Flats\nSouth Beulahside, MD 35870', '44497 Deshawn Wall Apt. 648\nNorth Robin, NV 31166-7203', 'иное', '4873648996', '205749215688', '', '2015-09-28 06:34:28', '2014-11-14 06:42:38');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (28, 'Uriel', 'Douglas', 'Женский', '1967-09-21', '24499 Murazik Shore Apt. 604\nNorth Vivian, NY 56091', '965 Emerson Forks Suite 670\nSouth Augustfurt, WV 51972-3454', 'Киргизия', '4971075852', '319185274099', '', '2011-02-10 18:47:02', '2019-06-11 00:59:48');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (29, 'Sadye', 'Rau', 'Женский', '1934-08-22', '1438 Marion Coves Apt. 688\nWest Cecil, NE 88427-2393', '54266 Thiel Lock\nSouth Lonzoland, NJ 74929-9414', 'Армения', '4392007093', '876084170486', '', '2011-06-15 05:53:01', '2015-06-06 09:49:21');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (30, 'Marquis', 'Sawayn', 'Мужской', '1982-07-18', '62933 Shanahan Walks\nWaltermouth, WI 94975', '62650 Bailey Mill\nWest Maudebury, AZ 31798', 'Белоруссия', '4600555863', '726785961981', '', '2014-12-12 23:40:03', '2017-06-20 22:33:37');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (31, 'Dashawn', 'Boyer', 'Женский', '1985-07-19', '514 Adele Way Apt. 940\nAurelieside, TX 69460-0403', '47040 Tamia Mills Apt. 812\nLake Hazle, TX 73448-1793', 'Белоруссия', '4643769264', '264963672538', '03 ly', '2018-09-10 10:31:27', '2011-11-19 03:11:18');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (32, 'Giles', 'Schaefer', 'Мужской', '1983-08-07', '271 Blanda Corner\nLake Grayson, SC 11321', '3968 Hilll Lodge\nLake Roelborough, HI 14593', 'Армения', '4444907851', '887739656270', '', '2011-12-21 11:22:29', '2010-12-16 11:33:57');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (33, 'Audra', 'Gleason', 'Мужской', '1976-06-04', '674 Chaya Mount\nNorth Verla, AK 78101-7527', '878 Adams Manor Suite 716\nBogisichport, CA 01231-5944', 'Киргизия', '4315809746', '761848470983', '41 gc', '2020-04-07 06:06:44', '2011-01-09 03:00:57');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (34, 'Shaina', 'Hills', 'Женский', '1974-08-01', '56270 Effertz Village Apt. 616\nLake Novaton, FL 37028-1255', '106 Lawrence Shoals Apt. 748\nPort Gerson, SD 69678', 'Казахстан', '4993437294', '576037749662', '', '2019-10-09 17:06:27', '2014-07-10 10:10:50');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (35, 'Alphonso', 'Bradtke', 'Женский', '1995-07-20', '28790 Cara Ville Suite 823\nEast Juanita, ND 57187', '4763 Darius Land Suite 392\nEwellside, MO 45101-3138', 'иное', '4639920491', '606747800838', '06 ni', '2016-03-03 19:38:05', '2011-02-04 12:04:29');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (36, 'Lafayette', 'Franecki', 'Мужской', '1990-04-03', '279 Maryse Walk\nLenorastad, MA 07975', '635 Jade Lane Suite 357\nGeorgiannafort, TX 85551-7815', 'Белоруссия', '4452374767', '113247281490', '60 uv', '2014-08-05 10:21:31', '2013-02-19 09:00:37');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (37, 'Corine', 'Hoppe', 'Женский', '1980-01-07', '8377 Desiree Parks\nAiyanastad, ID 35804-2399', '77381 Asia Plains Suite 760\nSouth Alizabury, CT 35933-8137', 'Белоруссия', '4507554445', '805818906548', '', '2016-09-28 21:06:42', '2011-12-06 01:16:57');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (38, 'Aida', 'Block', 'Женский', '1970-01-15', '433 Metz Station Apt. 103\nSkilesfort, WV 82065-3820', '1019 Floyd Curve\nSouth Palmaside, ME 00909-8723', 'Российская Федерация', '4830358325', '135657901833', '29 af', '2013-06-25 14:57:45', '2013-02-01 14:12:38');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (39, 'Irma', 'Brown', 'Женский', '1980-05-09', '785 Lukas Canyon Apt. 993\nEast Emiehaven, ND 02416-0034', '04829 Althea Way Apt. 162\nMrazborough, MS 59619', 'Армения', '4553267335', '290680837678', '46 xk', '2019-06-17 23:03:31', '2018-12-04 02:28:34');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (40, 'Charley', 'Kassulke', 'Женский', '1990-07-09', '568 Fleta Dale\nEast Maudfort, ID 11851', '64929 Jevon Knolls\nNienowton, NE 07144-1544', 'Белоруссия', '4816821567', '363611161522', '', '2019-03-29 16:32:35', '2012-06-13 02:27:44');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (41, 'Joel', 'Hickle', 'Женский', '1950-07-25', '597 Hayes Road Suite 869\nNorth Natasha, DE 92332', '42614 Christa Station Suite 610\nHanetown, ND 46628-0652', 'иное', '4358482250', '409421085268', '', '2018-03-04 01:33:17', '2016-09-27 17:18:20');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (42, 'Joel', 'Hickle', 'Женский', '1950-07-25', '597 Hayes Road Suite 869\nNorth Natasha, DE 92332', '42614 Christa Station Suite 610\nHanetown, ND 46628-0652', 'иное', '4358982250', '400421085268', '', '2018-03-04 01:33:17', '2016-09-27 17:18:20');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (43, 'Kennedy', 'Morissette', 'Мужской', '1940-12-25', '390 Annamae Greens Suite 654\nDomenicastad, MD 64179', '034 Deon Glen Suite 615\nSouth Clement, CT 32763', 'Белоруссия', '4714749548', '808881432643', '04 qc', '2011-08-30 00:59:16', '2011-08-01 14:15:40');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (44, 'Emmanuel', 'Lemke', 'Женский', '1930-12-28', '973 Shawna Garden Suite 438\nLake Myrontown, MA 37991-0944', '92648 Omer Fall\nPurdystad, IN 09519', 'иное', '4960605661', '222654970162', '97 qj', '2013-07-10 15:58:13', '2014-07-29 09:03:30');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (45, 'Willow', 'Rice', 'Женский', '1935-12-10', '92025 Fredy Well Apt. 201\nKreigerfurt, IL 69862-6660', '2579 Bashirian Forks\nDachville, AR 36831-5937', 'иное', '4214219599', '606162847821', '90 bv', '2014-02-22 19:04:19', '2019-04-01 23:57:37');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (46, 'Athena', 'Ondricka', 'Женский', '1973-12-15', '91029 Koss Squares Apt. 755\nSouth Ron, VA 06476-4103', '3138 Sylvester Ways Apt. 492\nHarrisberg, KY 53921', 'Киргизия', '4574729749', '576648332332', '73 eh', '2013-12-24 19:21:44', '2015-07-10 00:37:15');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (47, 'Yazmin', 'Johnston', 'Мужской', '1974-10-20', '676 Williamson Green Suite 161\nKenchester, MD 18723-5227', '7532 Schuyler Lock Suite 723\nColbyfurt, TX 13273-9223', 'Российская Федерация', '4889493860', '676816212917', '00 gh', '2011-09-09 05:12:40', '2015-04-19 14:53:02');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (48, 'Murray', 'Bahringer', 'Женский', '1975-10-05', '103 Shields Ranch Suite 974\nLake Cordieberg, HI 95217', '9907 Hintz Ranch Suite 164\nNew Josephine, TN 92685-2553', 'Казахстан', '4401312306', '448860114920', '63 eo', '2012-02-12 11:57:58', '2017-09-04 21:20:03');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (49, 'Bruce', 'Wisozk', 'Мужской', '1976-10-01', '684 Sauer Park\nGrantfurt, IA 53046-1876', '46133 Estrella Ramp\nNorth Rossie, ND 24619-1317', 'Белоруссия', '4832025260', '44012191267', '', '2014-08-07 08:27:58', '2020-05-05 07:51:34');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (50, 'Kamryn', 'Ryan', 'Женский', '1977-08-25', '35783 Shaina Port\nEast Owen, MI 87930-0968', '20179 Holly Forge\nSigridland, WV 77092', 'Белоруссия', '4326052180', '312184917000', '', '2013-01-05 19:28:05', '2014-11-14 16:19:39');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (51, 'Maxie', 'Ruecker', 'Мужской', '1988-08-02', '892 Kane Lodge\nLake Fabianbury, IN 25298-5643', '007 D\'Amore Court\nEast Bridgettown, WV 98525-3307', 'Российская Федерация', '4798454526', '105445022699', '', '2018-06-27 12:07:30', '2019-02-01 11:01:46');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (52, 'Ole', 'Bogisich', 'Мужской', '1922-01-04', '750 Pollich Mission\nNaderton, TN 49505-7618', '94184 Beatty Common\nRoselynfort, SD 20481', 'Белоруссия', '4938486413', '81457400065', '', '2017-06-30 00:24:57', '2018-01-31 13:29:05');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (53, 'Mariela', 'Wuckert', 'Женский', '1933-01-06', '8549 Balistreri Street\nNew Mike, DC 94767-4852', '398 Christiansen Station\nBotsfordmouth, NC 65722', 'Киргизия', '4808635388', '376168579217', '85 zb', '2019-01-22 18:32:32', '2011-11-26 05:15:22');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (54, 'Jean', 'Goodwin', 'Мужской', '1944-01-08', '9887 Bernhard Village\nNorth Osvaldoside, MT 34429', '50509 Zulauf Ridges\nEast Lorinestad, RI 07301-9123', 'Российская Федерация', '4813928743', '54321297030', '', '2014-10-08 14:08:33', '2014-09-26 23:41:27');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (55, 'Kayleigh', 'Zieme', 'Мужской', '1955-05-10', '22403 Holly Place\nSouth Laila, PA 48513', '68356 Layne Port\nAdrainstad, AZ 21300-3420', 'иное', '4772320883', '193142334609', '', '2014-11-13 20:23:44', '2013-12-27 06:41:22');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (56, 'Halie', 'Gleason', 'Мужской', '1966-06-12', '339 Brooklyn Street Suite 966\nEast Priscillaland, GA 84533-7753', '35445 Pouros Extension\nAmelyborough, OH 58090', 'Казахстан', '4113982036', '396717262589', '38 jt', '2013-11-08 16:53:41', '2019-11-18 01:47:22');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (57, 'Hayden', 'Block', 'Женский', '1977-06-14', '32949 Brakus Drive\nGutmannland, HI 18637', '931 Nickolas Corners\nHelenview, AR 73473-1212', 'Киргизия', '4933265178', '538405615720', '49 cp', '2019-08-08 12:38:40', '2020-07-15 02:40:53');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (58, 'Yessenia', 'Collier', 'Женский', '1988-05-16', '3177 Pouros Island Suite 913\nDestinville, MD 51807', '296 Johns Manors\nNadershire, VT 19645-8031', 'Белоруссия', '4988944424', '319398445147', '15 gk', '2011-09-13 06:02:23', '2013-12-10 14:30:32');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (59, 'Barry', 'Stracke', 'Женский', '1987-08-18', '776 Francesca Trail\nMabelleburgh, AZ 45915', '85811 Douglas Lock Suite 996\nWest Nicholashaven, MA 70166-7728', 'Казахстан', '4224813124', '534980177260', '', '2016-03-13 17:18:51', '2012-12-31 17:05:45');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (60, 'Danika', 'Kozey', 'Мужской', '1978-09-17', '229 Hamill Row\nSouth Clareborough, NE 76678-7760', '991 Abigale Shores\nFritschfort, MI 02151', 'Казахстан', '4116593980', '509073137371', '16 mx', '2020-03-17 11:57:36', '2013-05-24 03:38:03');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (61, 'Frieda', 'Lowe', 'Мужской', '1969-08-15', '66370 Kertzmann Stream\nMozellland, MO 07082', '37873 Iva Wall Apt. 841\nLake Jordanfort, SC 55029', 'Белоруссия', '4193638571', '687618817031', '', '2016-02-18 20:42:27', '2014-11-16 22:04:12');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (62, 'Loy', 'Bahringer', 'Мужской', '1996-07-13', '1115 Darion Locks\nLake Celine, NY 35287', '52639 Kozey Causeway Apt. 919\nPort Simeon, CO 76533-5978', 'иное', '4432870928', '71116441506', '', '2018-09-10 22:09:24', '2016-01-14 13:08:04');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (63, 'Prince', 'Walker', 'Мужской', '1945-12-11', '6352 Luella Track\nJohnstonview, UT 23487', '147 Jast Curve\nEast Dawson, NH 40710', 'Российская Федерация', '4718557660', '107693331600', '64 cw', '2014-06-20 15:36:59', '2015-10-06 08:15:09');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (64, 'Antonetta', 'Runolfsdottir', 'Мужской', '1954-12-09', '4266 Okuneva Mill Suite 096\nTownebury, MT 12046-8263', '7782 Lela Center\nNew General, IL 23056-3331', 'Армения', '4156724672', '130581968655', '', '2011-01-07 07:57:15', '2019-08-23 04:52:25');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (65, 'Bennett', 'Daugherty', 'Мужской', '1936-12-07', '422 McGlynn Inlet\nWavaland, NY 57018-1662', '69175 Pagac Port Suite 522\nNorth Mortonton, NH 01781-4860', 'Белоруссия', '4255457496', '81243815007', '20 vg', '2013-09-21 17:40:34', '2014-10-15 06:54:51');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (66, 'Judy', 'Schowalter', 'Женский', '1963-10-17', '026 Melissa Branch\nNorth Cali, LA 87898', '615 Lemke Hills Apt. 518\nSouth Noelia, IA 92906', 'Российская Федерация', '4276562189', '791245113109', '31 fu', '2012-05-23 20:40:24', '2019-09-19 02:46:57');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (67, 'Santiago', 'Corkery', 'Мужской', '1994-10-27', '855 Wiza Circle\nEast Reidfurt, TX 89431', '959 Torphy Run Apt. 884\nCasperton, MD 10417', 'иное', '4559575343', '646261292552', '91 bd', '2016-05-12 06:53:52', '2012-08-22 15:24:46');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (68, 'Reynold', 'Marquardt', 'Мужской', '1949-10-03', '3728 Khalid Stravenue Apt. 006\nNorth Zulashire, MD 45837', '7044 Aniya Grove Apt. 878\nFadelberg, TX 00988-4409', 'Армения', '4348294475', '582252883702', '', '2019-01-24 18:43:39', '2014-03-06 15:40:20');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (69, 'Terrance', 'Davis', 'Женский', '1965-11-16', '815 Libbie Highway Suite 501\nWest Peggietown, MT 10565-7912', '2908 Schuster Estate Suite 850\nEast Addie, SD 83597', 'Армения', '4607867467', '766666369746', '', '2019-01-27 01:11:29', '2014-06-25 06:18:29');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (70, 'Marta', 'Heathcote', 'Мужской', '1956-11-26', '589 Stamm Club Apt. 968\nJacemouth, AL 04692', '7097 Genevieve Dam\nLeannemouth, WA 88574-7100', 'Армения', '4765484040', '655994435726', '', '2012-03-26 00:32:31', '2013-07-06 17:31:28');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (71, 'Shanie', 'Dare', 'Мужской', '1983-11-06', '76338 Schowalter Meadows\nNorth Taryn, VT 32274', '33382 Upton Gardens\nPaucekborough, HI 18171-3226', 'Армения', '4537863248', '639683489097', '', '2012-03-10 23:55:52', '2015-09-06 03:15:54');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (72, 'Evie', 'Johnson', 'Женский', '1938-08-03', '1471 Leuschke Neck Apt. 739\nRodrigoland, NM 71692-9343', '1435 Hickle Orchard Suite 214\nEast Jettmouth, AL 01899-8205', 'Казахстан', '4266555915', '389226660756', '48 or', '2016-08-15 08:08:03', '2015-12-29 05:41:34');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (73, 'Kaylie', 'Goodwin', 'Мужской', '1971-08-13', '803 Brain Coves\nPort Elwin, SD 03546', '485 Diana Well\nWest Franco, CT 19612-8800', 'Казахстан', '4794089550', '611969110905', '43 cf', '2016-06-22 19:17:23', '2016-12-30 14:18:33');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (74, 'Hellen', 'Harris', 'Женский', '1974-08-23', '831 America Unions\nEstabury, WA 05597-4430', '75578 Conner Highway\nLancemouth, AZ 41026', 'Армения', '4206713547', '90883346418', '', '2012-02-04 17:01:00', '2011-08-23 02:00:52');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (75, 'Albin', 'Pouros', 'Мужской', '1975-05-25', '0408 McClure Harbor\nHauckbury, MO 64519-3972', '7434 Herman Valley\nPort Daniela, IA 16101', 'Белоруссия', '4396667748', '420063792258', '04 ga', '2014-12-21 18:55:48', '2017-07-29 14:38:39');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (76, 'Vella', 'Gerhold', 'Мужской', '1978-05-27', '84262 Ike Burg\nEricaton, CA 68458', '21998 Bartell Prairie Apt. 492\nWest Kristian, CA 59537', 'Белоруссия', '4163791656', '122583865746', '97 ix', '2016-10-24 03:45:30', '2017-07-26 10:13:56');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (77, 'Eugene', 'Kling', 'Мужской', '1986-01-17', '0926 Hudson Corners Suite 527\nLake Olaview, DC 80239', '874 Ebert Heights\nSandyberg, ID 64618', 'Армения', '4469381188', '93047882793', '04 by', '2012-09-28 07:04:59', '2019-11-20 04:25:55');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (78, 'Birdie', 'Boyle', 'Женский', '1989-01-18', '8636 Courtney Place Apt. 877\nSouth Rubye, NH 14955', '14455 Macey Springs\nEast Omari, NH 28671-4181', 'Казахстан', '4567436615', '138174260645', '', '2016-10-27 20:06:29', '2020-02-22 19:33:27');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (79, 'Santiago', 'Abbott', 'Женский', '1996-01-17', '1709 Eveline Hills\nNorth Wilfredofort, OH 57552', '50536 Torphy Crossroad Suite 611\nGwendolynmouth, KY 52137-1635', 'Армения', '4150162598', '13366036233', '04 tj', '2019-05-22 08:46:40', '2012-02-27 23:16:32');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (80, 'Zaria', 'Gerhold', 'Женский', '2000-02-20', '96950 Humberto Station\nJeraldmouth, MS 14809', '9406 Josiane Shoals Suite 302\nEstebanside, UT 27752-4946', 'Российская Федерация', '4339214859', '506850736584', '', '2016-07-02 06:17:28', '2012-11-13 03:45:15');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (81, 'Braden', 'Prosacco', 'Мужской', '2002-02-19', '3942 Letha Valleys\nJakubowskimouth, TN 18923', '5212 Gilbert Stravenue\nNorth Alexanechester, RI 34069-0674', 'Киргизия', '4898528775', '192307796706', '', '2017-11-01 08:44:02', '2020-06-29 11:17:56');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (82, 'Barton', 'Haley', 'Женский', '2000-02-19', '209 Dibbert Prairie\nRaventon, CO 32710', '43868 Wiegand Extension\nWinstonville, FL 39205-1627', 'Армения', '4452100525', '399188209772', '58 us', '2012-01-10 13:39:04', '2016-04-02 00:40:30');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (83, 'Rhett', 'Ritchie', 'Мужской', '2001-03-19', '162 Romaguera Mountains Apt. 899\nJohathanmouth, FL 74843-8301', '62576 Zulauf Bridge\nNorth Lessiefurt, RI 66732', 'Казахстан', '4911544620', '637651095577', '', '2017-01-11 06:06:26', '2019-04-22 18:50:15');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (84, 'August', 'Ankunding', 'Женский', '2002-06-24', '33175 Collins Gateway\nBeaulahville, MA 00512', '5087 Shanahan Vista Apt. 197\nKohlerville, ID 40689', 'Армения', '4802995932', '792644172022', '', '2020-04-22 03:25:37', '2019-10-14 15:17:40');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (85, 'Ona', 'Legros', 'Мужской', '1974-09-24', '2949 Stevie Burg Apt. 733\nLowefurt, HI 73721-3924', '05017 Raynor Parks Suite 078\nNorth Eryn, CT 14832-6337', 'Российская Федерация', '4271694433', '69972440553', '', '2011-03-04 10:22:22', '2020-08-29 18:20:54');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (86, 'Mireille', 'Orn', 'Мужской', '2002-07-25', '3955 Lenny Junctions\nKobeland, IA 81654-2306', '803 Kamron Divide\nNorth Mayeville, NE 34920-8509', 'Казахстан', '4756617956', '394278209777', '43 nz', '2018-02-26 02:17:44', '2011-05-02 06:29:28');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (87, 'Easter', 'Langosh', 'Мужской', '1991-08-25', '508 Halvorson Canyon Apt. 984\nIsabellachester, RI 90604', '40253 Schinner Mill\nLake Kalliestad, GA 83467', 'Российская Федерация', '4903724304', '643976241551', '27 yc', '2019-04-15 08:35:35', '2012-03-05 14:22:15');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (88, 'Elouise', 'Macejkovic', 'Женский', '1992-07-14', '5062 Triston Track\nSammouth, DC 97862-7883', '605 O\'Kon Square\nNew Eusebio, RI 12572', 'Армения', '4310071248', '460269880923', '85 zi', '2018-07-31 08:15:33', '2018-09-19 07:02:22');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (89, 'Cali', 'Hackett', 'Мужской', '1993-04-10', '90774 Clotilde Mountains\nSouth Gillianstad, AL 81269', '233 Estefania Burg\nNorth Savannahbury, FL 72605', 'Белоруссия', '4172142829', '903399189129', '43 sb', '2014-02-05 19:55:09', '2010-12-22 17:31:39');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (90, 'Unique', 'Wolff', 'Женский', '1993-04-04', '1990 Weissnat Motorway Apt. 429\nEast Valerie, AR 66182-5366', '770 Blick Path Suite 264\nSouth Cortez, CO 65589', 'Российская Федерация', '4679639219', '570010812678', '28 kk', '2013-11-05 15:25:53', '2019-04-25 01:44:15');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (91, 'Shaina', 'Roob', 'Женский', '1996-04-08', '464 Upton Stream\nNorth Ophelia, SC 72591', '37756 VonRueden Valley\nKingfurt, RI 63746', 'Российская Федерация', '4784881890', '277350776596', '01 bv', '2013-10-31 09:33:34', '2012-05-10 21:25:37');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (92, 'Unique', 'Labadie', 'Мужской', '1987-11-07', '89350 Muller Inlet\nMaximilliaberg, MI 93076-7471', '44256 Elissa Place Apt. 953\nGarthbury, ID 18531', 'Армения', '4104584409', '772904216312', '', '2016-08-24 15:19:42', '2018-09-01 21:30:26');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (93, 'Lea', 'Ledner', 'Женский', '1987-10-12', '3492 Kreiger Station Apt. 689\nMannport, AZ 40896', '5510 Feest Plaza\nLake Krista, WI 16702-7884', 'Российская Федерация', '4372954176', '530844454174', '', '2017-07-01 07:05:16', '2013-09-03 22:57:53');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (94, 'Candelario', 'Veum', 'Мужской', '1989-10-05', '71398 Amira Heights Suite 989\nSouth Rachel, OR 75776-2029', '42246 Bednar Shore\nEast Orie, NE 08489', 'Белоруссия', '4969513290', '727085420364', '30 au', '2014-05-14 22:58:35', '2019-07-09 14:09:58');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (95, 'Boyd', 'Bergstrom', 'Мужской', '1969-12-17', '240 Andy Motorway Suite 251\nPort Rosariobury, OR 92401-6698', '08918 Kiana Shoal\nNorth Jamil, WA 44619', 'Российская Федерация', '4242155943', '331644125334', '08 pm', '2014-05-27 21:11:13', '2020-06-26 23:02:15');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (96, 'Nathan', 'Murphy', 'Мужской', '1996-12-24', '414 Bednar Point\nJimmiestad, VT 20774-0588', '98952 Botsford Square Apt. 404\nJayceechester, WA 25331', 'Киргизия', '4409008806', '490509440326', '82 ce', '2020-03-30 07:57:06', '2019-09-08 09:38:10');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (97, 'Jeremie', 'Marquardt', 'Женский', '1975-05-23', '338 Thiel Roads\nWest Zetta, NY 04684-6155', '06065 Gutmann Port\nTheamouth, NH 24176-5308', 'иное', '4803702440', '448830209617', '54 uk', '2016-12-05 00:51:09', '2018-07-12 08:40:06');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (98, 'Rosario', 'Roberts', 'Мужской', '1990-05-03', '91976 Lebsack Trace Apt. 072\nThompsonmouth, AR 33926', '962 Hilll Stream\nNorth Emerson, ID 65682', 'иное', '4660336380', '729618382021', '', '2014-04-27 08:12:03', '2019-08-24 15:47:59');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (99, 'Kaycee', 'Harris', 'Мужской', '1950-04-07', '430 Jeffrey Motorway Suite 994\nEast Keiramouth, SC 49575-2956', '11152 Cleora Turnpike\nNew Jennings, RI 82591', 'Белоруссия', '4187329976', '253615565030', '04 hx', '2017-07-13 12:32:00', '2012-04-20 05:53:49');
INSERT INTO `profiles` (`user_id`, `first_name`, `last_name`, `gender`, `birthday`, `address_of_registration`, `address_actual`, `citizenship`, `passport_number`, `tax_number`, `car_number`, `created_at`, `updated_at`) VALUES (100, 'Kaycee', 'Harris', 'Мужской', '1950-04-07', '430 Jeffrey Motorway Suite 994\nEast Keiramouth, SC 49575-2956', '11152 Cleora Turnpike\nNew Jennings, RI 82591', 'Белоруссия', '4187325976', '250615565030', '04 zx', '2017-07-13 12:32:00', '2012-04-20 05:53:49');

SELECT * FROM profiles;

UPDATE profiles SET updated_at = NOW() WHERE updated_at < created_at;


