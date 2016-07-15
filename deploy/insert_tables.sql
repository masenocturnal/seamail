-- MySQL dump 10.15  Distrib 10.0.10-MariaDB, for debian-linux-gnu (x86_64)

-- Deploy insert_tables

BEGIN;
CREATE DATABASE mailtest;
use mailtest;


-- Table structure for table `expires`
--

DROP TABLE IF EXISTS `expires`;
CREATE TABLE `expires` (
  `username` varchar(255) NOT NULL,
  `mailbox` varchar(255) NOT NULL,
  `expire_stamp` int(11) NOT NULL,
  PRIMARY KEY (`username`,`mailbox`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `quota`
--

DROP TABLE IF EXISTS `quota`;
CREATE TABLE `quota` (
  `username` varchar(255) NOT NULL,
  `bytes` bigint(20) NOT NULL DEFAULT '0',
  `messages` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Table structure for table `virtual_alias`
--

DROP TABLE IF EXISTS virtual_alias;
CREATE TABLE `virtual_alias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias_name` varchar(128) NOT NULL DEFAULT '',
  `destination` varchar(128) NOT NULL DEFAULT '',
  `domain_id` int(11) NOT NULL REFERENCES virtual_domains(id) ON DELETE CASCADE on UPDATE cascade,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  CONSTRAINT UNIQUE (alias_name,domain_id)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `virtual_alias`
--

LOCK TABLES `virtual_alias` WRITE;
/*!40000 ALTER TABLE `virtual_alias` DISABLE KEYS */;
INSERT INTO `virtual_alias` VALUES (1,'foo','test.user2@example.com',1,'2013-09-10 14:55:55','2013-09-10 14:55:55');
/*!40000 ALTER TABLE `virtual_alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `virtual_domains`
--

DROP TABLE IF EXISTS `virtual_domains`;
CREATE TABLE `virtual_domains` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `domain_name` text NOT NULL,
  `max_users` int(4) DEFAULT '10',
  `create_date` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` enum('y','n') DEFAULT 'n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


LOCK TABLES `virtual_domains` WRITE;
INSERT INTO `virtual_domains` VALUES (1,'example.com',0,'2013-09-09 22:51:17','2013-09-09 22:51:17','y');
UNLOCK TABLES;

--
-- Table structure for table `virtual_user_quota`
--

DROP TABLE IF EXISTS `virtual_user_quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_user_quota` (
  `username` varchar(255) NOT NULL,
  `path` varchar(100) NOT NULL,
  `current` int(11) DEFAULT NULL,
  PRIMARY KEY (`username`,`path`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_user_quota`
--

LOCK TABLES `virtual_user_quota` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `virtual_users`
--

DROP TABLE IF EXISTS `virtual_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `home_dir` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` enum('y','n') NOT NULL DEFAULT 'n',
  `username` varchar(255) NOT NULL,
  `password_hash` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `domain_id` int(11) NOT NULL,
  `quota` int(11) DEFAULT '0',
  `quota_size` int(24) DEFAULT '20480' COMMENT '20MB default',
  `quota_messages` int(24) DEFAULT '81920' COMMENT 'No of emails ',
  `hash_salt` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `uid` int(4) NOT NULL DEFAULT '8001',
  `gid` int(4) NOT NULL DEFAULT '8001',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`,`domain_id`),
  UNIQUE KEY `username_2` (`username`,`domain_id`),
  KEY `domain_id` (`domain_id`),
  CONSTRAINT `virtual_users_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `virtual_domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_users`
--

LOCK TABLES `virtual_users` WRITE;

INSERT INTO `virtual_users` VALUES
(
 1,
 concat(
  '/',
  substring(
    SHA('test.user@example.com')
    ,1
    ,2
  ),
  '/',
  substring(
    SHA('test.user@example.com'),
    3
  )
 ),'2013-09-09 13:55:57','2013-09-09 13:55:57','y','test.user',
 ENCRYPT(
   'test',
   concat('$6$',substring(rand(),0, 512))
 ),1,0,1,12,'U',8001,1001);


INSERT INTO `virtual_users` VALUES
(
 2,
 concat(
  '/',
  substring(
    SHA('test.user2@example.com')
    ,1
    ,2
  ),
  '/',
  substring(
    SHA('test.user2@example.com'),
    3
  )
 ),'2013-09-09 13:55:57','2013-09-09 13:55:57','y','test.user2',
 ENCRYPT(
   'test',
   concat('$6$',substring(rand(),0, 512))
 ),1,0,1,12,'U',8002,1001);



UNLOCK TABLES;

-- Dump completed on 2015-04-06 14:48:54
COMMIT;
