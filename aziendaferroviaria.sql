-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema AziendaFerroviaria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema AziendaFerroviaria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `AziendaFerroviaria` DEFAULT CHARACTER SET utf8 ;
USE `AziendaFerroviaria` ;

-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Treno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Treno` (
  `Matricola` INT NOT NULL,
  `Data_Acquisto` DATE NOT NULL,
  PRIMARY KEY (`Matricola`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Turno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Turno` (
  `ID` INT NOT NULL,
  `Data` DATE NOT NULL,
  `Ora_inizio` TIME NOT NULL,
  `Ora_fine` TIME NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Tratta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Tratta` (
  `ID` INT NOT NULL,
  `Capolinea_partenza` VARCHAR(45) NOT NULL,
  `Capolinea_arrivo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Servizio_Ferroviario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Servizio_Ferroviario` (
  `ID` INT NOT NULL,
  `Turno_ID` INT NOT NULL,
  `Treno_Matricola` INT NOT NULL,
  `Tratta_ID` INT NOT NULL,
  `Data` DATE NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Tratta_Turno1_idx` (`Turno_ID` ASC) VISIBLE,
  INDEX `fk_Tratta_Treno1_idx` (`Treno_Matricola` ASC) VISIBLE,
  INDEX `fk_Itinerario_Tratta1_idx` (`Tratta_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Tratta_Turno1`
    FOREIGN KEY (`Turno_ID`)
    REFERENCES `AziendaFerroviaria`.`Turno` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tratta_Treno1`
    FOREIGN KEY (`Treno_Matricola`)
    REFERENCES `AziendaFerroviaria`.`Treno` (`Matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Itinerario_Tratta1`
    FOREIGN KEY (`Tratta_ID`)
    REFERENCES `AziendaFerroviaria`.`Tratta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Provincia` (
  `Sigla` VARCHAR(2) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Sigla`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Citta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Citta` (
  `Nome` VARCHAR(45) NOT NULL,
  `Provincia_Sigla` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`Nome`, `Provincia_Sigla`),
  INDEX `fk_Citta_Provincia1_idx` (`Provincia_Sigla` ASC) VISIBLE,
  CONSTRAINT `fk_Citta_Provincia1`
    FOREIGN KEY (`Provincia_Sigla`)
    REFERENCES `AziendaFerroviaria`.`Provincia` (`Sigla`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Stazione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Stazione` (
  `Nome_Stazione` VARCHAR(45) NOT NULL,
  `Citta_Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome_Stazione`),
  INDEX `fk_Stazione_Citta1_idx` (`Citta_Nome` ASC) VISIBLE,
  CONSTRAINT `fk_Stazione_Citta1`
    FOREIGN KEY (`Citta_Nome`)
    REFERENCES `AziendaFerroviaria`.`Citta` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Marca` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Modello`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Modello` (
  `Nome` VARCHAR(45) NOT NULL,
  `Marca_Nome` VARCHAR(45) NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Portata_max` INT NULL DEFAULT 0,
  `Num_max_passeggeri` INT NULL DEFAULT 0,
  `Classe` VARCHAR(45) NULL DEFAULT '-',
  PRIMARY KEY (`Marca_Nome`, `Nome`),
  INDEX `fk_Modello_Marca1_idx` (`Marca_Nome` ASC) VISIBLE,
  CONSTRAINT `fk_Modello_Marca1`
    FOREIGN KEY (`Marca_Nome`)
    REFERENCES `AziendaFerroviaria`.`Marca` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Materiale_Rotabile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Materiale_Rotabile` (
  `ID` INT NOT NULL,
  `Treno_Matricola` INT NOT NULL,
  `Modello_Marca_Nome` VARCHAR(45) NOT NULL,
  `Modello_Nome` VARCHAR(45) NOT NULL,
  INDEX `fk_Vagone_Treno1_idx` (`Treno_Matricola` ASC) VISIBLE,
  PRIMARY KEY (`ID`, `Treno_Matricola`, `Modello_Marca_Nome`, `Modello_Nome`),
  INDEX `fk_Materiale_Rotabile_Modello1_idx` (`Modello_Marca_Nome` ASC, `Modello_Nome` ASC) VISIBLE,
  CONSTRAINT `fk_Vagone_Treno1`
    FOREIGN KEY (`Treno_Matricola`)
    REFERENCES `AziendaFerroviaria`.`Treno` (`Matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Materiale_Rotabile_Modello1`
    FOREIGN KEY (`Modello_Marca_Nome` , `Modello_Nome`)
    REFERENCES `AziendaFerroviaria`.`Modello` (`Marca_Nome` , `Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Attivita_Manutenzione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Attivita_Manutenzione` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Data` DATE NOT NULL,
  `Info` VARCHAR(500) NOT NULL,
  `Materiale_Rotabile_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Attivita_Manutenzione_Materiale_Rotabile1_idx` (`Materiale_Rotabile_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Attivita_Manutenzione_Materiale_Rotabile1`
    FOREIGN KEY (`Materiale_Rotabile_ID`)
    REFERENCES `AziendaFerroviaria`.`Materiale_Rotabile` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Mansione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Mansione` (
  `ID` INT NOT NULL,
  `Incarico` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`login`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`login` (
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `ruolo` ENUM('amministratore', 'lavoratore', 'controllore', 'manutentore') NOT NULL,
  PRIMARY KEY (`username`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Lavoratore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Lavoratore` (
  `CF` VARCHAR(16) NOT NULL,
  `Mansione_ID` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Data_Nascita` DATE NOT NULL,
  `Luogo_Nascita` VARCHAR(45) NOT NULL,
  `login_username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CF`),
  INDEX `fk_Lavoratore_Mansione1_idx` (`Mansione_ID` ASC) VISIBLE,
  INDEX `fk_Lavoratore_login1_idx` (`login_username` ASC) VISIBLE,
  CONSTRAINT `fk_Lavoratore_Mansione1`
    FOREIGN KEY (`Mansione_ID`)
    REFERENCES `AziendaFerroviaria`.`Mansione` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lavoratore_login1`
    FOREIGN KEY (`login_username`)
    REFERENCES `AziendaFerroviaria`.`login` (`username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Copertura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Copertura` (
  `Lavoratore_CF` VARCHAR(16) NOT NULL,
  `Turno_ID` INT NOT NULL,
  PRIMARY KEY (`Lavoratore_CF`, `Turno_ID`),
  INDEX `fk_Copertura_Lavoratore1_idx` (`Lavoratore_CF` ASC) VISIBLE,
  INDEX `fk_Copertura_Turno1_idx` (`Turno_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Copertura_Lavoratore1`
    FOREIGN KEY (`Lavoratore_CF`)
    REFERENCES `AziendaFerroviaria`.`Lavoratore` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Copertura_Turno1`
    FOREIGN KEY (`Turno_ID`)
    REFERENCES `AziendaFerroviaria`.`Turno` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Malattia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Malattia` (
  `Lavoratore_CF` VARCHAR(16) NOT NULL,
  `Turno_ID` INT NOT NULL,
  PRIMARY KEY (`Lavoratore_CF`, `Turno_ID`),
  INDEX `fk_Malattia_Lavoratore1_idx` (`Lavoratore_CF` ASC) VISIBLE,
  INDEX `fk_Malattia_Turno1_idx` (`Turno_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Malattia_Lavoratore1`
    FOREIGN KEY (`Lavoratore_CF`)
    REFERENCES `AziendaFerroviaria`.`Lavoratore` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Malattia_Turno1`
    FOREIGN KEY (`Turno_ID`)
    REFERENCES `AziendaFerroviaria`.`Turno` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Azienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Azienda` (
  `PIVA` VARCHAR(11) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PIVA`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Fattura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Fattura` (
  `Numero_Fattura` VARCHAR(45) NOT NULL,
  `Azienda_PIVA_Mittente` VARCHAR(11) NOT NULL,
  `Azienda_PIVA_Destinatario` VARCHAR(11) NOT NULL,
  `Data` DATE NOT NULL,
  `Importo` FLOAT NOT NULL,
  `IVA_applicata` INT NOT NULL,
  INDEX `fk_Fattura_Azienda1_idx` (`Azienda_PIVA_Mittente` ASC) VISIBLE,
  INDEX `fk_Fattura_Azienda2_idx` (`Azienda_PIVA_Destinatario` ASC) VISIBLE,
  PRIMARY KEY (`Numero_Fattura`, `Azienda_PIVA_Mittente`),
  CONSTRAINT `fk_Fattura_Azienda1`
    FOREIGN KEY (`Azienda_PIVA_Mittente`)
    REFERENCES `AziendaFerroviaria`.`Azienda` (`PIVA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fattura_Azienda2`
    FOREIGN KEY (`Azienda_PIVA_Destinatario`)
    REFERENCES `AziendaFerroviaria`.`Azienda` (`PIVA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Merce_trasportata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Merce_trasportata` (
  `ID` INT NOT NULL,
  `Materiale_Rotabile_ID` INT NOT NULL,
  `Massa` INT NOT NULL,
  `Descrizione` VARCHAR(45) NOT NULL,
  `Servizio_Ferroviario_ID` INT NOT NULL,
  `Fattura_Numero_Fattura` VARCHAR(45) NOT NULL,
  `Fattura_Azienda_PIVA_Mittente` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Merce_trasportata_Materiale_Rotabile1_idx` (`Materiale_Rotabile_ID` ASC) VISIBLE,
  INDEX `fk_Merce_trasportata_Servizio_Ferroviario1_idx` (`Servizio_Ferroviario_ID` ASC) VISIBLE,
  INDEX `fk_Merce_trasportata_Fattura1_idx` (`Fattura_Numero_Fattura` ASC, `Fattura_Azienda_PIVA_Mittente` ASC) VISIBLE,
  CONSTRAINT `fk_Merce_trasportata_Materiale_Rotabile1`
    FOREIGN KEY (`Materiale_Rotabile_ID`)
    REFERENCES `AziendaFerroviaria`.`Materiale_Rotabile` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Merce_trasportata_Servizio_Ferroviario1`
    FOREIGN KEY (`Servizio_Ferroviario_ID`)
    REFERENCES `AziendaFerroviaria`.`Servizio_Ferroviario` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Merce_trasportata_Fattura1`
    FOREIGN KEY (`Fattura_Numero_Fattura` , `Fattura_Azienda_PIVA_Mittente`)
    REFERENCES `AziendaFerroviaria`.`Fattura` (`Numero_Fattura` , `Azienda_PIVA_Mittente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Posto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Posto` (
  `Num_posto` VARCHAR(3) NOT NULL,
  `Materiale_Rotabile_ID` INT NOT NULL,
  PRIMARY KEY (`Num_posto`, `Materiale_Rotabile_ID`),
  INDEX `fk_Posto_Materiale_Rotabile1_idx` (`Materiale_Rotabile_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Posto_Materiale_Rotabile1`
    FOREIGN KEY (`Materiale_Rotabile_ID`)
    REFERENCES `AziendaFerroviaria`.`Materiale_Rotabile` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Passeggero`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Passeggero` (
  `CF` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Data_nascita` DATE NOT NULL,
  `Carta_di_credito` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`CF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Prenotazione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Prenotazione` (
  `Codice_prenotazione` VARCHAR(5) NOT NULL,
  `Posto_Num_posto` VARCHAR(3) NOT NULL,
  `Passeggero_CF` VARCHAR(16) NOT NULL,
  `Stato` VARCHAR(45) NOT NULL,
  `Servizio_Ferroviario_ID` INT NOT NULL,
  PRIMARY KEY (`Codice_prenotazione`),
  INDEX `fk_Prenotazione_Posto1_idx` (`Posto_Num_posto` ASC) VISIBLE,
  INDEX `fk_Prenotazione_Passeggero1_idx` (`Passeggero_CF` ASC) VISIBLE,
  INDEX `fk_Prenotazione_Servizio_Ferroviario1_idx` (`Servizio_Ferroviario_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Prenotazione_Posto1`
    FOREIGN KEY (`Posto_Num_posto`)
    REFERENCES `AziendaFerroviaria`.`Posto` (`Num_posto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prenotazione_Passeggero1`
    FOREIGN KEY (`Passeggero_CF`)
    REFERENCES `AziendaFerroviaria`.`Passeggero` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prenotazione_Servizio_Ferroviario1`
    FOREIGN KEY (`Servizio_Ferroviario_ID`)
    REFERENCES `AziendaFerroviaria`.`Servizio_Ferroviario` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AziendaFerroviaria`.`Fermata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Fermata` (
  `Tratta_ID` INT NOT NULL,
  `Stazione_Nome_Stazione` VARCHAR(45) NOT NULL,
  `Orario_Partenza` TIME NULL,
  `Orario_Arrivo` TIME NULL,
  `Sequenza` INT NOT NULL,
  PRIMARY KEY (`Tratta_ID`, `Stazione_Nome_Stazione`),
  INDEX `fk_Fermata_Stazione1_idx` (`Stazione_Nome_Stazione` ASC) INVISIBLE,
  CONSTRAINT `fk_Fermata_Tratta1`
    FOREIGN KEY (`Tratta_ID`)
    REFERENCES `AziendaFerroviaria`.`Tratta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fermata_Stazione1`
    FOREIGN KEY (`Stazione_Nome_Stazione`)
    REFERENCES `AziendaFerroviaria`.`Stazione` (`Nome_Stazione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `AziendaFerroviaria` ;

-- -----------------------------------------------------
-- Placeholder table for view `AziendaFerroviaria`.`Convoglio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`Convoglio` (`Treno_Matricola` INT, `Modello_Marca_Nome` INT, `Modello_Nome` INT, `Tipo` INT, `Portata_max` INT, `Num_max_passeggeri` INT, `Classe` INT);

-- -----------------------------------------------------
-- Placeholder table for view `AziendaFerroviaria`.`composizione_treno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AziendaFerroviaria`.`composizione_treno` (`treno_matricola` INT, `tipo` INT, `classe` INT, `N_Vagoni` INT);

-- -----------------------------------------------------
-- procedure aggiungi_lavoratore
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `aggiungi_lavoratore` (IN var_cf VARCHAR(16), IN var_mansione INT, IN var_nome VARCHAR(45), IN var_cognome VARCHAR(45), IN var_data_nascita DATE, IN var_luogo_nascita VARCHAR(45), IN var_username VARCHAR(45), IN var_pass VARCHAR(45))
BEGIN	
		start transaction;
        INSERT INTO login(`username`,`password`,`ruolo`)
        VALUES(var_username, var_pass, '2');
        
		INSERT INTO Lavoratore(`CF`, `Mansione_ID`, `Nome`, `Cognome`, `Data_nascita`, `Luogo_nascita`,`login_username`)
		VALUES(var_cf, var_mansione, var_nome, var_cognome, var_data_nascita, var_luogo_nascita, var_username);
        commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure convalida_prenotazione
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `convalida_prenotazione` (IN var_codice_prenotazione VARCHAR(5))
BEGIN
DECLARE EXIT HANDLER FOR sqlexception
BEGIN
 rollback;
 resignal;
 END;
 
set transaction isolation level serializable;
	UPDATE `AziendaFerroviaria`.`Prenotazione`
	SET
	`Stato` = 'Utilizzata'
	WHERE `Codice_prenotazione` = var_codice_prenotazione;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `login` (in var_username varchar(45), in var_pass varchar(45), out var_role INT)
BEGIN
	declare var_user_role ENUM('amministratore', 'lavoratore', 'controllore','manutentore');
    
	select `ruolo` from `login`
		where `username` = var_username
        and `password` = var_pass
        into var_user_role;
        
        -- See the corresponding enum in the client
		if var_user_role = 'amministratore' then
			set var_role = 1;
		elseif var_user_role = 'lavoratore' then
			set var_role = 2;
		elseif var_user_role = 'controllore' then
			set var_role = 3;
		elseif var_user_role = 'manutentore' then
			set var_role = 4;
		else
			set var_role = 5;
		end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_azienda
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `aggiungi_azienda` (IN var_piva VARCHAR(11), IN var_nome VARCHAR(45))
BEGIN
		INSERT INTO Azienda
		(`PIVA`,
		`Nome`)
		VALUES
		(var_piva,
		var_nome);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_passeggero
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `aggiungi_passeggero` (IN var_cf VARCHAR(16), IN var_nome VARCHAR(45), IN var_cognome VARCHAR(45), IN var_data_nascita DATE, IN var_carta VARCHAR(16))
BEGIN
start transaction;
	INSERT INTO `AziendaFerroviaria`.`Passeggero`
	(`CF`,
	`Nome`,
	`Cognome`,
	`Data_nascita`,
	`Carta_di_credito`)
	VALUES
	(var_cf,
	var_nome,
	var_cognome,
	var_data_nascita,
	var_carta);
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_prenotazione
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `aggiungi_prenotazione` (IN var_codice_prenotazione VARCHAR(5), IN var_posto_num VARCHAR(4), IN var_passeggero_cf VARCHAR(16), IN var_servizio_id INT)

BEGIN
DECLARE EXIT HANDLER FOR sqlexception
 BEGIN
 rollback;
 resignal;
 END;
 
SET TRANSACTION ISOLATION LEVEL serializable;
start transaction;

 if exists (Select * from Prenotazione where Posto_num_posto = var_posto_num and
Servizio_Ferroviario_ID = var_servizio_id) then
SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Il posto selezionato è occupato.';
 end if;

	INSERT IGNORE INTO `AziendaFerroviaria`.`Prenotazione`
	(`Codice_prenotazione`,
	`Posto_Num_posto`,
	`Passeggero_CF`,
	`Stato`,
	`Servizio_Ferroviario_ID`)
	VALUES
	(var_codice_prenotazione,
	var_posto_num,
	var_passeggero_cf,
    'VALIDO',
    var_servizio_id);
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_spedizione
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `aggiungi_spedizione` (IN var_merce_id INT, IN var_mittente VARCHAR(11), IN var_servizio INT, IN var_vagone_id INT, IN var_massa INT, IN var_descrizione VARCHAR(120), IN var_fattura VARCHAR(45))
BEGIN
DECLARE EXIT HANDLER FOR sqlexception
 BEGIN
 rollback;
 resignal;
 END;
 
SET TRANSACTION ISOLATION LEVEL serializable;
start transaction;
	start transaction;
    
if exists (Select * from Merce_trasportata where Materiale_Rotabile_ID = var_vagone_id and
Servizio_Ferroviario_ID = var_servizio) then
SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Il vagone selezionato è occupato.';
 end if;

if exists (Select * from Materiale_Rotabile,Modello where ID = var_vagone_id and Modello_Nome = Nome and Tipo != 'MERCI') then
SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Il tipo di vagone selezionato non è corretto.';
 end if;
 
 if exists (Select * from Materiale_Rotabile,Modello where ID = var_vagone_id and Modello_Nome = Nome and Portata_max < var_massa) then
SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Il limite di massa per il vagone è stato superato.';
 end if;
    
	INSERT IGNORE INTO `AziendaFerroviaria`.`Merce_trasportata`
	(`ID`,
	`Servizio_Ferroviario_ID`,
	`Materiale_Rotabile_ID`,
	`Massa`,
	`Descrizione`,
	`Fattura_Numero_Fattura`,
    `Fattura_Azienda_PIVA_Mittente`)
	VALUES
	(var_merce_id,
	var_servizio,
	var_vagone_id,
	var_massa,
	var_descrizione,
    var_fattura,
    var_mittente);

    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_turno
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `aggiungi_turno` (IN var_id INT, IN var_data DATE, IN var_inizio TIME, IN var_fine TIME)

BEGIN
DECLARE EXIT HANDLER FOR sqlexception
 BEGIN
		rollback;
	resignal;
 END;
 
 start transaction;
 INSERT INTO `AziendaFerroviaria`.`Turno`
	(`ID`,
	`Data`,
	`Ora_inizio`,
	`Ora_fine`)
	VALUES
	(var_id,
	var_data,
	var_inizio,
	var_fine);

 commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure assegna_turno
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `assegna_turno` (IN var_lavoratore VARCHAR(16), IN var_turno INT)

BEGIN
DECLARE EXIT HANDLER FOR sqlexception
 BEGIN
rollback;
 resignal;
 
 END;
 set transaction isolation level serializable;
 start transaction;

 if exists (Select * from Malattia where Lavoratore_CF = var_lavoratore and
Turno_ID = var_turno) then
SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Lavoratore in malattia';
 end if;
 
 INSERT IGNORE INTO Copertura VALUES (var_lavoratore, var_turno);
 
 commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure lavoratori_disponibili
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `lavoratori_disponibili` (IN var_data DATE, IN var_inizio 
TIME, IN var_fine TIME)
BEGIN
set transaction read only;
set transaction isolation level serializable;
 start transaction;
 
 select CF, Nome, Cognome
from Lavoratore
where CF not in (
select Lavoratore_CF
from Copertura
join Turno on (Turno_ID = ID)
where Data = var_data and ((var_inizio > Ora_inizio and var_inizio <
Ora_fine) or (var_fine > Ora_inizio and var_fine < Ora_fine)
or (var_inizio <= Ora_inizio and var_fine >= Ora_fine))
 union
select Lavoratore_CF
 from Malattia
 join Turno on (Turno_ID = ID)
 where Data = var_data and ((var_inizio > Ora_inizio and var_inizio <
Ora_fine) or (var_fine > Ora_inizio and var_fine < Ora_fine)
or (var_inizio <= Ora_inizio and var_fine >= Ora_fine)
 ));
 
 commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure report_manutenzione
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `report_manutenzione` (IN var_id INT, IN var_data DATE, IN var_info LONGTEXT, IN var_materiale_rotabile_id INT)
BEGIN

set transaction isolation level read committed;
start transaction;
	INSERT INTO `AziendaFerroviaria`.`Attivita_Manutenzione`
	(`Data`,
	`Info`,
	`Materiale_Rotabile_ID`)
	VALUES
	(var_data,
	var_info,
	var_materiale_rotabile_id);
    
    set var_id = last_insert_id();
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure richiesta_malattia
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `richiesta_malattia` (IN var_lavoratore VARCHAR(16), IN var_turno VARCHAR(10))
BEGIN
set transaction isolation level repeatable read;
 start transaction;
 
insert into Malattia 
 select Lavoratore_CF, Turno_ID
 from Copertura
 where Lavoratore_CF = var_lavoratore and Turno_ID=
var_turno;
 
 delete from Copertura 
where Lavoratore_CF = var_lavoratore and Turno_ID = var_turno;
 
 commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_servizio
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `aggiungi_servizio` (IN var_id INT, IN var_turno INT, IN var_treno VARCHAR(4), IN var_tratta INT, IN var_data DATE)
BEGIN
DECLARE EXIT HANDLER FOR sqlexception
 BEGIN
 rollback;
 resignal;
 END;
 
SET TRANSACTION ISOLATION LEVEL repeatable read;
start transaction;
INSERT INTO `AziendaFerroviaria`.`Servizio_Ferroviario`
(`ID`,
`Turno_ID`,
`Treno_Matricola`,
`Tratta_ID`,
`Data`)
VALUES
(var_id,
var_turno,
var_treno,
var_tratta,
var_data);
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure verifica_prenotazione
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `verifica_prenotazione` (IN var_codice_prenotazione VARCHAR(5))

BEGIN
		set transaction read only;
		set transaction isolation level read committed;
		start transaction;

	SELECT Stato FROM Prenotazione
    WHERE Codice_prenotazione = var_codice_prenotazione;
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure report_lavoratore
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `report_lavoratore` (IN var_lavoratore VARCHAR(16))
BEGIN
set transaction read only;
set transaction isolation level read committed;
 start transaction;
SELECT Lavoratore_CF CF, Turno.Data, Ora_inizio, Ora_fine, Servizio_Ferroviario.ID Codice_Servizio FROM Copertura,Turno,Servizio_Ferroviario,Tratta
where Lavoratore_CF=var_lavoratore and Copertura.Turno_ID=Turno.ID and Servizio_Ferroviario.Turno_ID=Turno.ID and Turno.Data >= current_date
and Servizio_Ferroviario.Tratta_ID=Tratta.ID;
 commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure composizione_treno
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `composizione_treno` (IN var_treno INT)
BEGIN


set transaction read only;
set transaction isolation level read committed;
start transaction;

	select treno_matricola Matricola, Tipo, Classe, N_Vagoni Quantita
	from composizione_treno
	where Treno_matricola = var_treno;

commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure configurazione_treno
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `configurazione_treno` (IN var_treno INT)
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;
	SELECT Treno_Matricola Matricola, Modello_Marca_Nome Marca, Modello_Nome Modello, Tipo, Portata_max, Num_max_passeggeri Pass_max,Classe 
    FROM Materiale_Rotabile, Modello 
    where Modello_Nome=Nome and Modello_Marca_Nome=Marca_Nome and Treno_Matricola = var_treno;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifica_tratta_servizio
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `modifica_tratta_servizio` (IN var_servizio INT, IN var_tratta INT)
BEGIN
DECLARE EXIT HANDLER FOR sqlexception
BEGIN
 rollback;
 resignal;
 END;
 
set transaction isolation level serializable;

start transaction;
UPDATE `AziendaFerroviaria`.`Servizio_Ferroviario`
set Tratta_ID = var_tratta
where ID = var_servizio;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modifica_treno_servizio
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `modifica_treno_servizio` (IN var_servizio INT, IN var_treno VARCHAR(4))
BEGIN
DECLARE EXIT HANDLER FOR sqlexception
 BEGIN
rollback;
 resignal;
 END;
 
set transaction isolation level serializable;

start transaction;
UPDATE `AziendaFerroviaria`.`Servizio_Ferroviario`
set Treno_Matricola = var_treno
where ID = var_servizio;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure tratte_giornaliere
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `tratte_giornaliere` ()
BEGIN
set transaction read only;
set transaction isolation level serializable;
 start transaction;

 SELECT Tratta_ID Tratta, Capolinea_partenza Da, Capolinea_arrivo A, Orario_Partenza Delle  FROM Fermata,Tratta where Tratta_ID=ID and Sequenza=1 order by Orario_Partenza;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure fermate_tratta
-- -----------------------------------------------------

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE PROCEDURE `fermate_tratta` (IN var_tratta INT)
BEGIN
set transaction read only;
set transaction isolation level serializable;
 start transaction;

 SELECT Stazione_Nome_Stazione Stazione,Orario_Partenza Partenza, Orario_Arrivo Arrivo from Fermata where Tratta_ID = var_tratta order by Sequenza;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `AziendaFerroviaria`.`Convoglio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AziendaFerroviaria`.`Convoglio`;
USE `AziendaFerroviaria`;
CREATE  OR REPLACE VIEW Convoglio as SELECT Treno_Matricola, Modello_Marca_Nome, Modello_Nome, Tipo, Portata_max, Num_max_passeggeri,Classe 
FROM Materiale_Rotabile, Modello 
where Modello_Nome=Nome and Modello_Marca_Nome=Marca_Nome
order by Treno_Matricola;

-- -----------------------------------------------------
-- View `AziendaFerroviaria`.`composizione_treno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AziendaFerroviaria`.`composizione_treno`;
USE `AziendaFerroviaria`;
CREATE  OR REPLACE VIEW `composizione_treno` AS
select treno_matricola, tipo, classe, count(*) N_Vagoni
from Convoglio
where (Classe in ('PRIMA','SECONDA') or Tipo='LOCOMOTORE' or Tipo='MERCI') 
group by Treno_Matricola, Tipo, Classe
order by Treno_Matricola;
CREATE USER 'amministratore' IDENTIFIED BY 'amministratore';

GRANT EXECUTE ON procedure `AziendaFerroviaria`.`aggiungi_lavoratore` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`aggiungi_azienda` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`aggiungi_passeggero` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`aggiungi_prenotazione` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`aggiungi_spedizione` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`aggiungi_turno` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`lavoratori_disponibili` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`richiesta_malattia` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`assegna_turno` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`configurazione_treno` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`composizione_treno` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`modifica_treno_servizio` TO 'amministratore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`modifica_tratta_servizio` TO 'amministratore';
CREATE USER 'lavoratore' IDENTIFIED BY 'lavoratore';

GRANT EXECUTE ON procedure `AziendaFerroviaria`.`report_lavoratore` TO 'lavoratore';
CREATE USER 'controllore' IDENTIFIED BY 'controllore';

GRANT EXECUTE ON procedure `AziendaFerroviaria`.`verifica_prenotazione` TO 'controllore';
GRANT EXECUTE ON procedure `AziendaFerroviaria`.`convalida_prenotazione` TO 'controllore';
CREATE USER 'manutentore' IDENTIFIED BY 'manutentore';

GRANT EXECUTE ON procedure `AziendaFerroviaria`.`report_manutenzione` TO 'manutentore';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `AziendaFerroviaria`;

DELIMITER $$
USE `AziendaFerroviaria`$$
CREATE DEFINER = CURRENT_USER TRIGGER `AziendaFerroviaria`.`Turno_BEFORE_INSERT` BEFORE INSERT ON `Turno` FOR EACH ROW
BEGIN
 
IF(new.Ora_inizio > new.Ora_fine) THEN
SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Orari non validi';
ELSEIF(TIMEDIFF(new.Ora_fine, new.Ora_inizio) > "4") THEN
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Il turno deve essere di un massimo di 4 ore';
END IF;
END$$

USE `AziendaFerroviaria`$$
CREATE DEFINER = CURRENT_USER TRIGGER `AziendaFerroviaria`.`Copertura_BEFORE_INSERT` BEFORE INSERT ON `Copertura` FOR EACH ROW

BEGIN
DECLARE n INT;
DECLARE d DATE;

select data INTO d from Turno where ID=new.Turno_ID;

SELECT count(*) INTO n from Copertura, Turno where Turno_ID=ID and Lavoratore_CF=new.Lavoratore_CF and week(d)=week(Data) and year(d) = year(Data);

    IF(n >= 5) THEN
    SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Massimo numero di turni raggiunto';
    END IF;
END$$


DELIMITER ;
