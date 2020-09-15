CREATE TABLE IF NOT EXISTS `agendas` (
  `id` smallint(5) unsigned NOT NULL,
  `nom` varchar(32) DEFAULT NULL,
  `couleur` varchar(6) DEFAULT NULL,
  `affichage` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `agendas_evenements` (
  `id` int(10) unsigned NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  `debut` datetime DEFAULT NULL,
  `fin` datetime DEFAULT NULL,
  `allday` bit(1) NOT NULL,
  `lieu` varchar(128) DEFAULT NULL,
  `dossier` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `dossiers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` varchar(255) DEFAULT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `client` int(11) NOT NULL DEFAULT 0,
  `adversaire` int(11) NOT NULL DEFAULT 0,
  `avocat` int(11) NOT NULL DEFAULT 0,
  `date_ouverture` date DEFAULT NULL,
  `date_classement` date DEFAULT NULL,
  `numero_archive` int(11) DEFAULT NULL,
  `apporteur` int(11) NOT NULL DEFAULT 0,
  `domaine` tinyint(4) NOT NULL DEFAULT 0,
  `sous_domaine` tinyint(4) NOT NULL DEFAULT 0,
  `conseil` tinyint(1) NOT NULL DEFAULT 0,
  `contentieux` tinyint(1) NOT NULL DEFAULT 0,
  `aj` tinyint(1) NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `rg` varchar(8) DEFAULT NULL,
  `portalis` varchar(16) DEFAULT NULL,
  `juridiction` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `fax` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(8) DEFAULT '',
  `recipient` varchar(15) DEFAULT NULL,
  `sender` varchar(15) DEFAULT NULL,
  `dossier` int(11) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `status` varchar(8) DEFAULT NULL,
  `status_message` varchar(255) DEFAULT NULL,
  `date_sent` datetime DEFAULT NULL,
  `date_updated` datetime DEFAULT NULL,
  `pages` smallint(6) DEFAULT NULL,
  `pages_sent` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=515 DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `interventions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dossier` int(11) NOT NULL DEFAULT 0,
  `date_ouverture` date DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `db` varchar(16) DEFAULT NULL,
  `honoraires` decimal(10,2) DEFAULT NULL,
  `frais` decimal(10,2) DEFAULT NULL,
  `debours` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=90 DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `interventions_diligences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intervention` int(11) NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL,
  `intervenant` int(11) NOT NULL DEFAULT 0,
  `compte` int(11) NOT NULL DEFAULT 0,
  `commission` decimal(2,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `categorie` tinyint(4) NOT NULL DEFAULT 0,
  `type` tinyint(4) NOT NULL DEFAULT 0,
  `coefficient` decimal(5,2) NOT NULL DEFAULT 0.00,
  `tarif` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=80 DEFAULT CHARSET=latin1;
