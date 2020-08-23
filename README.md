# ALL SPARK INSTALLER

Ce dépôt contient des scripts de notre conception permettant d'installer très rapidement votre propore serveur cloud "ALL SPARK". Ce serveur sécurisé sous Linux DEBIAN constitue la base de toutes les applications développées par notre association CYBERTRON. Il permet notamment de stocker et d'accéder à l'ensemble de vos données (fichiers, courriels, agendas, sauvegardes, bases de données) dans des formats ouverts. Le serveur ALL SPARK intègre également l'API de communication qui lui permet d'échanger avec d'autres applications (dont OPTIMUS AVOCATS).  

Les scripts ont été conçus pour fonctionner sur une installation minimale Debian 10.5.  

Ils ont été testés sur deux types d'hébergement :
* des serveurs VPS, si vous souhaitez confier l'hébergement à un professionnel (par exemple OVH)
* des mini-PCs Intel NUC8I5BEK2 si vous préférez héberger vos données à votre cabinet.


# PREPARATION D'UN VPS

Le VPS (Virtual Private Server) a l'avantage de la simplicité. C'est l'hébergeur qui gère votre machine moyennant un abonnement mensuel compris entre 3 € HT et 20 € HT / mois selon les performances de la machine et l'espace disque souhaité. La performance de la connexion internet d'un tel serveur est souvent bien supérieure à ce que vous pourrez obtenir avec votre fournisseur d'accès d'internet.

