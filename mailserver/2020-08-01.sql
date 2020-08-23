CREATE DATABASE IF NOT EXISTS `mailserver` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `mailserver`;

CREATE TABLE IF NOT EXISTS `mailboxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) NOT NULL UNIQUE,
  `quota` bigint(11) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `aliases` text,
  `redirections` text,
  `sender_bcc` text,
  `recipient_bcc` text,
  `transport` text,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `mailboxes_acl` (
  `from_user` varchar(100) NOT NULL,
  `to_user` varchar(100) NOT NULL,
  `dummy` char(1) DEFAULT 1,
  PRIMARY KEY (from_user,to_user)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `mailboxes_acl_anyone` (
  `from_user` varchar(100) NOT NULL,
  `dummy` char(1) DEFAULT 1,
  PRIMARY KEY (from_user)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `mailboxes_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `domain` varchar(255) NOT NULL UNIQUE,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `awl` (
  `username` varchar(100) NOT NULL default '',
  `email` varbinary(255) NOT NULL default '',
  `ip` varchar(40) NOT NULL default '',
  `count` int(11) NOT NULL default '0',
  `totscore` float NOT NULL default '0',
  `signedby` varchar(255) NOT NULL default '',
  PRIMARY KEY (username,email,signedby,ip)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bayes_expire` (
  `id` int(11) NOT NULL default '0',
  `runtime` int(11) NOT NULL default '0',
  KEY bayes_expire_idx1 (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bayes_global_vars` (
  `variable` varchar(30) NOT NULL default '',
  `value` varchar(200) NOT NULL default '',
  PRIMARY KEY  (variable)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO `bayes_global_vars` VALUES ('VERSION','3');

CREATE TABLE IF NOT EXISTS `bayes_seen` (
  `id` int(11) NOT NULL default '0',
  `msgid` varchar(200) binary NOT NULL default '',
  `flag` char(1) NOT NULL default '',
  PRIMARY KEY  (id,msgid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bayes_token` (
  `id` int(11) NOT NULL default '0',
  `token` binary(5) NOT NULL default '',
  `spam_count` int(11) NOT NULL default '0',
  `ham_count` int(11) NOT NULL default '0',
  `atime` int(11) NOT NULL default '0',
  PRIMARY KEY  (id, token),
  INDEX bayes_token_idx1 (id, atime)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bayes_vars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(200) NOT NULL default '',
  `spam_count` int(11) NOT NULL default '0',
  `ham_count` int(11) NOT NULL default '0',
  `token_count` int(11) NOT NULL default '0',
  `last_expire` int(11) NOT NULL default '0',
  `last_atime_delta` int(11) NOT NULL default '0',
  `last_expire_reduce` int(11) NOT NULL default '0',
  `oldest_token_age` int(11) NOT NULL default '2147483647',
  `newest_token_age` int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE bayes_vars_idx1 (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `userpref` (
  `username` varchar(100) NOT NULL default '',
  `preference` varchar(50) NOT NULL default '',
  `value` varchar(100) NOT NULL default '',
  `prefid` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (prefid),
  KEY username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
