-- MySQL dump 10.13  Distrib 8.0.26, for Linux (x86_64)
--
-- Host: localhost    Database: AziendaFerroviaria
-- ------------------------------------------------------
-- Server version	8.0.26-0ubuntu0.21.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Attivita_Manutenzione`
--

DROP TABLE IF EXISTS `Attivita_Manutenzione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Attivita_Manutenzione` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Data` date NOT NULL,
  `Info` varchar(500) NOT NULL,
  `Materiale_Rotabile_ID` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Attivita_Manutenzione_Materiale_Rotabile1_idx` (`Materiale_Rotabile_ID`),
  CONSTRAINT `fk_Attivita_Manutenzione_Materiale_Rotabile1` FOREIGN KEY (`Materiale_Rotabile_ID`) REFERENCES `Materiale_Rotabile` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Attivita_Manutenzione`
--

LOCK TABLES `Attivita_Manutenzione` WRITE;
/*!40000 ALTER TABLE `Attivita_Manutenzione` DISABLE KEYS */;
INSERT INTO `Attivita_Manutenzione` VALUES (1,'2021-08-22','Sostituzione luci esterne',10001),(2,'2021-08-22','Sostituzione finestrino passeggero al posto A01',10002);
/*!40000 ALTER TABLE `Attivita_Manutenzione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Azienda`
--

DROP TABLE IF EXISTS `Azienda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Azienda` (
  `PIVA` varchar(11) NOT NULL,
  `Nome` varchar(45) NOT NULL,
  PRIMARY KEY (`PIVA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Azienda`
--

LOCK TABLES `Azienda` WRITE;
/*!40000 ALTER TABLE `Azienda` DISABLE KEYS */;
INSERT INTO `Azienda` VALUES ('0001','ALFA'),('0002','GAMMA'),('0003','DELTA'),('0004','YORK'),('0005','BETA'),('spl','spilloinc');
/*!40000 ALTER TABLE `Azienda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Citta`
--

DROP TABLE IF EXISTS `Citta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Citta` (
  `Nome` varchar(45) NOT NULL,
  `Provincia_Sigla` varchar(2) NOT NULL,
  PRIMARY KEY (`Nome`,`Provincia_Sigla`),
  KEY `fk_Citta_Provincia1_idx` (`Provincia_Sigla`),
  CONSTRAINT `fk_Citta_Provincia1` FOREIGN KEY (`Provincia_Sigla`) REFERENCES `Provincia` (`Sigla`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Citta`
--

LOCK TABLES `Citta` WRITE;
/*!40000 ALTER TABLE `Citta` DISABLE KEYS */;
INSERT INTO `Citta` VALUES ('BOLOGNA','BO'),('FERRARA','FE'),('FIRENZE','FI'),('FROSINONE','FR'),('MILANO','MI'),('NAPOLI','NA'),('PADOVA','PD'),('REGGIO EMILIA','RE'),('ROMA','RM'),('VENEZIA','VE');
/*!40000 ALTER TABLE `Citta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Convoglio`
--

DROP TABLE IF EXISTS `Convoglio`;
/*!50001 DROP VIEW IF EXISTS `Convoglio`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Convoglio` AS SELECT 
 1 AS `Treno_Matricola`,
 1 AS `Modello_Marca_Nome`,
 1 AS `Modello_Nome`,
 1 AS `Tipo`,
 1 AS `Portata_max`,
 1 AS `Num_max_passeggeri`,
 1 AS `Classe`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Copertura`
--

DROP TABLE IF EXISTS `Copertura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Copertura` (
  `Lavoratore_CF` varchar(16) NOT NULL,
  `Turno_ID` int NOT NULL,
  PRIMARY KEY (`Lavoratore_CF`,`Turno_ID`),
  KEY `fk_Copertura_Lavoratore1_idx` (`Lavoratore_CF`),
  KEY `fk_Copertura_Turno1_idx` (`Turno_ID`),
  CONSTRAINT `fk_Copertura_Lavoratore1` FOREIGN KEY (`Lavoratore_CF`) REFERENCES `Lavoratore` (`CF`),
  CONSTRAINT `fk_Copertura_Turno1` FOREIGN KEY (`Turno_ID`) REFERENCES `Turno` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Copertura`
--

LOCK TABLES `Copertura` WRITE;
/*!40000 ALTER TABLE `Copertura` DISABLE KEYS */;
INSERT INTO `Copertura` VALUES ('DRGMRI8394213454',1),('DRGMRI8394213454',2),('DRGMRI8394213454',3),('DRGMRI8394213454',4),('DRGMRI8394213454',5),('DRGMRI8394213454',24);
/*!40000 ALTER TABLE `Copertura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Fattura`
--

DROP TABLE IF EXISTS `Fattura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Fattura` (
  `Numero_Fattura` varchar(45) NOT NULL,
  `Azienda_PIVA_Mittente` varchar(11) NOT NULL,
  `Azienda_PIVA_Destinatario` varchar(11) NOT NULL,
  `Data` date NOT NULL,
  `Importo` varchar(45) NOT NULL,
  `IVA_applicata` int NOT NULL,
  PRIMARY KEY (`Numero_Fattura`,`Azienda_PIVA_Mittente`),
  KEY `fk_Fattura_Azienda1_idx` (`Azienda_PIVA_Mittente`),
  KEY `fk_Fattura_Azienda2_idx` (`Azienda_PIVA_Destinatario`),
  CONSTRAINT `fk_Fattura_Azienda1` FOREIGN KEY (`Azienda_PIVA_Mittente`) REFERENCES `Azienda` (`PIVA`),
  CONSTRAINT `fk_Fattura_Azienda2` FOREIGN KEY (`Azienda_PIVA_Destinatario`) REFERENCES `Azienda` (`PIVA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fattura`
--

LOCK TABLES `Fattura` WRITE;
/*!40000 ALTER TABLE `Fattura` DISABLE KEYS */;
INSERT INTO `Fattura` VALUES ('45620004','0004','0003','2022-01-01','1589',22),('85230002','0002','0003','2022-01-02','2359',22),('85490001','0001','0004','2022-01-01','560',22);
/*!40000 ALTER TABLE `Fattura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Fermata`
--

DROP TABLE IF EXISTS `Fermata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Fermata` (
  `Tratta_ID` int NOT NULL,
  `Stazione_Nome_Stazione` varchar(45) NOT NULL,
  `Orario_Partenza` time DEFAULT NULL,
  `Orario_Arrivo` time DEFAULT NULL,
  `Sequenza` int NOT NULL,
  PRIMARY KEY (`Tratta_ID`,`Stazione_Nome_Stazione`),
  KEY `fk_Fermata_Stazione1_idx` (`Stazione_Nome_Stazione`) /*!80000 INVISIBLE */,
  CONSTRAINT `fk_Fermata_Stazione1` FOREIGN KEY (`Stazione_Nome_Stazione`) REFERENCES `Stazione` (`Nome_Stazione`),
  CONSTRAINT `fk_Fermata_Tratta1` FOREIGN KEY (`Tratta_ID`) REFERENCES `Tratta` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fermata`
--

LOCK TABLES `Fermata` WRITE;
/*!40000 ALTER TABLE `Fermata` DISABLE KEYS */;
INSERT INTO `Fermata` VALUES (100,'BOLOGNA CENTRALE','10:30:00','10:25:00',3),(100,'FIRENZE RIFREDI','09:30:00','09:25:00',2),(100,'MILANO CENTRALE',NULL,'11:50:00',5),(100,'REGGIO EMILIA','11:10:00','11:00:00',4),(100,'ROMA TERMINI','08:10:00',NULL,1),(101,'BOLOGNA CENTRALE','11:30:00','11:25:00',3),(101,'FIRENZE RIFREDI','10:30:00','10:25:00',2),(101,'MILANO CENTRALE',NULL,'12:50:00',5),(101,'REGGIO EMILIA','12:10:00','12:00:00',4),(101,'ROMA TERMINI','09:10:00',NULL,1),(102,'BOLOGNA CENTRALE','14:30:00','14:25:00',3),(102,'FIRENZE RIFREDI','13:30:00','13:25:00',2),(102,'MILANO CENTRALE',NULL,'15:50:00',5),(102,'REGGIO EMILIA','15:10:00','15:00:00',4),(102,'ROMA TERMINI','12:10:00',NULL,1),(103,'BOLOGNA CENTRALE','15:30:00','10:25:00',3),(103,'FIRENZE RIFREDI','14:30:00','14:25:00',2),(103,'MILANO CENTRALE',NULL,'16:50:00',5),(103,'REGGIO EMILIA','16:10:00','16:00:00',4),(103,'ROMA TERMINI','13:10:00',NULL,1),(200,'BOLOGNA CENTRALE','10:31:00','10:26:00',3),(200,'FERRARA','11:11:00','11:01:00',4),(200,'FIRENZE S.M. NOVELLA','09:31:00','09:26:00',2),(200,'PADOVA','11:40:00','11:36:00',5),(200,'ROMA TERMINI','08:11:00',NULL,1),(200,'VENEZIA',NULL,'12:05:00',6),(201,'BOLOGNA CENTRALE','11:31:00','11:26:00',3),(201,'FERRARA','12:11:00','12:01:00',4),(201,'FIRENZE S.M. NOVELLA','10:31:00','10:26:00',2),(201,'PADOVA','12:40:00','12:36:00',5),(201,'ROMA TERMINI','09:11:00',NULL,1),(201,'VENEZIA',NULL,'13:05:00',6),(202,'BOLOGNA CENTRALE','14:31:00','14:26:00',3),(202,'FERRARA','15:11:00','15:01:00',4),(202,'FIRENZE S.M. NOVELLA','13:31:00','13:26:00',2),(202,'PADOVA','15:40:00','15:36:00',5),(202,'ROMA TERMINI','09:11:00',NULL,1),(202,'VENEZIA',NULL,'16:05:00',6),(300,'FROSINONE','08:55:00','08:50:00',2),(300,'NAPOLI CENTRALE','00:00:00','09:25:00',3),(300,'ROMA TERMINI','08:10:00',NULL,1),(301,'FROSINONE','09:55:00','09:50:00',2),(301,'NAPOLI CENTRALE','00:00:00','10:25:00',3),(301,'ROMA TERMINI','09:10:00',NULL,1),(302,'FROSINONE','10:55:00','10:50:00',2),(302,'NAPOLI CENTRALE','00:00:00','11:25:00',3),(302,'ROMA TERMINI','10:10:00',NULL,1);
/*!40000 ALTER TABLE `Fermata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Lavoratore`
--

DROP TABLE IF EXISTS `Lavoratore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lavoratore` (
  `CF` varchar(16) NOT NULL,
  `Mansione_ID` int NOT NULL,
  `Nome` varchar(45) NOT NULL,
  `Cognome` varchar(45) NOT NULL,
  `Data_Nascita` date NOT NULL,
  `Luogo_Nascita` varchar(45) NOT NULL,
  `login_username` varchar(45) NOT NULL,
  PRIMARY KEY (`CF`),
  KEY `fk_Lavoratore_Mansione1_idx` (`Mansione_ID`),
  KEY `fk_Lavoratore_login1_idx` (`login_username`),
  CONSTRAINT `fk_Lavoratore_login1` FOREIGN KEY (`login_username`) REFERENCES `login` (`username`),
  CONSTRAINT `fk_Lavoratore_Mansione1` FOREIGN KEY (`Mansione_ID`) REFERENCES `Mansione` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Lavoratore`
