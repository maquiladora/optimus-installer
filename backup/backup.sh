#!/bin/sh

clear

rsync --recursive --delete --copy-links --perms --owner --group --times --compress --verbose --progress --stats --backup --backup-dir=/srv/increments/`date +%Y-%m-%d--%Hh%M` -e "ssh -p 7822" 'root@adaris.org:/srv/' '/srv/' | tee rsync.log;

if [ $? -eq 0 ]; then echo "Subject: CONQUEST : BACKUP SUCCESSFULL" > email.txt; else echo "Subject: CONQUEST : BACKUP ERROR" > email.txt; fi;

echo "From: postmaster@$DOMAIN" >> email.txt;
echo "To: postmaster@$DOMAIN" >> email.txt;
cat rsync.log >> email.txt;
/usr/sbin/sendmail -t < email.txt;

rm email.txt;
rm rsync.log;

cd /srv/increments
for dir in */
do
  base=$(basename "$dir")
  tar -czf "${base}.tar.gz" "$dir" --remove-files
done