Il y a toutefois deux réserves à l'utilisation d'un VPS :
* Si vous n'avez plus de connexion internet au bureau, vous n'aurez plus accès à rien (mais on peut aujourd'hui facilement basculer sur la 4G de son téléphone comme solution de secours provisoire)
* Votre serveur peut faire l'objet d'une réquisition ou d'une saisie sur demande d'un juge et l'hébergeur s'y pliera sans que vous en soyez préalablement informé. Si vous travaillez sur des dossiers très sensibles, héberger vos données dans votre cabinet peut ainsi s'avérer être une meilleure option.

Voici la démarche pour réserver un VPS, par exemple chez l'hébergeur OVH CLOUD :
* Créez un compte sur https://www.ovh.com/auth/ ou connectez vous avec votre compte existant.
* Remplissez les champs d'identification de votre cabinet
* Une fois l'inscription terminée, rendez vous ici pour réserver un VPS : https://www.ovh.com/fr/order/vps
* Choisissez l'offre qui vous convient. Nous recommandons de démarrer avec l'offre VALUE qui intègre 40Go de stockage, sachant qu'on peut passer à une offre supérieure plus tard en cas de besoin.
* Sur la page suivante : "Configurez votre VPS", renseignez les champs comme suit :
  * Choix du système d'exploitation : Distribution Uniquement -> Debian -> Version 10
  * Localisation du datacenter : Europe de l'Ouest, France, Strasbourg (SBG)
  * Quantité : 1
* Sur la page suivante : "Options", aucune option n'est indispensable mais la sauvegarde automatisée à 3€ / mois peut être judicieuse (possibilité de souscrire les options ultérieurement)
* Sur la page suivante durée d'engagement, sélectionnez "sans engagement"
* Sur la page suivante "Paiement de votre commande", choisissez le mode de paiement. La carte bancaire permet d'activer le serveur dans la journée. La mise en place d'un prélèvement reporte de 2 à 3 jours l'ouverture du serveur. Il est possible de changer le mode de paiement à tout moment par la suite. Validez ensuite les conditions générales en cochant les cases au bas de la page. Finissez la commande en cliquant CONFIRMER ET PAYER
Vous recevrez, habituellement dans l'heure qui suit, un mail vous informant de l'ouverture du serveur, contenant le mot de passe d'accès.  

A noter : Par défaut le disque des VPS ne contient qu'une seule partition. Les scripts ALL SPARK peuvent redimensionner la partition système à 20Gb et créer une partition secondaire chiffrée avec le reste de l'espace libre.


# PREPARATION D'UN NUC8I5BEK2

Héberger vos données à votre cabinet sur une machine dédiée ne peut se faire que si :
* vous disposez d'une connexion internet rapide et fiable (type fibre)
* votre FAI (fournisseur d'accès internet) vous garantit une IP FIXE
* vous pouvez rediriger les ports entrants et sortants vers le serveur (via votre box internet ou votre routeur)

Pour le serveur, nous recommandons ce mini PC INTEL NUC8I5BEK2 : https://www.amazon.fr/gp/product/B07JBM1CFH  
Nous préconisons d'y ajouter 8 Go de RAM : https://www.amazon.fr/Crucial-CT16G4SFD824A-PC4-19200-260-Pin-M%C3%A9moire/dp/B019FRD3SE/  
Et un disque SSD NVMe de 500 Go ou 1 To : https://www.amazon.fr/Samsung-SSD-Interne-Plus-NVMe/dp/B07MBQPQ62/  
Soit un investissement total qui devrait rester sous le seuil d'immobilisation de 500 € HT.  

Une fois le NUC lancé, on commence par quelques réglages préalables :
* Au démarrage du NUC, lorsque le logo INTEL apparait, tapez F2 pour entrer dans le menu du BIOS.  
* Cliquez sur "ADVANCED" pour entrer dans le menu avancé.  
* Dans la section "BOOT (UEFI Boot Priority)", décochez "UEFI BOOT" pour permettre au NUC de démarrer depuis son disque NVMe.  
* Dans la section "BOOT (Legacy Boot Priority)", déplacez le disque NVME en première position.  
* Dans la section "POWER", sélectionnez "AFTER POWER FAILURE : POWER ON" pour que le NUC redémarre en cas de coupure de courant.  
* Appuyez sur "F10" et "ENTREE" pour sauvegarder les modifications et redémarrer.  

Il faut ensuite installer DEBIAN 10.5 sur le NUC.  
Pour ce faire il faut télécharger l'iSO de DEBIAN 10.5 : https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.5.0-amd64-netinst.iso  
Puis l'installer sur une clé USB d'au moins 1 Go avec par exemple le logiciel RUFUS : https://rufus.ie/fr_FR.html  

DEBIAN ne reconnait pas la carte WIFI du NUC par défaut car elle requiert un pilote propriétaire INTEL.  
Ce pilote est téléchargeable ici : http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-iwlwifi_20190114-2_all.deb  
Il suffit de copier le fichier dans le dossier "firmware" de la clé USB pour que la carte wifi soit détectée pendant l'installation.  
Nous recommandons cependant de connecter le NUC en filaire et pas en WIFI. Dans ce cas cette étape est optionnelle.

Pour lancer l'installation il suffit ensuite d'insérer la clé USB dans un des ports USB du NUC et de le redémarrer. Il devrait lancer l'installation de DEBIAN 10.5 depuis la clé USB et vous devriez ensuite voir le menu d'installation bleu.
Choisissez "Install" (2e option) pour lancer l'installation non graphique.  
Ensuite répondez comme suit aux questions posées :  
* Select a language : English
* Select your location : other -> Europe -> France
* Configure locales : en_US.UTF-8
* Keymap to use : French
* Configure the Network : eno1 Intel Corporation Device<
* Root Password : Choisissez un mot de passe de 10 caractères minimum mélangeant chiffres, minuscules, majuscules et caractères spéciaux et surtout ne l'oubliez pas !
* Set up users and Passwords : debian
* Choose an password for the new users : Choisissez un mot de passe de 10 caractères minimum mélangeant chiffres, minuscules, majuscules et caractères spéciaux et surtout ne l'oubliez pas !
* Partition Disk : Manual -> /dev/nvme0n1 -> Yes -> pri/log -> Create a new partition -> 20 GB -> Primary -> Beginning -> Bootable flag : on -> Done setting up the partition -> Finish partitioning and write changes to disk -> No -> Yes
* Software selection : Uniquement "SSH Server" et "standard system utilities"
* Configure the package manager : France -> deb.debian.org -> Continue -> No
* Install the GRUB boot loader : Yes -> /dev/nvme0n1
* Finish the installation : Retirez la clé USB puis "continue"

A l'issue de l'installation, si vous avez suivi ces instructions, le système consomme 20Go et le reste de l'espace disque est libre est non configuré. Cet espace libre sera monté sur /srv et servira à stocker les données. Il est recommandé de chiffrer cette partition /srv pour que les données soient inutilisables en cas de vol du NUC. Les scripts d'installation ALL SPARK réaliseront ces opérations à votre place.  



# ORGANISATION DES DOSSIERS

L'arborescence OPTIMUS est la suivante :
* /srv/api contient l'api de communication
* /srv/db-backup contient les sauvegardes quotidiennes de la base de données
* /srv/cloud contient le serveur WEBDAV
* /srv/databases contient les bases de données qui seront servies via MARIA DB
* /srv/files contient les fichiers des utilisateurs, qui seront servis via WEBDAV
* /srv/increments contient les sauvegardes incrémentielles quotidienne du dossier /srv
* /srv/mailboxes contient les boites mail des utilisateurs, qui seront servies via IMAP
* /srv/webmail contient le client ROUNDCUBE
* /srv/www contient un espace pour héberger votre site web


# LANCEMENT DES SCRIPTS ALL SPARK

Le plus simple pour contrôler un serveur DEBIAN est de s'y connecter avec le logiciel PUTTY : https://www.putty.org/
L'identifiant est "debian".  
Le mot de passe est celui que vous avez renseigné lors de l'installaiton (NUC) ou celui qui vous a été envoyé par mail (VPS)

Une fois connecté au terminal, voici la commande à taper pour installer les scripts ALL SPARK

<pre>
  <code>
     bash <(wget -qO- https://raw.githubusercontent.com/MetallianFR68/optimus-installer/vest/install.sh); sudo /etc/allspark/menu.sh
  </code>
</pre>

Le menu ALL SPARK se lance alors sur votre machine et il suffit de suivre les directives qui apparaissent à l'écran.  


# SERVEUR MAIL

Prérequis : disposer d'un nom de domaine et en avoir le contrôle.

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

Il est ainsi possible de créer et gérer autant d'adresses mail que nécessaire sur le domaine dont vous êtes propriétaire.

Les courriels peuvent être consultés via n'importe quel logiciel client (OUTLOOK, THUNDERBIRD, K9 MAIL sur ANDROID, IPHONE) ou via le webmail intégré au serveur.
