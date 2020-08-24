#!/bin/sh

echo "From: prime@$DOMAIN" > /srv/email.txt
echo "To: prime@$DOMAIN" >> /srv/email.txt
echo "Subject: BACKUP REPORT" >> /srv/email.txt

echo "DATABASE BACKUP" >> /srv/email.txt
mysql -N -e 'show databases' | while read dbname; do if [ $dbname != 'information_schema' ] && [ $dbname != 'performance_schema' ]; then mysqldump --routines --triggers --single-transaction "$dbname" > "/srv/db-backup/$dbname".sql; fi done
cd /srv/db-backup/
zip `date +%Y-%m-%d.zip` *.sql >> /srv/email.txt

echo
echo "SERVER BACKUP" >> /srv/email.txt
rdiff-backup -v 7 --remote-schema "ssh -i /root/private.pem %s rdiff-backup --server" /srv debian@$BACKUP_SERVER::/srv >> /srv/email.txt

/usr/sbin/sendmail -t < /srv/email.txt

rm /srv/db-backup/*.sql
rm /srv/email.txt
