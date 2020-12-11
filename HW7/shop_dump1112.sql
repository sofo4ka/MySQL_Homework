-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: shop
-- ------------------------------------------------------
-- Server version	8.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Ibex','Capra ibex'),(2,'Ox, musk','Ovibos moschatus'),(3,'Turtle (unidentified)','unavailable'),(4,'Gonolek, burchell\'s','Laniaurius atrococcineus'),(5,'Phascogale, red-tailed','Phascogale calura'),(6,'Goose, greylag','Anser anser'),(7,'Fox, savanna','Dusicyon thous'),(8,'Lion, mountain','Felis concolor'),(9,'Crowned hawk-eagle','Spizaetus coronatus'),(10,'Bird, bare-faced go away','Lorythaixoides concolor'),(11,'Eurasian red squirrel','Sciurus vulgaris'),(12,'Ibis, puna','Plegadis ridgwayi'),(13,'Burmese brown mountain tortoise','Manouria emys'),(14,'Common zorro','Dusicyon thous'),(15,'Dabchick','Tachybaptus ruficollis'),(16,'Ibex','Capra ibex'),(17,'Moose','Alces alces'),(18,'Alpaca','Lama pacos'),(19,'Arctic hare','Lepus arcticus'),(20,'Three-banded plover','Charadrius tricollaris'),(21,'Marshbird, brown and yellow','Pseudoleistes virescens'),(22,'Tyrant flycatcher','Myiarchus tuberculifer');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `categories_id` int NOT NULL,
  PRIMARY KEY (`id`,`categories_id`),
  KEY `fk_goods_categories_idx` (`categories_id`),
  CONSTRAINT `fk_goods_categories` FOREIGN KEY (`categories_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES (1,'dfghj','lalalalala',8,100500.00,13);
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `goodswithcategories`
--

DROP TABLE IF EXISTS `goodswithcategories`;
/*!50001 DROP VIEW IF EXISTS `goodswithcategories`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `goodswithcategories` AS SELECT 
 1 AS `id`,
 1 AS `name`,
 1 AS `description`,
 1 AS `categories_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL,
  `data` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_has_goods`
--

DROP TABLE IF EXISTS `orders_has_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_has_goods` (
  `orders_id` int NOT NULL,
  `goods_id` int NOT NULL,
  `goods_categories_id` int NOT NULL,
  PRIMARY KEY (`orders_id`,`goods_id`,`goods_categories_id`),
  KEY `fk_orders_has_goods_goods1_idx` (`goods_id`,`goods_categories_id`),
  KEY `fk_orders_has_goods_orders1_idx` (`orders_id`),
  CONSTRAINT `fk_orders_has_goods_goods1` FOREIGN KEY (`goods_id`, `goods_categories_id`) REFERENCES `goods` (`id`, `categories_id`),
  CONSTRAINT `fk_orders_has_goods_orders1` FOREIGN KEY (`orders_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_has_goods`
--

LOCK TABLES `orders_has_goods` WRITE;
/*!40000 ALTER TABLE `orders_has_goods` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders_has_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `goodswithcategories`
--

/*!50001 DROP VIEW IF EXISTS `goodswithcategories`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `goodswithcategories` (`id`,`name`,`description`,`categories_name`) AS select `g`.`id` AS `id`,`g`.`name` AS `name`,`g`.`description` AS `description`,`c`.`name` AS `categories_id` from (`goods` `g` left join `categories` `c` on((`g`.`categories_id` = `c`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-12-11 20:15:44
