# optimus-installer
Scripts d'installation pour serveur et station de travail optimus<br/>

Les scripts ont été conçus pour fonctionner sur une installation minimale Debian 10.<br/>

Il est recommandé de créer une partition spécifique /srv pour stocker les données. Cette partition sera cryptée.<br/>

Si le disque ne contient qu'une seule partition, ce qui est notamment le cas par défaut sur les VPS OVH, les scripts peuvent redimensionner la partition root à 4Gb et créer une partition secondaire avec le reste de l'espace libre. Cette fonction ne doit être utilisée que sur une installation vierge, au risque sinon de corrompre le système ou de perdre des données.<br/>

Pour lancer les scripts depuis la ligne de commande :

<pre>
  <code>
     bash <(wget -qO- https://raw.githubusercontent.com/MetallianFR68/optimus-installer/vest/install.sh);sudo /installer/menu.sh
  </code>
</pre>

L'arborescence OPTIMUS est la suivante :

<ul>
  <li>/srv/api contient l'api de communication</li>
  <li>/srv/backup contient les sauvegardes quotidiennes de la base de données</li>
  <li>/srv/cloud contient le serveur WEBDAV</li>
  <li>/srv/databases contient les bases de données qui seront servies via MARIA DB</li>
  <li>/srv/files contient les fichiers des utilisateurs, qui seront servis via WEBDAV</li>
  <li>/srv/mailboxes contient les boites mail des utilisateurs, qui seront servies via IMAP</li>
  <li>/srv/webmail contient le client ROUNDCUBE</li>
  <li>/srv/www contient un espace pour héberger le site web du cabinet</li>
</ul>

<b><u>SERVEUR MAIL</u></b>

Le serveur mail est composé des éléments suivants :

<ul>
  <li>POSTFIX pour la distribution des courriels entrants et l'envoi des courriels sortants via SMTP sécurisé (port 587 - SSL/TLS)</li>
  <li>DOVECOT pour la consultation des courriels via IMAP sécurisé (port 993 - SSL/TLS)</li>
  <li>SPAMASSASSIN pour filtrer les courriels indésirables via des règles configurables (whitelist, blacklist, scoring)</li>
  <li>CLAMAV pour mettre en quarantaine les courriels qui contiennent des virus</li>
  <li>SIEVE pour mettre en place des règles de filtrage (par exemple le classement automatique des spams dans un dossier "Indésirables"). Ce protocole permet également de mettre en place des messages d'absence intelligents et configurables</li>
  <li>ACL pour partager dossiers ou sous dossiers avec d'autres utilisateurs du même domaine</li>
  <li>OPENDKIM et OPENDMARC pour authentifier l'expéditeur auprès des destinataires et éviter d'être classé en indésirable</li>
  <li>ALIASES : Une boite de messagerie peut être contactée via plusieurs adresses</li>
  <li>REDIRECTIONS : redirection automatique des courriels destinés à une adresse vers une ou plusieurs autres adresses</li>
  <li>RECIPIENT_BCC : envoi d'une copie des courriels entrants destinés à une adresse sur une seconde adresse</li>
  <li>SENDER_BCC : envoi d'une copie des courriels envoyés depuis une adresse sur une seconde adresse</li>
</ul>

Il est ainsi possible de créer et gérer autant d'adresses mail que nécessaire sur les domaines dont vous êtes propriétaire.

Les courriels peuvent être consultés via n'importe quel logiciel client (OUTLOOK, THUNDERBIRD, K9 MAIL sur ANDROID, IPHONE) ou via le webmail intégré au serveur.
