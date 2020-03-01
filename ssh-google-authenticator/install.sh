apt-get -qq -y install libpam-google-authenticator

if ! grep -q "auth required pam_google_authenticator.so" /etc/pam.d/sshd; then
  echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/ssh
fi

if grep -q "ChallengeResponseAuthentication no" /etc/ssh/sshd_config; then
  sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
fi

service sshd restart

google-authenticator
