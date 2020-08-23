#!/bin/sh

echo "From: prime@$DOMAIN" > /srv/email.txt
echo "To: prime@$DOMAIN" >> /srv/email.txt
echo "Subject: BACKUP REPORT" >> /srv/email.txt

echo "DATABASE BACKUP" >> /srv/email.txt
mysql -N -e 'show databases' | while read dbname; do if [ $dbname != 'information_schema' ] && [ $dbname != 'performance_schema' ]; then mysqldump --routines --triggers --single-transaction "$dbname" > "/srv/db-backup/$dbname".sql; fi done
cd /srv/db-backup/
zip `date +%Y-%m-%d.zip` *.sql >> /srv/email.txt

/usr/sbin/sendmail -t < /srv/email.txt

rm /srv/db-backup/*.sql
rm /srv/email.txt

# rsync --recursive --delete --copy-links --perms --owner --group --times --compress --verbose --progress --stats --backup --backup-dir=debian@$BACKUP_SERVER:/srv/increments/`date +%Y-%m-%d--%Hh%M` --exclude '/srv/increments' -e "ssh -p 22 -i /root/private.pem" '/srv/' 'debian@$BACKUP_SERVER:/srv/' | tee rsync.log


#ssh -i /root/private.pem debian@$BACKUP_SERVER <<'ENDSSH'
#cd /srv/increments
#for dir in */
#do
#  base=$(basename "$dir")
#  tar -czf "${base}.tar.gz" "$dir" --remove-files
#done
#ENDSSH

#rsync --recursive --delete --copy-links --perms --owner --group --times --compress --verbose --progress --stats -e "ssh -p 7822 -i /root/private.pem" 'debian@$DOMAIN:/srv/increments' '/srv/increments' | tee rsync.log
