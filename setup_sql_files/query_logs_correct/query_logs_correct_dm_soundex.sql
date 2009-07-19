-- MySQL dump 10.11
--
-- Host: localhost    Database: dm_soundex
-- ------------------------------------------------------
-- Server version	5.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `query_logs_correct_dm_soundex`
--

DROP TABLE IF EXISTS `query_logs_correct_dm_soundex`;
CREATE TABLE `query_logs_correct_dm_soundex` (
  `query` varchar(200) NOT NULL,
  `dm_soundex` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `query_logs_correct_dm_soundex`
--

LOCK TABLES `query_logs_correct_dm_soundex` WRITE;
/*!40000 ALTER TABLE `query_logs_correct_dm_soundex` DISABLE KEYS */;
INSERT INTO `query_logs_correct_dm_soundex` VALUES ('ruzomberok','946795'),('mnisek nad popradom','664500'),('gnazda','564300'),('piarg','795000'),('prasice','794500 794400'),('batovce','737500 737400'),('svaty kriz nad hronom','473000'),('varin','796000'),('dolny kubin','386000'),('modry kamen','639000'),('solosnica','484650 484640'),('udavske','037450'),('nadas','634000'),('plavnica','787650 787640'),('horne byhymcine','596000'),('sielnica','486500 486400'),('lubenik','876500'),('zakopcie','457500 457400'),('bogdanovce','753675 753674'),('myto pod dumbierom','630000'),('tura luka','390000'),('horne obdiekovce','596000'),('lom nad hronom','860000'),('kozarovce','549750 549740'),('medzilaborce','648795 648794'),('snina','466000'),('dezerice','349500 349400'),('gocovo','557000 547000'),('havaj','570000'),('okruhle','059800'),('selce','485000 484000'),('nemce','665000 664000'),('pohorela','759800'),('svaty ondrej nad hronom','473000'),('dovalovo','378700'),('handlova','563870'),('rakova','957000'),('malacky','685000 684500'),('busevce','747500 747400'),('priekopa','795700'),('modranka','639650'),('parnica','796500 796400'),('secovce','457500 447500 457400 447400'),('sered','493000'),('boleraz','789400'),('banka','765000'),('brezno nad hronom','794600'),('maly lipnik','680000');
/*!40000 ALTER TABLE `query_logs_correct_dm_soundex` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-07-19  1:23:30