--

LOCK TABLES `Lavoratore` WRITE;
/*!40000 ALTER TABLE `Lavoratore` DISABLE KEYS */;
INSERT INTO `Lavoratore` VALUES ('CIFSRI3426546537',2,'SERGIO','CIOFFI','1976-02-02','PADOVA','sergio_cioffi'),('CPOMRI8473902374',1,'MARIO','CAPO','1983-01-01','ROMA','mario_capo'),('DRGMRI8394213454',1,'MARIO','DRAGHI','1983-01-01','ROMA','mario_draghi'),('NGILGI5558875341',2,'LUIGI','NERI','1976-02-04','PADOVA','luigi_neri'),('POGCRL4325642365',2,'CARLO','POGGI','1976-02-04','PADOVA','carlo_poggi'),('STRMRC3335514896',1,'MARCO','STORTI','1983-01-01','ROMA','marco_storti');
/*!40000 ALTER TABLE `Lavoratore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Malattia`
--

DROP TABLE IF EXISTS `Malattia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Malattia` (
  `Lavoratore_CF` varchar(16) NOT NULL,
  `Turno_ID` int NOT NULL,
  PRIMARY KEY (`Lavoratore_CF`,`Turno_ID`),
  KEY `fk_Malattia_Lavoratore1_idx` (`Lavoratore_CF`),
  KEY `fk_Malattia_Turno1_idx` (`Turno_ID`),
  CONSTRAINT `fk_Malattia_Lavoratore1` FOREIGN KEY (`Lavoratore_CF`) REFERENCES `Lavoratore` (`CF`),
  CONSTRAINT `fk_Malattia_Turno1` FOREIGN KEY (`Turno_ID`) REFERENCES `Turno` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Malattia`
--

LOCK TABLES `Malattia` WRITE;
/*!40000 ALTER TABLE `Malattia` DISABLE KEYS */;
INSERT INTO `Malattia` VALUES ('DRGMRI8394213454',11);
/*!40000 ALTER TABLE `Malattia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Mansione`
--

DROP TABLE IF EXISTS `Mansione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Mansione` (
  `ID` int NOT NULL,
  `Incarico` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Mansione`
--

LOCK TABLES `Mansione` WRITE;
/*!40000 ALTER TABLE `Mansione` DISABLE KEYS */;
INSERT INTO `Mansione` VALUES (1,'CAPOTRENO'),(2,'CONDUCENTE');
/*!40000 ALTER TABLE `Mansione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Marca`
--

DROP TABLE IF EXISTS `Marca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Marca` (
  `Nome` varchar(45) NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Marca`
--

LOCK TABLES `Marca` WRITE;
/*!40000 ALTER TABLE `Marca` DISABLE KEYS */;
INSERT INTO `Marca` VALUES ('ASTON'),('BREDA');
/*!40000 ALTER TABLE `Marca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Materiale_Rotabile`
--

DROP TABLE IF EXISTS `Materiale_Rotabile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Materiale_Rotabile` (
  `ID` int NOT NULL,
  `Treno_Matricola` int NOT NULL,
  `Modello_Marca_Nome` varchar(45) NOT NULL,
  `Modello_Nome` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`,`Treno_Matricola`,`Modello_Marca_Nome`,`Modello_Nome`),
  KEY `fk_Vagone_Treno1_idx` (`Treno_Matricola`),
  KEY `fk_Materiale_Rotabile_Modello1_idx` (`Modello_Marca_Nome`,`Modello_Nome`),
  CONSTRAINT `fk_Materiale_Rotabile_Modello1` FOREIGN KEY (`Modello_Marca_Nome`, `Modello_Nome`) REFERENCES `Modello` (`Marca_Nome`, `Nome`),
  CONSTRAINT `fk_Vagone_Treno1` FOREIGN KEY (`Treno_Matricola`) REFERENCES `Treno` (`Matricola`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Materiale_Rotabile`
--

LOCK TABLES `Materiale_Rotabile` WRITE;
/*!40000 ALTER TABLE `Materiale_Rotabile` DISABLE KEYS */;
INSERT INTO `Materiale_Rotabile` VALUES (10001,1000,'BREDA','LOC01'),(10002,1000,'BREDA','PAS01'),(10003,1000,'BREDA','PAS02'),(10004,1000,'BREDA','PAS02'),(10011,1001,'BREDA','LOC01'),(10012,1001,'BREDA','PAS01'),(10013,1001,'BREDA','PAS02'),(10014,1001,'BREDA','PAS02'),(10021,1002,'BREDA','LOC01'),(10022,1002,'BREDA','PAS01'),(10023,1002,'BREDA','PAS02'),(10024,1002,'BREDA','PAS02'),(20012,2001,'ASTON','AST_PAS01'),(20013,2001,'ASTON','AST_PAS02'),(20014,2001,'ASTON','AST_PAS02'),(20015,2001,'ASTON','AST_LOC1'),(20022,2002,'ASTON','AST_PAS01'),(20023,2002,'ASTON','AST_PAS02'),(20024,2002,'ASTON','AST_PAS02'),(20025,2002,'ASTON','AST_LOC1'),(50001,5000,'BREDA','LOC01'),(50002,5000,'BREDA','MER01'),(50003,5000,'BREDA','MER01'),(50004,5000,'BREDA','MER02'),(60012,6001,'ASTON','AST_MER01'),(60013,6001,'ASTON','AST_MER01'),(60014,6001,'ASTON','AST_MER01'),(60015,6001,'ASTON','AST_MER01'),(60016,6001,'ASTON','AST_LOC1');
/*!40000 ALTER TABLE `Materiale_Rotabile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Merce_trasportata`
--

DROP TABLE IF EXISTS `Merce_trasportata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Merce_trasportata` (
  `ID` int NOT NULL,
  `Materiale_Rotabile_ID` int NOT NULL,
  `Massa` int NOT NULL,
  `Descrizione` varchar(45) NOT NULL,
  `Servizio_Ferroviario_ID` int NOT NULL,
  `Fattura_Numero_Fattura` varchar(45) NOT NULL,
  `Fattura_Azienda_PIVA_Mittente` varchar(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Merce_trasportata_Materiale_Rotabile1_idx` (`Materiale_Rotabile_ID`),
  KEY `fk_Merce_trasportata_Servizio_Ferroviario1_idx` (`Servizio_Ferroviario_ID`),
  KEY `fk_Merce_trasportata_Fattura1_idx` (`Fattura_Numero_Fattura`,`Fattura_Azienda_PIVA_Mittente`),
  CONSTRAINT `fk_Merce_trasportata_Fattura1` FOREIGN KEY (`Fattura_Numero_Fattura`, `Fattura_Azienda_PIVA_Mittente`) REFERENCES `Fattura` (`Numero_Fattura`, `Azienda_PIVA_Mittente`),
  CONSTRAINT `fk_Merce_trasportata_Materiale_Rotabile1` FOREIGN KEY (`Materiale_Rotabile_ID`) REFERENCES `Materiale_Rotabile` (`ID`),
  CONSTRAINT `fk_Merce_trasportata_Servizio_Ferroviario1` FOREIGN KEY (`Servizio_Ferroviario_ID`) REFERENCES `Servizio_Ferroviario` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Merce_trasportata`
--

LOCK TABLES `Merce_trasportata` WRITE;
/*!40000 ALTER TABLE `Merce_trasportata` DISABLE KEYS */;
INSERT INTO `Merce_trasportata` VALUES (1849,50002,400,'Mascherine ffp2',50001,'85490001','0001');
/*!40000 ALTER TABLE `Merce_trasportata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Modello`
--

DROP TABLE IF EXISTS `Modello`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Modello` (
  `Nome` varchar(45) NOT NULL,
  `Marca_Nome` varchar(45) NOT NULL,
  `Tipo` varchar(45) NOT NULL,
  `Portata_max` int DEFAULT '0',
  `Num_max_passeggeri` int DEFAULT '0',
  `Classe` varchar(45) DEFAULT '-',
  PRIMARY KEY (`Marca_Nome`,`Nome`),
  KEY `fk_Modello_Marca1_idx` (`Marca_Nome`),
  CONSTRAINT `fk_Modello_Marca1` FOREIGN KEY (`Marca_Nome`) REFERENCES `Marca` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Modello`
--

LOCK TABLES `Modello` WRITE;
/*!40000 ALTER TABLE `Modello` DISABLE KEYS */;
INSERT INTO `Modello` VALUES ('AST_LOC1','ASTON','LOCOMOTORE',0,0,'-'),('AST_MER01','ASTON','MERCI',900,0,'-'),('AST_PAS01','ASTON','PASSEGGERI',0,45,'PRIMA'),('AST_PAS02','ASTON','PASSEGGERI',0,90,'SECONDA'),('LOC01','BREDA','LOCOMOTORE',0,0,'-'),('LOC02','BREDA','LOCOMOTORE',0,0,'-'),('MER01','BREDA','MERCI',500,0,'-'),('MER02','BREDA','MERCI',800,0,'-'),('MER03','BREDA','MERCI',500,0,'-'),('PAS01','BREDA','PASSEGGERI',0,50,'PRIMA'),('PAS01A','BREDA','PASSEGGERI',0,40,'PRIMA'),('PAS02','BREDA','PASSEGGERI',0,70,'SECONDA'),('PAS03','BREDA','PASSEGGERI',0,30,'PRIMA');
/*!40000 ALTER TABLE `Modello` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Passeggero`
--

DROP TABLE IF EXISTS `Passeggero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Passeggero` (
  `CF` varchar(16) NOT NULL,
  `Nome` varchar(45) NOT NULL,
  `Cognome` varchar(45) NOT NULL,
  `Data_nascita` date NOT NULL,
  `Carta_di_credito` varchar(16) NOT NULL,
  PRIMARY KEY (`CF`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Passeggero`
--

LOCK TABLES `Passeggero` WRITE;
/*!40000 ALTER TABLE `Passeggero` DISABLE KEYS */;
INSERT INTO `Passeggero` VALUES ('AAABBB001','STEFANO','BIANCHI','1963-01-13','2233445566774444'),('AAABBB002','SANDRO','ROSSI','1945-01-12','3646475858688887'),('AAABBB003','LUIGI','BIANCHI','1988-11-21','3453634763473777'),('AAABBB004','MARIO','VERDI','1978-02-13','3266885888889898'),('AAABBB005','CARLO','CARLI','1979-02-15','3266885888889555');
/*!40000 ALTER TABLE `Passeggero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Posto`
--

DROP TABLE IF EXISTS `Posto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Posto` (
  `Num_posto` varchar(3) NOT NULL,
  `Materiale_Rotabile_ID` int NOT NULL,
  PRIMARY KEY (`Num_posto`,`Materiale_Rotabile_ID`),
  KEY `fk_Posto_Materiale_Rotabile1_idx` (`Materiale_Rotabile_ID`),
  CONSTRAINT `fk_Posto_Materiale_Rotabile1` FOREIGN KEY (`Materiale_Rotabile_ID`) REFERENCES `Materiale_Rotabile` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Posto`
--

LOCK TABLES `Posto` WRITE;
/*!40000 ALTER TABLE `Posto` DISABLE KEYS */;
INSERT INTO `Posto` VALUES ('A01',10002),('A02',10002),('A03',10002),('B01',10002),('B02',10002),('B03',10002),('C01',10002),('C02',10002),('C03',10002),('D01',10002),('D02',10002),('D03',10002),('E01',10002),('E02',10002),('E03',10002),('F01',10002),('F02',10002),('F03',10002),('G01',10002),('G02',10002),('G03',10002),('H01',10002),('H02',10002),('H03',10002),('I01',10002),('I02',10002),('I03',10002),('L01',10002),('L02',10002),('L03',10002),('M01',10002),('M02',10002),('M03',10002),('N01',10002),('N02',10002),('N03',10002),('A01',10003),('A02',10003),('A03',10003),('B01',10003),('B02',10003),('B03',10003),('C01',10003),('C02',10003),('C03',10003),('D01',10003),('D02',10003),('D03',10003),('E01',10003),('E02',10003),('E03',10003),('F01',10003),('F02',10003),('F03',10003),('G01',10003),('G02',10003),('G03',10003),('H01',10003),('H02',10003),('H03',10003),('I01',10003),('I02',10003),('I03',10003),('L01',10003),('L02',10003),('L03',10003),('M01',10003),('M02',10003),('M03',10003),('N01',10003),('N02',10003),('N03',10003);
/*!40000 ALTER TABLE `Posto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Prenotazione`
--

DROP TABLE IF EXISTS `Prenotazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Prenotazione` (
  `Codice_prenotazione` varchar(5) NOT NULL,
  `Posto_Num_posto` varchar(3) NOT NULL,
  `Passeggero_CF` varchar(16) NOT NULL,
  `Stato` varchar(45) NOT NULL,
  `Servizio_Ferroviario_ID` int NOT NULL,
  PRIMARY KEY (`Codice_prenotazione`),
  KEY `fk_Prenotazione_Posto1_idx` (`Posto_Num_posto`),
  KEY `fk_Prenotazione_Passeggero1_idx` (`Passeggero_CF`),
  KEY `fk_Prenotazione_Servizio_Ferroviario1_idx` (`Servizio_Ferroviario_ID`),
  CONSTRAINT `fk_Prenotazione_Passeggero1` FOREIGN KEY (`Passeggero_CF`) REFERENCES `Passeggero` (`CF`),
  CONSTRAINT `fk_Prenotazione_Posto1` FOREIGN KEY (`Posto_Num_posto`) REFERENCES `Posto` (`Num_posto`),
  CONSTRAINT `fk_Prenotazione_Servizio_Ferroviario1` FOREIGN KEY (`Servizio_Ferroviario_ID`) REFERENCES `Servizio_Ferroviario` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Prenotazione`
--

LOCK TABLES `Prenotazione` WRITE;
/*!40000 ALTER TABLE `Prenotazione` DISABLE KEYS */;
INSERT INTO `Prenotazione` VALUES ('a1111','a01','AAABBB005','Utilizzata',20001),('a1112','a02','AAABBB004','VALIDO',20001);
/*!40000 ALTER TABLE `Prenotazione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Provincia`
--

DROP TABLE IF EXISTS `Provincia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Provincia` (
  `Sigla` varchar(2) NOT NULL,
  `Nome` varchar(45) NOT NULL,
  PRIMARY KEY (`Sigla`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Provincia`
--

LOCK TABLES `Provincia` WRITE;
/*!40000 ALTER TABLE `Provincia` DISABLE KEYS */;
INSERT INTO `Provincia` VALUES ('BO','BOILOGNA'),('FE','FERRARA'),('FI','FIRENZE'),('FR','FROSINONE'),('MI','MILANO'),('NA','NAPOLI'),('PD','PADOVA'),('RE','REGGIO EMILIA'),('RM','ROMA'),('VE','VENEZIA');
/*!40000 ALTER TABLE `Provincia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Servizio_Ferroviario`
--

DROP TABLE IF EXISTS `Servizio_Ferroviario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Servizio_Ferroviario` (
  `ID` int NOT NULL,
  `Turno_ID` int NOT NULL,
  `Treno_Matricola` int NOT NULL,
  `Tratta_ID` int NOT NULL,
  `Data` date NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Tratta_Turno1_idx` (`Turno_ID`),
  KEY `fk_Tratta_Treno1_idx` (`Treno_Matricola`),
  KEY `fk_Itinerario_Tratta1_idx` (`Tratta_ID`),
  CONSTRAINT `fk_Itinerario_Tratta1` FOREIGN KEY (`Tratta_ID`) REFERENCES `Tratta` (`ID`),
  CONSTRAINT `fk_Tratta_Treno1` FOREIGN KEY (`Treno_Matricola`) REFERENCES `Treno` (`Matricola`),
  CONSTRAINT `fk_Tratta_Turno1` FOREIGN KEY (`Turno_ID`) REFERENCES `Turno` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Servizio_Ferroviario`
--

LOCK TABLES `Servizio_Ferroviario` WRITE;
/*!40000 ALTER TABLE `Servizio_Ferroviario` DISABLE KEYS */;
INSERT INTO `Servizio_Ferroviario` VALUES (20000,1,1000,100,'2022-01-01'),(20001,4,1001,101,'2022-01-01'),(20002,5,1002,102,'2022-01-01'),(20004,7,2000,200,'2022-01-01'),(20005,8,2001,201,'2022-01-01'),(20006,8,2002,202,'2022-01-01'),(20010,19,1000,100,'2022-01-02'),(20011,20,1001,101,'2022-01-02'),(20012,21,1002,102,'2022-01-02'),(20014,22,2000,200,'2022-01-02'),(20015,23,2001,201,'2022-01-02'),(20016,24,2002,202,'2022-01-02'),(50001,26,5000,100,'2022-01-01'),(50002,26,6000,200,'2022-01-01'),(50011,19,5000,100,'2022-01-02'),(50012,20,6000,200,'2022-01-02');
/*!40000 ALTER TABLE `Servizio_Ferroviario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stazione`
--

DROP TABLE IF EXISTS `Stazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stazione` (
  `Nome_Stazione` varchar(45) NOT NULL,
  `Citta_Nome` varchar(45) NOT NULL,
  PRIMARY KEY (`Nome_Stazione`),
  KEY `fk_Stazione_Citta1_idx` (`Citta_Nome`),
  CONSTRAINT `fk_Stazione_Citta1` FOREIGN KEY (`Citta_Nome`) REFERENCES `Citta` (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stazione`
--

LOCK TABLES `Stazione` WRITE;
/*!40000 ALTER TABLE `Stazione` DISABLE KEYS */;
INSERT INTO `Stazione` VALUES ('BOLOGNA CENTRALE','BOLOGNA'),('FERRARA','FERRARA'),('FIRENZE RIFREDI ','FIRENZE'),('FIRENZE S.M. NOVELLA','FIRENZE'),('FROSINONE','FROSINONE'),('MILANO CENTRALE','MILANO'),('MILANO ROGOREDO','MILANO'),('NAPOLI CENTRALE','NAPOLI'),('PADOVA','PADOVA'),('REGGIO EMILIA','REGGIO EMILIA'),('ROMA TERMINI','ROMA'),('ROMA TIBURTINA','ROMA'),('VENEZIA','VENEZIA');
/*!40000 ALTER TABLE `Stazione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tratta`
--

DROP TABLE IF EXISTS `Tratta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tratta` (
  `ID` int NOT NULL,
  `Capolinea_partenza` varchar(45) NOT NULL,
  `Capolinea_arrivo` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tratta`
--

LOCK TABLES `Tratta` WRITE;
/*!40000 ALTER TABLE `Tratta` DISABLE KEYS */;
INSERT INTO `Tratta` VALUES (100,'ROMA TERMINI','MILANO CENTRALE'),(101,'ROMA TERMINI','MILANO CENTRALE'),(102,'ROMA TERMINI','MILANO CENTRALE'),(103,'ROMA TERMINI','MILANO CENTRALE'),(200,'ROMA TERMINI','VENEZIA'),(201,'ROMA TERMINI','VENEZIA'),(202,'ROMA TERMINI','VENEZIA'),(300,'ROMA TERMINI','NAPOLI CENTRALE'),(301,'ROMA TERMINI','NAPOLI CENTRALE'),(302,'ROMA TERMINI','NAPOLI CENTRALE');
/*!40000 ALTER TABLE `Tratta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Treno`
--

DROP TABLE IF EXISTS `Treno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Treno` (
  `Matricola` int NOT NULL,
  `Data_Acquisto` date NOT NULL,
  PRIMARY KEY (`Matricola`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Treno`
--

LOCK TABLES `Treno` WRITE;
/*!40000 ALTER TABLE `Treno` DISABLE KEYS */;
INSERT INTO `Treno` VALUES (1000,'2010-05-01'),(1001,'2015-05-01'),(1002,'2017-08-21'),(2000,'2018-01-01'),(2001,'2018-01-01'),(2002,'2018-01-01'),(2003,'2018-01-01'),(5000,'2010-05-01'),(6000,'2018-01-01'),(6001,'2018-01-01');
/*!40000 ALTER TABLE `Treno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Turno`
--

DROP TABLE IF EXISTS `Turno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Turno` (
  `ID` int NOT NULL,
  `Data` date NOT NULL,
  `Ora_inizio` time NOT NULL,
  `Ora_fine` time NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Turno`
--

LOCK TABLES `Turno` WRITE;
/*!40000 ALTER TABLE `Turno` DISABLE KEYS */;
INSERT INTO `Turno` VALUES (1,'2022-01-01','08:00:00','12:00:00'),(2,'2022-01-01','09:00:00','13:00:00'),(3,'2022-01-01','10:00:00','14:00:00'),(4,'2022-01-01','11:00:00','13:00:00'),(5,'2022-01-01','08:00:00','12:00:00'),(6,'2022-01-01','09:00:00','13:00:00'),(7,'2022-01-01','10:00:00','14:00:00'),(8,'2022-01-01','11:00:00','15:00:00'),(9,'2022-01-01','12:00:00','16:00:00'),(10,'2022-01-01','13:00:00','17:00:00'),(11,'2022-01-01','14:00:00','18:00:00'),(12,'2022-01-01','08:00:00','12:00:00'),(13,'2022-01-01','09:00:00','13:00:00'),(14,'2022-01-01','10:00:00','14:00:00'),(15,'2022-01-01','11:00:00','15:00:00'),(16,'2022-01-01','12:00:00','16:00:00'),(17,'2022-01-01','13:00:00','17:00:00'),(18,'2022-01-01','14:00:00','18:00:00'),(19,'2022-01-02','08:00:00','12:00:00'),(20,'2022-01-02','09:00:00','13:00:00'),(21,'2022-01-02','10:00:00','14:00:00'),(22,'2022-01-02','11:00:00','13:00:00'),(23,'2022-01-02','08:00:00','12:00:00'),(24,'2022-01-02','09:00:00','13:00:00'),(25,'2022-01-02','10:00:00','14:00:00'),(26,'2022-01-02','11:00:00','13:00:00');
/*!40000 ALTER TABLE `Turno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `composizione_treno`
--

DROP TABLE IF EXISTS `composizione_treno`;
/*!50001 DROP VIEW IF EXISTS `composizione_treno`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `composizione_treno` AS SELECT 
 1 AS `treno_matricola`,
 1 AS `tipo`,
 1 AS `classe`,
 1 AS `N_Vagoni`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `ruolo` enum('amministratore','lavoratore','controllore','manutentore') NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES ('admin','admin','amministratore'),('carlo_poggi','carlo','lavoratore'),('controllore','controllore','controllore'),('luigi_neri','luigi','lavoratore'),('manutentore','manutentore','manutentore'),('marco_storti','marco','lavoratore'),('mario_capo','mario','lavoratore'),('mario_draghi','mario','lavoratore'),('sergio_cioffi','sergio','lavoratore');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `Convoglio`
--

/*!50001 DROP VIEW IF EXISTS `Convoglio`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Convoglio` AS select `Materiale_Rotabile`.`Treno_Matricola` AS `Treno_Matricola`,`Materiale_Rotabile`.`Modello_Marca_Nome` AS `Modello_Marca_Nome`,`Materiale_Rotabile`.`Modello_Nome` AS `Modello_Nome`,`Modello`.`Tipo` AS `Tipo`,`Modello`.`Portata_max` AS `Portata_max`,`Modello`.`Num_max_passeggeri` AS `Num_max_passeggeri`,`Modello`.`Classe` AS `Classe` from (`Materiale_Rotabile` join `Modello`) where ((`Materiale_Rotabile`.`Modello_Nome` = `Modello`.`Nome`) and (`Materiale_Rotabile`.`Modello_Marca_Nome` = `Modello`.`Marca_Nome`)) order by `Materiale_Rotabile`.`Treno_Matricola` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `composizione_treno`
--

/*!50001 DROP VIEW IF EXISTS `composizione_treno`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `composizione_treno` AS select `Convoglio`.`Treno_Matricola` AS `treno_matricola`,`Convoglio`.`Tipo` AS `tipo`,`Convoglio`.`Classe` AS `classe`,count(0) AS `N_Vagoni` from `Convoglio` where ((`Convoglio`.`Classe` in ('PRIMA','SECONDA')) or (`Convoglio`.`Tipo` = 'LOCOMOTORE') or (`Convoglio`.`Tipo` = 'MERCI')) group by `Convoglio`.`Treno_Matricola`,`Convoglio`.`Tipo`,`Convoglio`.`Classe` order by `Convoglio`.`Treno_Matricola` */;
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

-- Dump completed on 2021-08-26 17:18:08
