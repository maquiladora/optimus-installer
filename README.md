# optimus-installer
Scripts d'installation pour serveur et station de travail optimus

Le script a été conçu pour fonctionner sur une installation minimale Debian 10
Il est recommandé de créer une partition spécifique /srv pour stocker les données.
Cette partition sera cryptée.

/srv/files contient les fichiers des utilisateurs, qui seront servis via WEBDAV<br/>
/srv/mailboxes contient les boites mail des utilisateurs, qui seront servies via IMAP<br/>
/srv/db contient les bases de données qui seront servies via MARIA DB<br/>
/srv/webmail contient le client ROUNDCUBE<br/>
/srv/website contient un espace pour héberger le site web du cabinet<br/>
/srv/backup contient les sauvegardes quotidiennes de la base de données<br/>
/srv/api contient l'api de communication<br/>
