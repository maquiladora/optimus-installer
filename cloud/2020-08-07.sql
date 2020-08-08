CREATE DATABASE IF NOT EXISTS cloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE cloud;

CREATE TABLE IF NOT EXISTS addressbookchanges (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  uri varbinary(200) NOT NULL,
  synctoken int(11) unsigned NOT NULL,
  addressbookid int(11) unsigned NOT NULL,
  operation tinyint(1) NOT NULL,
  PRIMARY KEY (id),
  KEY addressbookid_synctoken (addressbookid,synctoken)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS calendarchanges (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  uri varbinary(200) NOT NULL,
  synctoken int(11) unsigned NOT NULL,
  calendarid int(11) unsigned NOT NULL,
  operation tinyint(1) NOT NULL,
  PRIMARY KEY (id),
  KEY calendarid_synctoken (calendarid,synctoken)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS calendarinstances (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  calendarid int(10) unsigned NOT NULL,
  principaluri varbinary(100) DEFAULT NULL,
  access tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = owner, 2 = read, 3 = readwrite',
  displayname varchar(100) DEFAULT NULL,
  uri varbinary(200) DEFAULT NULL,
  description text,
  calendarorder int(11) unsigned NOT NULL DEFAULT '0',
  calendarcolor varbinary(10) DEFAULT NULL,
  timezone text,
  transparent tinyint(1) NOT NULL DEFAULT '0',
  share_href varbinary(100) DEFAULT NULL,
  share_displayname varchar(100) DEFAULT NULL,
  share_invitestatus tinyint(1) NOT NULL DEFAULT '2' COMMENT '1 = noresponse, 2 = accepted, 3 = declined, 4 = invalid',
  PRIMARY KEY (id),
  UNIQUE KEY principaluri (principaluri,uri),
  UNIQUE KEY calendarid (calendarid,principaluri),
  UNIQUE KEY calendarid_2 (calendarid,share_href)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS calendarobjects (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  calendardata mediumblob,
  uri varbinary(200) DEFAULT NULL,
  calendarid int(10) unsigned NOT NULL,
  lastmodified int(11) unsigned DEFAULT NULL,
  etag varbinary(32) DEFAULT NULL,
  size int(11) unsigned NOT NULL,
  componenttype varbinary(8) DEFAULT NULL,
  firstoccurence int(11) unsigned DEFAULT NULL,
  lastoccurence int(11) unsigned DEFAULT NULL,
  uid varbinary(200) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY calendarid (calendarid,uri),
  KEY calendarid_time (calendarid,firstoccurence)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS calendars (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  synctoken int(10) unsigned NOT NULL DEFAULT '1',
  components varbinary(21) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS calendarsubscriptions (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  uri varbinary(200) NOT NULL,
  principaluri varbinary(100) NOT NULL,
  `source` text,
  displayname varchar(100) DEFAULT NULL,
  refreshrate varchar(10) DEFAULT NULL,
  calendarorder int(11) unsigned NOT NULL DEFAULT '0',
  calendarcolor varbinary(10) DEFAULT NULL,
  striptodos tinyint(1) DEFAULT NULL,
  stripalarms tinyint(1) DEFAULT NULL,
  stripattachments tinyint(1) DEFAULT NULL,
  lastmodified int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY principaluri (principaluri,uri)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cards (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  addressbookid int(11) unsigned NOT NULL,
  carddata mediumblob,
  uri varbinary(200) DEFAULT NULL,
  lastmodified int(11) unsigned DEFAULT NULL,
  etag varbinary(32) DEFAULT NULL,
  size int(11) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS groupmembers (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  principal_id int(10) unsigned NOT NULL,
  member_id int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY principal_id (principal_id,member_id)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `locks` (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` varchar(100) DEFAULT NULL,
  timeout int(10) unsigned DEFAULT NULL,
  created int(11) DEFAULT NULL,
  token varbinary(100) DEFAULT NULL,
  scope tinyint(4) DEFAULT NULL,
  depth tinyint(4) DEFAULT NULL,
  uri varbinary(1000) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY token (token),
  KEY uri (uri(100))
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS propertystorage (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  path varbinary(1024) NOT NULL,
  `name` varbinary(100) NOT NULL,
  valuetype int(10) unsigned DEFAULT NULL,
  `value` mediumblob,
  PRIMARY KEY (id),
  UNIQUE KEY path_property (path(600),`name`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS schedulingobjects (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  principaluri varbinary(255) DEFAULT NULL,
  calendardata mediumblob,
  uri varbinary(200) DEFAULT NULL,
  lastmodified int(11) unsigned DEFAULT NULL,
  etag varbinary(32) DEFAULT NULL,
  size int(11) unsigned NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS shares (
  id int(11) NOT NULL DEFAULT '0',
  `type` tinyint(4) DEFAULT NULL,
  uri varchar(255) DEFAULT NULL,
  sharee int(11) DEFAULT NULL,
  expire datetime DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  rights tinyint(4) DEFAULT NULL,
  invitestatus tinyint(4) DEFAULT NULL,
  displayname varchar(255) DEFAULT NULL,
  `order` tinyint(4) DEFAULT NULL,
  color varchar(6) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
