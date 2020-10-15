CREATE DATABASE IF NOT EXISTS `optimus_user_1` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `optimus_user_1`;

CREATE TABLE IF NOT EXISTS `agendas` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `nom` varchar(32) DEFAULT NULL,
  `couleur` varchar(6) DEFAULT 'FF0000',
  `affichage` bit NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `agendas_evenements` (
  `id` int unsigned NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  `debut` datetime DEFAULT NULL,
  `fin` datetime DEFAULT NULL,
  `allday` bit NOT NULL,
  `lieu` varchar(128) DEFAULT NULL,
  `dossier` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `authorizations` (
  `email` varchar(128) DEFAULT NULL,
  `resource` varchar(128) DEFAULT NULL,
  `read` bit NOT NULL DEFAULT 0,
  `write` bit NOT NULL DEFAULT 0,
  PRIMARY KEY (`email`,`resource`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `contacts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint unsigned NOT NULL DEFAULT 30,
  `title` tinyint unsigned NOT NULL DEFAULT 0,
  `firstname` varchar(255) DEFAULT '',
  `lastname` varchar(255) DEFAULT '',
  `birth_date` date DEFAULT NULL,
  `birth_zipcode` varchar(255) DEFAULT NULL,
  `birth_city` varchar(255) DEFAULT NULL,
  `birth_city_name` varchar(255) DEFAULT NULL,
  `birth_country` int unsigned NOT NULL DEFAULT 0,
  `insee` varchar(255) DEFAULT NULL,
  `marital_status` tinyint unsigned NOT NULL DEFAULT 0,
  `maiden_name` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT '',
  `company_type` smallint unsigned NOT NULL DEFAULT 0,
  `company_capital` varchar(255) DEFAULT NULL,
  `rcs` varchar(255) DEFAULT NULL,
  `siret` varchar(255) DEFAULT NULL,
  `company_registration_city` smallint unsigned NOT NULL DEFAULT '0',
  `company_representative` tinyint unsigned NOT NULL DEFAULT 0,
  `address` varchar(255) DEFAULT NULL,
  `zipcode` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `city_name` varchar(255) DEFAULT NULL,
  `country` int unsigned NOT NULL DEFAULT 74,
  `phone` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `company` int unsigned NOT NULL DEFAULT 0,
  `job_title` varchar(255) DEFAULT NULL,
  `pro_phone` varchar(255) DEFAULT NULL,
  `pro_fax` varchar(255) DEFAULT NULL,
  `pro_mobile` varchar(255) DEFAULT NULL,
  `pro_email` varchar(255) DEFAULT NULL,
  `pro_website` varchar(255) DEFAULT NULL,
  `iban` varchar(255) DEFAULT NULL,
  `bic` varchar(255) DEFAULT NULL,
  `tva` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `categorie` tinyint unsigned DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `dossiers_intervenants` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `dossier` int unsigned NOT NULL,
  `contact` int unsigned NOT NULL,
  `qualite` smallint unsigned NOT NULL,
  `lien` int unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `dossiers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `numero` varchar(255) DEFAULT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `date_ouverture` date DEFAULT NULL,
  `date_classement` date DEFAULT NULL,
  `numero_archive` int unsigned DEFAULT NULL,
  `domaine` tinyint unsigned NOT NULL DEFAULT 0,
  `sous_domaine` tinyint unsigned NOT NULL DEFAULT 0,
  `conseil` bit NOT NULL DEFAULT b'0',
  `contentieux` bit NOT NULL DEFAULT b'0',
  `aj` bit NOT NULL DEFAULT b'0',
  `notes` text DEFAULT NULL,
  `rg` varchar(8) DEFAULT NULL,
  `portalis` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `fax` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(8) DEFAULT '',
  `recipient` varchar(15) DEFAULT NULL,
  `sender` varchar(15) DEFAULT NULL,
  `dossier` int unsigned DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `status` varchar(8) DEFAULT NULL,
  `status_message` varchar(255) DEFAULT NULL,
  `date_sent` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `pages` smallint unsigned DEFAULT NULL,
  `pages_sent` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `interventions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `dossier` int unsigned NOT NULL DEFAULT 0,
  `date_ouverture` date DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `db` varchar(16) DEFAULT NULL,
  `honoraires` decimal(10,2) DEFAULT NULL,
  `frais` decimal(10,2) DEFAULT NULL,
  `debours` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `interventions_diligences` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `intervention` int unsigned NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL,
  `intervenant` int unsigned NOT NULL DEFAULT 0,
  `compte` int unsigned NOT NULL DEFAULT 0,
  `commission` decimal(2,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `categorie` tinyint unsigned NOT NULL DEFAULT 0,
  `type` tinyint unsigned NOT NULL DEFAULT 0,
  `coefficient` decimal(5,2) NOT NULL DEFAULT 0.00,
  `tarif` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `settings` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `structures` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `structure` varchar(128) DEFAULT NULL,
  `server` varchar(128) DEFAULT NULL,
  `entree` date DEFAULT NULL,
  `sortie` date DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
