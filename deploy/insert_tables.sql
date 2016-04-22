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
-- Dumping data for table `expires`
--

LOCK TABLES `expires` WRITE;
/*!40000 ALTER TABLE `expires` DISABLE KEYS */;
/*!40000 ALTER TABLE `expires` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quota`
--

DROP TABLE IF EXISTS `quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quota` (
  `username` varchar(255) NOT NULL,
  `bytes` bigint(20) NOT NULL DEFAULT '0',
  `messages` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quota`
--

LOCK TABLES `quota` WRITE;
/*!40000 ALTER TABLE `quota` DISABLE KEYS */;
INSERT INTO `quota` VALUES ('root',0,0),('test.user2@example.com',0,0),('test.user@example.com',73916,107);
/*!40000 ALTER TABLE `quota` ENABLE KEYS */;
UNLOCK TABLES;

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
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_domains` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `domain_name` text NOT NULL,
  `max_users` int(4) DEFAULT '10',
  `create_date` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` enum('y','n') DEFAULT 'n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_domains`
--

LOCK TABLES `virtual_domains` WRITE;
/*!40000 ALTER TABLE `virtual_domains` DISABLE KEYS */;
INSERT INTO `virtual_domains` VALUES (1,'example.com',0,'2013-09-09 22:51:17','2013-09-09 22:51:17','y');
/*!40000 ALTER TABLE `virtual_domains` ENABLE KEYS */;
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
/*!40000 ALTER TABLE `virtual_user_quota` DISABLE KEYS */;
/*!40000 ALTER TABLE `virtual_user_quota` ENABLE KEYS */;
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
/*!40000 ALTER TABLE `virtual_users` DISABLE KEYS */;
INSERT INTO `virtual_users` VALUES (1,'var/mail/virtual/e6e989e7/bf7b/4422/8c81/8c373111259b/','2013-09-09 13:55:57','2013-09-09 13:55:57','y','test.user','05e18ec9b281ce722988245a164e0cbcf7fafb1855c1ee251715c7ef1adc3898293b226bfb6b810b93230e4d8d0224240a58a2b7b486a2f11602820e661ca42d',1,0,1,12,'BnvWwJ6q80EZhuerM8rOXoCRJUROuL+bXN+fcQnyL4fKUlmV75dLsm6if/h2SHVasHcgamPzZoAn5HsLoBOdfF30wKFTjVVBoYjTVHpI/pBK8Znzg7OsJbHx9XPW5me2A6/1XJgbmqsy7jMaUbdwtu5pNwll+97tnra5ig2PU00QALWgjm6fIdlIwIEsMuhFcDVPgOoVUiRRlZF75ufK0wJjAbZqLrEyM8OzHcdaEEayxij/HbLH4ZeSqT5L15dRstqVrgaoPkHjwdI4w91f1PNWGF+2EPKzDiQY5jXZQ3wa76YQdnemy5zCre6Wq0hLFdR1LKOr5hQK3NJHgm35McM2f6Sh28M/o/ip0NN96dR+HAch1LSp/kuWdmEi5HLZ+hrxFEvX2AYoISVTJ8sBaT8+FT4hjOn8j3tdAKtbxygow3tnS/aBLazYwFwHoPZj3c10NnkwBsaeg0Gt6AOWlEdUnf9E9lLqT3JcfMYXX8yJFkqHHY6DvhnBYQBqVMQGFWXd2a0YmnR6OhYPv14PDh6d/k1P5PiQydmu+7Lk+XN7qsH9FhZy7S1enKcAGpGhyVuLwZi2wa4aitJTXDEZ9Ci3HTpwdRjupMDb+VuotJdWCfen33aWyOs/ShI7ngNlqp6brUxzf/FgFcdb//bg6oXm5B21726BY7wYMwkJMsU',8001,1001),(2,'var/mail/virtual/acfd1bd5/4c62/4506/94c6/e4e8441ec063/','2013-09-10 14:38:50','2013-09-10 14:38:50','y','test.user2','40f0206fbc8f3a1855b93d59e62aa9e545502de8d7fb0ae338ab1ed2a46d4b76949136d3cc8179059675b7c8b5655648cf71938e8cc2505f5f40b41a4bbee9e2',1,0,1,12,'9nuS+gSvmlxNZJC19imYz2fJb3jUs/jEwPq/CuHGrMPd1pmcGYdWNgPvZChl/Kbov6x5r/97q6HXaBjYj8ONp6e4wdBr0unxsq7LBU6xkXsAhZ/HiHZ0T5oKAJj9SEOpY1JqoELLqDEXZXBjZ4YCOPkUkFuQOLaTpac8NFmo8u184uEEubMwCFShvzqJUgGrwwV96YlWxnSdLfsZ59ozUaEaSNxaY58+SpIXC9SPTJN6z2AW/qJT61HNEsJKFPBmvT2xs1Q4TCkh0YwbZkAqUXOwY1p0Lj7OM5wOCUJZa7CpLPxqH30gBVZDwFMNRtvfBeMfeQD6270O12XmJ7SyiArqDDw2x+5wSABywGI35GIoAyS3/6N5Wl6Ew5UlcIaEyVkmib292RPqeNuFVWoZcuFAgLJm+A7bgT4OtxOt0lsePazKoLuu97duMue2UT8su1rfIcYHeR1YFKClyKcQvueTWuRWaAfbZe6EbJiGvOuYrvcbrN+JS9chICqb+BNZHj8+xKK6/9A0FM2C35+xALrePiRocfJQCfdi/m9Or+h9uRMtyyYMYeQ5/tv832nq1nKtcrKPCsBW4ySf2UjKyZn8GxXyIv2GMY0uJt2ZORRBhwiFhlvXkJ/QTPRe99Y1YSqGSeUggBVkzYZHX50R4ctZ17CWDuJnyQxhtALd7k8',8001,1001);
/*!40000 ALTER TABLE `virtual_users` ENABLE KEYS */;
UNLOCK TABLES;

-- Dump completed on 2015-04-06 14:48:54
COMMIT;
