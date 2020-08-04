CREATE DATABASE IF NOT EXISTS server CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE server;

CREATE TABLE IF NOT EXISTS mailboxes (
  id int(11) NOT NULL AUTO_INCREMENT,
  email varchar(255) NOT NULL UNIQUE,
  password varchar(255) NOT NULL,
  quota bigint(11) NOT NULL DEFAULT 0,
  status tinyint(1) NOT NULL DEFAULT 1,
  aliases text,
  redirections text,
  sender_bcc text,
  recipient_bcc text,
  transport text,
  PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS mailboxes_acl (
  from_user varchar(100) NOT NULL,
  to_user varchar(100) NOT NULL,
  dummy char(1) DEFAULT 1,
  PRIMARY KEY (from_user,to_user)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS mailboxes_acl_anyone (
  from_user varchar(100) NOT NULL,
  dummy char(1) DEFAULT 1,
  PRIMARY KEY (from_user)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS mailboxes_domains (
  id int(11) NOT NULL AUTO_INCREMENT,
  status tinyint(1) NOT NULL DEFAULT 0,
  domain varchar(255) NOT NULL UNIQUE,
  PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



CREATE TABLE IF NOT EXISTS awl (
  username varchar(100) NOT NULL default '',
  email varbinary(255) NOT NULL default '',
  ip varchar(40) NOT NULL default '',
  count int(11) NOT NULL default '0',
  totscore float NOT NULL default '0',
  signedby varchar(255) NOT NULL default '',
  PRIMARY KEY (username,email,signedby,ip)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS bayes_expire (
  id int(11) NOT NULL default '0',
  runtime int(11) NOT NULL default '0',
  KEY bayes_expire_idx1 (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bayes_global_vars (
  variable varchar(30) NOT NULL default '',
  value varchar(200) NOT NULL default '',
  PRIMARY KEY  (variable)
) ENGINE=InnoDB;

INSERT IGNORE INTO bayes_global_vars VALUES ('VERSION','3');

CREATE TABLE IF NOT EXISTS bayes_seen (
  id int(11) NOT NULL default '0',
  msgid varchar(200) binary NOT NULL default '',
  flag char(1) NOT NULL default '',
  PRIMARY KEY  (id,msgid)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bayes_token (
  id int(11) NOT NULL default '0',
  token binary(5) NOT NULL default '',
  spam_count int(11) NOT NULL default '0',
  ham_count int(11) NOT NULL default '0',
  atime int(11) NOT NULL default '0',
  PRIMARY KEY  (id, token),
  INDEX bayes_token_idx1 (id, atime)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bayes_vars (
  id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(200) NOT NULL default '',
  spam_count int(11) NOT NULL default '0',
  ham_count int(11) NOT NULL default '0',
  token_count int(11) NOT NULL default '0',
  last_expire int(11) NOT NULL default '0',
  last_atime_delta int(11) NOT NULL default '0',
  last_expire_reduce int(11) NOT NULL default '0',
  oldest_token_age int(11) NOT NULL default '2147483647',
  newest_token_age int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE bayes_vars_idx1 (username)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS userpref (
  username varchar(100) NOT NULL default '',
  preference varchar(50) NOT NULL default '',
  value varchar(100) NOT NULL default '',
  prefid int(11) NOT NULL auto_increment,
  PRIMARY KEY  (prefid),
  KEY username (username)
) ENGINE=MyISAM;

GRANT ALL ON server.mailboxes TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.mailboxes_acl TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.mailboxes_acl_anyone TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.mailboxes_domains TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.awl TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.bayes_expire TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.bayes_global_vars TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.bayes_token TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.bayes_vars TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';
GRANT ALL ON server.userpref TO '$mysql_mail_user'@'localhost' IDENTIFIED BY '$mysql_mail_password';

INSERT IGNORE INTO mailboxes VALUES (NULL, 'postmaster@$domain', '$mysql_mail_password', '0', '1', 'root@$domain', null, null, null, null);
INSERT IGNORE INTO mailboxes_domains VALUES (NULL, 1, '$domain');