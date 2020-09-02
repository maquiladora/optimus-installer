#!/bin/sh

echo "DATABASE BACKUP" > /var/log/allspark-backup.log
mysql -N -e 'show databases' | while read dbname; do if [ $dbname != 'information_schema' ] && [ $dbname != 'performance_schema' ]; then mysqldump --routines --triggers --single-transaction "$dbname" > "/srv/db-backup/$dbname".sql; fi done
cd /srv/db-backup/
zip -v `date +%Y-%m-%d.zip` *.sql >> /var/log/allspark-backup.log
rm /srv/db-backup/*.sql

echo "" >> /var/log/allspark-backup.log

echo "SERVER BACKUP" >> /var/log/allspark-backup.log
rdiff-backup -v 6 --force --exclude /srv/databases --print-statistics --remote-schema "ssh -p$BACKUP_SERVER_SSHPORT -i /root/private.pem %s sudo rdiff-backup --server" /srv autobackup@$BACKUP_SERVER::/srv >> /var/log/allspark-backup.log

ssh -i /root/private.pem -p $BACKUP_SERVER_SSHPORT autobackup@$BACKUP_SERVER sudo umount /backup &>> /var/log/allspark-backup.log
ssh -i /root/private.pem -p $BACKUP_SERVER_SSHPORT autobackup@$BACKUP_SERVER sudo rdiff-backup-fs --full /backup /srv &>> /var/log/allspark-backup.log

mail -s "BACKUP REPORT" prime@%DOMAIN -aFrom:prime@%DOMAIN < /var/log/allspark-backup.log
