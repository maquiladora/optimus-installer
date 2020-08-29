#!/bin/sh

echo "DATABASE BACKUP" > /var/log/allspark-backup.log
mysql -N -e 'show databases' | while read dbname; do if [ $dbname != 'information_schema' ] && [ $dbname != 'performance_schema' ]; then mysqldump --routines --triggers --single-transaction "$dbname" > "/srv/db-backup/$dbname".sql; fi done
cd /srv/db-backup/
zip -v `date +%Y-%m-%d.zip` *.sql >> /var/log/allspark-backup.log
rm /srv/db-backup/*.sql

echo "" >> /var/log/allspark-backup.log

echo "SERVER BACKUP" >> /var/log/allspark-backup.log
rdiff-backup -v 7 --remote-schema "ssh -i /root/private.pem %s rdiff-backup --server" /srv debian@$BACKUP_SERVER::/srv >> /var/log/allspark-backup.log


mail -s "BACKUP REPORT" prime@%DOMAIN -aFrom:prime@%DOMAIN < /var/log/allspark-backup.log
