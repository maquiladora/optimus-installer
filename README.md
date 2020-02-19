# optimus-installer
Scripts d'installation pour serveur et station de travail optimus

Le script a été conçu pour fonctionner sur une installation minimale Debian 10
Il est recommandé de créer une partition spécifique /srv pour stocker les données.
Cette partition sera cryptée.

/srv/files contient les fichiers des utilisateurs, qui seront servis via WEBDAV
/srv/mailboxes contient les boites mail des utilisateurs, qui seront servies via IMAP
/srv/db contient les bases de données qui seront servies via MARIA DB
/srv/webmail contient le client ROUNDCUBE
/srv/website contient un espace pour héberger le site web du cabinet
/srv/backup contient les sauvegardes quotidiennes de la base de données
/srv/api contient l'api de communication
