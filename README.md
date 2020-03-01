# optimus-installer
Scripts d'installation pour serveur et station de travail optimus<br/>

Les scripts ont été conçus pour fonctionner sur une installation minimale Debian 10.<br/>

Il est recommandé de créer une partition spécifique /srv pour stocker les données. Cette partition sera cryptée.<br/>

Si le disque ne contient qu'une seule partition, ce qui est notamment le cas par défaut sur les VPS OVH, les scripts peuvent redimensionner la partition root à 4Gb et créer une partition secondaire avec le reste de l'espace libre. Cette fonction ne doit être utilisée que sur une installation vierge, au risque sinon de corrompre le système ou de perdre des données.<br/>

L'arborescence OPTIMUS est la suivante :

<li>
<ul>/srv/files contient les fichiers des utilisateurs, qui seront servis via WEBDAV</ul>
<ul>/srv/mailboxes contient les boites mail des utilisateurs, qui seront servies via IMAP</ul>
<ul>/srv/db contient les bases de données qui seront servies via MARIA DB</ul>
<ul>/srv/webmail contient le client ROUNDCUBE</ul>
<ul>/srv/website contient un espace pour héberger le site web du cabinet</ul>
<ul>/srv/backup contient les sauvegardes quotidiennes de la base de données</ul>
/srv/api contient l'api de communication<br/>
</li>
