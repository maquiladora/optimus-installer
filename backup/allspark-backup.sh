#!/bin/sh

echo "From: prime@$DOMAIN" > /var/log/allspark-backup.log
echo "To: prime@$DOMAIN" >> /var/log/allspark-backup.log
echo "Subject: BACKUP REPORT" >> /var/log/allspark-backup.log

echo "DATABASE BACKUP" >> /var/log/allspark-backup.log
mysql -N -e 'show databases' | while read dbname; do if [ $dbname != 'information_schema' ] && [ $dbname != 'performance_schema' ]; then mysqldump --routines --triggers --single-transaction "$dbname" > "/srv/db-backup/$dbname".sql; fi done
cd /srv/db-backup/
zip `date +%Y-%m-%d.zip` *.sql >> /var/log/allspark-backup.log
rm /srv/db-backup/*.sql

echo
echo "SERVER BACKUP" >> /var/log/allspark-backup.log
rdiff-backup -v 7 --remote-schema "ssh -i /root/private.pem %s rdiff-backup --server" /srv debian@$BACKUP_SERVER::/srv >> /var/log/allspark-backup.log

/usr/sbin/sendmail -t < /var/log/allspark-backup.log

rm /var/log/allspark-backup.log
