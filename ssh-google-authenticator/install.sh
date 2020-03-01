#!/bin/bash

apt-get -qq -y install libpam-google-authenticator

if ! grep -q "auth required pam_google_authenticator.so" /etc/pam.d/sshd
then
  echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/sshd
fi

if grep -q "ChallengeResponseAuthentication no" /etc/ssh/sshd_config
then
  sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
fi

systemctl restart sshd

google-authenticator -t -f -d -w 3 -r 3 -R 30 -e 4
if [ -d "/home/optimus" ]
then
  cp /root/.google_authenticator /home/optimus/.google_authenticator
fi
