CREATE DATABASE IF NOT EXISTS `optimus` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `optimus`;


CREATE TABLE IF NOT EXISTS `apps` (
  `module` varchar(16) NOT NULL,
  `app` varchar(16) NOT NULL,
  `link` varchar(255) NOT NULL,
  `position` smallint(6) unsigned NOT NULL,
  PRIMARY KEY (`module`,`app`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `apps` VALUES ('user','dossiers','modules/dossiers/index.php',100);
INSERT INTO `apps` VALUES ('user','contacts','modules/contacts/index.php',200);
INSERT INTO `apps` VALUES ('user','interventions','modules/interventions/index.php',300);
INSERT INTO `apps` VALUES ('structure','factures','modules/compta/factures/index.php',100);
INSERT INTO `apps` VALUES ('structure','compta','modules/compta/grand-livre.php',200);
INSERT INTO `apps` VALUES ('structure','releves','modules/compta/releves/index.php',300);
INSERT INTO `apps` VALUES ('structure','des','modules/compta/des.php',400);
INSERT INTO `apps` VALUES ('structure','tva','modules/compta/tva.php',500);
INSERT INTO `apps` VALUES ('structure','recettes','modules/compta/recettes.php',600);
INSERT INTO `apps` VALUES ('structure','stats','modules/compta/stats/index.php',700);
INSERT INTO `apps` VALUES ('structure','benefices','modules/compta/benefices.php',800);


CREATE TABLE IF NOT EXISTS `company_types_lvl1` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `company_types_lvl1` VALUES (1,'Entrepreneur individuel');
INSERT INTO `company_types_lvl1` VALUES (2,'Groupement de droit privé non doté de la personnalité morale');
INSERT INTO `company_types_lvl1` VALUES (3,'Personne morale de droit étranger');
INSERT INTO `company_types_lvl1` VALUES (4,'Personne morale de droit public soumise au droit commercial');
INSERT INTO `company_types_lvl1` VALUES (5,'Société commerciale');
INSERT INTO `company_types_lvl1` VALUES (6,'Autre personne morale immatriculée au RCS');
INSERT INTO `company_types_lvl1` VALUES (7,'Personne morale et organisme soumis au droit administratif');
INSERT INTO `company_types_lvl1` VALUES (8,'Organisme privé spécialisé');
INSERT INTO `company_types_lvl1` VALUES (9,'Groupement de droit privé');


CREATE TABLE IF NOT EXISTS `company_types_lvl2` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `company_types_lvl2` VALUES (10,'Entrepreneur individuel');
INSERT INTO `company_types_lvl2` VALUES (21,'Indivision');
INSERT INTO `company_types_lvl2` VALUES (22,'Société créée de fait');
INSERT INTO `company_types_lvl2` VALUES (23,'Société en participation');
INSERT INTO `company_types_lvl2` VALUES (24,'Fiducie ');
INSERT INTO `company_types_lvl2` VALUES (27,'Paroisse hors zone concordataire');
INSERT INTO `company_types_lvl2` VALUES (29,'Autre groupement de droit privé non doté de la personnalité morale');
INSERT INTO `company_types_lvl2` VALUES (31,'Personne morale de droit étranger, immatriculée au RCS (registre du commerce et des sociétés)');
INSERT INTO `company_types_lvl2` VALUES (32,'Personne morale de droit étranger, non immatriculée au RCS');
INSERT INTO `company_types_lvl2` VALUES (41,'Etablissement public ou régie à caractère industriel ou commercial');
INSERT INTO `company_types_lvl2` VALUES (51,'Société coopérative commerciale particulière');
INSERT INTO `company_types_lvl2` VALUES (52,'Société en nom collectif');
INSERT INTO `company_types_lvl2` VALUES (53,'Société en commandite');
INSERT INTO `company_types_lvl2` VALUES (54,'Société à responsabilité limitée (SARL)');
INSERT INTO `company_types_lvl2` VALUES (55,'Société anonyme à conseil d\'administration');
INSERT INTO `company_types_lvl2` VALUES (56,'Société anonyme à directoire');
INSERT INTO `company_types_lvl2` VALUES (57,'Société par actions simplifiée');
INSERT INTO `company_types_lvl2` VALUES (58,'Société européenne ');
INSERT INTO `company_types_lvl2` VALUES (61,'Caisse d\'épargne et de prévoyance');
INSERT INTO `company_types_lvl2` VALUES (62,'Groupement d\'intérêt économique');
INSERT INTO `company_types_lvl2` VALUES (63,'Société coopérative agricole');
INSERT INTO `company_types_lvl2` VALUES (64,'Société d\'assurance mutuelle');
INSERT INTO `company_types_lvl2` VALUES (65,'Société civile');
INSERT INTO `company_types_lvl2` VALUES (69,'Autre personne morale de droit privé inscrite au registre du commerce et des sociétés');
INSERT INTO `company_types_lvl2` VALUES (71,'Administration de l\'état');
INSERT INTO `company_types_lvl2` VALUES (72,'Collectivité territoriale');
INSERT INTO `company_types_lvl2` VALUES (73,'Etablissement public administratif');
INSERT INTO `company_types_lvl2` VALUES (74,'Autre personne morale de droit public administratif');
INSERT INTO `company_types_lvl2` VALUES (81,'Organisme gérant un régime de protection sociale à adhésion obligatoire');
INSERT INTO `company_types_lvl2` VALUES (82,'Organisme mutualiste');
INSERT INTO `company_types_lvl2` VALUES (83,'Comité d\'entreprise');
INSERT INTO `company_types_lvl2` VALUES (84,'Organisme professionnel');
INSERT INTO `company_types_lvl2` VALUES (85,'Organisme de retraite à adhésion non obligatoire');
INSERT INTO `company_types_lvl2` VALUES (91,'Syndicat de propriétaires');
INSERT INTO `company_types_lvl2` VALUES (92,'Association loi 1901 ou assimilé');
INSERT INTO `company_types_lvl2` VALUES (93,'Fondation');
INSERT INTO `company_types_lvl2` VALUES (99,'Autre personne morale de droit privé');


CREATE TABLE IF NOT EXISTS `company_types_lvl3` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `company_types_lvl3` VALUES (1000,'Entrepreneur individuel');
INSERT INTO `company_types_lvl3` VALUES (2110,'Indivision entre personnes physiques ');
INSERT INTO `company_types_lvl3` VALUES (2120,'Indivision avec personne morale ');
INSERT INTO `company_types_lvl3` VALUES (2210,'Société créée de fait entre personnes physiques ');
INSERT INTO `company_types_lvl3` VALUES (2220,'Société créée de fait avec personne morale ');
INSERT INTO `company_types_lvl3` VALUES (2310,'Société en participation entre personnes physiques ');
INSERT INTO `company_types_lvl3` VALUES (2320,'Société en participation avec personne morale ');
INSERT INTO `company_types_lvl3` VALUES (2385,'Société en participation de professions libérales ');
INSERT INTO `company_types_lvl3` VALUES (2400,'Fiducie ');
INSERT INTO `company_types_lvl3` VALUES (2700,'Paroisse hors zone concordataire ');
INSERT INTO `company_types_lvl3` VALUES (2900,'Autre groupement de droit privé non doté de la personnalité morale ');
INSERT INTO `company_types_lvl3` VALUES (3110,'Représentation ou agence commerciale d\'état ou organisme public étranger immatriculé au RCS ');
INSERT INTO `company_types_lvl3` VALUES (3120,'Société commerciale étrangère immatriculée au RCS');
INSERT INTO `company_types_lvl3` VALUES (3205,'Organisation internationale ');
INSERT INTO `company_types_lvl3` VALUES (3210,'État, collectivité ou établissement public étranger');
INSERT INTO `company_types_lvl3` VALUES (3220,'Société étrangère non immatriculée au RCS ');
INSERT INTO `company_types_lvl3` VALUES (3290,'Autre personne morale de droit étranger ');
INSERT INTO `company_types_lvl3` VALUES (4110,'Établissement public national à caractère industriel ou commercial doté d\'un comptable public ');
INSERT INTO `company_types_lvl3` VALUES (4120,'Établissement public national à caractère industriel ou commercial non doté d\'un comptable public ');
INSERT INTO `company_types_lvl3` VALUES (4130,'Exploitant public ');
INSERT INTO `company_types_lvl3` VALUES (4140,'Établissement public local à caractère industriel ou commercial ');
INSERT INTO `company_types_lvl3` VALUES (4150,'Régie d\'une collectivité locale à caractère industriel ou commercial ');
INSERT INTO `company_types_lvl3` VALUES (4160,'Institution Banque de France ');
INSERT INTO `company_types_lvl3` VALUES (5191,'Société de caution mutuelle ');
INSERT INTO `company_types_lvl3` VALUES (5192,'Société coopérative de banque populaire ');
INSERT INTO `company_types_lvl3` VALUES (5193,'Caisse de crédit maritime mutuel ');
INSERT INTO `company_types_lvl3` VALUES (5194,'Caisse (fédérale) de crédit mutuel ');
INSERT INTO `company_types_lvl3` VALUES (5195,'Association coopérative inscrite (droit local Alsace Moselle) ');
INSERT INTO `company_types_lvl3` VALUES (5196,'Caisse d\'épargne et de prévoyance à forme coopérative ');
INSERT INTO `company_types_lvl3` VALUES (5202,'Société en nom collectif ');
INSERT INTO `company_types_lvl3` VALUES (5203,'Société en nom collectif coopérative ');
INSERT INTO `company_types_lvl3` VALUES (5306,'Société en commandite simple ');
INSERT INTO `company_types_lvl3` VALUES (5307,'Société en commandite simple coopérative ');
INSERT INTO `company_types_lvl3` VALUES (5308,'Société en commandite par actions ');
INSERT INTO `company_types_lvl3` VALUES (5309,'Société en commandite par actions coopérative ');
INSERT INTO `company_types_lvl3` VALUES (5370,'Société de Participations Financières de Profession Libérale Société en commandite par actions (SPFPL SCA)');
INSERT INTO `company_types_lvl3` VALUES (5385,'Société d\'exercice libéral en commandite par actions ');
INSERT INTO `company_types_lvl3` VALUES (5410,'SARL nationale ');
INSERT INTO `company_types_lvl3` VALUES (5415,'SARL d\'économie mixte ');
INSERT INTO `company_types_lvl3` VALUES (5422,'SARL immobilière pour le commerce et l\'industrie (SICOMI) ');
INSERT INTO `company_types_lvl3` VALUES (5426,'SARL immobilière de gestion');
INSERT INTO `company_types_lvl3` VALUES (5430,'SARL d\'aménagement foncier et d\'équipement rural (SAFER)');
INSERT INTO `company_types_lvl3` VALUES (5431,'SARL mixte d\'intérêt agricole (SMIA) ');
INSERT INTO `company_types_lvl3` VALUES (5432,'SARL d\'intérêt collectif agricole (SICA) ');
INSERT INTO `company_types_lvl3` VALUES (5442,'SARL d\'attribution ');
INSERT INTO `company_types_lvl3` VALUES (5443,'SARL coopérative de construction ');
INSERT INTO `company_types_lvl3` VALUES (5451,'SARL coopérative de consommation ');
INSERT INTO `company_types_lvl3` VALUES (5453,'SARL coopérative artisanale ');
INSERT INTO `company_types_lvl3` VALUES (5454,'SARL coopérative d\'intérêt maritime ');
INSERT INTO `company_types_lvl3` VALUES (5455,'SARL coopérative de transport');
INSERT INTO `company_types_lvl3` VALUES (5458,'SARL coopérative ouvrière de production (SCOP)');
INSERT INTO `company_types_lvl3` VALUES (5459,'SARL union de sociétés coopératives ');
INSERT INTO `company_types_lvl3` VALUES (5460,'Autre SARL coopérative ');
INSERT INTO `company_types_lvl3` VALUES (5470,'Société de Participations Financières de Profession Libérale Société à responsabilité limitée (SPFPL SARL)');
INSERT INTO `company_types_lvl3` VALUES (5485,'Société d\'exercice libéral à responsabilité limitée ');
INSERT INTO `company_types_lvl3` VALUES (5498,'SARL unipersonnelle ');
INSERT INTO `company_types_lvl3` VALUES (5499,'Société à responsabilité limitée (sans autre indication)');
INSERT INTO `company_types_lvl3` VALUES (5505,'SA à participation ouvrière à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5510,'SA nationale à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5515,'SA d\'économie mixte à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5520,'Fonds à forme sociétale à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5522,'SA immobilière pour le commerce et l\'industrie (SICOMI) à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5525,'SA immobilière d\'investissement à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5530,'SA d\'aménagement foncier et d\'équipement rural (SAFER) à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5531,'Société anonyme mixte d\'intérêt agricole (SMIA) à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5532,'SA d\'intérêt collectif agricole (SICA) à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5542,'SA d\'attribution à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5543,'SA coopérative de construction à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5546,'SA de HLM à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5547,'SA coopérative de production de HLM à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5548,'SA de crédit immobilier à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5551,'SA coopérative de consommation à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5552,'SA coopérative de commerçants-détaillants à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5553,'SA coopérative artisanale à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5554,'SA coopérative (d\'intérêt) maritime à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5555,'SA coopérative de transport à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5558,'SA coopérative ouvrière de production (SCOP) à conseil d\'administration');
INSERT INTO `company_types_lvl3` VALUES (5559,'SA union de sociétés coopératives à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5560,'Autre SA coopérative à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5570,'Société de Participations Financières de Profession Libérale Société anonyme à conseil d\'administration (SPFPL SA à conseil d\'administration)');
INSERT INTO `company_types_lvl3` VALUES (5585,'Société d\'exercice libéral à forme anonyme à conseil d\'administration ');
INSERT INTO `company_types_lvl3` VALUES (5599,'SA à conseil d\'administration (s.a.i.)');
INSERT INTO `company_types_lvl3` VALUES (5605,'SA à participation ouvrière à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5610,'SA nationale à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5615,'SA d\'économie mixte à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5620,'Fonds à forme sociétale à directoire');
INSERT INTO `company_types_lvl3` VALUES (5622,'SA immobilière pour le commerce et l\'industrie (SICOMI) à directoire');
INSERT INTO `company_types_lvl3` VALUES (5625,'SA immobilière d\'investissement à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5630,'Safer anonyme à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5631,'SA mixte d\'intérêt agricole (SMIA)');
INSERT INTO `company_types_lvl3` VALUES (5632,'SA d\'intérêt collectif agricole (SICA)');
INSERT INTO `company_types_lvl3` VALUES (5642,'SA d\'attribution à directoire');
INSERT INTO `company_types_lvl3` VALUES (5643,'SA coopérative de construction à directoire');
INSERT INTO `company_types_lvl3` VALUES (5646,'SA de HLM à directoire');
INSERT INTO `company_types_lvl3` VALUES (5647,'Société coopérative de production de HLM anonyme à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5648,'SA de crédit immobilier à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5651,'SA coopérative de consommation à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5652,'SA coopérative de commerçants-détaillants à directoire');
INSERT INTO `company_types_lvl3` VALUES (5653,'SA coopérative artisanale à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5654,'SA coopérative d\'intérêt maritime à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5655,'SA coopérative de transport à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5658,'SA coopérative ouvrière de production (SCOP) à directoire');
INSERT INTO `company_types_lvl3` VALUES (5659,'SA union de sociétés coopératives à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5660,'Autre SA coopérative à directoire');
INSERT INTO `company_types_lvl3` VALUES (5670,'Société de Participations Financières de Profession Libérale Société anonyme à Directoire (SPFPL SA à directoire)');
INSERT INTO `company_types_lvl3` VALUES (5685,'Société d\'exercice libéral à forme anonyme à directoire ');
INSERT INTO `company_types_lvl3` VALUES (5699,'SA à directoire (s.a.i.)');
INSERT INTO `company_types_lvl3` VALUES (5710,'SAS, société par actions simplifiée');
INSERT INTO `company_types_lvl3` VALUES (5720,'Société par actions simplifiée à associé unique ou société par actions simplifiée unipersonnelle ');
INSERT INTO `company_types_lvl3` VALUES (5770,'Société de Participations Financières de Profession Libérale Société par actions simplifiée (SPFPL SAS)');
INSERT INTO `company_types_lvl3` VALUES (5785,'Société d\'exercice libéral par action simplifiée ');
INSERT INTO `company_types_lvl3` VALUES (5800,'Société européenne ');
INSERT INTO `company_types_lvl3` VALUES (6100,'Caisse d\'Épargne et de Prévoyance ');
INSERT INTO `company_types_lvl3` VALUES (6210,'Groupement européen d\'intérêt économique (GEIE) ');
INSERT INTO `company_types_lvl3` VALUES (6220,'Groupement d\'intérêt économique (GIE) ');
INSERT INTO `company_types_lvl3` VALUES (6316,'Coopérative d\'utilisation de matériel agricole en commun (CUMA) ');
INSERT INTO `company_types_lvl3` VALUES (6317,'Société coopérative agricole ');
INSERT INTO `company_types_lvl3` VALUES (6318,'Union de sociétés coopératives agricoles ');
INSERT INTO `company_types_lvl3` VALUES (6411,'Société d\'assurance à forme mutuelle');
INSERT INTO `company_types_lvl3` VALUES (6511,'Sociétés Interprofessionnelles de Soins Ambulatoires ');
INSERT INTO `company_types_lvl3` VALUES (6521,'Société civile de placement collectif immobilier (SCPI) ');
INSERT INTO `company_types_lvl3` VALUES (6532,'Société civile d\'intérêt collectif agricole (SICA) ');
INSERT INTO `company_types_lvl3` VALUES (6533,'Groupement agricole d\'exploitation en commun (GAEC) ');
INSERT INTO `company_types_lvl3` VALUES (6534,'Groupement foncier agricole ');
INSERT INTO `company_types_lvl3` VALUES (6535,'Groupement agricole foncier ');
INSERT INTO `company_types_lvl3` VALUES (6536,'Groupement forestier ');
INSERT INTO `company_types_lvl3` VALUES (6537,'Groupement pastoral ');
INSERT INTO `company_types_lvl3` VALUES (6538,'Groupement foncier et rural');
INSERT INTO `company_types_lvl3` VALUES (6539,'Société civile foncière ');
INSERT INTO `company_types_lvl3` VALUES (6540,'Société civile immobilière ');
INSERT INTO `company_types_lvl3` VALUES (6541,'Société civile immobilière de construction-vente');
INSERT INTO `company_types_lvl3` VALUES (6542,'Société civile d\'attribution ');
INSERT INTO `company_types_lvl3` VALUES (6543,'Société civile coopérative de construction ');
INSERT INTO `company_types_lvl3` VALUES (6544,'Société civile immobilière d\' accession progressive à la propriété');
INSERT INTO `company_types_lvl3` VALUES (6551,'Société civile coopérative de consommation ');
INSERT INTO `company_types_lvl3` VALUES (6554,'Société civile coopérative d\'intérêt maritime ');
INSERT INTO `company_types_lvl3` VALUES (6558,'Société civile coopérative entre médecins ');
INSERT INTO `company_types_lvl3` VALUES (6560,'Autre société civile coopérative ');
INSERT INTO `company_types_lvl3` VALUES (6561,'SCP d\'avocats ');
INSERT INTO `company_types_lvl3` VALUES (6562,'SCP d\'avocats aux conseils ');
INSERT INTO `company_types_lvl3` VALUES (6563,'SCP d\'avoués d\'appel ');
INSERT INTO `company_types_lvl3` VALUES (6564,'SCP d\'huissiers ');
INSERT INTO `company_types_lvl3` VALUES (6565,'SCP de notaires ');
INSERT INTO `company_types_lvl3` VALUES (6566,'SCP de commissaires-priseurs ');
INSERT INTO `company_types_lvl3` VALUES (6567,'SCP de greffiers de tribunal de commerce ');
INSERT INTO `company_types_lvl3` VALUES (6568,'SCP de conseils juridiques ');
INSERT INTO `company_types_lvl3` VALUES (6569,'SCP de commissaires aux comptes ');
INSERT INTO `company_types_lvl3` VALUES (6571,'SCP de médecins ');
INSERT INTO `company_types_lvl3` VALUES (6572,'SCP de dentistes ');
INSERT INTO `company_types_lvl3` VALUES (6573,'SCP d\'infirmiers ');
INSERT INTO `company_types_lvl3` VALUES (6574,'SCP de masseurs-kinésithérapeutes');
INSERT INTO `company_types_lvl3` VALUES (6575,'SCP de directeurs de laboratoire d\'analyse médicale ');
INSERT INTO `company_types_lvl3` VALUES (6576,'SCP de vétérinaires ');
INSERT INTO `company_types_lvl3` VALUES (6577,'SCP de géomètres experts');
INSERT INTO `company_types_lvl3` VALUES (6578,'SCP d\'architectes ');
INSERT INTO `company_types_lvl3` VALUES (6585,'Autre société civile professionnelle');
INSERT INTO `company_types_lvl3` VALUES (6588,'Société civile laitière ');
INSERT INTO `company_types_lvl3` VALUES (6589,'Société civile de moyens ');
INSERT INTO `company_types_lvl3` VALUES (6595,'Caisse locale de crédit mutuel ');
INSERT INTO `company_types_lvl3` VALUES (6596,'Caisse de crédit agricole mutuel ');
INSERT INTO `company_types_lvl3` VALUES (6597,'Société civile d\'exploitation agricole ');
INSERT INTO `company_types_lvl3` VALUES (6598,'Exploitation agricole à responsabilité limitée ');
INSERT INTO `company_types_lvl3` VALUES (6599,'Autre société civile ');
INSERT INTO `company_types_lvl3` VALUES (6901,'Autre personne de droit privé inscrite au registre du commerce et des sociétés');
INSERT INTO `company_types_lvl3` VALUES (7111,'Autorité constitutionnelle ');
INSERT INTO `company_types_lvl3` VALUES (7112,'Autorité administrative ou publique indépendante');
INSERT INTO `company_types_lvl3` VALUES (7113,'Ministère ');
INSERT INTO `company_types_lvl3` VALUES (7120,'Service central d\'un ministère ');
INSERT INTO `company_types_lvl3` VALUES (7150,'Service du ministère de la Défense ');
INSERT INTO `company_types_lvl3` VALUES (7160,'Service déconcentré à compétence nationale d\'un ministère (hors Défense)');
INSERT INTO `company_types_lvl3` VALUES (7171,'Service déconcentré de l\'État à compétence (inter) régionale ');
INSERT INTO `company_types_lvl3` VALUES (7172,'Service déconcentré de l\'État à compétence (inter) départementale ');
INSERT INTO `company_types_lvl3` VALUES (7179,'(Autre) Service déconcentré de l\'État à compétence territoriale ');
INSERT INTO `company_types_lvl3` VALUES (7190,'Ecole nationale non dotée de la personnalité morale ');
INSERT INTO `company_types_lvl3` VALUES (7210,'Commune et commune nouvelle ');
INSERT INTO `company_types_lvl3` VALUES (7220,'Département ');
INSERT INTO `company_types_lvl3` VALUES (7225,'Collectivité et territoire d\'Outre Mer');
INSERT INTO `company_types_lvl3` VALUES (7229,'(Autre) Collectivité territoriale ');
INSERT INTO `company_types_lvl3` VALUES (7230,'Région ');
INSERT INTO `company_types_lvl3` VALUES (7312,'Commune associée et commune déléguée ');
INSERT INTO `company_types_lvl3` VALUES (7313,'Section de commune ');
INSERT INTO `company_types_lvl3` VALUES (7314,'Ensemble urbain ');
INSERT INTO `company_types_lvl3` VALUES (7321,'Association syndicale autorisée ');
INSERT INTO `company_types_lvl3` VALUES (7322,'Association foncière urbaine ');
INSERT INTO `company_types_lvl3` VALUES (7323,'Association foncière de remembrement ');
INSERT INTO `company_types_lvl3` VALUES (7331,'Établissement public local d\'enseignement ');
INSERT INTO `company_types_lvl3` VALUES (7340,'Pôle métropolitain');
INSERT INTO `company_types_lvl3` VALUES (7341,'Secteur de commune ');
INSERT INTO `company_types_lvl3` VALUES (7342,'District urbain ');
INSERT INTO `company_types_lvl3` VALUES (7343,'Communauté urbaine ');
INSERT INTO `company_types_lvl3` VALUES (7344,'Métropole');
INSERT INTO `company_types_lvl3` VALUES (7345,'Syndicat intercommunal à vocation multiple (SIVOM) ');
INSERT INTO `company_types_lvl3` VALUES (7346,'Communauté de communes ');
INSERT INTO `company_types_lvl3` VALUES (7347,'Communauté de villes ');
INSERT INTO `company_types_lvl3` VALUES (7348,'Communauté d\'agglomération ');
INSERT INTO `company_types_lvl3` VALUES (7349,'Autre établissement public local de coopération non spécialisé ou entente ');
INSERT INTO `company_types_lvl3` VALUES (7351,'Institution interdépartementale ou entente');
INSERT INTO `company_types_lvl3` VALUES (7352,'Institution interrégionale ou entente ');
INSERT INTO `company_types_lvl3` VALUES (7353,'Syndicat intercommunal à vocation unique (SIVU) ');
INSERT INTO `company_types_lvl3` VALUES (7354,'Syndicat mixte fermé ');
INSERT INTO `company_types_lvl3` VALUES (7355,'Syndicat mixte ouvert');
INSERT INTO `company_types_lvl3` VALUES (7356,'Commission syndicale pour la gestion des biens indivis des communes ');
INSERT INTO `company_types_lvl3` VALUES (7357,'Pôle d\'équilibre territorial et rural (PETR)');
INSERT INTO `company_types_lvl3` VALUES (7361,'Centre communal d\'action sociale ');
INSERT INTO `company_types_lvl3` VALUES (7362,'Caisse des écoles ');
INSERT INTO `company_types_lvl3` VALUES (7363,'Caisse de crédit municipal ');
INSERT INTO `company_types_lvl3` VALUES (7364,'Établissement d\'hospitalisation ');
INSERT INTO `company_types_lvl3` VALUES (7365,'Syndicat inter hospitalier ');
INSERT INTO `company_types_lvl3` VALUES (7366,'Établissement public local social et médico-social ');
INSERT INTO `company_types_lvl3` VALUES (7367,'Centre Intercommunal d\'action sociale (CIAS)');
INSERT INTO `company_types_lvl3` VALUES (7371,'Office public d\'habitation à loyer modéré (OPHLM) ');
INSERT INTO `company_types_lvl3` VALUES (7372,'Service départemental d\'incendie et de secours (SDIS)');
INSERT INTO `company_types_lvl3` VALUES (7373,'Établissement public local culturel ');
INSERT INTO `company_types_lvl3` VALUES (7378,'Régie d\'une collectivité locale à caractère administratif ');
INSERT INTO `company_types_lvl3` VALUES (7379,'(Autre) Établissement public administratif local ');
INSERT INTO `company_types_lvl3` VALUES (7381,'Organisme consulaire ');
INSERT INTO `company_types_lvl3` VALUES (7382,'Établissement public national ayant fonction d\'administration centrale ');
INSERT INTO `company_types_lvl3` VALUES (7383,'Établissement public national à caractère scientifique culturel et professionnel ');
INSERT INTO `company_types_lvl3` VALUES (7384,'Autre établissement public national d\'enseignement ');
INSERT INTO `company_types_lvl3` VALUES (7385,'Autre établissement public national administratif à compétence territoriale limitée ');
INSERT INTO `company_types_lvl3` VALUES (7389,'Établissement public national à caractère administratif ');
INSERT INTO `company_types_lvl3` VALUES (7410,'Groupement d\'intérêt public (GIP) ');
INSERT INTO `company_types_lvl3` VALUES (7430,'Établissement public des cultes d\'Alsace-Lorraine ');
INSERT INTO `company_types_lvl3` VALUES (7450,'Etablissement public administratif, cercle et foyer dans les armées ');
INSERT INTO `company_types_lvl3` VALUES (7470,'Groupement de coopération sanitaire à gestion publique ');
INSERT INTO `company_types_lvl3` VALUES (7490,'Autre personne morale de droit administratif ');
INSERT INTO `company_types_lvl3` VALUES (8110,'Régime général de la Sécurité Sociale');
INSERT INTO `company_types_lvl3` VALUES (8120,'Régime spécial de Sécurité Sociale');
INSERT INTO `company_types_lvl3` VALUES (8130,'Institution de retraite complémentaire ');
INSERT INTO `company_types_lvl3` VALUES (8140,'Mutualité sociale agricole ');
INSERT INTO `company_types_lvl3` VALUES (8150,'Régime maladie des non-salariés non agricoles ');
INSERT INTO `company_types_lvl3` VALUES (8160,'Régime vieillesse ne dépendant pas du régime général de la Sécurité Sociale');
INSERT INTO `company_types_lvl3` VALUES (8170,'Régime d\'assurance chômage ');
INSERT INTO `company_types_lvl3` VALUES (8190,'Autre régime de prévoyance sociale ');
INSERT INTO `company_types_lvl3` VALUES (8210,'Mutuelle ');
INSERT INTO `company_types_lvl3` VALUES (8250,'Assurance mutuelle agricole ');
INSERT INTO `company_types_lvl3` VALUES (8290,'Autre organisme mutualiste ');
INSERT INTO `company_types_lvl3` VALUES (8310,'Comité central d\'entreprise ');
INSERT INTO `company_types_lvl3` VALUES (8311,'Comité d\'établissement ');
INSERT INTO `company_types_lvl3` VALUES (8410,'Syndicat de salariés ');
INSERT INTO `company_types_lvl3` VALUES (8420,'Syndicat patronal ');
INSERT INTO `company_types_lvl3` VALUES (8450,'Ordre professionnel ou assimilé ');
INSERT INTO `company_types_lvl3` VALUES (8470,'Centre technique industriel ou comité professionnel du développement économique ');
INSERT INTO `company_types_lvl3` VALUES (8490,'Autre organisme professionnel ');
INSERT INTO `company_types_lvl3` VALUES (8510,'Institution de prévoyance ');
INSERT INTO `company_types_lvl3` VALUES (8520,'Institution de retraite supplémentaire ');
INSERT INTO `company_types_lvl3` VALUES (9110,'Syndicat de copropriété ');
INSERT INTO `company_types_lvl3` VALUES (9150,'Association syndicale libre ');
INSERT INTO `company_types_lvl3` VALUES (9210,'Association non déclarée ');
INSERT INTO `company_types_lvl3` VALUES (9220,'Association déclarée ');
INSERT INTO `company_types_lvl3` VALUES (9221,'Association déclarée d\'insertion par l\'économique');
INSERT INTO `company_types_lvl3` VALUES (9222,'Association intermédiaire ');
INSERT INTO `company_types_lvl3` VALUES (9223,'Groupement d\'employeurs ');
INSERT INTO `company_types_lvl3` VALUES (9224,'Association d\'avocats à responsabilité professionnelle individuelle');
INSERT INTO `company_types_lvl3` VALUES (9230,'Association déclarée, reconnue d\'utilité publique');
INSERT INTO `company_types_lvl3` VALUES (9240,'Congrégation ');
INSERT INTO `company_types_lvl3` VALUES (9260,'Association de droit local (Bas-Rhin, Haut-Rhin et Moselle)');
INSERT INTO `company_types_lvl3` VALUES (9300,'Fondation ');
INSERT INTO `company_types_lvl3` VALUES (9900,'Autre personne morale de droit privé ');
INSERT INTO `company_types_lvl3` VALUES (9970,'Groupement de coopération sanitaire à gestion privée ');


CREATE TABLE IF NOT EXISTS `contacts_categories` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `contacts_categories` VALUES (10,'Clients');
INSERT INTO `contacts_categories` VALUES (30,'Avocats');
INSERT INTO `contacts_categories` VALUES (50,'Juridictions');
INSERT INTO `contacts_categories` VALUES (60,'Huissiers');
INSERT INTO `contacts_categories` VALUES (70,'Notaires');
INSERT INTO `contacts_categories` VALUES (110,'Administrateur Judiciaire');
INSERT INTO `contacts_categories` VALUES (120,'Mandataire Judiciaire');


CREATE TABLE IF NOT EXISTS `contacts_company_representatives` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `contacts_company_representatives` VALUES (10,'Gérant');
INSERT INTO `contacts_company_representatives` VALUES (20,'Directeur');
INSERT INTO `contacts_company_representatives` VALUES (30,'Président');
INSERT INTO `contacts_company_representatives` VALUES (40,'Président du Conseil d\'Administration');
INSERT INTO `contacts_company_representatives` VALUES (50,'Président du Directoire');
INSERT INTO `contacts_company_representatives` VALUES (60,'Président Directeur Général');


CREATE TABLE IF NOT EXISTS `contacts_marital_statuses` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `contacts_marital_statuses` VALUES (10,'Célibataire');
INSERT INTO `contacts_marital_statuses` VALUES (20,'En Concubinage');
INSERT INTO `contacts_marital_statuses` VALUES (30,'PACSé(e)');
INSERT INTO `contacts_marital_statuses` VALUES (40,'Marié(e)');
INSERT INTO `contacts_marital_statuses` VALUES (50,'Divorcé(e)');
INSERT INTO `contacts_marital_statuses` VALUES (60,'Veuf(ve)');


CREATE TABLE IF NOT EXISTS `contacts_titles` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `contacts_titles` VALUES (10,'Madame');
INSERT INTO `contacts_titles` VALUES (20,'Mademoiselle');
INSERT INTO `contacts_titles` VALUES (30,'Monsieur');
INSERT INTO `contacts_titles` VALUES (40,'Maitre');
INSERT INTO `contacts_titles` VALUES (50,'Docteur');
INSERT INTO `contacts_titles` VALUES (60,'Professeur');


CREATE TABLE IF NOT EXISTS `contacts_types` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `contacts_types` VALUES (10,'Homme');
INSERT INTO `contacts_types` VALUES (20,'Femme');
INSERT INTO `contacts_types` VALUES (30,'Personne Morale');


CREATE TABLE IF NOT EXISTS `countries` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `nom` text NOT NULL,
  `continent` text NOT NULL,
  `region` text NOT NULL,
  `iso1` smallint(6) NOT NULL DEFAULT 0,
  `iso2` tinytext NOT NULL,
  `iso3` tinytext NOT NULL,
  `cctld` tinytext NOT NULL,
  `OHIM` tinyint(1) NOT NULL DEFAULT 0,
  `WIPO` tinyint(1) NOT NULL DEFAULT 0,
  `OAPI` tinyint(1) NOT NULL DEFAULT 0,
  `ARIPO` tinyint(1) NOT NULL DEFAULT 0,
  `BTO` tinyint(1) NOT NULL DEFAULT 0,
  `canvas` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `countries` VALUES (1,'Afghanistan','Asia','Southern and Central Asia',4,'AF','AFG','af',0,1,0,0,0,'[[6390,2329],[6416,2300],[6416,2283],[6390,2278],[6382,2227],[6403,2151],[6437,2164],[6526,2087],[6548,2096],[6582,2100],[6624,2100],[6667,2057],[6679,2062],[6679,2074],[6688,2074],[6684,2100],[6692,2117],[6726,2096],[6764,2091],[6781,2100],[6773,2104],[6756,2113],[6726,2108],[6692,2121],[6679,2134],[6692,2164],[6671,2185],[6675,2193],[6667,2202],[6641,2202],[6654,2223],[6633,2232],[6624,2266],[6611,2274],[6594,2270],[6560,2287],[6543,2295],[6543,2325],[6480,2342],[6433,2342]]');
INSERT INTO `countries` VALUES (2,'Aland Islands','Europe','Nordic Countries',248,'AX','ALA','ax',0,0,0,0,0,'[[5251,1256],[5236,1262],[5256,1273]]');
INSERT INTO `countries` VALUES (3,'Albania','Europe','Southern Europe',8,'AL','ALB','al',0,1,0,0,0,'[[5251,1921],[5268,1943],[5264,1968],[5276,1981],[5276,1989],[5255,2023],[5234,1998],[5238,1947],[5230,1947]]');
INSERT INTO `countries` VALUES (4,'Algeria','Africa','Northern Africa',12,'DZ','DZA','dz',0,1,0,0,0,'[[4928,2108],[4923,2164],[4898,2206],[4945,2261],[4953,2317],[4953,2440],[5026,2517],[4894,2597],[4855,2640],[4809,2648],[4779,2648],[4719,2589],[4549,2474],[4447,2406],[4447,2393],[4447,2363],[4583,2287],[4583,2270],[4656,2257],[4630,2168],[4775,2108]]');
INSERT INTO `countries` VALUES (5,'American Samoa','Oceania','Polynesia',16,'AS','ASM','as',0,0,0,0,0,'[[9977,3586],[9971,3588],[9973,3590]]');
INSERT INTO `countries` VALUES (6,'Andorra','Europe','Southern Europe',20,'AD','AND','ad',0,1,0,0,0,'[[4741,1921],[4732,1926],[4732,1921]]');
INSERT INTO `countries` VALUES (7,'Angola','Africa','Central Africa',24,'AO','AGO','ao',0,1,0,0,0,'[[5026,3329],[5047,3307],[5055,3316],[5038,3329],[5038,3346],[5030,3346]],[[5038,3354],[5051,3350],[5153,3350],[5179,3409],[5230,3409],[5234,3380],[5264,3380],[5264,3388],[5298,3388],[5310,3503],[5361,3494],[5361,3550],[5302,3550],[5302,3639],[5344,3686],[5272,3694],[5221,3690],[5204,3677],[5081,3677],[5055,3665],[5017,3673],[5017,3631],[5043,3562],[5072,3528],[5077,3494],[5051,3439],[5064,3426],[5034,3358]]');
INSERT INTO `countries` VALUES (8,'Anguilla','North America','Caribbean',660,'AI','AIA','ai',0,0,0,0,0,'[[2930,2670],[2927,2674],[2933,2670]],[[2931,2674],[2926,2677],[2931,2678]]');
INSERT INTO `countries` VALUES (9,'Antarctica','Antarctica','Antarctica',10,'AQ','ATA','aq',0,0,0,0,0,'[[0,5972],[1232,5686],[1887,5758],[1845,5609],[2714,5662],[2644,5458],[3060,5210],[3000,5758],[3464,5908],[4446,5526],[5655,5442],[5821,5502],[6173,5311],[6851,5484],[7125,5321],[8417,5311],[9476,5567],[9250,5889],[10000,5972]]');
INSERT INTO `countries` VALUES (10,'Antigua and Barbuda','North America','Caribbean',28,'AG','ATG','ag',0,1,0,0,0,'[[2964,2701],[2962,2706],[2969,2706]],[[2963,2685],[2965,2691],[2967,2689]]');
INSERT INTO `countries` VALUES (11,'Argentina','South America','South America',32,'AR','ARG','ar',0,1,0,0,0,'[[2815,3835],[2844,3805],[2853,3813],[2887,3818],[2895,3835],[2904,3813],[2942,3818],[2997,3864],[3082,3911],[3053,3966],[3134,3971],[3159,3949],[3168,3915],[3189,3915],[3189,3962],[3082,4056],[3057,4170],[3057,4192],[3095,4217],[3112,4264],[3082,4307],[2951,4328],[2951,4392],[2878,4392],[2887,4443],[2857,4532],[2806,4557],[2806,4591],[2853,4608],[2849,4642],[2802,4685],[2798,4710],[2764,4727],[2759,4749],[2781,4800],[2738,4787],[2683,4787],[2670,4736],[2649,4740],[2640,4689],[2696,4545],[2679,4438],[2696,4332],[2713,4315],[2734,4149],[2721,4085],[2776,3949],[2776,3890],[2810,3869]]');
INSERT INTO `countries` VALUES (12,'Armenia','Asia','Middle East',51,'AM','ARM','am',0,1,0,0,0,'[[5948,1964],[5906,1968],[5910,2006],[5935,2015],[5969,2023],[5978,2045],[5986,2045],[5986,2019],[5965,2011],[5974,1998]]');
INSERT INTO `countries` VALUES (13,'Aruba','North America','Caribbean',533,'AW','ABW','aw',0,0,0,0,0,'[[2734,2831],[2740,2837],[2735,2836]]');
INSERT INTO `countries` VALUES (14,'Australia','Oceania','Australia and New Zealand',36,'AU','AUS','au',0,1,0,0,0,'[[8614,3690],[8661,3490],[8712,3592],[8746,3609],[8776,3716],[8963,3915],[8975,4013],[8941,4128],[8882,4226],[8873,4285],[8776,4332],[8729,4307],[8699,4332],[8593,4285],[8571,4221],[8529,4175],[8482,4200],[8418,4111],[8338,4098],[8210,4119],[8142,4170],[8040,4170],[7980,4204],[7904,4175],[7921,4115],[7861,3949],[7878,3920],[7853,3869],[7951,3771],[8074,3741],[8121,3656],[8142,3673],[8236,3575],[8270,3609],[8308,3609],[8304,3588],[8350,3524],[8389,3528],[8401,3503],[8512,3537],[8474,3605]],[[8729,4387],[8780,4404],[8831,4387],[8831,4434],[8793,4485],[8767,4481],[8729,4400]]');
INSERT INTO `countries` VALUES (15,'Austria','Europe','Western Europe',40,'AT','AUT','at',1,1,0,0,0,'[[4962,1751],[5051,1751],[5047,1730],[5077,1709],[5102,1713],[5111,1696],[5166,1709],[5166,1743],[5145,1773],[5098,1790],[5072,1785],[5030,1768],[4983,1777],[4957,1764]]');
INSERT INTO `countries` VALUES (16,'Azerbaijan','Asia','Middle East',31,'AZ','AZE','az',0,1,0,0,0,'[[5986,1943],[5982,1951],[5995,1964],[5991,1972],[5957,1960],[5948,1964],[5974,1998],[5965,2011],[5986,2019],[5986,2045],[6029,2019],[6054,2062],[6071,2002],[6093,1994],[6071,1985],[6046,1947],[6029,1968]],[[5969,2023],[5935,2015],[5961,2040],[5978,2045]]');
INSERT INTO `countries` VALUES (17,'Bahamas','North America','Caribbean',44,'BS','BHS','bs',0,1,0,0,0,'[[2509,2470],[2500,2487],[2513,2495],[2521,2487]],[[2521,2495],[2513,2500],[2526,2512]],[[2491,2427],[2517,2419],[2517,2423]],[[2530,2419],[2543,2432],[2534,2444],[2538,2432]]');
INSERT INTO `countries` VALUES (18,'Bahrain','Asia','Middle East',48,'BH','BHR','bh',0,1,0,0,0,'[[6096,2439],[6105,2435],[6102,2449]]');
INSERT INTO `countries` VALUES (19,'Bangladesh','Asia','Southern and Central Asia',50,'BD','BGD','bd',0,1,0,0,0,'[[7177,2568],[7168,2495],[7147,2487],[7173,2466],[7151,2449],[7160,2432],[7194,2440],[7198,2466],[7270,2474],[7236,2512],[7245,2538],[7266,2512],[7275,2563],[7275,2585],[7262,2593],[7245,2542]]');
INSERT INTO `countries` VALUES (20,'Barbados','North America','Caribbean',52,'BB','BRB','bb',0,1,0,0,0,'[[3025,2812],[3032,2816],[3026,2820]]');
INSERT INTO `countries` VALUES (21,'Belarus','Europe','Eastern Europe',112,'BY','BLR','by',0,1,0,0,0,'[[5476,1428],[5434,1449],[5404,1505],[5349,1517],[5357,1564],[5340,1581],[5349,1585],[5349,1602],[5395,1590],[5544,1611],[5557,1585],[5578,1585],[5570,1543],[5604,1534],[5553,1483],[5553,1449]]');
INSERT INTO `countries` VALUES (22,'Belgium','Europe','Western Europe',56,'BE','BEL','be',1,1,0,0,1,'[[4762,1624],[4783,1611],[4830,1607],[4855,1619],[4847,1632],[4860,1632],[4868,1649],[4860,1658],[4851,1666],[4851,1679],[4843,1679]]');
INSERT INTO `countries` VALUES (23,'Belize','North America','Central America',84,'BZ','BLZ','bz',0,1,0,0,0,'[[2202,2682],[2224,2661],[2224,2716],[2207,2738],[2202,2738]]');
INSERT INTO `countries` VALUES (24,'Benin','Africa','Western Africa',204,'BJ','BEN','bj',0,1,1,0,0,'[[4766,3006],[4766,2933],[4775,2933],[4796,2895],[4787,2865],[4792,2857],[4766,2835],[4758,2852],[4715,2878],[4711,2895],[4732,2908],[4741,3010]]');
INSERT INTO `countries` VALUES (25,'Bermuda','North America','North America',60,'BM','BMU','bm',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (26,'Bhutan','Asia','Southern and Central Asia',64,'BT','BTN','bt',0,1,0,0,0,'[[7168,2415],[7198,2423],[7262,2419],[7258,2402],[7249,2402],[7249,2393],[7202,2376]]');
INSERT INTO `countries` VALUES (27,'Bolivia','South America','South America',68,'BO','BOL','bo',0,1,0,0,0,'[[2751,3677],[2764,3656],[2776,3643],[2755,3622],[2772,3537],[2751,3494],[2785,3494],[2827,3465],[2866,3456],[2874,3524],[3006,3575],[3010,3643],[3061,3643],[3061,3673],[3082,3699],[3070,3754],[3040,3733],[2968,3741],[2942,3818],[2904,3813],[2895,3835],[2887,3818],[2853,3813],[2844,3805],[2815,3835],[2793,3835]]');
INSERT INTO `countries` VALUES (28,'Bosnia and Herzegovina','Europe','Southern Europe',70,'BA','BIH','ba',0,1,0,0,0,'[[5225,1841],[5225,1892],[5204,1926],[5128,1845],[5132,1832]]');
INSERT INTO `countries` VALUES (29,'Botswana','Africa','Southern Africa',72,'BW','BWA','bw',0,1,0,1,0,'[[5391,3686],[5472,3796],[5510,3813],[5442,3860],[5404,3920],[5336,3907],[5298,3954],[5268,3954],[5264,3941],[5272,3932],[5247,3894],[5247,3809],[5276,3809],[5276,3703],[5340,3694],[5349,3707]]');
INSERT INTO `countries` VALUES (30,'Bouvet Island','Antarctica','Antarctica',74,'BV','BVT','bv',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (31,'Brazil','South America','South America',76,'BR','BRA','br',0,1,0,0,0,'[[3248,3069],[3210,3125],[3168,3120],[3112,3133],[3048,3150],[3023,3133],[3014,3044],[2997,3040],[2997,3048],[2934,3086],[2883,3069],[2904,3116],[2921,3120],[2849,3167],[2823,3154],[2806,3129],[2793,3137],[2738,3137],[2738,3154],[2755,3154],[2755,3167],[2734,3167],[2734,3193],[2755,3222],[2738,3303],[2713,3303],[2657,3329],[2649,3367],[2623,3397],[2679,3469],[2721,3452],[2721,3494],[2785,3494],[2827,3465],[2866,3456],[2874,3524],[3006,3575],[3010,3643],[306INSERT INTO `countries` VALUES 1,3643],[3061,3673],[3082,3699],[3070,3754],[3070,3813],[3134,3818],[3146,3869],[3176,3869],[3168,3915],[3189,3915],[3189,3962],[3082,4056],[3104,4051],[3206,4132],[3193,4149],[3197,4166],[3329,4005],[3333,3920],[3410,3860],[3520,3835],[3597,3682],[3610,3554],[3712,3431],[3716,3380],[3699,3329],[3652,3324],[3571,3265],[3469,3252],[3448,3265],[3431,3227],[3355,3201],[3325,3227],[3338,3193],[3291,3176],[3295,3137],[3282,3133]]');
INSERT INTO `countries` VALUES (32,'British Indian Ocean Territory','Asia','Southeast Asia',86,'IO','IOT','io',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (33,'Brunei Darussalam','Asia','Southeast Asia',96,'BN','BRN','bn',0,1,0,0,0,'[[7904,3048],[7912,3065],[7895,3052],[7895,3069],[7891,3074],[7878,3061]]');
INSERT INTO `countries` VALUES (34,'Bulgaria','Europe','Eastern Europe',100,'BG','BGR','bg',1,1,0,0,0,'[[5332,1964],[5327,1943],[5315,1930],[5332,1900],[5315,1879],[5323,1866],[5332,1879],[5408,1883],[5451,1870],[5489,1883],[5485,1896],[5455,1926],[5472,1943],[5425,1951],[5421,1964],[5395,1968],[5374,1955]]');
INSERT INTO `countries` VALUES (35,'Burkina Faso','Africa','Western Africa',854,'BF','BFA','bf',0,1,1,0,0,'[[4715,2878],[4758,2852],[4696,2767],[4664,2767],[4634,2780],[4630,2789],[4609,2793],[4541,2857],[4537,2895],[4571,2916],[4592,2903],[4613,2925],[4613,2878],[4677,2878],[4685,2874],[4694,2874]]');
INSERT INTO `countries` VALUES (36,'Burundi','Africa','Eastern Africa',108,'BI','BDI','bi',0,1,0,0,0,'[[5548,3252],[5553,3278],[5519,3312],[5506,3282],[5497,3265]]');
INSERT INTO `countries` VALUES (37,'Cambodia','Asia','Southeast Asia',116,'KH','KHM','kh',0,1,0,0,0,'[[7606,2895],[7640,2878],[7653,2886],[7645,2861],[7691,2840],[7691,2776],[7674,2784],[7666,2780],[7653,2784],[7653,2793],[7649,2797],[7628,2784],[7572,2784],[7547,2810],[7560,2852],[7568,2869],[7568,2882],[7577,2882],[7581,2878],[7585,2886],[7581,2891],[7585,2895],[7589,2891]]');
INSERT INTO `countries` VALUES (38,'Cameroon','Africa','Central Africa',120,'CM','CMR','cm',0,1,1,0,0,'[[4962,3125],[5098,3125],[5140,3142],[5140,3125],[5094,3018],[5123,2971],[5081,2912],[5089,2903],[5123,2903],[5111,2874],[5115,2848],[5094,2818],[5085,2818],[5085,2840],[5094,2840],[5098,2861],[5081,2869],[5009,3006],[4983,2988],[4928,3052],[4970,3095]]');
INSERT INTO `countries` VALUES (39,'Canada','North America','North America',124,'CA','CAN','ca',0,1,0,0,0,'[[3116,1607],[3036,1743],[3210,1764],[3189,1679],[3112,1670],[3146,1598]],[[2504,803],[2653,909],[2670,952],[2611,1003],[2632,1028],[2534,1041],[2513,1075],[2547,1088],[2619,1075],[2704,1143],[2849,1186],[2772,1113],[2874,1148],[2895,1118],[2798,994],[2917,1054],[2976,977],[2793,884],[2823,846],[2772,778],[2526,676],[2457,697],[2411,620],[2304,654],[2304,722],[2275,676],[2317,620],[2241,620],[2177,705],[2181,748],[2245,765],[2194,765],[2245,807],[2491,820]INSERT INTO `countries` VALUES ],[[2436,625],[2474,671],[2568,667],[2517,629]],[[1777,637],[1747,671],[1773,761],[1875,820],[1841,867],[1709,846],[1531,892],[1416,816],[1560,795],[1412,786],[1382,765],[1441,739],[1369,731],[1390,684],[1484,637],[1514,676],[1531,659],[1594,688],[1599,663],[1654,684],[1675,731],[1675,646],[1730,659],[1709,629],[1747,620]],[[1471,633],[1331,705],[1322,739],[1259,769],[1178,714],[1233,616],[1207,591],[1305,578],[1407,595]],[[1446,403],[1263,480],[1416,476]],[[1475,467],[1416,540],[1573,586],[1735INSERT INTO `countries` VALUES ,540],[1739,493],[1671,484],[1645,442],[1611,518]],[[1747,297],[1862,318],[1913,386],[1786,361]],[[1781,459],[1964,471],[1956,548],[1901,548]],[[2028,523],[1994,548],[2062,569],[2079,535]],[[1981,437],[2160,450],[2202,514],[2453,518],[2440,574],[2181,582],[2109,531],[2083,471],[2041,480]],[[1939,340],[2011,408],[2096,395]],[[2551,897],[2530,931],[2568,952],[2594,909]],[[1522,382],[1616,365],[1620,395],[1556,412]],[[2823,1841],[2798,1811],[2798,1764],[2759,1751],[2691,1836],[2598,1836],[2568,1858INSERT INTO `countries` VALUES ],[2483,1875],[2462,1896],[2483,1896],[2487,1909],[2372,1938],[2372,1930],[2389,1904],[2406,1892],[2419,1836],[2457,1858],[2436,1807],[2338,1790],[2330,1781],[2321,1734],[2232,1696],[2185,1730],[2037,1696],[1263,1696],[1190,1653],[1241,1700],[1241,1717],[1178,1696],[1105,1632],[1122,1628],[1165,1641],[1042,1513],[1050,1483],[1063,1432],[906,1284],[855,1318],[753,1254],[753,833],[910,871],[1076,807],[1054,833],[1131,803],[1190,846],[1212,812],[1505,892],[1471,918],[1552,926],[1620,914],[1667,939]INSERT INTO `countries` VALUES ,[1679,909],[1735,888],[1658,897],[1667,884],[1735,871],[1747,892],[1837,926],[1935,918],[1935,897],[1969,888],[1918,863],[1960,816],[2020,875],[1981,888],[2011,905],[2007,943],[2028,909],[2075,884],[2049,833],[1998,799],[2032,714],[2015,625],[2071,599],[2168,612],[2122,676],[2075,671],[2062,722],[2130,803],[2105,829],[2126,846],[2173,841],[2241,901],[2253,952],[2304,880],[2304,824],[2419,854],[2394,901],[2423,939],[2347,1016],[2270,986],[2262,1041],[2151,1122],[2054,1237],[2045,1313],[2088,1326INSERT INTO `countries` VALUES ],[2109,1390],[2160,1381],[2321,1466],[2394,1466],[2394,1556],[2453,1611],[2500,1573],[2462,1483],[2547,1432],[2534,1352],[2496,1322],[2538,1271],[2513,1165],[2666,1186],[2747,1237],[2764,1318],[2802,1343],[2853,1318],[2887,1245],[3010,1454],[3091,1488],[3138,1573],[3023,1649],[2832,1649],[2721,1756],[2840,1687],[2895,1696],[2883,1785],[2959,1811],[2997,1764],[3010,1807],[2861,1887],[2840,1858],[2891,1811]],[[2296,1028],[2262,1113],[2317,1135],[2368,1092],[2428,1118],[2440,1105]],[[1884,620],[19INSERT INTO `countries` VALUES 73,612],[1990,722],[1930,752],[1824,671],[1896,671]],[[2245,416],[2190,463],[2483,471],[2483,425],[2615,327],[2585,297],[2717,263],[2980,97],[2619,34],[2389,72],[2372,110],[2321,80],[2122,148],[2292,221],[2449,212],[2266,238],[2355,323],[2275,323],[2245,374],[2313,395],[2232,395]],[[2096,165],[2211,250],[2313,297],[2207,369],[2122,365],[1994,255]]');
INSERT INTO `countries` VALUES (40,'Cape Verde','Africa','Western Africa',132,'CV','CPV','cv',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (41,'Cayman Islands','North America','Caribbean',136,'KY','CYM','ky',0,0,0,0,0,'[[2398,2574],[2406,2571],[2402,2574]],[[2413,2572],[2415,2575],[2419,2570]]');
INSERT INTO `countries` VALUES (42,'Central African Republic','Africa','Central Africa',140,'CF','CAF','cf',0,1,1,0,0,'[[5208,3086],[5208,3065],[5238,3040],[5259,3061],[5319,3069],[5332,3048],[5455,3044],[5332,2878],[5208,2959],[5123,2971],[5094,3018],[5140,3125],[5153,3086]]');
INSERT INTO `countries` VALUES (43,'Chad','Africa','Central Africa',148,'TD','TCD','td',0,1,1,0,0,'[[5111,2534],[5136,2521],[5361,2636],[5361,2742],[5336,2742],[5302,2823],[5332,2878],[5208,2959],[5123,2971],[5081,2912],[5089,2903],[5123,2903],[5111,2874],[5115,2848],[5094,2818],[5085,2818],[5068,2801],[5068,2780],[5123,2708],[5136,2610]]');
INSERT INTO `countries` VALUES (44,'Chile','South America','South America',152,'CL','CHL','cl',0,1,0,0,0,'[[2781,4800],[2738,4787],[2683,4787],[2670,4736],[2649,4740],[2640,4689],[2696,4545],[2679,4438],[2696,4332],[2713,4315],[2734,4149],[2721,4085],[2776,3949],[2776,3890],[2810,3869],[2815,3835],[2793,3835],[2751,3677],[2725,3703],[2734,3796],[2691,4056],[2696,4128],[2649,4268],[2632,4277],[2645,4345],[2628,4404],[2632,4421],[2623,4426],[2611,4477],[2632,4485],[2645,4421],[2662,4421],[2636,4532],[2628,4494],[2611,4511],[2606,4557],[2577,4596],[2615,4600],[26INSERT INTO `countries` VALUES 02,4634],[2581,4642],[2585,4740],[2598,4727],[2589,4770],[2619,4770],[2594,4778],[2645,4825],[2602,4812],[2670,4881],[2759,4910],[2870,4898],[2870,4889],[2840,4881],[2785,4838],[2768,4804],[2751,4804],[2725,4825],[2725,4838],[2755,4838],[2734,4851],[2738,4863],[2764,4881],[2730,4868],[2721,4846],[2708,4863],[2674,4846],[2704,4855],[2717,4817],[2755,4795]]');
INSERT INTO `countries` VALUES (45,'China','Asia','Eastern Asia',156,'CN','CHN','cn',0,1,0,0,0,'[[7143,1692],[7130,1696],[7083,1721],[7083,1764],[7007,1764],[6981,1832],[6930,1841],[6930,1934],[6871,1972],[6837,1977],[6820,1994],[6781,1994],[6756,2006],[6752,2023],[6747,2023],[6756,2053],[6777,2057],[6781,2100],[6811,2117],[6815,2142],[6862,2155],[6896,2189],[6888,2198],[6913,2240],[6896,2253],[6888,2244],[6879,2249],[6892,2283],[6952,2317],[6981,2317],[7088,2381],[7151,2389],[7168,2381],[7168,2415],[7202,2376],[7249,2393],[7279,2385],[7334,2346],[7355,INSERT INTO `countries` VALUES 2351],[7372,2342],[7406,2376],[7419,2368],[7445,2398],[7445,2449],[7415,2483],[7415,2504],[7449,2500],[7453,2529],[7470,2534],[7457,2559],[7483,2563],[7487,2580],[7513,2576],[7517,2585],[7530,2589],[7526,2555],[7530,2551],[7543,2551],[7551,2542],[7568,2551],[7632,2525],[7670,2542],[7670,2563],[7704,2580],[7721,2572],[7759,2580],[7751,2593],[7764,2614],[7776,2606],[7768,2593],[7861,2555],[7861,2538],[7870,2546],[7883,2546],[7951,2525],[8027,2449],[8099,2329],[8061,2317],[8095,2295],[8087,2261],[8INSERT INTO `countries` VALUES 070,2244],[8048,2189],[8019,2172],[8095,2104],[8108,2108],[8112,2091],[8099,2087],[8087,2091],[8065,2074],[8027,2100],[8010,2087],[8010,2066],[7980,2066],[7980,2036],[8010,2036],[8019,2028],[8074,1977],[8104,1989],[8082,2019],[8087,2036],[8074,2045],[8074,2049],[8142,2011],[8163,2011],[8236,1947],[8265,1964],[8270,1943],[8312,1926],[8321,1909],[8338,1930],[8338,1913],[8350,1909],[8350,1845],[8372,1828],[8406,1841],[8452,1726],[8346,1747],[8316,1687],[8253,1670],[8206,1560],[8134,1530],[8065,1539INSERT INTO `countries` VALUES ],[8040,1560],[8040,1568],[8061,1568],[8061,1590],[7980,1679],[7946,1666],[7917,1730],[7925,1747],[8002,1734],[8040,1773],[8031,1785],[7968,1785],[7866,1845],[7819,1836],[7802,1862],[7815,1883],[7747,1926],[7683,1930],[7623,1955],[7504,1917],[7385,1917],[7347,1862],[7292,1841],[7228,1832],[7219,1819],[7232,1802],[7207,1738],[7147,1713]],[[7778,2618],[7741,2624],[7723,2642],[7725,2664],[7750,2674],[7775,2657],[7789,2629]]');
INSERT INTO `countries` VALUES (46,'Christmas Island','Oceania','Oceania',162,'CX','CXR','cx',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (47,'Cocos (Keeling) Islands','Oceania','Oceania',166,'CC','CCK','cc',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (48,'Colombia','South America','South America',170,'CO','COL','co',0,1,0,0,0,'[[2517,2984],[2534,2963],[2530,2942],[2547,2950],[2598,2874],[2645,2869],[2691,2835],[2704,2848],[2683,2861],[2640,2929],[2691,2988],[2734,2988],[2751,3014],[2806,3010],[2793,3061],[2810,3091],[2798,3103],[2815,3120],[2823,3154],[2806,3129],[2793,3137],[2738,3137],[2738,3154],[2755,3154],[2755,3167],[2734,3167],[2734,3193],[2755,3222],[2738,3303],[2717,3290],[2734,3261],[2687,3248],[2649,3252],[2632,3218],[2589,3188],[2491,3146],[2534,3082],[2526,3069],[25INSERT INTO `countries` VALUES 30,2997]]');
INSERT INTO `countries` VALUES (49,'Comoros','Africa','Eastern Africa',174,'KM','COM','km',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (50,'Congo','Africa','Central Africa',178,'CG','COG','cg',0,1,0,0,0,'[[5140,3125],[5153,3086],[5208,3086],[5208,3099],[5183,3205],[5140,3248],[5140,3282],[5132,3295],[5102,3320],[5094,3320],[5094,3307],[5072,3312],[5064,3320],[5055,3316],[5047,3307],[5026,3329],[5000,3295],[5013,3282],[5021,3290],[5013,3252],[5038,3248],[5038,3239],[5047,3235],[5055,3252],[5085,3252],[5094,3201],[5077,3193],[5094,3150],[5060,3150],[5060,3125],[5098,3125],[5140,3142]]');
INSERT INTO `countries` VALUES (51,'Congo, The Democratic Republic of the','Africa','Central Africa',180,'CD','COD','cd',0,0,1,0,0,'[[5506,3282],[5497,3265],[5497,3252],[5519,3222],[5519,3184],[5565,3125],[5548,3116],[5553,3086],[5455,3044],[5332,3048],[5319,3069],[5259,3061],[5238,3040],[5208,3065],[5208,3086],[5208,3099],[5183,3205],[5140,3248],[5140,3282],[5132,3295],[5102,3320],[5094,3320],[5094,3307],[5072,3312],[5064,3320],[5055,3316],[5038,3329],[5038,3346],[5030,3346],[5038,3354],[5051,3350],[5153,3350],[5179,3409],[5230,3409],[5234,3380],[5264,3380],[5264,3388],[5298,3388],[531INSERT INTO `countries` VALUES 0,3503],[5361,3494],[5370,3494],[5374,3507],[5395,3503],[5400,3511],[5442,3524],[5446,3511],[5506,3562],[5523,3562],[5523,3528],[5502,3533],[5480,3507],[5489,3486],[5485,3448],[5497,3426],[5544,3414],[5510,3358],[5502,3324]]');
INSERT INTO `countries` VALUES (52,'Cook Islands','Oceania','Polynesia',184,'CK','COK','ck',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (53,'Costa Rica','North America','Central America',188,'CR','CRI','cr',0,1,0,0,0,'[[2355,2882],[2347,2886],[2321,2874],[2300,2869],[2296,2874],[2292,2899],[2313,2916],[2326,2912],[2372,2954],[2381,2916]]');
INSERT INTO `countries` VALUES (54,'Côte d\'Ivoire','Africa','Western Africa',384,'CI','CIV','ci',0,1,1,0,0,'[[4613,3044],[4600,3001],[4622,2954],[4613,2925],[4592,2903],[4571,2916],[4537,2895],[4520,2903],[4515,2891],[4494,2903],[4469,2899],[4456,2976],[4452,3001],[4481,3027],[4477,3065],[4532,3044],[4588,3040]]');
INSERT INTO `countries` VALUES (55,'Croatia','Europe','Southern Europe',191,'HR','HRV','hr',0,1,0,0,0,'[[5217,1811],[5187,1811],[5149,1785],[5128,1802],[5119,1824],[5072,1824],[5077,1845],[5204,1926],[5128,1845],[5132,1832],[5225,1841]]');
INSERT INTO `countries` VALUES (56,'Cuba','North America','Caribbean',192,'CU','CUB','cu',0,1,0,0,0,'[[2334,2551],[2394,2525],[2496,2546],[2619,2614],[2521,2623],[2534,2602],[2398,2542],[2330,2568]],[[2372,2563],[2368,2576],[2385,2576]]');
INSERT INTO `countries` VALUES (57,'Cyprus','Europe','Middle East',196,'CY','CYP','cy',1,1,0,0,0,'[[5655,2145],[5631,2156],[5609,2154],[5606,2163],[5592,2165],[5611,2181],[5639,2167],[5638,2158]]');
INSERT INTO `countries` VALUES (58,'Czech Republic','Europe','Eastern Europe',203,'CZ','CZE','cz',1,1,0,0,0,'[[5217,1679],[5166,1709],[5111,1696],[5102,1713],[5077,1709],[5034,1653],[5106,1628],[5208,1666]]');
INSERT INTO `countries` VALUES (59,'Denmark','Europe','Nordic Countries',208,'DK','DNK','dk',1,1,0,0,0,'[[4932,1479],[4957,1479],[4962,1454],[4983,1475],[4991,1458],[4974,1449],[4966,1454],[4966,1449],[4996,1415],[4979,1411],[4983,1364],[4953,1390],[4932,1390],[4915,1415],[4915,1454],[4932,1458]],[[5038,1432],[5021,1437],[5021,1445],[5013,1437],[5000,1449],[5004,1466],[5030,1475],[5030,1466],[5038,1462],[5030,1454],[5043,1449]],[[5000,1475],[4996,1483],[5013,1492],[5026,1488],[5034,1475],[5017,1475],[5013,1479]]');
INSERT INTO `countries` VALUES (60,'Djibouti','Africa','Eastern Africa',262,'DJ','DJI','dj',0,1,0,0,0,'[[5893,2831],[5872,2835],[5859,2857],[5859,2878],[5889,2878],[5897,2865],[5884,2861],[5901,2848]]');
INSERT INTO `countries` VALUES (61,'Dominica','North America','Caribbean',212,'DM','DMA','dm',0,1,0,0,0,'[[2974,2746],[2980,2749],[2980,2757],[2977,2758]]');
INSERT INTO `countries` VALUES (62,'Dominican Republic','North America','Caribbean',214,'DO','DOM','do',0,1,0,0,0,'[[2687,2627],[2687,2674],[2696,2687],[2721,2665],[2776,2670],[2785,2661],[2713,2623]]');
INSERT INTO `countries` VALUES (63,'Ecuador','South America','South America',218,'EC','ECU','ec',0,1,0,0,0,'[[2589,3188],[2491,3146],[2432,3214],[2432,3248],[2462,3269],[2449,3282],[2445,3312],[2470,3312],[2483,3329],[2513,3269],[2551,3256],[2589,3214]]');
INSERT INTO `countries` VALUES (64,'Egypt','Africa','Northern Africa',818,'EG','EGY','eg',0,1,0,0,0,'[[5646,2283],[5668,2338],[5646,2389],[5595,2325],[5685,2529],[5638,2572],[5616,2563],[5391,2563],[5391,2274],[5412,2274],[5502,2300],[5557,2278],[5612,2291]]');
INSERT INTO `countries` VALUES (65,'El Salvador','North America','Central America',222,'SV','SLV','sv',0,1,0,0,0,'[[2194,2780],[2241,2797],[2236,2814],[2173,2797]]');
INSERT INTO `countries` VALUES (66,'Equatorial Guinea','Africa','Central Africa',226,'GQ','GNQ','gq',0,1,1,0,0,'[[4957,3159],[5009,3159],[5009,3125],[4962,3125],[4953,3154]],[[4940,3082],[4932,3095],[4923,3091],[4932,3082]]');
INSERT INTO `countries` VALUES (67,'Eritrea','Africa','Eastern Africa',232,'ER','ERI','er',0,1,0,0,0,'[[5765,2678],[5723,2708],[5710,2784],[5740,2789],[5748,2767],[5765,2780],[5812,2780],[5872,2835],[5893,2831],[5838,2772],[5812,2763],[5804,2750],[5799,2755],[5787,2733],[5774,2691]]');
INSERT INTO `countries` VALUES (68,'Estonia','Europe','Baltic Countries',233,'EE','EST','ee',1,1,0,0,0,'[[5319,1313],[5306,1318],[5319,1326],[5302,1335],[5306,1360],[5340,1330],[5323,1326],[5332,1318]],[[5370,1360],[5395,1352],[5429,1373],[5442,1369],[5451,1373],[5463,1360],[5455,1322],[5472,1296],[5408,1288],[5344,1305],[5353,1343],[5374,1343]]');
INSERT INTO `countries` VALUES (69,'Ethiopia','Africa','Eastern Africa',230,'ET','ETH','et',0,1,0,0,0,'[[5693,3057],[5689,3035],[5612,2967],[5616,2950],[5638,2950],[5651,2882],[5663,2886],[5710,2784],[5740,2789],[5748,2767],[5765,2780],[5812,2780],[5872,2835],[5859,2857],[5859,2878],[5889,2878],[5880,2886],[5914,2929],[5999,2963],[6029,2963],[5948,3048],[5918,3048],[5859,3074],[5838,3074],[5829,3065],[5795,3091],[5753,3086],[5719,3061]]');
INSERT INTO `countries` VALUES (70,'Falkland Islands (Malvinas)','South America','South America',238,'FK','FLK','fk',0,0,0,0,0,'[[3074,4761],[2997,4761],[3002,4783],[2985,4783],[2997,4795],[3036,4766],[3019,4800],[3078,4774]]');
INSERT INTO `countries` VALUES (71,'Faroe Islands','Europe','Nordic Countries',234,'FO','FRO','fo',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (72,'Fiji Islands','Oceania','Melanesia',242,'FJ','FJI','fj',0,1,0,0,0,'[[9663,3672],[9636,3692],[9663,3703],[9680,3695]],[[9673,3658],[9681,3665],[9722,3660],[9710,3641]]');
INSERT INTO `countries` VALUES (73,'Finland','Europe','Nordic Countries',246,'FI','FIN','fi',1,1,0,0,0,'[[5361,1020],[5349,918],[5268,867],[5285,850],[5327,884],[5361,875],[5387,888],[5429,820],[5468,816],[5502,833],[5510,841],[5497,863],[5480,875],[5493,875],[5485,888],[5493,909],[5527,931],[5502,965],[5531,1024],[5523,1028],[5519,1054],[5544,1096],[5527,1113],[5574,1148],[5561,1169],[5468,1250],[5336,1279],[5285,1250],[5293,1207],[5281,1156],[5378,1062],[5400,1058],[5395,1033]]');
INSERT INTO `countries` VALUES (74,'France','Europe','Western Europe',250,'FR','FRA','fr',1,1,0,0,0,'[[4643,1896],[4732,1921],[4741,1921],[4775,1926],[4779,1900],[4809,1892],[4864,1904],[4887,1890],[4898,1883],[4902,1866],[4881,1862],[4885,1849],[4877,1836],[4889,1824],[4881,1790],[4860,1798],[4885,1756],[4902,1751],[4919,1700],[4868,1683],[4851,1679],[4843,1679],[4762,1624],[4732,1632],[4732,1658],[4685,1687],[4660,1683],[4656,1675],[4639,1675],[4647,1713],[4613,1713],[4600,1704],[4558,1713],[4571,1743],[4622,1751],[4660,1819],[4656,1862]],[[4954,1905],[4INSERT INTO `countries` VALUES 957,1936],[4947,1960],[4931,1943],[4932,1923],[4950,1915]]');
INSERT INTO `countries` VALUES (75,'French Guiana','South America','South America',254,'GF','GUF','gf',0,0,0,0,0,'[[3185,3023],[3168,3048],[3185,3086],[3168,3120],[3210,3125],[3248,3069],[3219,3040]]');
INSERT INTO `countries` VALUES (76,'French Polynesia','Oceania','Polynesia',258,'PF','PYF','pf',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (77,'French Southern Territories','Antarctica','Antarctica',260,'TF','ATF','tf',0,0,0,0,0,'[[6616,4664],[6637,4681],[6658,4676],[6650,4702],[6611,4698]]');
INSERT INTO `countries` VALUES (78,'Gabon','Africa','Central Africa',266,'GA','GAB','ga',0,1,1,0,0,'[[5000,3295],[5013,3282],[5021,3290],[5013,3252],[5038,3248],[5038,3239],[5047,3235],[5055,3252],[5085,3252],[5094,3201],[5077,3193],[5094,3150],[5060,3150],[5060,3125],[5009,3125],[5009,3159],[4957,3159],[4953,3184],[4936,3210],[4949,3239]]');
INSERT INTO `countries` VALUES (79,'Gambia','Africa','Western Africa',270,'GM','GMB','gm',0,1,0,1,0,'[[4222,2818],[4269,2806],[4294,2814],[4307,2810],[4273,2797],[4226,2806]]');
INSERT INTO `countries` VALUES (80,'Georgia','Asia','Middle East',268,'GE','GEO','ge',0,1,0,0,0,'[[5850,1955],[5880,1955],[5906,1968],[5948,1964],[5957,1960],[5991,1972],[5995,1964],[5982,1951],[5986,1943],[5965,1934],[5969,1926],[5812,1887],[5808,1896],[5846,1917],[5855,1951]]');
INSERT INTO `countries` VALUES (81,'Germany','Europe','Western Europe',276,'DE','DEU','de',1,1,0,0,0,'[[4885,1539],[4889,1526],[4936,1517],[4932,1479],[4957,1479],[4974,1496],[5000,1496],[4996,1513],[5055,1496],[5085,1517],[5094,1547],[5085,1556],[5098,1568],[5106,1628],[5034,1653],[5077,1709],[5047,1730],[5051,1751],[4902,1751],[4919,1700],[4868,1683],[4872,1670],[4860,1658],[4868,1649],[4860,1632],[4847,1632],[4864,1607],[4855,1594],[4881,1590],[4889,1543]]');
INSERT INTO `countries` VALUES (82,'Ghana','Africa','Western Africa',288,'GH','GHA','gh',0,1,0,1,0,'[[4724,3014],[4707,2997],[4702,2899],[4685,2886],[4694,2874],[4685,2873],[4677,2878],[4613,2878],[4613,2925],[4622,2954],[4600,3001],[4613,3044],[4634,3052]]');
INSERT INTO `countries` VALUES (83,'Gibraltar','Europe','Southern Europe',292,'GI','GIB','gi',0,0,0,0,0,'[[4541,2130],[4542,2132],[4540,2133]]');
INSERT INTO `countries` VALUES (84,'Greece','Europe','Southern Europe',300,'GR','GRC','gr',1,1,0,0,0,'[[5255,2023],[5276,1989],[5276,1981],[5332,1964],[5374,1955],[5395,1968],[5421,1964],[5425,1951],[5421,1985],[5391,1977],[5353,1985],[5361,1998],[5340,2002],[5327,1994],[5319,2006],[5374,2070],[5361,2070],[5361,2087],[5349,2074],[5336,2079],[5349,2091],[5336,2096],[5323,2087],[5336,2125],[5323,2113],[5319,2125],[5306,2104],[5302,2113],[5293,2100],[5298,2096],[5281,2074],[5298,2062],[5332,2074],[5336,2070],[5302,2062],[5281,2062]],[[5349,2151],[5349,2159],[5INSERT INTO `countries` VALUES 387,2168],[5425,2168],[5425,2159]]');
INSERT INTO `countries` VALUES (85,'Greenland','North America','North America',304,'GL','GRL','gl',0,0,0,0,0,'[[2815,229],[2878,259],[2657,361],[2789,420],[2708,433],[2798,501],[2955,480],[3110,573],[3154,661],[3143,743],[3205,723],[3270,786],[3168,777],[3193,850],[3274,829],[3189,935],[3321,1211],[3469,1271],[3576,1045],[3703,1007],[3788,897],[4065,816],[4060,650],[4154,582],[4133,306],[4354,148],[4218,123],[4060,165],[4077,89],[3763,0],[3321,59],[3359,110],[3240,76],[3253,114],[3138,97],[2959,140],[2963,182],[2921,178]]');
INSERT INTO `countries` VALUES (86,'Grenada','North America','Caribbean',308,'GD','GRD','gd',0,1,0,0,0,'[[2967,2842],[2971,2846],[2965,2849]]');
INSERT INTO `countries` VALUES (87,'Guadeloupe','North America','Caribbean',312,'GP','GLP','gp',0,0,0,0,0,'[[2965,2725],[2972,2726],[2975,2720],[2982,2728],[2972,2731],[2967,2737]]');
INSERT INTO `countries` VALUES (88,'Guam','Oceania','Micronesia',316,'GU','GUM','gu',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (89,'Guatemala','North America','Central America',320,'GT','GTM','gt',0,1,0,0,0,'[[2207,2738],[2202,2738],[2202,2682],[2151,2682],[2151,2699],[2139,2699],[2164,2733],[2130,2733],[2113,2776],[2143,2793],[2173,2797],[2194,2780],[2228,2742]]');
INSERT INTO `countries` VALUES (90,'Guinea','Africa','Western Africa',324,'GN','GIN','gn',0,1,1,0,0,'[[4320,2933],[4345,2908],[4379,2908],[4396,2942],[4392,2950],[4405,2946],[4422,2950],[4426,2976],[4439,2984],[4447,2971],[4456,2976],[4469,2899],[4430,2844],[4375,2852],[4371,2835],[4307,2831],[4307,2857],[4277,2865],[4273,2878]]');
INSERT INTO `countries` VALUES (91,'Guinea-Bissau','Africa','Western Africa',624,'GW','GNB','gw',0,1,1,0,0,'[[4273,2878],[4277,2865],[4307,2857],[4307,2831],[4264,2831],[4222,2840],[4247,2857],[4260,2857],[4256,2865]]');
INSERT INTO `countries` VALUES (92,'Guyana','South America','South America',328,'GY','GUY','gy',0,1,0,0,0,'[[3023,2950],[2993,2976],[3006,2988],[2976,3018],[2997,3040],[3014,3044],[3023,3133],[3048,3150],[3112,3133],[3070,3069],[3095,3023]]');
INSERT INTO `countries` VALUES (93,'Haiti','North America','Caribbean',332,'HT','HTI','ht',0,1,0,0,0,'[[2687,2627],[2687,2674],[2615,2670],[2615,2661],[2670,2661],[2662,2640],[2640,2631],[2657,2623]]');
INSERT INTO `countries` VALUES (94,'Heard Island And McDonald Islands','Antarctica','Antarctica',334,'HM','HMD','hm',0,0,0,0,0,'[[6735,4821],[6752,4825],[6739,4829]]');
INSERT INTO `countries` VALUES (95,'Holy See (Vatican City State)','Europe','Southern Europe',336,'VA','VAT','va',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (96,'Honduras','North America','Central America',340,'HN','HND','hn',0,1,0,0,0,'[[2194,2780],[2241,2797],[2236,2814],[2253,2823],[2321,2767],[2368,2763],[2334,2738],[2228,2742]]');
INSERT INTO `countries` VALUES (97,'Hong Kong','Asia','Eastern Asia',344,'HK','HKG','hk',0,0,0,0,0,'[[7870,2546],[7883,2546],[7878,2555]]');
INSERT INTO `countries` VALUES (98,'Hungary','Europe','Eastern Europe',348,'HU','HUN','hu',1,1,0,0,0,'[[5310,1721],[5327,1734],[5310,1743],[5281,1798],[5234,1798],[5217,1811],[5187,1811],[5149,1785],[5145,1773],[5166,1743],[5166,1734],[5183,1743],[5217,1738],[5217,1734],[5264,1717]]');
INSERT INTO `countries` VALUES (99,'Iceland','Europe','Nordic Countries',352,'IS','ISL','is',0,1,0,0,0,'[[4031,1058],[4082,1088],[4060,1109],[4167,1131],[4311,1054],[4239,986],[4124,1003],[4099,1037],[4056,986],[4009,1033],[4073,1037]]');
INSERT INTO `countries` VALUES (100,'India','Asia','Southern and Central Asia',356,'IN','IND','in',0,1,0,0,0,'[[6594,2508],[6675,2491],[6662,2453],[6654,2453],[6650,2427],[6637,2427],[6633,2415],[6658,2385],[6667,2393],[6696,2385],[6773,2291],[6773,2270],[6794,2253],[6777,2249],[6752,2189],[6764,2176],[6807,2185],[6862,2155],[6896,2189],[6888,2198],[6913,2240],[6896,2253],[6888,2244],[6879,2249],[6892,2283],[6952,2317],[6922,2355],[7015,2406],[7037,2402],[7054,2406],[7054,2415],[7075,2423],[7147,2432],[7151,2389],[7168,2381],[7168,2415],[7198,2423],[7262,2419],[7258,INSERT INTO `countries` VALUES 2402],[7249,2402],[7249,2393],[7279,2385],[7334,2346],[7355,2351],[7372,2342],[7406,2376],[7406,2389],[7394,2402],[7402,2415],[7385,2406],[7347,2427],[7317,2508],[7296,2504],[7292,2555],[7275,2563],[7266,2512],[7245,2538],[7236,2512],[7270,2474],[7198,2466],[7194,2440],[7160,2432],[7151,2449],[7173,2466],[7147,2487],[7168,2495],[7177,2568],[7122,2576],[7117,2602],[6926,2755],[6935,2814],[6918,2861],[6918,2899],[6905,2899],[6896,2925],[6875,2933],[6871,2954],[6854,2963],[6828,2937],[6820,2908],[6INSERT INTO `countries` VALUES 743,2738],[6718,2627],[6726,2606],[6713,2559],[6701,2589],[6667,2602],[6616,2555],[6650,2546],[6650,2538],[6633,2542]]');
INSERT INTO `countries` VALUES (101,'Indonesia','Asia','Southeast Asia',360,'ID','IDN','id',0,1,0,0,0,'[[7347,3031],[7411,3044],[7432,3074],[7585,3180],[7577,3205],[7606,3218],[7619,3252],[7640,3256],[7649,3273],[7640,3350],[7598,3341],[7543,3299],[7474,3188],[7457,3180],[7449,3142],[7394,3086],[7381,3082]],[[7623,3244],[7645,3231],[7657,3256],[7670,3261],[7666,3278],[7649,3265],[7645,3248]],[[7696,3261],[7691,3278],[7708,3278],[7713,3265]],[[7649,3354],[7632,3380],[7662,3384],[7657,3392],[7887,3435],[7883,3409],[7844,3401],[7836,3388],[7874,3384],[7785,3371],INSERT INTO `countries` VALUES [7772,3380],[7721,3375],[7713,3358]],[[7980,3074],[7921,3069],[7887,3146],[7861,3154],[7827,3146],[7819,3159],[7776,3163],[7751,3133],[7730,3159],[7747,3222],[7755,3218],[7768,3269],[7810,3269],[7810,3286],[7887,3286],[7887,3303],[7929,3290],[7980,3159],[8010,3159],[7968,3099]],[[8176,3137],[8189,3146],[8163,3176],[8053,3176],[8040,3205],[8070,3227],[8082,3210],[8134,3205],[8082,3248],[8129,3316],[8121,3346],[8108,3333],[8116,3312],[8091,3324],[8082,3320],[8070,3265],[8044,3273],[8057,3346],[802INSERT INTO `countries` VALUES 3,3341],[8027,3286],[8006,3282],[8044,3167],[8070,3154],[8155,3167]],[[7887,3418],[7908,3414],[7921,3422],[7908,3435]],[[7934,3418],[7946,3422],[7938,3435],[7925,3431]],[[7955,3422],[7951,3443],[7993,3431]],[[7976,3414],[8010,3418],[8014,3431],[7997,3435]],[[8031,3431],[8053,3418],[8104,3431],[8180,3414],[8185,3422],[8087,3435]],[[8176,3439],[8180,3452],[8142,3482],[8134,3473],[8146,3452]],[[8053,3477],[8061,3469],[8036,3448],[8010,3452]],[[8210,3278],[8236,3273],[8244,3290],[8231,3295]],[[8265,INSERT INTO `countries` VALUES 3269],[8325,3269],[8346,3295],[8287,3278],[8274,3286]],[[8278,3116],[8270,3123],[8248,3142],[8257,3197],[8274,3214],[8261,3184],[8261,3171],[8282,3180],[8282,3176],[8265,3167],[8282,3154],[8282,3142],[8257,3167],[8257,3159],[8265,3142],[8261,3137]],[[8253,3227],[8248,3235],[8265,3235]],[[8163,3235],[8219,3239],[8163,3244]],[[8346,3222],[8389,3197],[8431,3205],[8444,3261],[8457,3278],[8474,3282],[8537,3231],[8627,3261],[8627,3439],[8593,3414],[8533,3422],[8546,3397],[8567,3392],[8542,3337],[8418,INSERT INTO `countries` VALUES 3286],[8410,3303],[8380,3265],[8427,3252],[8380,3248],[8372,3231]],[[8444,3341],[8435,3363],[8435,3375],[8452,3363]],[[8363,3388],[8350,3405],[8350,3414],[8363,3397]]');
INSERT INTO `countries` VALUES (102,'Iran, Islamic Republic of','Asia','Southern and Central Asia',364,'IR','IRN','ir',0,1,0,0,0,'[[6042,2325],[6025,2270],[5961,2198],[5978,2142],[5957,2138],[5940,2100],[5923,2028],[5935,2015],[5961,2040],[5978,2045],[5986,2045],[6029,2019],[6054,2062],[6063,2087],[6139,2121],[6199,2108],[6195,2096],[6267,2062],[6399,2117],[6403,2151],[6382,2227],[6390,2278],[6416,2283],[6416,2300],[6390,2329],[6454,2406],[6454,2427],[6416,2436],[6407,2470],[6288,2453],[6276,2410],[6216,2427],[6131,2389],[6084,2317]]');
INSERT INTO `countries` VALUES (103,'Iraq','Asia','Middle East',368,'IQ','IRQ','iq',0,1,0,0,0,'[[5940,2100],[5876,2100],[5855,2121],[5846,2121],[5833,2189],[5774,2219],[5787,2257],[5863,2287],[5940,2351],[5991,2351],[6008,2325],[6042,2325],[6025,2270],[5961,2198],[5978,2142],[5957,2138]]');
INSERT INTO `countries` VALUES (104,'Ireland','Europe','British Islands',372,'IE','IRL','ie',1,1,0,0,0,'[[4515,1513],[4494,1496],[4486,1509],[4464,1496],[4490,1471],[4494,1462],[4460,1466],[4443,1488],[4456,1492],[4447,1500],[4409,1500],[4409,1534],[4430,1547],[4401,1581],[4418,1607],[4511,1581],[4524,1551]]');
INSERT INTO `countries` VALUES (105,'Israel','Asia','Middle East',376,'IL','ISR','il',0,1,0,0,0,'[[5672,2227],[5685,2223],[5685,2240],[5680,2291],[5668,2338],[5646,2283],[5659,2266]]');
INSERT INTO `countries` VALUES (106,'Italy','Europe','Southern Europe',380,'IT','ITA','it',1,1,0,0,0,'[[4898,1883],[4936,1858],[5055,1968],[5128,2006],[5145,2045],[5128,2066],[5136,2079],[5170,2032],[5153,2015],[5170,1994],[5200,2015],[5208,2002],[5153,1968],[5136,1955],[5140,1943],[5111,1943],[5068,1887],[5034,1866],[5034,1824],[5068,1811],[5072,1785],[5030,1768],[4983,1777],[4974,1798],[4953,1790],[4940,1811],[4923,1790],[4911,1807],[4885,1807],[4889,1824],[4877,1836],[4885,1849],[4881,1862],[4902,1866]],[[5123,2066],[5111,2113],[5034,2079]],[[4953,1968],INSERT INTO `countries` VALUES [4966,1994],[4957,2036],[4923,2036],[4919,1981]]');
INSERT INTO `countries` VALUES (107,'Jamaica','North America','Caribbean',388,'JM','JAM','jm',0,1,0,0,0,'[[2500,2670],[2530,2661],[2564,2678],[2534,2687]]');
INSERT INTO `countries` VALUES (108,'Japan','Asia','Eastern Asia',392,'JP','JPN','jp',0,1,0,0,0,'[[8644,1828],[8635,1900],[8593,1917],[8601,1955],[8622,1947],[8610,1926],[8652,1917],[8686,1938],[8754,1896],[8746,1862],[8716,1875],[8652,1819]],[[8431,2189],[8452,2202],[8435,2223],[8418,2215],[8401,2240],[8384,2219],[8401,2198],[8410,2206],[8418,2202],[8423,2193]],[[8346,2202],[8380,2232],[8355,2283],[8342,2295],[8325,2283],[8333,2240],[8304,2223]],[[8610,1964],[8622,1960],[8661,2028],[8627,2074],[8618,2142],[8499,2189],[8482,2219],[8457,2193],[8469,2176],INSERT INTO `countries` VALUES [8389,2193],[8380,2202],[8346,2198],[8350,2185],[8397,2151],[8465,2147],[8482,2155],[8491,2147],[8486,2134],[8516,2100],[8525,2113],[8580,2066],[8601,2011],[8597,1985]]');
INSERT INTO `countries` VALUES (109,'Jordan','Asia','Middle East',400,'JO','JOR','jo',0,1,0,0,0,'[[5774,2219],[5719,2253],[5685,2240],[5680,2291],[5668,2338],[5668,2346],[5697,2351],[5753,2308],[5723,2278],[5787,2257]]');
INSERT INTO `countries` VALUES (110,'Kazakhstan','Asia','Southern and Central Asia',398,'KZ','KAZ','kz',0,1,0,0,0,'[[6254,1964],[6241,1968],[6207,1930],[6173,1934],[6156,1951],[6152,1934],[6165,1921],[6139,1913],[6110,1866],[6093,1862],[6093,1849],[6122,1853],[6114,1841],[6127,1828],[6165,1824],[6173,1781],[6118,1764],[6063,1790],[5991,1717],[6020,1645],[6042,1670],[6054,1662],[6050,1641],[6110,1598],[6152,1598],[6246,1641],[6322,1619],[6356,1645],[6403,1632],[6407,1611],[6365,1590],[6395,1577],[6386,1560],[6399,1551],[6420,1551],[6424,1547],[6399,1539],[6399,1517],[6628,INSERT INTO `countries` VALUES 1462],[6667,1462],[6679,1509],[6743,1517],[6743,1530],[6832,1500],[6926,1632],[6952,1615],[6986,1636],[7020,1624],[7096,1679],[7113,1675],[7130,1696],[7083,1721],[7083,1764],[7007,1764],[6981,1832],[6930,1841],[6930,1934],[6901,1913],[6803,1913],[6760,1900],[6739,1926],[6688,1913],[6671,1934],[6616,1964],[6603,1985],[6582,1968],[6556,1968],[6548,1943],[6535,1943],[6535,1909],[6526,1913],[6501,1883],[6420,1892],[6395,1862],[6327,1819],[6254,1841]]');
INSERT INTO `countries` VALUES (111,'Kenya','Africa','Eastern Africa',404,'KE','KEN','ke',0,1,0,1,0,'[[5638,3069],[5651,3057],[5693,3057],[5719,3061],[5753,3086],[5795,3091],[5829,3065],[5838,3074],[5859,3074],[5833,3108],[5833,3210],[5850,3231],[5825,3256],[5812,3261],[5812,3278],[5787,3316],[5740,3282],[5744,3273],[5642,3214],[5638,3180],[5672,3129]]');
INSERT INTO `countries` VALUES (112,'Kiribati','Oceania','Micronesia',296,'KI','KIR','ki',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (113,'Korea, Democratic People\'s Republic Of','Asia','Eastern Asia',408,'KP','PRK','kp',0,0,0,0,0,'[[8163,2011],[8236,1947],[8265,1964],[8270,1943],[8312,1926],[8321,1909],[8338,1930],[8308,1955],[8312,1981],[8248,2015],[8248,2036],[8274,2053],[8227,2079],[8176,2070],[8189,2023]]');
INSERT INTO `countries` VALUES (114,'Korea, Republic Of','Asia','Eastern Asia',410,'KR','KOR','kr',0,1,0,0,0,'[[8274,2053],[8308,2108],[8295,2168],[8223,2189],[8214,2168],[8227,2134],[8214,2113],[8231,2104],[8227,2079]]');
INSERT INTO `countries` VALUES (115,'Kuwait','Asia','Middle East',414,'KW','KWT','kw',0,1,0,0,0,'[[6042,2325],[6025,2342],[6042,2368],[6020,2368],[6016,2355],[5991,2351],[6008,2325]]');
INSERT INTO `countries` VALUES (116,'Kyrgyzstan','Asia','Southern and Central Asia',417,'KG','KGZ','kg',0,1,0,0,0,'[[6747,2023],[6667,2028],[6628,2023],[6624,2015],[6645,2002],[6662,2011],[6671,2002],[6692,2006],[6730,1981],[6692,1960],[6684,1968],[6654,1955],[6679,1938],[6671,1934],[6688,1913],[6739,1926],[6760,1900],[6803,1913],[6901,1913],[6930,1934],[6871,1972],[6837,1977],[6820,1994],[6781,1994],[6756,2006],[6752,2023]]');
INSERT INTO `countries` VALUES (117,'Lao People\'s Democratic Republic','Asia','Southeast Asia',418,'LA','LAO','la',0,1,0,0,0,'[[7513,2576],[7483,2610],[7496,2619],[7496,2636],[7517,2636],[7509,2691],[7513,2695],[7543,2674],[7555,2687],[7577,2665],[7615,2699],[7615,2721],[7640,2746],[7636,2763],[7636,2780],[7628,2784],[7649,2797],[7653,2793],[7653,2784],[7666,2780],[7674,2784],[7691,2776],[7696,2759],[7683,2742],[7691,2738],[7623,2665],[7628,2661],[7594,2640],[7623,2619],[7598,2593],[7585,2602],[7564,2585],[7564,2572],[7543,2551],[7530,2551],[7526,2555],[7530,2589],[7517,2585]]');
INSERT INTO `countries` VALUES (118,'Latvia','Europe','Baltic Countries',428,'LV','LVA','lv',1,1,0,0,0,'[[5276,1432],[5310,1420],[5387,1420],[5434,1449],[5476,1428],[5468,1381],[5442,1369],[5429,1373],[5395,1352],[5370,1360],[5370,1386],[5349,1398],[5319,1364],[5285,1386]]');
INSERT INTO `countries` VALUES (119,'Lebanon','Asia','Middle East',422,'LB','LBN','lb',0,1,0,0,0,'[[5693,2181],[5702,2181],[5710,2193],[5685,2223],[5672,2227]]');
INSERT INTO `countries` VALUES (120,'Lesotho','Africa','Southern Africa',426,'LS','LSO','ls',0,1,0,1,0,NULL);
INSERT INTO `countries` VALUES (121,'Liberia','Africa','Western Africa',430,'LR','LBR','lr',0,1,0,0,0,'[[4477,3065],[4481,3027],[4452,3001],[4456,2976],[4447,2971],[4439,2984],[4426,2976],[4422,2950],[4405,2946],[4371,2993],[4435,3044]]');
INSERT INTO `countries` VALUES (122,'Libyan Arab Jamahiriya','Africa','Northern Africa',434,'LY','LBY','ly',0,1,0,0,0,'[[5391,2274],[5391,2563],[5391,2623],[5361,2623],[5361,2636],[5136,2521],[5111,2533],[5089,2546],[5068,2529],[5026,2517],[4953,2440],[4953,2317],[4979,2300],[4970,2278],[5013,2249],[5013,2227],[5115,2253],[5128,2278],[5225,2317],[5255,2287],[5247,2270],[5298,2232],[5336,2244],[5340,2257],[5387,2266]]');
INSERT INTO `countries` VALUES (123,'Liechtenstein','Europe','Western Europe',438,'LI','LIE','li',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (124,'Lithuania','Europe','Baltic Countries',440,'LT','LTU','lt',1,1,0,0,0,'[[5285,1462],[5276,1432],[5310,1420],[5387,1420],[5434,1449],[5404,1505],[5349,1517],[5323,1496],[5323,1471]]');
INSERT INTO `countries` VALUES (125,'Luxembourg','Europe','Western Europe',442,'LU','LUX','lu',1,1,0,0,1,'[[4851,1666],[4851,1679],[4868,1683],[4872,1670],[4860,1658]]');
INSERT INTO `countries` VALUES (126,'Macao','Asia','Eastern Asia',446,'MO','MAC','mo',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (127,'Macedonia, the Former Yugoslav Republic of','Europe','Southern Europe',807,'MK','MKD','mk',0,1,0,0,0,'[[5315,1930],[5327,1943],[5332,1964],[5276,1981],[5264,1968],[5268,1943]]');
INSERT INTO `countries` VALUES (128,'Madagascar','Africa','Eastern Africa',450,'MG','MDG','mg',0,1,0,0,0,'[[5952,3915],[6003,3898],[6101,3618],[6067,3520],[6003,3613],[5931,3643],[5914,3677],[5931,3750],[5901,3801],[5910,3856],[5927,3903]]');
INSERT INTO `countries` VALUES (129,'Malawi','Africa','Eastern Africa',454,'MW','MWI','mw',0,1,0,1,0,'[[5608,3443],[5642,3456],[5668,3511],[5663,3571],[5693,3596],[5689,3639],[5672,3652],[5676,3669],[5646,3631],[5655,3613],[5651,3592],[5629,3596],[5616,3579],[5629,3482]]');
INSERT INTO `countries` VALUES (130,'Malaysia','Asia','Southeast Asia',458,'MY','MYS','my',0,1,0,0,0,'[[7487,3010],[7491,3006],[7513,3014],[7513,3031],[7534,3027],[7543,3014],[7577,3048],[7577,3108],[7585,3116],[7602,3146],[7585,3146],[7581,3150],[7517,3108],[7517,3095],[7500,3078]],[[7751,3133],[7776,3163],[7819,3159],[7827,3146],[7861,3154],[7887,3146],[7921,3069],[7980,3074],[8002,3065],[7989,3048],[8019,3040],[7955,2988],[7904,3048],[7912,3065],[7895,3052],[7895,3069],[7891,3074],[7878,3061],[7844,3099],[7802,3112],[7789,3146]]');
INSERT INTO `countries` VALUES (131,'Maldives','Asia','Southern and Central Asia',462,'MV','MDV','mv',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (132,'Mali','Africa','Western Africa',466,'ML','MLI','ml',0,1,1,0,0,'[[4549,2474],[4507,2474],[4532,2721],[4541,2729],[4537,2750],[4392,2750],[4384,2763],[4366,2746],[4349,2776],[4371,2835],[4375,2852],[4430,2844],[4469,2899],[4494,2903],[4515,2891],[4520,2903],[4537,2895],[4541,2857],[4609,2793],[4630,2789],[4634,2780],[4664,2767],[4696,2767],[4717,2767],[4728,2755],[4787,2755],[4809,2725],[4809,2648],[4779,2648],[4719,2589]]');
INSERT INTO `countries` VALUES (133,'Malta','Europe','Southern Europe',470,'MT','MLT','mt',1,1,0,0,0,'[[5088,2133],[5098,2140],[5093,2142]]');
INSERT INTO `countries` VALUES (134,'Marshall Islands','Oceania','Micronesia',584,'MH','MHL','mh',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (135,'Martinique','North America','Caribbean',474,'MQ','MTQ','mq',0,0,0,0,0,'[[2981,2768],[2990,2771],[2991,2781],[2985,2779]]');
INSERT INTO `countries` VALUES (136,'Mauritania','Africa','Western Africa',478,'MR','MRT','mr',0,1,1,0,0,'[[4218,2585],[4324,2585],[4324,2534],[4354,2521],[4354,2444],[4447,2444],[4447,2406],[4549,2474],[4507,2474],[4532,2721],[4541,2729],[4537,2750],[4392,2750],[4384,2763],[4366,2746],[4349,2776],[4290,2716],[4230,2729],[4243,2687],[4230,2640],[4239,2614]]');
INSERT INTO `countries` VALUES (137,'Mauritius','Africa','Eastern Africa',480,'MU','MUS','mu',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (138,'Mayotte','Africa','Eastern Africa',175,'YT','MYT','yt',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (139,'Mexico','North America','Central America',484,'MX','MEX','mx',0,1,0,0,0,'[[1977,2444],[1926,2432],[1858,2329],[1832,2325],[1811,2355],[1718,2270],[1671,2270],[1671,2283],[1590,2283],[1488,2244],[1420,2244],[1458,2329],[1509,2372],[1501,2393],[1475,2389],[1556,2444],[1556,2478],[1624,2534],[1637,2521],[1488,2312],[1488,2266],[1526,2283],[1556,2355],[1752,2576],[1743,2610],[1798,2670],[1994,2746],[2032,2729],[2058,2733],[2113,2776],[2130,2733],[2164,2733],[2139,2699],[2151,2699],[2151,2682],[2202,2682],[2224,2661],[2241,2665],[22INSERT INTO `countries` VALUES 62,2572],[2168,2589],[2156,2640],[2126,2661],[2049,2674],[2037,2657],[2015,2657],[1956,2555]]');
INSERT INTO `countries` VALUES (140,'Micronesia, Federated States of','Oceania','Micronesia',583,'FM','FSM','fm',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (141,'Moldova, Republic of','Europe','Eastern Europe',498,'MD','MDA','md',0,1,0,0,0,'[[5438,1721],[5480,1781],[5472,1798],[5485,1832],[5519,1828],[5540,1798],[5527,1785],[5502,1734],[5459,1717]]');
INSERT INTO `countries` VALUES (142,'Monaco','Europe','Western Europe',492,'MC','MCO','mc',0,1,0,0,0,'[[4885,1892],[4887,1890],[4887,1892]]');
INSERT INTO `countries` VALUES (143,'Mongolia','Asia','Eastern Asia',496,'MN','MNG','mn',0,1,0,0,0,'[[7143,1692],[7147,1713],[7207,1738],[7232,1802],[7219,1819],[7228,1832],[7292,1841],[7347,1862],[7385,1917],[7504,1917],[7623,1955],[7683,1930],[7747,1926],[7815,1883],[7802,1862],[7819,1836],[7866,1845],[7968,1785],[8031,1785],[8040,1773],[8002,1734],[7925,1747],[7917,1730],[7946,1666],[7878,1653],[7781,1692],[7628,1645],[7585,1658],[7547,1641],[7543,1611],[7453,1585],[7419,1628],[7432,1645],[7423,1662],[7406,1670],[7334,1662],[7321,1641],[7266,1632]]');
INSERT INTO `countries` VALUES (144,'Montserrat','North America','Caribbean',500,'MS','MSR','ms',0,0,0,0,0,'[[2952,2713],[2955,2712],[2954,2716]]');
INSERT INTO `countries` VALUES (145,'Morocco','Africa','Northern Africa',504,'MA','MAR','ma',0,1,0,0,0,'[[4630,2168],[4656,2257],[4583,2270],[4583,2287],[4447,2363],[4447,2393],[4324,2393],[4409,2342],[4418,2278],[4452,2227],[4498,2202],[4524,2147],[4541,2142],[4549,2159]]');
INSERT INTO `countries` VALUES (146,'Mozambique','Africa','Eastern Africa',508,'MZ','MOZ','mz',0,1,0,1,0,'[[5821,3482],[5736,3511],[5668,3511],[5663,3571],[5693,3596],[5689,3639],[5672,3652],[5676,3669],[5646,3631],[5655,3613],[5651,3592],[5629,3596],[5616,3579],[5536,3609],[5540,3626],[5540,3635],[5608,3656],[5608,3758],[5565,3822],[5582,3928],[5587,3954],[5608,3954],[5608,3932],[5599,3928],[5685,3864],[5680,3813],[5659,3762],[5727,3686],[5804,3648],[5829,3601]]');
INSERT INTO `countries` VALUES (147,'Myanmar','Asia','Southeast Asia',104,'MM','MMR','mm',0,1,0,0,0,'[[7262,2593],[7275,2585],[7275,2563],[7292,2555],[7296,2504],[7317,2508],[7347,2427],[7385,2406],[7402,2415],[7394,2402],[7406,2389],[7406,2376],[7419,2368],[7445,2398],[7445,2449],[7415,2483],[7415,2504],[7449,2500],[7453,2529],[7470,2534],[7457,2559],[7483,2563],[7487,2580],[7513,2576],[7483,2610],[7428,2631],[7411,2665],[7419,2687],[7449,2725],[7440,2738],[7440,2755],[7432,2759],[7440,2784],[7462,2801],[7457,2818],[7470,2857],[7440,2908],[7440,2882],[7445,INSERT INTO `countries` VALUES 2861],[7445,2835],[7398,2699],[7389,2721],[7355,2746],[7321,2733],[7330,2691],[7313,2653],[7300,2640],[7304,2631],[7283,2619]]');
INSERT INTO `countries` VALUES (148,'Namibia','Africa','Southern Africa',516,'NA','NAM','na',0,1,0,1,0,'[[5247,3894],[5247,3809],[5276,3809],[5276,3703],[5340,3694],[5349,3707],[5391,3686],[5370,3677],[5344,3686],[5272,3694],[5221,3690],[5204,3677],[5081,3677],[5055,3665],[5017,3673],[5094,3839],[5106,3941],[5149,4009],[5166,3988],[5179,4009],[5230,4017],[5247,4000]]');
INSERT INTO `countries` VALUES (149,'Nauru','Oceania','Micronesia',520,'NR','NRU','nr',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (150,'Nepal','Asia','Southern and Central Asia',524,'NP','NPL','np',0,1,0,0,0,'[[7151,2389],[7147,2432],[7075,2423],[7054,2415],[7054,2406],[7037,2402],[7015,2406],[6922,2355],[6952,2317],[6981,2317],[7088,2381]]');
INSERT INTO `countries` VALUES (151,'Netherlands','Europe','Western Europe',528,'NL','NLD','nl',1,1,0,0,1,'[[4855,1619],[4864,1607],[4855,1594],[4881,1590],[4889,1543],[4881,1534],[4847,1539],[4826,1551],[4817,1577],[4783,1611],[4830,1607]]');
INSERT INTO `countries` VALUES (152,'Netherlands Antilles','North America','Caribbean',530,'AN','ANT','an',0,0,0,0,0,'[[2759,2838],[2771,2847],[2769,2848]],[[2782,2840],[2787,2844],[2784,2848]]');
INSERT INTO `countries` VALUES (153,'New Caledonia','Oceania','Melanesia',540,'NC','NCL','nc',0,0,0,0,0,'[[9267,3756],[9307,3777],[9352,3821],[9297,3792]]');
INSERT INTO `countries` VALUES (154,'New Zealand','Oceania','Australia and New Zealand',554,'NZ','NZL','nz',0,1,0,0,0,'[[9515,4187],[9571,4294],[9562,4332],[9541,4345],[9583,4375],[9571,4409],[9588,4421],[9677,4294],[9643,4298],[9600,4285]],[[9511,4383],[9524,4409],[9558,4404],[9554,4430],[9511,4485],[9520,4498],[9473,4511],[9426,4591],[9337,4574],[9349,4545],[9460,4464],[9477,4426],[9494,4413],[9494,4396]]');
INSERT INTO `countries` VALUES (155,'Nicaragua','North America','Central America',558,'NI','NIC','ni',0,1,0,0,0,'[[2253,2823],[2321,2767],[2368,2763],[2347,2865],[2355,2882],[2347,2886],[2321,2874],[2321,2869],[2309,2852],[2292,2848],[2300,2869],[2296,2874],[2245,2827]]');
INSERT INTO `countries` VALUES (156,'Niger','Africa','Western Africa',562,'NE','NER','ne',0,1,1,0,0,'[[4792,2857],[4766,2835],[4758,2852],[4695,2767],[4718,2767],[4728,2755],[4787,2755],[4809,2725],[4809,2648],[4855,2640],[4894,2597],[5026,2517],[5068,2529],[5089,2546],[5111,2534],[5136,2610],[5123,2708],[5068,2780],[5068,2801],[5038,2818],[4991,2810],[4957,2827],[4911,2810],[4885,2823],[4817,2797]]');
INSERT INTO `countries` VALUES (157,'Nigeria','Africa','Western Africa',566,'NG','NGA','ng',0,1,0,0,0,'[[4928,3052],[4983,2988],[5009,3006],[5081,2869],[5098,2861],[5094,2840],[5085,2840],[5085,2818],[5068,2801],[5038,2818],[4991,2810],[4957,2827],[4911,2810],[4885,2823],[4817,2797],[4792,2857],[4787,2865],[4796,2895],[4775,2933],[4766,2933],[4766,3006],[4813,3006],[4860,3065]]');
INSERT INTO `countries` VALUES (158,'Niue','Oceania','Polynesia',570,'NU','NIU','nu',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (159,'Norfolk Island','Oceania','Australia and New Zealand',574,'NF','NFK','nf',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (160,'Northern Mariana Islands','Oceania','Micronesia',580,'MP','MNP','mp',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (161,'Norway','Europe','Nordic Countries',578,'NO','NOR','no',0,1,0,0,0,'[[5000,1313],[5017,1313],[5021,1279],[5038,1271],[5034,1233],[5051,1216],[5030,1199],[5026,1135],[5051,1096],[5081,1101],[5085,1079],[5072,1075],[5094,1003],[5111,1003],[5145,960],[5140,943],[5174,914],[5187,918],[5196,892],[5247,901],[5251,867],[5268,867],[5285,850],[5327,884],[5361,875],[5387,888],[5429,820],[5468,816],[5502,833],[5510,841],[5497,863],[5553,829],[5493,812],[5531,816],[5557,799],[5493,773],[5472,790],[5485,769],[5451,769],[5429,799],[54INSERT INTO `countries` VALUES 34,769],[5391,807],[5412,765],[5378,769],[5336,816],[5332,803],[5217,820],[4949,1122],[4838,1182],[4826,1228],[4847,1335],[4889,1356],[4919,1352],[4987,1296]]');
INSERT INTO `countries` VALUES (162,'Oman','Asia','Middle East',512,'OM','OMN','om',0,1,0,0,0,'[[6259,2444],[6263,2436],[6267,2436],[6263,2457]],[[6263,2478],[6250,2478],[6250,2504],[6241,2504],[6229,2546],[6246,2563],[6224,2623],[6139,2653],[6173,2721],[6305,2653],[6361,2546]]');
INSERT INTO `countries` VALUES (163,'Pakistan','Asia','Southern and Central Asia',586,'PK','PAK','pk',0,1,0,0,0,'[[6407,2470],[6416,2436],[6454,2427],[6454,2406],[6390,2329],[6433,2342],[6480,2342],[6543,2325],[6543,2295],[6594,2270],[6611,2274],[6624,2266],[6633,2232],[6654,2223],[6641,2202],[6667,2202],[6675,2193],[6671,2185],[6692,2164],[6679,2134],[6692,2121],[6726,2108],[6756,2113],[6781,2100],[6811,2117],[6815,2142],[6862,2155],[6807,2185],[6764,2176],[6752,2189],[6777,2249],[6794,2253],[6773,2270],[6773,2291],[6696,2385],[6667,2393],[6658,2385],[6633,2415],[6637,INSERT INTO `countries` VALUES 2427],[6650,2427],[6654,2453],[6662,2453],[6675,2491],[6594,2508],[6577,2508],[6548,2461]]');
INSERT INTO `countries` VALUES (164,'Palau','Oceania','Micronesia',585,'PW','PLW','pw',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (165,'Panama','North America','Central America',591,'PA','PAN','pa',0,1,0,0,0,'[[2381,2916],[2372,2954],[2406,2959],[2432,2984],[2457,2976],[2445,2954],[2474,2933],[2504,2950],[2500,2959],[2517,2984],[2534,2963],[2530,2942],[2496,2920],[2466,2916],[2423,2942]]');
INSERT INTO `countries` VALUES (166,'Papua New Guinea','Oceania','Melanesia',598,'PG','PNG','pg',0,1,0,0,0,'[[8627,3439],[8627,3261],[8750,3312],[8759,3337],[8805,3354],[8818,3375],[8793,3375],[8839,3443],[8856,3439],[8899,3482],[8814,3473],[8759,3409],[8724,3397],[8673,3452]],[[8822,3341],[8873,3367],[8937,3337],[8941,3307],[8920,3307],[8924,3324],[8899,3341]],[[8958,3324],[8963,3299],[8903,3261],[8950,3299]],[[9009,3337],[9048,3371],[9035,3380],[9014,3354]]');
INSERT INTO `countries` VALUES (167,'Paraguay','South America','South America',600,'PY','PRY','py',0,1,0,0,0,'[[2942,3818],[2968,3741],[3040,3733],[3070,3754],[3070,3813],[3134,3818],[3146,3869],[3176,3869],[3168,3915],[3159,3949],[3134,3971],[3053,3966],[3082,3911],[2997,3864]]');
INSERT INTO `countries` VALUES (168,'Peru','South America','South America',604,'PE','PER','pe',0,1,0,0,0,'[[2449,3282],[2445,3312],[2470,3312],[2483,3329],[2513,3269],[2551,3256],[2589,3214],[2589,3188],[2632,3218],[2649,3252],[2687,3248],[2734,3261],[2717,3290],[2738,3303],[2713,3303],[2657,3329],[2649,3367],[2623,3397],[2679,3469],[2721,3452],[2721,3494],[2751,3494],[2772,3537],[2755,3622],[2738,3618],[2738,3635],[2759,3643],[2764,3656],[2751,3677],[2725,3703],[2560,3579],[2564,3567],[2457,3375],[2423,3346],[2423,3303]]');
INSERT INTO `countries` VALUES (169,'Philippines','Asia','Southeast Asia',608,'PH','PHL','ph',0,1,0,0,0,'[[8064,2659],[8101,2671],[8104,2722],[8077,2757],[8098,2792],[8156,2802],[8153,2829],[8093,2797],[8064,2802],[8035,2727],[8054,2732]],[[8051,2807],[8079,2808],[8078,2844]],[[8127,2851],[8132,2834],[8152,2849],[8136,2844]],[[8093,2853],[8133,2863],[8098,2890]],[[8107,2911],[8135,2878],[8132,2917],[8153,2873],[8152,2895],[8125,2931]],[[8159,2835],[8186,2831],[8200,2879]],[[8177,2864],[8162,2875],[8185,2905]],[[8159,2900],[8144,2922],[8165,2912]],[[8025,2864],[8INSERT INTO `countries` VALUES 033,2892],[7961,2954],[8020,2887]],[[8195,2899],[8191,2933],[8152,2956],[8140,2942],[8101,2962],[8095,2993],[8114,2970],[8121,2981],[8144,2964],[8160,2978],[8152,3009],[8192,3028],[8197,3005],[8189,2995],[8204,2977],[8212,3010],[8225,2969]],[[8089,3001],[8106,3000],[8098,3007]]');
INSERT INTO `countries` VALUES (170,'Pitcairn','Oceania','Polynesia',612,'PN','PCN','pn',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (171,'Poland','Europe','Eastern Europe',616,'PL','POL','pl',1,1,0,0,0,'[[5085,1517],[5204,1483],[5217,1500],[5323,1496],[5349,1517],[5357,1564],[5340,1581],[5349,1585],[5349,1602],[5361,1645],[5323,1679],[5327,1696],[5319,1696],[5217,1679],[5208,1666],[5106,1628],[5098,1568],[5085,1556],[5094,1547]]');
INSERT INTO `countries` VALUES (172,'Portugal','Europe','Southern Europe',620,'PT','PRT','pt',1,1,0,0,0,'[[4443,1938],[4515,1955],[4486,2023],[4481,2100],[4439,2104],[4443,2057],[4426,2053],[4447,1968]]');
INSERT INTO `countries` VALUES (173,'Puerto Rico','North America','Caribbean',630,'PR','PRI','pr',0,0,0,0,0,'[[2815,2665],[2815,2678],[2853,2678],[2857,2665]]');
INSERT INTO `countries` VALUES (174,'Qatar','Asia','Middle East',634,'QA','QAT','qa',0,1,0,0,0,'[[6122,2491],[6110,2483],[6110,2453],[6122,2440],[6131,2449],[6131,2478]]');
INSERT INTO `countries` VALUES (175,'Réunion','Africa','Eastern Africa',638,'RE','REU','re',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (176,'Romania','Europe','Eastern Europe',642,'RO','ROU','ro',1,1,0,0,0,'[[5327,1734],[5310,1743],[5281,1798],[5255,1798],[5323,1866],[5332,1879],[5408,1883],[5451,1870],[5489,1883],[5502,1845],[5514,1845],[5519,1828],[5485,1832],[5472,1798],[5480,1781],[5438,1721],[5387,1747]]');
INSERT INTO `countries` VALUES (177,'Russia','Asia','Northern Asia',643,'RU','RUS','ru',0,1,0,0,0,'[[5217,1500],[5285,1462],[5323,1471],[5323,1496]],[[5472,1296],[5455,1322],[5463,1360],[5451,1373],[5468,1381],[5476,1428],[5553,1449],[5553,1483],[5604,1534],[5570,1543],[5578,1585],[5634,1573],[5646,1615],[5668,1615],[5685,1649],[5714,1653],[5736,1645],[5808,1679],[5799,1738],[5765,1743],[5757,1764],[5791,1768],[5744,1785],[5761,1798],[5731,1828],[5714,1824],[5710,1832],[5808,1896],[5812,1887],[5969,1926],[5965,1934],[5986,1943],[6029,1968],[6046,1947],[599INSERT INTO `countries` VALUES 5,1858],[6020,1815],[6050,1807],[6063,1790],[5991,1717],[6020,1645],[6042,1670],[6054,1662],[6050,1641],[6110,1598],[6152,1598],[6246,1641],[6322,1619],[6356,1645],[6403,1632],[6407,1611],[6365,1590],[6395,1577],[6386,1560],[6399,1551],[6420,1551],[6424,1547],[6399,1539],[6399,1517],[6628,1462],[6667,1462],[6679,1509],[6743,1517],[6743,1530],[6832,1500],[6926,1632],[6952,1615],[6986,1636],[7020,1624],[7096,1679],[7113,1675],[7130,1696],[7143,1692],[7266,1632],[7321,1641],[7334,1662],[7406,1670],INSERT INTO `countries` VALUES [7423,1662],[7432,1645],[7419,1628],[7453,1585],[7543,1611],[7547,1641],[7585,1658],[7628,1645],[7781,1692],[7878,1653],[7946,1666],[7980,1679],[8061,1590],[8061,1568],[8040,1568],[8040,1560],[8065,1539],[8134,1530],[8206,1560],[8253,1670],[8316,1687],[8346,1747],[8452,1726],[8406,1841],[8372,1828],[8350,1845],[8350,1909],[8338,1913],[8338,1930],[8384,1904],[8406,1917],[8474,1879],[8601,1717],[8639,1539],[8567,1500],[8542,1530],[8469,1475],[8686,1301],[9022,1305],[8997,1284],[9082,1199],[9167,11INSERT INTO `countries` VALUES 94],[9162,1245],[9281,1160],[9286,1169],[9256,1233],[9073,1373],[9035,1458],[9065,1628],[9222,1483],[9213,1432],[9247,1428],[9239,1360],[9213,1356],[9290,1275],[9460,1254],[9643,1160],[9690,1177],[9707,1156],[9630,1067],[9711,1058],[9745,1011],[9906,1088],[10000,1003],[9877,956],[9868,973],[9860,943],[9605,824],[9443,812],[9464,867],[9422,875],[9396,820],[9188,850],[9120,769],[8946,782],[8831,701],[8622,671],[8593,744],[8435,756],[8397,722],[8342,782],[8278,654],[8138,625],[8116,667],[7849,612],INSERT INTO `countries` VALUES [7662,654],[7866,531],[7857,484],[7785,454],[7674,467],[7683,442],[7602,395],[7368,506],[7190,518],[7088,582],[7100,612],[6935,637],[6956,697],[7015,735],[6947,714],[6849,688],[6815,735],[6879,769],[6790,748],[6786,680],[6730,748],[6764,795],[6756,863],[6824,871],[6769,888],[6769,935],[6709,999],[6650,990],[6713,952],[6743,892],[6718,769],[6730,671],[6654,650],[6599,731],[6552,829],[6616,875],[6599,897],[6446,833],[6365,820],[6395,871],[6352,884],[6339,871],[6173,880],[6029,935],[6020,965],[5952INSERT INTO `countries` VALUES ,952],[5991,918],[5927,888],[5910,952],[5918,1003],[5863,990],[5795,1033],[5812,1071],[5723,1045],[5714,1067],[5748,1088],[5740,1109],[5663,1079],[5659,1011],[5595,969],[5599,956],[5685,994],[5761,1007],[5812,999],[5846,960],[5838,931],[5697,863],[5553,829],[5497,863],[5480,875],[5493,875],[5485,888],[5493,909],[5527,931],[5502,965],[5531,1024],[5523,1028],[5519,1054],[5544,1096],[5527,1113],[5574,1148],[5561,1169],[5468,1250],[5527,1271],[5476,1284]],[[6054,841],[6033,875],[6063,880],[6093,854]INSERT INTO `countries` VALUES ],[[6280,795],[6131,744],[6263,552],[6399,484],[6565,446],[6616,454],[6603,488],[6395,544],[6293,629],[6237,701],[6250,752],[6301,778]],[[7538,297],[7466,382],[7619,357]],[[7479,267],[7474,327],[7309,280]],[[7296,267],[7402,238],[7423,208],[7355,182],[7241,259]],[[8652,1534],[8652,1798],[8690,1781],[8673,1734],[8699,1683],[8720,1692],[8682,1517]]');
INSERT INTO `countries` VALUES (178,'Rwanda','Africa','Eastern Africa',646,'RW','RWA','rw',0,1,0,0,0,'[[5540,3214],[5527,3227],[5519,3222],[5497,3252],[5497,3265],[5548,3252]]');
INSERT INTO `countries` VALUES (179,'Saint Helena','Africa','Western Africa',654,'SH','SHN','sh',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (180,'Saint Kitts and Nevis','North America','Caribbean',659,'KN','KNA','kn',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (181,'Saint Lucia','North America','Caribbean',662,'LC','LCA','lc',0,1,0,0,0,'[[2989,2789],[2985,2798],[2990,2800]]');
INSERT INTO `countries` VALUES (182,'Saint Pierre and Miquelon','North America','North America',666,'PM','SPM','pm',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (183,'Saint Vincent and the Grenadines','North America','Caribbean',670,'VC','VCT','vc',0,1,0,0,0,'[[2981,2811],[2984,2812],[2982,2819],[2979,2815]]');
INSERT INTO `countries` VALUES (184,'Samoa','Oceania','Polynesia',882,'WS','WSM','ws',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (185,'San Marino','Europe','Southern Europe',674,'SM','SMR','sm',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (186,'Sao Tome and Principe','Africa','Central Africa',678,'ST','STP','st',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (187,'Saudi Arabia','Asia','Middle East',682,'SA','SAU','sa',0,1,0,0,0,'[[6042,2368],[6020,2368],[6016,2355],[5991,2351],[5940,2351],[5863,2287],[5787,2257],[5723,2278],[5753,2308],[5697,2351],[5668,2346],[5655,2381],[5668,2381],[5740,2495],[5765,2512],[5782,2555],[5778,2563],[5804,2614],[5825,2627],[5884,2725],[5897,2716],[5897,2699],[5906,2695],[5995,2704],[6008,2712],[6033,2678],[6139,2653],[6224,2623],[6246,2563],[6229,2546],[6161,2538],[6131,2500],[6122,2491],[6110,2483],[6088,2449],[6084,2419],[6054,2398]]');
INSERT INTO `countries` VALUES (188,'Senegal','Africa','Western Africa',686,'SN','SEN','sn',0,1,1,0,0,'[[4222,2840],[4264,2831],[4307,2831],[4371,2835],[4349,2776],[4290,2716],[4230,2729],[4226,2746],[4205,2772],[4226,2806],[4273,2797],[4307,2810],[4294,2814],[4269,2806],[4222,2818]]');
INSERT INTO `countries` VALUES (189,'Serbia','Europe','Eastern Europe',688,'RS','SRB','rs',0,1,0,0,0,'[[5255,1798],[5323,1866],[5315,1879],[5332,1900],[5315,1930],[5268,1943],[5251,1921],[5259,1909],[5225,1892],[5225,1841],[5217,1811],[5234,1798]]');
INSERT INTO `countries` VALUES (190,'Seychelles','Africa','Eastern Africa',690,'SC','SYC','sc',0,1,0,0,0,NULL);
INSERT INTO `countries` VALUES (191,'Sierra Leone','Africa','Western Africa',694,'SL','SLE','sl',0,1,0,1,0,'[[4371,2993],[4405,2946],[4392,2950],[4396,2942],[4379,2908],[4345,2908],[4320,2933],[4324,2954],[4341,2976]]');
INSERT INTO `countries` VALUES (192,'Singapore','Asia','Southeast Asia',702,'SG','SGP','sg',0,1,0,0,0,'[[7585,3146],[7581,3150],[7589,3154],[7594,3146]]');
INSERT INTO `countries` VALUES (193,'Slovakia','Europe','Eastern Europe',703,'SK','SVK','sk',1,1,0,0,0,'[[5217,1679],[5319,1696],[5310,1721],[5264,1717],[5217,1734],[5217,1738],[5183,1743],[5166,1734],[5166,1709]]');
INSERT INTO `countries` VALUES (194,'Slovenia','Europe','Southern Europe',705,'SI','SVN','si',1,1,0,0,0,'[[5068,1811],[5072,1785],[5098,1790],[5145,1773],[5149,1785],[5128,1802],[5119,1824],[5072,1824]]');
INSERT INTO `countries` VALUES (195,'Solomon Islands','Oceania','Melanesia',90,'SB','SLB','sb',0,0,0,0,0,'[[9058,3372],[9077,3381],[9089,3395]],[[9112,3397],[9153,3417],[9148,3423]],[[9148,3443],[9168,3449],[9179,3461],[9156,3461]],[[9173,3420],[9180,3419],[9197,3456],[9178,3439]],[[9195,3468],[9218,3479],[9214,3491]],[[9073,3407],[9089,3411],[9105,3432],[9082,3423]]');
INSERT INTO `countries` VALUES (196,'Somalia','Africa','Eastern Africa',706,'SO','SOM','so',0,1,0,1,0,'[[5859,3074],[5918,3048],[5948,3048],[6029,2963],[5999,2963],[5914,2929],[5880,2886],[5889,2878],[5897,2865],[5927,2895],[5944,2895],[6114,2852],[6122,2891],[6059,3006],[6029,3061],[5974,3120],[5901,3171],[5850,3231],[5833,3210],[5833,3108]]');
INSERT INTO `countries` VALUES (197,'South Africa','Africa','Southern Africa',710,'ZA','ZAF','za',0,1,0,0,0,'[[5608,3954],[5587,3954],[5582,3966],[5561,3966],[5548,3941],[5565,3920],[5582,3928],[5565,3822],[5510,3813],[5442,3860],[5404,3920],[5336,3907],[5298,3954],[5268,3954],[5264,3941],[5272,3932],[5247,3894],[5247,4000],[5230,4017],[5179,4009],[5166,3988],[5149,4009],[5204,4128],[5191,4136],[5247,4200],[5302,4183],[5408,4175],[5523,4094],[5595,4005]]');
INSERT INTO `countries` VALUES (198,'South Georgia and the South Sandwich Islands','South America','South America',239,'GS','SGS','gs',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (199,'Spain','Europe','Southern Europe',724,'ES','ESP','es',1,1,0,0,0,'[[4775,1926],[4779,1947],[4707,1989],[4681,2028],[4627,2114],[4541,2130],[4537,2134],[4498,2100],[4481,2100],[4486,2023],[4515,1955],[4443,1938],[4430,1909],[4473,1879],[4643,1896],[4732,1921],[4732,1926],[4741,1921]],[[4777,2007],[4787,2015],[4776,2032],[4755,2019]],[[4797,2006],[4806,2003],[4811,2012]],[[4724,2040],[4733,2034],[4736,2037],[4728,2044]]');
INSERT INTO `countries` VALUES (200,'Sri Lanka','Asia','Southern and Central Asia',144,'LK','LKA','lk',0,1,0,0,0,'[[6922,2912],[6947,2929],[6973,2976],[6977,2997],[6943,3023],[6926,3014],[6913,2963],[6926,2925]]');
INSERT INTO `countries` VALUES (201,'Sudan','Africa','Northern Africa',736,'SD','SDN','sd',0,1,0,1,0,'[[5332,2878],[5302,2823],[5336,2742],[5361,2742],[5361,2636],[5361,2623],[5391,2623],[5391,2563],[5616,2563],[5638,2572],[5685,2529],[5719,2559],[5736,2657],[5765,2678],[5723,2708],[5710,2784],[5663,2886],[5651,2882],[5638,2950],[5616,2950],[5612,2967],[5689,3035],[5693,3057],[5651,3057],[5638,3069],[5625,3082],[5553,3086],[5455,3044]]');
INSERT INTO `countries` VALUES (202,'Suriname','South America','South America',740,'SR','SUR','sr',0,1,0,0,0,'[[3095,3023],[3070,3069],[3112,3133],[3168,3120],[3185,3086],[3168,3048],[3185,3023]]');
INSERT INTO `countries` VALUES (203,'Svalbard and Jan Mayen','Europe','Nordic Countries',744,'SJ','SJM','sj',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (204,'Swaziland','Africa','Southern Africa',748,'SZ','SWZ','sz',0,1,0,1,0,'[[5582,3928],[5565,3920],[5548,3941],[5561,3966],[5582,3966],[5587,3954]]');
INSERT INTO `countries` VALUES (205,'Sweden','Europe','Nordic Countries',752,'SE','SWE','se',1,1,0,0,0,'[[5000,1313],[5051,1415],[5038,1428],[5055,1462],[5089,1454],[5098,1432],[5140,1428],[5162,1330],[5221,1284],[5191,1250],[5174,1241],[5170,1203],[5208,1143],[5293,1079],[5281,1062],[5315,1016],[5361,1020],[5349,918],[5268,867],[5251,867],[5247,901],[5196,892],[5187,918],[5174,914],[5140,943],[5145,960],[5111,1003],[5094,1003],[5072,1075],[5085,1079],[5081,1101],[5051,1096],[5026,1135],[5030,1199],[5051,1216],[5034,1233],[5038,1271],[5021,1279],[5017,1313INSERT INTO `countries` VALUES ]]');
INSERT INTO `countries` VALUES (206,'Switzerland','Europe','Western Europe',756,'CH','CHE','ch',0,1,0,0,0,'[[4902,1751],[4885,1756],[4860,1798],[4881,1790],[4885,1807],[4911,1807],[4923,1790],[4940,1811],[4953,1790],[4974,1798],[4983,1777],[4957,1764],[4962,1751]]');
INSERT INTO `countries` VALUES (207,'Syrian Arab Republic','Asia','Middle East',760,'SY','SYR','sy',0,1,0,0,0,'[[5693,2138],[5706,2138],[5714,2113],[5774,2113],[5876,2100],[5855,2121],[5846,2121],[5833,2189],[5774,2219],[5719,2253],[5685,2240],[5685,2223],[5710,2193],[5702,2181],[5693,2181]]');
INSERT INTO `countries` VALUES (208,'Taiwan, Province of China','Asia','Eastern Asia',158,'TW','TWN','tw',0,0,0,0,0,'[[8070,2474],[8095,2474],[8065,2568],[8040,2538],[8044,2512]]');
INSERT INTO `countries` VALUES (209,'Tajikistan','Asia','Southern and Central Asia',762,'TJ','TJK','tj',0,1,0,0,0,'[[6624,2100],[6582,2100],[6599,2070],[6594,2045],[6569,2032],[6577,2019],[6603,2019],[6658,1972],[6667,1981],[6654,1994],[6671,2002],[6662,2011],[6645,2002],[6624,2015],[6628,2023],[6667,2028],[6747,2023],[6756,2053],[6777,2057],[6781,2100],[6764,2091],[6726,2096],[6692,2117],[6684,2100],[6688,2074],[6679,2074],[6679,2062],[6667,2057]]');
INSERT INTO `countries` VALUES (210,'Tanzania, United Republic Of','Africa','Eastern Africa',834,'TZ','TZA','tz',0,1,0,1,0,'[[5787,3316],[5740,3282],[5744,3273],[5642,3214],[5621,3239],[5634,3248],[5625,3256],[5578,3256],[5578,3214],[5540,3214],[5548,3252],[5553,3278],[5519,3312],[5527,3350],[5523,3363],[5536,3371],[5561,3426],[5608,3443],[5642,3456],[5668,3511],[5736,3511],[5821,3482],[5799,3465],[5787,3418],[5795,3380],[5774,3354]]');
INSERT INTO `countries` VALUES (211,'Thailand','Asia','Southeast Asia',764,'TH','THA','th',0,1,0,0,0,'[[7560,2852],[7547,2810],[7572,2784],[7628,2784],[7636,2780],[7636,2763],[7640,2746],[7615,2721],[7615,2699],[7577,2665],[7555,2687],[7543,2674],[7513,2695],[7509,2691],[7517,2636],[7496,2636],[7496,2619],[7483,2610],[7428,2631],[7411,2665],[7419,2687],[7449,2725],[7440,2738],[7440,2755],[7432,2759],[7440,2784],[7462,2801],[7457,2818],[7470,2857],[7440,2908],[7436,2971],[7445,2954],[7487,3010],[7491,3006],[7513,3014],[7513,3031],[7534,3027],[7543,3014],[7521,INSERT INTO `countries` VALUES 2993],[7509,2997],[7496,2984],[7479,2929],[7462,2929],[7457,2903],[7483,2848],[7483,2810],[7509,2810],[7504,2831],[7538,2835]]');
INSERT INTO `countries` VALUES (212,'Timor-Leste','Asia','Southeast Asia',626,'TL','TLS','tl',0,0,0,0,0,'[[8176,3439],[8185,3431],[8240,3422],[8244,3426],[8180,3452]]');
INSERT INTO `countries` VALUES (213,'Togo','Africa','Western Africa',768,'TG','TGO','tg',0,1,1,0,0,'[[4741,3010],[4732,2908],[4711,2895],[4715,2878],[4694,2874],[4685,2886],[4702,2899],[4707,2997],[4724,3014]]');
INSERT INTO `countries` VALUES (214,'Tokelau','Oceania','Oceania',772,'TK','TKL','tk',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (215,'Tonga','Oceania','Polynesia',776,'TO','TON','to',0,1,0,0,0,'[[9845,3783],[9855,3785],[9850,3789]]');
INSERT INTO `countries` VALUES (216,'Trinidad and Tobago','South America','Caribbean',780,'TT','TTO','tt',0,1,0,0,0,'[[2965,2902],[2974,2898],[2970,2885],[2989,2882],[2986,2902]],[[2992,2872],[2999,2867],[3000,2871]]');
INSERT INTO `countries` VALUES (217,'Tunisia','Africa','Northern Africa',788,'TN','TUN','tn',0,1,0,0,0,'[[5013,2227],[5013,2249],[4970,2278],[4979,2300],[4953,2317],[4945,2261],[4898,2206],[4923,2164],[4928,2108],[4966,2096],[4983,2113],[5000,2104],[4983,2134],[5000,2164],[4970,2198]]');
INSERT INTO `countries` VALUES (218,'Turkey','Asia','Middle East',792,'TR','TUR','tr',0,1,0,0,0,'[[5472,1943],[5425,1951],[5421,1985],[5438,1989],[5463,1972],[5502,1977],[5510,1985],[5463,1998],[5451,1994],[5434,1994],[5421,2011],[5421,2023],[5438,2032],[5442,2062],[5429,2062],[5463,2096],[5459,2104],[5523,2134],[5540,2125],[5544,2108],[5587,2121],[5604,2138],[5634,2134],[5663,2113],[5680,2121],[5693,2108],[5702,2117],[5689,2125],[5693,2138],[5706,2138],[5714,2113],[5774,2113],[5876,2100],[5940,2100],[5923,2028],[5935,2015],[5910,2006],[5906,1968],[5880,INSERT INTO `countries` VALUES 1955],[5850,1955],[5812,1977],[5761,1977],[5706,1968],[5668,1938],[5621,1943],[5565,1964],[5561,1972],[5502,1968],[5476,1955]]');
INSERT INTO `countries` VALUES (219,'Turkmenistan','Asia','Southern and Central Asia',795,'TM','TKM','tm',0,1,0,0,0,'[[6195,2096],[6267,2062],[6399,2117],[6403,2151],[6437,2164],[6526,2087],[6548,2096],[6548,2074],[6433,2006],[6407,1964],[6369,1960],[6365,1930],[6318,1917],[6280,1947],[6284,1964],[6254,1964],[6241,1968],[6207,1930],[6173,1934],[6156,1951],[6165,1964],[6165,1947],[6173,1938],[6195,1938],[6216,1972],[6190,1989],[6173,1981],[6165,1968],[6161,2006],[6182,2011],[6182,2023],[6173,2028],[6186,2032]]');
INSERT INTO `countries` VALUES (220,'Turks and Caicos Islands','North America','Caribbean',796,'TC','TCA','tc',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (221,'Tuvalu','Oceania','Polynesia',798,'TV','TUV','tv',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (222,'Uganda','Africa','Eastern Africa',800,'UG','UGA','ug',0,1,0,1,0,'[[5553,3086],[5625,3082],[5638,3069],[5672,3129],[5638,3180],[5621,3176],[5582,3188],[5578,3214],[5540,3214],[5527,3227],[5519,3222],[5519,3184],[5565,3125],[5548,3116]]');
INSERT INTO `countries` VALUES (223,'Ukraine','Europe','Eastern Europe',804,'UA','UKR','ua',0,1,0,0,0,'[[5578,1585],[5557,1585],[5544,1611],[5395,1590],[5349,1602],[5361,1645],[5323,1679],[5327,1696],[5319,1696],[5310,1721],[5327,1734],[5387,1747],[5438,1721],[5459,1717],[5502,1734],[5527,1785],[5540,1798],[5548,1785],[5629,1807],[5599,1824],[5625,1832],[5625,1853],[5642,1858],[5706,1836],[5710,1824],[5680,1828],[5655,1811],[5676,1790],[5757,1764],[5765,1743],[5799,1738],[5808,1679],[5736,1645],[5714,1653],[5685,1649],[5668,1615],[5646,1615],[5634,1573]]');
INSERT INTO `countries` VALUES (224,'United Arab Emirates','Asia','Middle East',784,'AE','ARE','ae',0,1,0,0,0,'[[6131,2500],[6199,2500],[6259,2444],[6263,2457],[6263,2478],[6250,2478],[6250,2504],[6241,2504],[6229,2546],[6161,2538]]');
INSERT INTO `countries` VALUES (225,'United Kingdom','Europe','British Islands',826,'GB','GBR','uk',1,1,0,0,0,'[[4698,1636],[4728,1619],[4728,1611],[4705,1611],[4736,1585],[4741,1564],[4724,1551],[4702,1551],[4698,1560],[4690,1556],[4698,1547],[4677,1496],[4656,1488],[4643,1449],[4605,1432],[4639,1369],[4579,1369],[4605,1330],[4549,1330],[4524,1377],[4515,1424],[4558,1454],[4549,1483],[4592,1479],[4609,1539],[4575,1539],[4566,1534],[4562,1539],[4566,1547],[4558,1560],[4575,1556],[4575,1581],[4545,1590],[4549,1602],[4600,1611],[4618,1600],[4605,1615],[4571,1619],[45INSERT INTO `countries` VALUES 37,1658],[4545,1662],[4558,1649],[4575,1649],[4588,1653],[4596,1641],[4613,1636],[4656,1641],[4668,1632]],[[4490,1471],[4464,1496],[4486,1509],[4494,1496],[4515,1513],[4541,1496],[4520,1462]]');
INSERT INTO `countries` VALUES (226,'United States','North America','North America',840,'US','USA','us',0,1,0,0,0,'[[1420,2244],[1488,2244],[1590,2283],[1671,2283],[1671,2270],[1718,2270],[1811,2355],[1832,2325],[1858,2329],[1926,2432],[1977,2444],[1969,2402],[2054,2334],[2134,2334],[2160,2355],[2211,2312],[2287,2312],[2313,2334],[2343,2317],[2385,2359],[2377,2385],[2423,2466],[2449,2466],[2457,2423],[2415,2304],[2428,2266],[2581,2142],[2560,2074],[2572,2087],[2623,2015],[2628,1989],[2725,1947],[2713,1913],[2730,1879],[2823,1841],[2798,1811],[2798,1764],[2759,1751],[26INSERT INTO `countries` VALUES 91,1836],[2598,1836],[2568,1858],[2560,1887],[2547,1896],[2483,1896],[2487,1909],[2479,1921],[2406,1955],[2372,1955],[2364,1943],[2389,1904],[2377,1870],[2351,1883],[2364,1832],[2326,1811],[2283,1849],[2275,1887],[2283,1909],[2266,1947],[2249,1951],[2236,1900],[2270,1811],[2309,1798],[2321,1802],[2355,1802],[2330,1785],[2317,1777],[2258,1790],[2224,1764],[2228,1751],[2198,1768],[2122,1777],[2185,1730],[2037,1696],[1263,1696],[1263,1726],[1207,1721],[1229,1798],[1229,1853],[1212,1913],[1229,1964]INSERT INTO `countries` VALUES ,[1216,1994],[1327,2181],[1395,2206]],[[1050,1483],[1063,1432],[906,1284],[855,1318],[753,1254],[753,833],[315,752],[51,871],[43,897],[196,990],[174,1007],[115,1003],[115,977],[0,1024],[55,1071],[145,1071],[191,1058],[200,1109],[132,1143],[102,1131],[55,1199],[85,1233],[68,1250],[128,1284],[157,1267],[174,1292],[170,1326],[217,1313],[251,1335],[306,1318],[289,1373],[85,1488],[98,1496],[242,1437],[412,1318],[387,1305],[468,1224],[451,1305],[561,1271],[565,1237],[595,1233],[676,1271],[774,1284],[7INSERT INTO `countries` VALUES 82,1279],[791,1292],[872,1343],[931,1424],[944,1407],[986,1483],[1012,1475]]');
INSERT INTO `countries` VALUES (227,'United States Minor Outlying Islands','North America','Pacific Ocean',581,'UM','UMI','um',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (228,'Uruguay','South America','South America',858,'UY','URY','uy',0,1,0,0,0,'[[3197,4166],[3193,4149],[3206,4132],[3104,4051],[3082,4056],[3057,4170],[3121,4200],[3180,4196]]');
INSERT INTO `countries` VALUES (229,'Uzbekistan','Asia','Southern and Central Asia',860,'UZ','UZB','uz',0,1,0,0,0,'[[6582,2100],[6548,2096],[6548,2074],[6433,2006],[6407,1964],[6369,1960],[6365,1930],[6318,1917],[6280,1947],[6284,1964],[6254,1964],[6254,1841],[6327,1819],[6395,1862],[6420,1892],[6501,1883],[6526,1913],[6535,1909],[6535,1943],[6548,1943],[6556,1968],[6582,1968],[6603,1985],[6616,1964],[6671,1934],[6679,1938],[6654,1955],[6684,1968],[6692,1960],[6730,1981],[6692,2006],[6671,2002],[6654,1994],[6667,1981],[6658,1972],[6603,2019],[6577,2019],[6569,2032],[6594,INSERT INTO `countries` VALUES 2045],[6599,2070]]');
INSERT INTO `countries` VALUES (230,'Vanuatu','Oceania','Melanesia',548,'VU','VUT','vu',0,0,0,0,0,'[[9342,3599],[9346,3627],[9360,3624]],[[9359,3633],[9365,3652],[9375,3648]]');
INSERT INTO `countries` VALUES (231,'Venezuela','South America','South America',862,'VE','VEN','ve',0,1,0,0,0,'[[2683,2861],[2640,2929],[2691,2988],[2734,2988],[2751,3014],[2806,3010],[2793,3061],[2810,3091],[2798,3103],[2815,3120],[2823,3154],[2849,3167],[2921,3120],[2904,3116],[2883,3069],[2934,3086],[2997,3048],[2997,3040],[2976,3018],[3006,2988],[2993,2976],[3023,2950],[2993,2942],[2989,2920],[2938,2886],[2878,2903],[2844,2886],[2793,2891],[2755,2861],[2696,2882],[2708,2920],[2691,2929],[2674,2912],[2691,2886]]');
INSERT INTO `countries` VALUES (232,'Vietnam','Asia','Southeast Asia',704,'VN','VNM','vn',0,1,0,0,0,'[[7704,2580],[7670,2563],[7670,2542],[7632,2525],[7568,2551],[7551,2542],[7543,2551],[7564,2572],[7564,2585],[7585,2602],[7598,2593],[7623,2619],[7594,2640],[7628,2661],[7623,2665],[7691,2738],[7683,2742],[7696,2759],[7691,2776],[7691,2840],[7645,2861],[7653,2886],[7640,2878],[7606,2895],[7623,2908],[7615,2950],[7734,2869],[7747,2827],[7730,2759],[7636,2653],[7649,2623]]');
INSERT INTO `countries` VALUES (233,'Virgin Islands, British','North America','Caribbean',92,'VG','VGB','vg',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (234,'Virgin Islands, U.S.','North America','Caribbean',850,'VI','VIR','vi',0,0,0,0,0,NULL);
INSERT INTO `countries` VALUES (235,'Wallis and Futuna','Oceania','Polynesia',876,'WF','WLF','wf',0,0,0,0,0,'[[9767,3586],[9772,3590],[9768,3590]]');
INSERT INTO `countries` VALUES (236,'Western Sahara','Africa','Northern Africa',732,'EH','ESH','eh',0,0,0,0,0,'[[4447,2406],[4447,2393],[4324,2393],[4307,2427],[4286,2440],[4273,2483],[4218,2568],[4218,2585],[4324,2585],[4324,2534],[4354,2521],[4354,2444],[4447,2444]]');
INSERT INTO `countries` VALUES (237,'Yemen','Asia','Middle East',887,'YE','YEM','ye',0,1,0,0,0,'[[5884,2725],[5897,2716],[5897,2699],[5906,2695],[5995,2704],[6008,2712],[6033,2678],[6139,2653],[6173,2721],[6148,2733],[6148,2746],[5910,2835]]');
INSERT INTO `countries` VALUES (238,'Zambia','Africa','Eastern Africa',894,'ZM','ZMB','zm',0,1,0,1,0,'[[5344,3686],[5302,3639],[5302,3550],[5361,3550],[5361,3494],[5370,3494],[5374,3507],[5395,3503],[5400,3511],[5442,3524],[5446,3511],[5506,3562],[5523,3562],[5523,3528],[5502,3533],[5480,3507],[5489,3486],[5485,3448],[5497,3426],[5544,3414],[5540,3422],[5557,3431],[5561,3426],[5608,3443],[5629,3482],[5616,3579],[5536,3609],[5540,3626],[5497,3635],[5493,3652],[5446,3690],[5391,3686],[5370,3677]]');
INSERT INTO `countries` VALUES (239,'Zimbabwe','Africa','Eastern Africa',716,'ZW','ZWE','zw',0,1,0,1,0,'[[5565,3822],[5608,3758],[5608,3656],[5540,3635],[5540,3626],[5497,3635],[5493,3652],[5446,3690],[5391,3686],[5472,3796],[5510,3813]]');
INSERT INTO `countries` VALUES (241,'Montenegro','Europe','Eastern Europe',499,'ME','MNE','me',0,1,0,0,0,'[[5259,1909],[5251,1921],[5230,1947],[5204,1926],[5225,1892]]');


CREATE TABLE IF NOT EXISTS `diligences_categories` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(64) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `diligences_categories` VALUES (1,'Honoraires');
INSERT INTO `diligences_categories` VALUES (2,'Frais');
INSERT INTO `diligences_categories` VALUES (3,'Débours');


CREATE TABLE IF NOT EXISTS `diligences_subcategories` (
  `id` tinyint(4) unsigned NOT NULL,
  `category` tinyint(4) NOT NULL AUTO_INCREMENT,
  `value` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`category`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `diligences_subcategories` VALUES (1,1,'Temps Passé');
INSERT INTO `diligences_subcategories` VALUES (2,1,'Forfait');
INSERT INTO `diligences_subcategories` VALUES (3,1,'Résultat');
INSERT INTO `diligences_subcategories` VALUES (4,1,'Provision');
INSERT INTO `diligences_subcategories` VALUES (5,1,'A.J.');
INSERT INTO `diligences_subcategories` VALUES (9,1,'Commissions');
INSERT INTO `diligences_subcategories` VALUES (6,1,'Remise');
INSERT INTO `diligences_subcategories` VALUES (1,2,'Copies');
INSERT INTO `diligences_subcategories` VALUES (2,2,'Frais Postaux');
INSERT INTO `diligences_subcategories` VALUES (3,2,'Indemnités Km');
INSERT INTO `diligences_subcategories` VALUES (4,2,'Repas');
INSERT INTO `diligences_subcategories` VALUES (5,2,'Documentation');
INSERT INTO `diligences_subcategories` VALUES (6,2,'Divers');
INSERT INTO `diligences_subcategories` VALUES (7,2,'Marque Recherche');
INSERT INTO `diligences_subcategories` VALUES (8,2,'Taxe Domaine');
INSERT INTO `diligences_subcategories` VALUES (9,2,'Avion');
INSERT INTO `diligences_subcategories` VALUES (10,2,'Train / RER');
INSERT INTO `diligences_subcategories` VALUES (11,2,'Métro');
INSERT INTO `diligences_subcategories` VALUES (12,2,'Taxi');
INSERT INTO `diligences_subcategories` VALUES (13,2,'Hotel');
INSERT INTO `diligences_subcategories` VALUES (14,2,'Péages');
INSERT INTO `diligences_subcategories` VALUES (15,2,'Parking');
INSERT INTO `diligences_subcategories` VALUES (16,2,'Essence');
INSERT INTO `diligences_subcategories` VALUES (17,2,'Marque Surveillance');
INSERT INTO `diligences_subcategories` VALUES (18,2,'Marque INPI');
INSERT INTO `diligences_subcategories` VALUES (19,2,'Marque OHMI');
INSERT INTO `diligences_subcategories` VALUES (20,2,'Marque OMPI');
INSERT INTO `diligences_subcategories` VALUES (21,2,'Marque Autre Office');
INSERT INTO `diligences_subcategories` VALUES (22,2,'D&M INPI');
INSERT INTO `diligences_subcategories` VALUES (23,2,'D&M OHMI');
INSERT INTO `diligences_subcategories` VALUES (24,2,'D&M OMPI');
INSERT INTO `diligences_subcategories` VALUES (25,2,'D&M Autres');
INSERT INTO `diligences_subcategories` VALUES (26,2,'Postulant');
INSERT INTO `diligences_subcategories` VALUES (27,2,'Avocat Extérieur');
INSERT INTO `diligences_subcategories` VALUES (28,2,'Apporteur');
INSERT INTO `diligences_subcategories` VALUES (29,2,'Cotisation');
INSERT INTO `diligences_subcategories` VALUES (30,2,'Frais bancaires');
INSERT INTO `diligences_subcategories` VALUES (31,2,'Traduction');
INSERT INTO `diligences_subcategories` VALUES (32,2,'Ouverture de dossier');
INSERT INTO `diligences_subcategories` VALUES (1,3,'Droit de plaidoirie');
INSERT INTO `diligences_subcategories` VALUES (5,3,'Frais de greffe');
INSERT INTO `diligences_subcategories` VALUES (6,3,'Pub légale');
INSERT INTO `diligences_subcategories` VALUES (7,3,'Frais d\'huissier');
INSERT INTO `diligences_subcategories` VALUES (8,3,'Divers');
INSERT INTO `diligences_subcategories` VALUES (9,3,'Taxe Enrôlement');


CREATE TABLE IF NOT EXISTS `dossiers_domaines` (
  `id` tinyint(4) unsigned NOT NULL DEFAULT 0,
  `value` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `dossiers_domaines` VALUES (10,'Droit des Personnes');
INSERT INTO `dossiers_domaines` VALUES (15,'Droit Pénal');
INSERT INTO `dossiers_domaines` VALUES (20,'Droit Immobilier');
INSERT INTO `dossiers_domaines` VALUES (25,'Droit Rural');
INSERT INTO `dossiers_domaines` VALUES (30,'Droit de l\'Environnement');
INSERT INTO `dossiers_domaines` VALUES (35,'Droit Public');
INSERT INTO `dossiers_domaines` VALUES (40,'Droit de la Propriété Intellectuelle');
INSERT INTO `dossiers_domaines` VALUES (45,'Droit Commercial');
INSERT INTO `dossiers_domaines` VALUES (50,'Droit des Sociétés');
INSERT INTO `dossiers_domaines` VALUES (55,'Droit Fiscal');
INSERT INTO `dossiers_domaines` VALUES (60,'Droit Social');
INSERT INTO `dossiers_domaines` VALUES (65,'Droit Economique');
INSERT INTO `dossiers_domaines` VALUES (70,'Droit des Mesures d\'Exécution');
INSERT INTO `dossiers_domaines` VALUES (75,'Droit Communautaire');
INSERT INTO `dossiers_domaines` VALUES (80,'Droit des Relations Internationales');
INSERT INTO `dossiers_domaines` VALUES (85,'Recouvrements');


CREATE TABLE IF NOT EXISTS `dossiers_sousdomaines` (
  `id` smallint(5) NOT NULL DEFAULT 0,
  `domaine` tinyint(4) NOT NULL DEFAULT 0,
  `value` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `dossiers_sousdomaines` VALUES (10,10,'Droit de la Famille');
INSERT INTO `dossiers_sousdomaines` VALUES (20,10,'Réparation du Préjudice Corporel');
INSERT INTO `dossiers_sousdomaines` VALUES (30,10,'Droit des Etrangers En France');
INSERT INTO `dossiers_sousdomaines` VALUES (40,10,'Droit des Successions et Donation');
INSERT INTO `dossiers_sousdomaines` VALUES (50,10,'Droit du Patrimoine');
INSERT INTO `dossiers_sousdomaines` VALUES (60,10,'Droit du Surrendettement');
INSERT INTO `dossiers_sousdomaines` VALUES (70,10,'Responsabilité Civile');
INSERT INTO `dossiers_sousdomaines` VALUES (80,10,'Assurance des Particuliers');
INSERT INTO `dossiers_sousdomaines` VALUES (90,10,'Droit des Mineurs');
INSERT INTO `dossiers_sousdomaines` VALUES (100,15,'Droit Pénal Général');
INSERT INTO `dossiers_sousdomaines` VALUES (110,15,'Droit Pénal des Affaires');
INSERT INTO `dossiers_sousdomaines` VALUES (120,15,'Droit Pénal de la Presse');
INSERT INTO `dossiers_sousdomaines` VALUES (130,20,'Construction');
INSERT INTO `dossiers_sousdomaines` VALUES (140,20,'Urbanisme');
INSERT INTO `dossiers_sousdomaines` VALUES (150,20,'Copropriété');
INSERT INTO `dossiers_sousdomaines` VALUES (160,20,'Baux d\'Habitation');
INSERT INTO `dossiers_sousdomaines` VALUES (170,20,'Baux Commerciaux et Professionnels');
INSERT INTO `dossiers_sousdomaines` VALUES (180,20,'Expropriation');
INSERT INTO `dossiers_sousdomaines` VALUES (190,20,'Droit des Mines');
INSERT INTO `dossiers_sousdomaines` VALUES (200,25,'Baux Ruraux et Entreprises Agricoles');
INSERT INTO `dossiers_sousdomaines` VALUES (210,25,'Droit des Produits Alimentaires');
INSERT INTO `dossiers_sousdomaines` VALUES (220,25,'Droit de la Coopération Agricole');
INSERT INTO `dossiers_sousdomaines` VALUES (230,30,'Droit de l\'Environnement');
INSERT INTO `dossiers_sousdomaines` VALUES (240,35,'Droit Electoral');
INSERT INTO `dossiers_sousdomaines` VALUES (250,35,'Collectivités Locales');
INSERT INTO `dossiers_sousdomaines` VALUES (260,35,'Fonction Publique');
INSERT INTO `dossiers_sousdomaines` VALUES (270,35,'Droit Public Economique');
INSERT INTO `dossiers_sousdomaines` VALUES (280,35,'Droit Administratif Général');
INSERT INTO `dossiers_sousdomaines` VALUES (290,40,'Droit des Brevets');
INSERT INTO `dossiers_sousdomaines` VALUES (300,40,'Droit des Marques');
INSERT INTO `dossiers_sousdomaines` VALUES (310,40,'Droit des Dessins et Modèles');
INSERT INTO `dossiers_sousdomaines` VALUES (320,40,'Propriété Littéraire et Artistique');
INSERT INTO `dossiers_sousdomaines` VALUES (330,40,'Droit de l\'Informatique et des Télécoms');
INSERT INTO `dossiers_sousdomaines` VALUES (340,45,'Droit Bancaire et Financier');
INSERT INTO `dossiers_sousdomaines` VALUES (350,45,'Procédures Collectives');
INSERT INTO `dossiers_sousdomaines` VALUES (360,45,'Vente de fonds de commerce');
INSERT INTO `dossiers_sousdomaines` VALUES (370,45,'Droit Boursier');
INSERT INTO `dossiers_sousdomaines` VALUES (380,45,'Transport Aérien');
INSERT INTO `dossiers_sousdomaines` VALUES (390,45,'Transport Maritime');
INSERT INTO `dossiers_sousdomaines` VALUES (400,45,'Transport Terrestre');
INSERT INTO `dossiers_sousdomaines` VALUES (410,45,'Droit de la Publicité');
INSERT INTO `dossiers_sousdomaines` VALUES (420,50,'Approbations des comptes');
INSERT INTO `dossiers_sousdomaines` VALUES (430,50,'Restructurations (Fusions, TUP, Apports)');
INSERT INTO `dossiers_sousdomaines` VALUES (440,50,'Créations');
INSERT INTO `dossiers_sousdomaines` VALUES (450,50,'Cessions');
INSERT INTO `dossiers_sousdomaines` VALUES (460,50,'Autres Assemblées Générales');
INSERT INTO `dossiers_sousdomaines` VALUES (470,50,'Divers');
INSERT INTO `dossiers_sousdomaines` VALUES (480,55,'Fiscalité des Particuliers');
INSERT INTO `dossiers_sousdomaines` VALUES (490,55,'Fiscalité des Professionnels');
INSERT INTO `dossiers_sousdomaines` VALUES (500,55,'Fiscalité Internationale');
INSERT INTO `dossiers_sousdomaines` VALUES (510,55,'Fiscalité du Patrimoine');
INSERT INTO `dossiers_sousdomaines` VALUES (520,5,'TVA');
INSERT INTO `dossiers_sousdomaines` VALUES (530,55,'Fiscalité Immobilière');
INSERT INTO `dossiers_sousdomaines` VALUES (540,55,'Contentieux Fiscal');
INSERT INTO `dossiers_sousdomaines` VALUES (550,55,'Divers');
INSERT INTO `dossiers_sousdomaines` VALUES (560,60,'Droit du Travail');
INSERT INTO `dossiers_sousdomaines` VALUES (570,60,'Droit de la Sécurité Sociale');
INSERT INTO `dossiers_sousdomaines` VALUES (580,60,'Droit de la Protection Sociale');
INSERT INTO `dossiers_sousdomaines` VALUES (590,65,'Droit des Règlementations Professionnelles');
INSERT INTO `dossiers_sousdomaines` VALUES (600,65,'Droit de la Concurrence');
INSERT INTO `dossiers_sousdomaines` VALUES (610,65,'Droit de la Consommation');
INSERT INTO `dossiers_sousdomaines` VALUES (620,65,'Droit de la Distribution');
INSERT INTO `dossiers_sousdomaines` VALUES (630,70,'Mesures d\'Exécution Forcée');
INSERT INTO `dossiers_sousdomaines` VALUES (640,70,'Mesures Conservatoires');
INSERT INTO `dossiers_sousdomaines` VALUES (650,75,'Droit Public Européen');
INSERT INTO `dossiers_sousdomaines` VALUES (660,75,'Contentieux Juridictions Européènnes');
INSERT INTO `dossiers_sousdomaines` VALUES (670,75,'Droit Européen de la Concurrence');
INSERT INTO `dossiers_sousdomaines` VALUES (680,80,'Droit des Etrangers hors de France');
INSERT INTO `dossiers_sousdomaines` VALUES (690,80,'Contentieux Internationaux');
INSERT INTO `dossiers_sousdomaines` VALUES (700,80,'Contrats Internationaux');
INSERT INTO `dossiers_sousdomaines` VALUES (710,85,'Recouvrements Civils');
INSERT INTO `dossiers_sousdomaines` VALUES (720,85,'Recouvrements Commerciaux');


CREATE TABLE IF NOT EXISTS `intervenants_qualites` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `intervenants_qualites` VALUES (10,'Client');
INSERT INTO `intervenants_qualites` VALUES (20,'Adversaire');
INSERT INTO `intervenants_qualites` VALUES (21,'Demandeur');
INSERT INTO `intervenants_qualites` VALUES (22,'Défendeur');
INSERT INTO `intervenants_qualites` VALUES (23,'Intervenant volontaire');
INSERT INTO `intervenants_qualites` VALUES (24,'Intervenant forcé');
INSERT INTO `intervenants_qualites` VALUES (25,'Appelant');
INSERT INTO `intervenants_qualites` VALUES (26,'Intimé');
INSERT INTO `intervenants_qualites` VALUES (27,'Appelé en déclaration de jugement commun');
INSERT INTO `intervenants_qualites` VALUES (30,'Avocat');
INSERT INTO `intervenants_qualites` VALUES (35,'Avocat Plaidant');
INSERT INTO `intervenants_qualites` VALUES (40,'Avocat Postulant');
INSERT INTO `intervenants_qualites` VALUES (50,'Juridiction');
INSERT INTO `intervenants_qualites` VALUES (60,'Huissier');
INSERT INTO `intervenants_qualites` VALUES (70,'Notaire');
INSERT INTO `intervenants_qualites` VALUES (80,'Expert Amiable');
INSERT INTO `intervenants_qualites` VALUES (90,'Expert Judiciaire');
INSERT INTO `intervenants_qualites` VALUES (100,'Apporteur d\'affaire');
INSERT INTO `intervenants_qualites` VALUES (110,'Administrateur Judiciaire');
INSERT INTO `intervenants_qualites` VALUES (115,'Mandataire Judiciaire');
INSERT INTO `intervenants_qualites` VALUES (120,'Liquidateur Judiciaire');
INSERT INTO `intervenants_qualites` VALUES (130,'Curateur');
INSERT INTO `intervenants_qualites` VALUES (140,'Tuteur');
INSERT INTO `intervenants_qualites` VALUES (150,'Représentant légal - Gérant');
INSERT INTO `intervenants_qualites` VALUES (160,'Représentant légal - Président');
INSERT INTO `intervenants_qualites` VALUES (170,'Représentant légal - Directeur Général');
INSERT INTO `intervenants_qualites` VALUES (180,'Associé');
INSERT INTO `intervenants_qualites` VALUES (190,'Enfant');
INSERT INTO `intervenants_qualites` VALUES (250,'Autre');


CREATE TABLE IF NOT EXISTS `languages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `languages` VALUES (1,'english');
INSERT INTO `languages` VALUES (2,'french');
INSERT INTO `languages` VALUES (3,'german');


CREATE TABLE IF NOT EXISTS `tva_rates` (
  `id` tinyint(4) unsigned NOT NULL AUTO_INCREMENT,
  `value` decimal(4,2) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `tva_rates` VALUES (1,19.60,'Ancien taux (19,6%)');
INSERT INTO `tva_rates` VALUES (2,5.50,'Taux Réduit (5,5%)');
INSERT INTO `tva_rates` VALUES (3,0.00,'Prestations Intra Communautaires');
INSERT INTO `tva_rates` VALUES (4,0.00,'Prestations Export');
INSERT INTO `tva_rates` VALUES (5,0.00,'Franchise en Base');
INSERT INTO `tva_rates` VALUES (6,20.00,'Taux Normal (20%)');
INSERT INTO `tva_rates` VALUES (7,8.50,'Taux Normal DOM (8,5%)');


CREATE TABLE IF NOT EXISTS `users_types` (
  `id` tinyint(4) unsigned NOT NULL DEFAULT 0,
  `value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;
INSERT INTO `users_types` VALUES (0,'Admin');
INSERT INTO `users_types` VALUES (10,'Associé');
INSERT INTO `users_types` VALUES (20,'Collaborateur');
INSERT INTO `users_types` VALUES (100,'Client');
