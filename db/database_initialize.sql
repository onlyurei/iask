drop database if exists iask_development;
create database iask_development;
drop database if exists iask_test;
create database iask_test;
drop database if exists iask_production;
create database iask_production;
GRANT ALL PRIVILEGES ON iask_development.* TO 'iask'@'localhost'
  IDENTIFIED BY '123456' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON iask_test.* TO 'iask'@'localhost'
  IDENTIFIED BY '123456' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON iask_production.* TO 'iask'@'localhost'
  IDENTIFIED BY '123456' WITH GRANT OPTION;




/*
SQLyog Community Edition- MySQL GUI v6.16
MySQL - 5.0.45-community-nt : Database - iask_development
*********************************************************************
*/
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

USE `iask_development`;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `courses` */

DROP TABLE IF EXISTS `courses`;

CREATE TABLE `courses` (
  `id` int(11) NOT NULL auto_increment,
  `official_id` varchar(255) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `courses` */

/*Table structure for table `courses_users` */

DROP TABLE IF EXISTS `courses_users`;

CREATE TABLE `courses_users` (
  `course_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  KEY `index_courses_users_on_course_id_and_user_id` (`course_id`,`user_id`),
  KEY `index_courses_users_on_course_id` (`course_id`),
  KEY `index_courses_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `courses_users` */

/*Table structure for table `entries` */

DROP TABLE IF EXISTS `entries`;

CREATE TABLE `entries` (
  `id` int(11) NOT NULL auto_increment,
  `course_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `question` varchar(255) NOT NULL default '',
  `answer` text NOT NULL,
  `notes` text,
  `user_official_id` varchar(255) NOT NULL default '',
  `user_last_name` varchar(255) NOT NULL default '',
  `user_first_name` varchar(255) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `entries` */

/*Table structure for table `keywords` */

DROP TABLE IF EXISTS `keywords`;

CREATE TABLE `keywords` (
  `id` int(11) NOT NULL auto_increment,
  `value` varchar(100) NOT NULL default '',
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `keywords` */

/*Table structure for table `notes` */

DROP TABLE IF EXISTS `notes`;

CREATE TABLE `notes` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `content` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `notes` */

/*Table structure for table `queries` */

DROP TABLE IF EXISTS `queries`;

CREATE TABLE `queries` (
  `id` int(11) NOT NULL auto_increment,
  `course_id` int(11) NOT NULL default '0',
  `student_id` int(11) NOT NULL default '0',
  `teacher_id` int(11) NOT NULL default '0',
  `question` varchar(255) NOT NULL default '',
  `answer` text,
  `solved` tinyint(1) NOT NULL default '0',
  `notes` text,
  `course_official_id` varchar(255) NOT NULL default '',
  `course_name` varchar(255) NOT NULL default '',
  `student_official_id` varchar(255) NOT NULL default '',
  `student_last_name` varchar(255) NOT NULL default '',
  `student_first_name` varchar(255) NOT NULL default '',
  `teacher_official_id` varchar(255) NOT NULL default '',
  `teacher_last_name` varchar(255) NOT NULL default '',
  `teacher_first_name` varchar(255) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_queries_on_course_id_and_student_id` (`course_id`,`student_id`),
  KEY `index_queries_on_course_id_and_teacher_id` (`course_id`,`teacher_id`),
  KEY `index_queries_on_course_id` (`course_id`),
  KEY `index_queries_on_student_id` (`student_id`),
  KEY `index_queries_on_teacher_id` (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `queries` */

/*Table structure for table `relevances` */

DROP TABLE IF EXISTS `relevances`;

CREATE TABLE `relevances` (
  `id` int(11) NOT NULL auto_increment,
  `entry_id` int(11) NOT NULL default '0',
  `keyword_id` int(11) NOT NULL default '0',
  `value` int(11) NOT NULL default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_relevances_on_entry_id_and_keyword_id` (`entry_id`,`keyword_id`),
  KEY `index_relevances_on_entry_id` (`entry_id`),
  KEY `index_relevances_on_keyword_id` (`keyword_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `relevances` */

/*Table structure for table `schema_info` */

DROP TABLE IF EXISTS `schema_info`;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `schema_info` */

insert  into `schema_info`(`version`) values (8);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `official_id` varchar(255) NOT NULL default '',
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `last_name` varchar(80) default NULL,
  `first_name` varchar(80) default NULL,
  `is_admin` tinyint(1) NOT NULL default '0',
  `is_teacher` tinyint(1) NOT NULL default '0',
  `entries_sum` int(11) NOT NULL default '0',
  `comment` text,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `users` */

insert  into `users`(`id`,`official_id`,`login`,`email`,`last_name`,`first_name`,`is_admin`,`is_teacher`,`entries_sum`,`comment`,`crypted_password`,`salt`,`created_at`,`updated_at`,`remember_token`,`remember_token_expires_at`) values (11341,'000000','administrator','admin@iask.com',NULL,NULL,1,0,0,NULL,'1dd4a8ec9f8a8a27f19de60313eba743e8bae69a','6f21194112d20f4f3f22ceeda395382b9e003dc9','2008-05-23 14:33:17','2008-05-23 14:33:18',NULL,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;




/*
SQLyog Community Edition- MySQL GUI v6.16
MySQL - 5.0.45-community-nt : Database - iask_test
*********************************************************************
*/
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

USE `iask_test`;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `courses` */

DROP TABLE IF EXISTS `courses`;

CREATE TABLE `courses` (
  `id` int(11) NOT NULL auto_increment,
  `official_id` varchar(255) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `courses` */

/*Table structure for table `courses_users` */

DROP TABLE IF EXISTS `courses_users`;

CREATE TABLE `courses_users` (
  `course_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  KEY `index_courses_users_on_course_id_and_user_id` (`course_id`,`user_id`),
  KEY `index_courses_users_on_course_id` (`course_id`),
  KEY `index_courses_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `courses_users` */

/*Table structure for table `entries` */

DROP TABLE IF EXISTS `entries`;

CREATE TABLE `entries` (
  `id` int(11) NOT NULL auto_increment,
  `course_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `question` varchar(255) NOT NULL default '',
  `answer` text NOT NULL,
  `notes` text,
  `user_official_id` varchar(255) NOT NULL default '',
  `user_last_name` varchar(255) NOT NULL default '',
  `user_first_name` varchar(255) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `entries` */

/*Table structure for table `keywords` */

DROP TABLE IF EXISTS `keywords`;

CREATE TABLE `keywords` (
  `id` int(11) NOT NULL auto_increment,
  `value` varchar(100) NOT NULL default '',
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `keywords` */

/*Table structure for table `notes` */

DROP TABLE IF EXISTS `notes`;

CREATE TABLE `notes` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `content` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `notes` */

/*Table structure for table `queries` */

DROP TABLE IF EXISTS `queries`;

CREATE TABLE `queries` (
  `id` int(11) NOT NULL auto_increment,
  `course_id` int(11) NOT NULL default '0',
  `student_id` int(11) NOT NULL default '0',
  `teacher_id` int(11) NOT NULL default '0',
  `question` varchar(255) NOT NULL default '',
  `answer` text,
  `solved` tinyint(1) NOT NULL default '0',
  `notes` text,
  `course_official_id` varchar(255) NOT NULL default '',
  `course_name` varchar(255) NOT NULL default '',
  `student_official_id` varchar(255) NOT NULL default '',
  `student_last_name` varchar(255) NOT NULL default '',
  `student_first_name` varchar(255) NOT NULL default '',
  `teacher_official_id` varchar(255) NOT NULL default '',
  `teacher_last_name` varchar(255) NOT NULL default '',
  `teacher_first_name` varchar(255) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_queries_on_course_id_and_student_id` (`course_id`,`student_id`),
  KEY `index_queries_on_course_id_and_teacher_id` (`course_id`,`teacher_id`),
  KEY `index_queries_on_course_id` (`course_id`),
  KEY `index_queries_on_student_id` (`student_id`),
  KEY `index_queries_on_teacher_id` (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `queries` */

/*Table structure for table `relevances` */

DROP TABLE IF EXISTS `relevances`;

CREATE TABLE `relevances` (
  `id` int(11) NOT NULL auto_increment,
  `entry_id` int(11) NOT NULL default '0',
  `keyword_id` int(11) NOT NULL default '0',
  `value` int(11) NOT NULL default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_relevances_on_entry_id_and_keyword_id` (`entry_id`,`keyword_id`),
  KEY `index_relevances_on_entry_id` (`entry_id`),
  KEY `index_relevances_on_keyword_id` (`keyword_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `relevances` */

/*Table structure for table `schema_info` */

DROP TABLE IF EXISTS `schema_info`;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `schema_info` */

insert  into `schema_info`(`version`) values (8);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `official_id` varchar(255) NOT NULL default '',
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `last_name` varchar(80) default NULL,
  `first_name` varchar(80) default NULL,
  `is_admin` tinyint(1) NOT NULL default '0',
  `is_teacher` tinyint(1) NOT NULL default '0',
  `entries_sum` int(11) NOT NULL default '0',
  `comment` text,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `users` */

insert  into `users`(`id`,`official_id`,`login`,`email`,`last_name`,`first_name`,`is_admin`,`is_teacher`,`entries_sum`,`comment`,`crypted_password`,`salt`,`created_at`,`updated_at`,`remember_token`,`remember_token_expires_at`) values (9831,'000000','administrator','admin@iask.com',NULL,NULL,1,0,0,NULL,'58219f5d4a500c6d76db6bbff25b94e006d260b6','73bdb6f264153aefa533dc8a18d5b11036a7a519','2008-05-23 13:59:38','2008-05-23 13:59:38',NULL,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;




/*
SQLyog Community Edition- MySQL GUI v6.16
MySQL - 5.0.45-community-nt : Database - iask_production
*********************************************************************
*/
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

USE `iask_production`;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `courses` */

DROP TABLE IF EXISTS `courses`;

CREATE TABLE `courses` (
  `id` int(11) NOT NULL auto_increment,
  `official_id` varchar(255) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `courses` */

/*Table structure for table `courses_users` */

DROP TABLE IF EXISTS `courses_users`;

CREATE TABLE `courses_users` (
  `course_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  KEY `index_courses_users_on_course_id_and_user_id` (`course_id`,`user_id`),
  KEY `index_courses_users_on_course_id` (`course_id`),
  KEY `index_courses_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `courses_users` */

/*Table structure for table `entries` */

DROP TABLE IF EXISTS `entries`;

CREATE TABLE `entries` (
  `id` int(11) NOT NULL auto_increment,
  `course_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `question` varchar(255) NOT NULL default '',
  `answer` text NOT NULL,
  `notes` text,
  `user_official_id` varchar(255) NOT NULL default '',
  `user_last_name` varchar(255) NOT NULL default '',
  `user_first_name` varchar(255) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `entries` */

/*Table structure for table `keywords` */

DROP TABLE IF EXISTS `keywords`;

CREATE TABLE `keywords` (
  `id` int(11) NOT NULL auto_increment,
  `value` varchar(100) NOT NULL default '',
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `keywords` */

/*Table structure for table `notes` */

DROP TABLE IF EXISTS `notes`;

CREATE TABLE `notes` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `content` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `notes` */

/*Table structure for table `queries` */

DROP TABLE IF EXISTS `queries`;

CREATE TABLE `queries` (
  `id` int(11) NOT NULL auto_increment,
  `course_id` int(11) NOT NULL default '0',
  `student_id` int(11) NOT NULL default '0',
  `teacher_id` int(11) NOT NULL default '0',
  `question` varchar(255) NOT NULL default '',
  `answer` text,
  `solved` tinyint(1) NOT NULL default '0',
  `notes` text,
  `course_official_id` varchar(255) NOT NULL default '',
  `course_name` varchar(255) NOT NULL default '',
  `student_official_id` varchar(255) NOT NULL default '',
  `student_last_name` varchar(255) NOT NULL default '',
  `student_first_name` varchar(255) NOT NULL default '',
  `teacher_official_id` varchar(255) NOT NULL default '',
  `teacher_last_name` varchar(255) NOT NULL default '',
  `teacher_first_name` varchar(255) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_queries_on_course_id_and_student_id` (`course_id`,`student_id`),
  KEY `index_queries_on_course_id_and_teacher_id` (`course_id`,`teacher_id`),
  KEY `index_queries_on_course_id` (`course_id`),
  KEY `index_queries_on_student_id` (`student_id`),
  KEY `index_queries_on_teacher_id` (`teacher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `queries` */

/*Table structure for table `relevances` */

DROP TABLE IF EXISTS `relevances`;

CREATE TABLE `relevances` (
  `id` int(11) NOT NULL auto_increment,
  `entry_id` int(11) NOT NULL default '0',
  `keyword_id` int(11) NOT NULL default '0',
  `value` int(11) NOT NULL default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_relevances_on_entry_id_and_keyword_id` (`entry_id`,`keyword_id`),
  KEY `index_relevances_on_entry_id` (`entry_id`),
  KEY `index_relevances_on_keyword_id` (`keyword_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `relevances` */

/*Table structure for table `schema_info` */

DROP TABLE IF EXISTS `schema_info`;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `schema_info` */

insert  into `schema_info`(`version`) values (8);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `official_id` varchar(255) NOT NULL default '',
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `last_name` varchar(80) default NULL,
  `first_name` varchar(80) default NULL,
  `is_admin` tinyint(1) NOT NULL default '0',
  `is_teacher` tinyint(1) NOT NULL default '0',
  `entries_sum` int(11) NOT NULL default '0',
  `comment` text,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `users` */

insert  into `users`(`id`,`official_id`,`login`,`email`,`last_name`,`first_name`,`is_admin`,`is_teacher`,`entries_sum`,`comment`,`crypted_password`,`salt`,`created_at`,`updated_at`,`remember_token`,`remember_token_expires_at`) values (12681,'000000','administrator','admin@iask.com',NULL,NULL,1,0,0,NULL,'58219f5d4a500c6d76db6bbff25b94e006d260b6','73bdb6f264153aefa533dc8a18d5b11036a7a519','2008-05-23 13:59:38','2008-05-23 13:59:38',NULL,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
