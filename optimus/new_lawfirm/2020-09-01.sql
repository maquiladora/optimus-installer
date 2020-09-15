CREATE TABLE IF NOT EXISTS `bilans` (
  `id` varchar(2) NOT NULL,
  `exercice` year(4) NOT NULL,
  `montant` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`exercice`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `compta_affectations` (
  `id` int(11) NOT NULL,
  `regle` int(11) DEFAULT NULL,
  `poste` varchar(255) DEFAULT NULL,
  `modifier` varchar(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `montant` varchar(32) DEFAULT NULL,
  `repartition` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `compta_affectations` VALUES (1,1,'62810000','now','COTISATION ORDINALE - %Y-%m',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (2,2,'10820000','-20 days','PRELEVEMENT PERSONNEL - %Y-%m',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (3,3,'10820000','now','CRDS NON DEDUCTIBLE - %Y-%m','-32',NULL);
INSERT INTO `compta_affectations` VALUES (4,3,'64620000','now','ALLOCATIONS FAMILIALES - %Y-%m','-247',NULL);
INSERT INTO `compta_affectations` VALUES (5,3,'64610000','now','RSI - %Y-%m',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (6,3,'63700000','now','CSG DEDUCTIBLE - %Y-%m','-323',NULL);
INSERT INTO `compta_affectations` VALUES (7,3,'10820000','now','CSG NON DEDUCTIBLE - %Y-%m','-152',NULL);
INSERT INTO `compta_affectations` VALUES (8,3,'63580000','now','CONTRIBUTION A LA FORMATION PROFESSIONNELLE','-97',NULL);
INSERT INTO `compta_affectations` VALUES (9,4,'64640000','now','CNBF (COTISATION) - %Y-%m',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (10,5,'64640000','now','CNBF (DROIT EQUIVALENT) - %Y-%m',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (11,6,'64640000','-100 days','CNBF (TIMBRE DE PLAIDOIRIE) - %Y-',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (12,7,'63580000','now','CFE - %Y',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (13,8,'64630000','now','PREVOYANCE - %Y-%m',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (14,9,'64630000','now','MUTUELLE SANTE - %Y-%m',NULL,NULL);
INSERT INTO `compta_affectations` VALUES (15,10,'64630000','now','EPARGNE RETRAITE -%Y-%m',NULL,NULL);


CREATE TABLE IF NOT EXISTS `compta_comptes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `banque` varchar(255) DEFAULT NULL,
  `code_banque` char(5) DEFAULT NULL,
  `code_agence` char(5) DEFAULT NULL,
  `numero` char(11) DEFAULT NULL,
  `cle` char(2) DEFAULT NULL,
  `bic` char(11) DEFAULT NULL,
  `iban` char(27) DEFAULT NULL,
  `login` varchar(32) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL,
  `import_script` varchar(16) DEFAULT NULL,
  `import_start` date DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `compta_depenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operation` int(11) NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL,
  `montant` decimal(10,2) NOT NULL DEFAULT 0.00,
  `description` varchar(255) DEFAULT NULL,
  `compte` varchar(8) NOT NULL DEFAULT '0',
  `piece` int(11) DEFAULT NULL,
  `repartition` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `compta_operations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `montant` decimal(10,2) DEFAULT 0.00,
  `description` varchar(255) DEFAULT NULL,
  `compte` tinyint(4) NOT NULL DEFAULT 2,
  `import_date` date DEFAULT NULL,
  `solde` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `compta_plan` (
  `id` varchar(8) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `pcg` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `compta_plan` VALUES ('00000000','Opérations en cours d\'affectation','Toutes les opérations dont le numéro de compte n\'a pas encore été renseigné',0);
INSERT INTO `compta_plan` VALUES ('47100000','Compte d\'attente - Opérations à solde nul','Opérations aller-retour à solde nul (chèques impayés, erreurs de virement …)',1);
INSERT INTO `compta_plan` VALUES ('10820000','Compte de l\'exploitant','prélèvements personnels ou assimilés (épargne salariale, dépenses personnelles, CSG non déductible)',0);
INSERT INTO `compta_plan` VALUES ('21831000','Immobilisations - Matériel de bureau','',1);
INSERT INTO `compta_plan` VALUES ('21832000','Immobilisations - Matériel Informatiques','',1);
INSERT INTO `compta_plan` VALUES ('21833000','Immobilisations - Logiciels','',1);
INSERT INTO `compta_plan` VALUES ('21840000','Immobilisations - Mobilier','',1);
INSERT INTO `compta_plan` VALUES ('27510000','Dépôts Versés','Dépôt de Garantie du Bail',1);
INSERT INTO `compta_plan` VALUES ('44551000','TVA - TVA décaissée','Chèques mensuels de TVA débités',1);
INSERT INTO `compta_plan` VALUES ('44562000','TVA - TVA déductible sur immobilisations','',1);
INSERT INTO `compta_plan` VALUES ('44566000','TVA - TVA déductible sur autres biens et services','A priori toute la TVA déductible ira dans ce poste, sauf celle relative aux immobilisations',1);
INSERT INTO `compta_plan` VALUES ('44567000','TVA - Crédit de TVA à reporter','Doit-on vraiment utiliser ce compte en comptabilité BNC ?',1);
INSERT INTO `compta_plan` VALUES ('44571100','TVA - TVA collectée à 19,6 %','',1);
INSERT INTO `compta_plan` VALUES ('44571200','TVA - TVA collectée à 5,5%','',1);
INSERT INTO `compta_plan` VALUES ('51211000','Compte bancaire N°1','',0);
INSERT INTO `compta_plan` VALUES ('58000000','Virements internes','Enregistrement de tous les virements internes de compte à compte',1);
INSERT INTO `compta_plan` VALUES ('60410000','Rétrocessions aux collaborateurs du cabinet','Rétrocession des collaborateurs du cabinet. Attention, lorsqu\'ils refacturent des frais, il faut ventiler. Il faut donc vérifier leurs factures',0);
INSERT INTO `compta_plan` VALUES ('60510000','Achat de Mobilier','Ne constituant pas une immobilisation, càd < 500 € HT',0);
INSERT INTO `compta_plan` VALUES ('60520000','Achat d\'équipement informatique','Ne constituant pas une immobilisation, càd < 500 € HT',0);
INSERT INTO `compta_plan` VALUES ('60530000','Achat de logiciels','Ne constituant pas une immobilisation, càd < 500 € HT',0);
INSERT INTO `compta_plan` VALUES ('60540000','Achat de matériel de bureau','Ne constituant pas une immobilisation, càd < ??? € HT',0);
INSERT INTO `compta_plan` VALUES ('60611000','Eau','Pour mémoire car je crois que l\'eau est incluse dans les charges',0);
INSERT INTO `compta_plan` VALUES ('60612000','Electricité','Factures d\'électricité ou montant refacturé par MC',0);
INSERT INTO `compta_plan` VALUES ('60613000','Fioul','Pour mémoire car pas de fioul',0);
INSERT INTO `compta_plan` VALUES ('60630000','Fournitures d\'entretien et de petit équipement','Petit matériel de bureau (balance, machine à étiqueter …)',0);
INSERT INTO `compta_plan` VALUES ('60640000','Fournitures administratives','Consommables (papier, stylos, CD-ROM, hamacs, piles, agrafes …)',0);
INSERT INTO `compta_plan` VALUES ('60680000','Autres matières et fournitures','Tout ce qui ne va ni dans 6064, ni dans 6063',0);
INSERT INTO `compta_plan` VALUES ('60810000','Débours - Frais d\'huissier','Débours refacturés au cent prêt, sans application de TVA, et dont la facture est communiquée au client',0);
INSERT INTO `compta_plan` VALUES ('60820000','Débours - Frais de greffe','Débours refacturés au cent prêt, sans application de TVA, et dont la facture est communiquée au client',0);
INSERT INTO `compta_plan` VALUES ('60830000','Débours - Frais de publication légale','Débours refacturés au cent prêt, sans application de TVA, et dont la facture est communiquée au client',0);
INSERT INTO `compta_plan` VALUES ('60880000','Débours - Autres débours refacturables','Tous les débours qui n\'entrent dans aucun autre des comptes 608',0);
INSERT INTO `compta_plan` VALUES ('61110000','Sous traitance de courrier','Dépôt et enlèvement du courrier habituellement refacturé par MC',1);
INSERT INTO `compta_plan` VALUES ('61220000','Redevances de Crédit Bail mobilier','Location des photocopieurs',1);
INSERT INTO `compta_plan` VALUES ('61250000','Redevances de Crédit-Bail immobilier','',1);
INSERT INTO `compta_plan` VALUES ('61320000','Locations immobilières','Loyers hors charges et avances sur charges',1);
INSERT INTO `compta_plan` VALUES ('61350000','Locations mobilières','Location des photocopieurs',1);
INSERT INTO `compta_plan` VALUES ('61410000','Charges locatives','Avances sur charges telles qu\'elles apparaissent sur les factures de loyer, régularisation annuelle des charges',1);
INSERT INTO `compta_plan` VALUES ('61420000','Charges de copropriété','',1);
INSERT INTO `compta_plan` VALUES ('61520000','Entretien des biens immobiliers','Nettoyage SANI',1);
INSERT INTO `compta_plan` VALUES ('61550000','Entretien des biens mobiliers','',1);
INSERT INTO `compta_plan` VALUES ('61560000','Maintenance','Maintenance informatique ? Maintenance téléphonique ?',1);
INSERT INTO `compta_plan` VALUES ('61600000','Primes d\'assurance','Toutes les cotisations de toutes les assurances (multirisques etc …)',1);
INSERT INTO `compta_plan` VALUES ('61700000','Etudes et recherches','',1);
INSERT INTO `compta_plan` VALUES ('61810000','Documentation générale','',1);
INSERT INTO `compta_plan` VALUES ('61830000','Documentation technique','A priori on a que de la doc technique. On met aussi dans ce poste les abonnements électroniques : LEXISNEXIS + NAVIS refacturé par MC',1);
INSERT INTO `compta_plan` VALUES ('61850000','Frais de colloques, séminaires, conférences','Frais de transport, hébergement, repas, inscription, essence pour les conférences, notamment IPG',1);
INSERT INTO `compta_plan` VALUES ('62260000','Honoraires versés à des intermédiaires extérieurs','Honoraires IN EXTENSO notamment',1);
INSERT INTO `compta_plan` VALUES ('62270000','Frais d\'actes et de contentieux','Forfait de 60 € versés à l\'Ordre pour les procédures de taxation d\'honoraires',1);
INSERT INTO `compta_plan` VALUES ('62310000','Publicité du cabinet - Annonces et insertions','Pages Jaunes, Google ADWORDS',1);
INSERT INTO `compta_plan` VALUES ('62340000','Publicité du cabinet - Cadeaux à la clientèle','',1);
INSERT INTO `compta_plan` VALUES ('62360000','Publicité du cabinet - Catalogues et imprimés','Plaquette du cabinet et cartes de visite',1);
INSERT INTO `compta_plan` VALUES ('62370000','Publicité du cabinet - Publications','Y compris les frais liés au site internet, dont notamment le renouvellement des noms de domaine qui appartiennent à ADARIS',1);
INSERT INTO `compta_plan` VALUES ('61860000','Abonnement RPVA','Abonnement RPVA',0);
INSERT INTO `compta_plan` VALUES ('60420000','Rétrocessions à des avocats postulants ou correspondants ','Postulants ou correspondants qui assurent exclusivement le suivi des audiences pour nous',0);
INSERT INTO `compta_plan` VALUES ('60430000','Rétrocessions à des avocats sous-traitants','Avocats qui sous-traitent une partie de la prestation (avocats spécialisés)',0);
INSERT INTO `compta_plan` VALUES ('60440000','Rétrocessions à des avocats apporteurs ','Commissions versés à des avocats apporteurs du dossier, telle que partage des honoraires de résultats par exemple.',0);
INSERT INTO `compta_plan` VALUES ('61871000','Frais de gestion de portefeuilles - Marques','Frais et Taxes liés à la gestion de portefeuilles de titres de PI - refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('61872000','Frais de gestion de portefeuilles - Dessins et Modèles','Frais et Taxes liés à la gestion de portefeuilles de titres de PI - refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('61873000','Frais de gestion de portefeuilles - Brevets','Frais et Taxes liés à la gestion de portefeuilles de titres de PI - refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('61874000','Frais de gestion de portefeuilles - Noms de domaine','Frais et Taxes liés à la gestion de portefeuilles de titres de PI - refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561110','Missions extérieures - Pour dossier - Transport - Avion','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561120','Missions extérieures - Pour dossier - Transport - Train / RER','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561130','Missions extérieures - Pour dossier - Transport - Métro','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561140','Missions extérieures - Pour dossier - Transport - Taxi','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62411000','Missions extérieures - Pour dossier - Transport - Indemnité Km','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561160','Missions extérieures - Pour dossier - Transport - Péages','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561170','Missions extérieures - Pour dossier - Transport - Parking','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561180','Missions extérieures - Pour dossier - Transport - Essence','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561200','Missions extérieures - Pour dossier - Hébergement','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62561100','Missions extérieures - Pour dossier - Repas','Déplacements effectués pour les besoins d\'un dossier, refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562110','Missions extérieures - Pour cabinet - Transport - Avion','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562120','Missions extérieures - Pour  cabinet - Transport - Train / RER','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562130','Missions extérieures - Pour  cabinet - Transport - Métro','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562140','Missions extérieures - Pour  cabinet - Transport - Taxi','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562150','Missions extérieures - Pour  cabinet - Transport - Indemnité Km','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562160','Missions extérieures - Pour  cabinet - Transport - Péages','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562170','Missions extérieures - Pour  cabinet - Transport - Parking','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562180','Missions extérieures - Pour  cabinet - Transport - Essence','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562200','Missions extérieures - Pour  cabinet - Hébergement','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62562100','Missions extérieures - Pour  cabinet - Repas','Déplacements effectués pour les besoins du cabinet, non refacturés au client',0);
INSERT INTO `compta_plan` VALUES ('62571000','Repas avec des membres du cabinet','',0);
INSERT INTO `compta_plan` VALUES ('62572000','Repas avec des tiers','Repas avec des clients, prestataires, apporteurs, prospects ...',0);
INSERT INTO `compta_plan` VALUES ('62573000','Sorties avec les collaborateurs','Repas de Noel, Séminaires ...',0);
INSERT INTO `compta_plan` VALUES ('62610000','Affranchissement et frais postaux','Achat de timbres, achat de liasses recommandées, frais postaux pour l\'envoi de colis, frais d\'enlèvement du courrier',1);
INSERT INTO `compta_plan` VALUES ('62620000','Téléphone','Abonnement téléphonique et communications',0);
INSERT INTO `compta_plan` VALUES ('62630000','Internet','Abonnement Internet',0);
INSERT INTO `compta_plan` VALUES ('62780000','Autres frais et commissions sur prestation de service','',1);
INSERT INTO `compta_plan` VALUES ('62810000','Cotisation syndicales et professionnelles','Cotisation ordinale ou autres',1);
INSERT INTO `compta_plan` VALUES ('63511000','Taxe professionnelles','Pour mémoire car payé par chaque avocat personnellement : taxe professionnelle (CFE et CVAE)',1);
INSERT INTO `compta_plan` VALUES ('63580000','Autres droits','contribution à la formation continue payée avec l\'une des échéances URSSAF',1);
INSERT INTO `compta_plan` VALUES ('63700000','Autres impôts, taxes et versements assimilés (autres organismes)','CSG déductible',1);
INSERT INTO `compta_plan` VALUES ('64110000','Charges de personnel - Salaires et appointements','Concerne uniquement les salariés, pas les collaborateurs. Salaires nets versés',1);
INSERT INTO `compta_plan` VALUES ('64120000','Charges de personnel - Congés payés','',1);
INSERT INTO `compta_plan` VALUES ('64130000','Charges de personnel - Primes et gratifications','',1);
INSERT INTO `compta_plan` VALUES ('64140000','Charges de personnel - Indemnités et avantages divers','Indemnité de licenciement',1);
INSERT INTO `compta_plan` VALUES ('64150000','Charges de personnel - Supplément familial','',1);
INSERT INTO `compta_plan` VALUES ('64510000','Charges de personnel - Cotisations URSSAF','',1);
INSERT INTO `compta_plan` VALUES ('64520000','Charges de personnel - Cotisations aux mutuelles','N/A',1);
INSERT INTO `compta_plan` VALUES ('64530000','Charges de personnel - Cotisations aux Caisses de retraites','CREPA (part retraite)',1);
INSERT INTO `compta_plan` VALUES ('64540000','Charges de personnel - Cotisations ASSEDIC','',1);
INSERT INTO `compta_plan` VALUES ('64580000','Charges de personnel - Cotisations aux autres organismes sociaux','',1);
INSERT INTO `compta_plan` VALUES ('64610000','Cotisations personnelles des associés - Sécurité sociale','Pour mémoire car payé par chaque avocat personnellement : Mutuelle de l\'Est',0);
INSERT INTO `compta_plan` VALUES ('64620000','Cotisations personnelles des associés - URSSAF','Cotisations personnelles des dirigeants',0);
INSERT INTO `compta_plan` VALUES ('64630000','Cotisations personnelles des associés - Mutuelles','Cotisations personnelles des dirigeants : Mutuelles et Prévoyances MADELIN (part déductible)',0);
INSERT INTO `compta_plan` VALUES ('64640000','Cotisations personnelles des associés - Retraite','Cotisations personnelles des dirigeants : CNBF, droits de plaidoirie, contribution équivalente',0);
INSERT INTO `compta_plan` VALUES ('64750000','Charges de personnel - Médecine du travail','',1);
INSERT INTO `compta_plan` VALUES ('65160000','Droits d\'auteurs et de reproduction','Redevance SACEM pour l\'attente téléphonique, SDRM, SPPF',1);
INSERT INTO `compta_plan` VALUES ('65800000','Charges diverses de gestion courante','Toutes les petites charges qui n\'entrent dans aucune autre catégorie',1);
INSERT INTO `compta_plan` VALUES ('66110000','Intérêts des emprunts et dettes','Agios sur découvert bancaire',1);
INSERT INTO `compta_plan` VALUES ('66600000','Pertes de change','',1);
INSERT INTO `compta_plan` VALUES ('67120000','Pénalités, amendes fiscales et pénales','Pénalités non refacturables au client, notamment pour dépôt tardif d\'un acte à l\'enregistrement',1);
INSERT INTO `compta_plan` VALUES ('70611000','Honoraires sur prestations réalisées en France','',0);
INSERT INTO `compta_plan` VALUES ('70612000','Honoraires sur prestations réalisées dans l\'UE, hors France','',0);
INSERT INTO `compta_plan` VALUES ('70613000','Honoraires sur prestations réalisées hors UE','',0);
INSERT INTO `compta_plan` VALUES ('70651000','Frais refacturés sur prestations réalisées en France','',0);
INSERT INTO `compta_plan` VALUES ('70652000','Frais refacturés sur prestations réalisées dans l\'UE, hors France','',0);
INSERT INTO `compta_plan` VALUES ('70653000','Frais refacturés sur prestations réalisées hors UE','',0);
INSERT INTO `compta_plan` VALUES ('70661000','Débours refacturés sur prestations réalisées en France','',0);
INSERT INTO `compta_plan` VALUES ('70662000','Débours refacturés sur prestations réalisées dans l\'UE, hors France','',0);
INSERT INTO `compta_plan` VALUES ('70663000','Débours refacturés sur prestations réalisées hors UE','',0);
INSERT INTO `compta_plan` VALUES ('70800000','Gains divers',NULL,1);
INSERT INTO `compta_plan` VALUES ('76000000','Produits financiers','Intérêts générés sur des comptes rémunérés',1);
INSERT INTO `compta_plan` VALUES ('60840000','Débours - Frais de placement','Frais de placement d\'assignation',0);
INSERT INTO `compta_plan` VALUES ('60850000','Débours - Taxe d\'Enrôlement','Contribution pour l\'aide juridique de 35 ou 150 € payée à l\'introduction de certaines procédures',0);
INSERT INTO `compta_plan` VALUES ('61831000','Documentation spécialisée marques','',0);
INSERT INTO `compta_plan` VALUES ('63330000','Participation des employeurs à la formation professionnelle continue','CREPA (part formation professionnelle)',0);
INSERT INTO `compta_plan` VALUES ('68112000','Dotation aux amortissements',NULL,0);
INSERT INTO `compta_plan` VALUES ('75800000','Produits d\'activités annexes','',0);
INSERT INTO `compta_plan` VALUES ('64700000','Tickets Restaurants','Tickets Restaurants',0);


CREATE TABLE IF NOT EXISTS `compta_recettes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operation` int(11) NOT NULL,
  `facture` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `montant` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `compta_regles` (
  `id` tinyint(4) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `libelle_valeur` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `compta_regles` VALUES (1,'Cotisation Ordinale','ORDRE DES AVOCATS');
INSERT INTO `compta_regles` VALUES (2,'Prélèvements Personnels','Perso');
INSERT INTO `compta_regles` VALUES (3,'URSSAF','URSSAF');
INSERT INTO `compta_regles` VALUES (4,'CNBF (Cotisation)','CNBF');
INSERT INTO `compta_regles` VALUES (5,'CNBF (Droit équivalent)','CNBF');
INSERT INTO `compta_regles` VALUES (6,'CNBF (Droit de plaidoirie)','CHQ');
INSERT INTO `compta_regles` VALUES (7,'CFE','CFE');
INSERT INTO `compta_regles` VALUES (8,'Prévoyance','ADIS');
INSERT INTO `compta_regles` VALUES (9,'Mutuelle Santé','GIEPS');
INSERT INTO `compta_regles` VALUES (10,'Epargne Retraite','ADIS');


CREATE TABLE IF NOT EXISTS `factures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` varchar(255) DEFAULT NULL,
  `client` int(11) NOT NULL DEFAULT 0,
  `dossier` int(11) NOT NULL DEFAULT 0,
  `intervention` int(11) NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL,
  `language` tinyint(4) NOT NULL DEFAULT 2,
  `template` tinyint(4) NOT NULL DEFAULT 1,
  `tva` tinyint(4) NOT NULL DEFAULT 6,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `provision` tinyint(1) NOT NULL DEFAULT 0,
  `reminder1` date DEFAULT NULL,
  `reminder2` date DEFAULT NULL,
  `reminder3` date DEFAULT NULL,
  `reminder4` date DEFAULT NULL,
  `reminder5` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `db` varchar(16) NOT NULL DEFAULT 'vest',
  `irrecouvrable` tinyint(1) NOT NULL DEFAULT 0,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=86 DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `factures_paiements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facture` int(11) NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_method` tinyint(4) NOT NULL DEFAULT 0,
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `factures_templates` (
  `id` tinyint(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
INSERT INTO `factures_templates` VALUES (1,'DEFAUT');


CREATE DATABASE IF NOT EXISTS `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `type` smallint(6) unsigned NOT NULL DEFAULT 10,
  `firstname` varchar(32) DEFAULT NULL,
  `lastname` varchar(32) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `initials` varchar(3) NOT NULL DEFAULT 'XXX',
  `color` varchar(6) DEFAULT NULL,
  `db` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE DATABASE IF NOT EXISTS `users_rights` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user` tinyint(4) unsigned NOT NULL DEFAULT 0,
  `db` varchar(16) NOT NULL DEFAULT '',
  `app` varchar(16) NOT NULL DEFAULT '',
  `write_access` tinyint(1) NOT NULL DEFAULT 0,
  `settings` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE DATABASE IF NOT EXISTS `users_structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) DEFAULT NULL,
  `structure` varchar(16) DEFAULT NULL,
  `entree` date DEFAULT NULL,
  `sortie` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;


CREATE DATABASE IF NOT EXISTS `users_types` (
  `id` tinyint(4) NOT NULL DEFAULT 0,
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `users_types` VALUES (0,'Admin');
INSERT INTO `users_types` VALUES (10,'Associé');
INSERT INTO `users_types` VALUES (20,'Collaborateur');
INSERT INTO `users_types` VALUES (100,'Client');
