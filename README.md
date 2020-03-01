# optimus-installer
Scripts d'installation pour serveur et station de travail optimus<br/>

Les scripts ont été conçus pour fonctionner sur une installation minimale Debian 10.<br/>

Il est recommandé de créer une partition spécifique /srv pour stocker les données. Cette partition sera cryptée.<br/>

Si le disque ne contient qu'une seule partition, ce qui est notamment le cas par défaut sur les VPS OVH, les scripts peuvent redimensionner la partition root à 4Gb et créer une partition secondaire avec le reste de l'espace libre. Cette fonction ne doit être utilisée que sur une installation vierge, au risque sinon de corrompre le système ou de perdre des données.<br/>

Pour lancer les scripts depuis la ligne de commande :

<pre>
  <code>
    wget -qO- https://github.com/MetallianFR68/optimus-installer/install.sh | bash
  </code>
</pre>

L'arborescence OPTIMUS est la suivante :

<ul>
  <li>/srv/files contient les fichiers des utilisateurs, qui seront servis via WEBDAV</li>
  <li>/srv/mailboxes contient les boites mail des utilisateurs, qui seront servies via IMAP</li>
  <li>/srv/db contient les bases de données qui seront servies via MARIA DB</li>
  <li>/srv/webmail contient le client ROUNDCUBE</li>
  <li>/srv/website contient un espace pour héberger le site web du cabinet</li>
  <li>/srv/backup contient les sauvegardes quotidiennes de la base de données</li>
  <li>/srv/api contient l'api de communication</li>
</ul>
