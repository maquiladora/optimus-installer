#!/bin/sh
clear

# mysqldump --all-databases --ignore-database roundcube | gzip > /srv/db-backup/`date +%Y-%m-%d.sql.gz`

mysql -N -e 'show databases' | while read dbname; do mysqldump --complete-insert --routines --triggers --single-transaction "$dbname" > "/srv/db-backup/$dbname".sql; done
zip /srv/db-backup/`date +%Y-%m-%d.sql.gz` /srv/db-backup/*.sql
rm /srv/db-backup/*.sql

exit 0

# rsync --recursive --delete --copy-links --perms --owner --group --times --compress --verbose --progress --stats --backup --backup-dir=debian@$BACKUP_SERVER:/srv/increments/`date +%Y-%m-%d--%Hh%M` --exclude '/srv/increments' -e "ssh -p 22 -i /root/private.pem" '/srv/' 'debian@$BACKUP_SERVER:/srv/' | tee rsync.log

if [ $? -eq 0 ]; then echo "Subject: CONQUEST : BACKUP SUCCESSFULL" > email.txt; else echo "Subject: CONQUEST : BACKUP ERROR" > email.txt; fi;

exit 0;

ssh -i /root/private.pem debian@$BACKUP_SERVER <<'ENDSSH'
cd /srv/increments
for dir in */
do
  base=$(basename "$dir")
  tar -czf "${base}.tar.gz" "$dir" --remove-files
done
ENDSSH

rsync --recursive --delete --copy-links --perms --owner --group --times --compress --verbose --progress --stats -e "ssh -p 7822 -i /root/private.pem" 'debian@$DOMAIN:/srv/increments' '/srv/increments' | tee rsync.log

echo "From: prime@$DOMAIN" >> email.txt;
echo "To: prime@$DOMAIN" >> email.txt;
cat rsync.log >> email.txt;
/usr/sbin/sendmail -t < email.txt;

rm email.txt;
rm rsync.log;
