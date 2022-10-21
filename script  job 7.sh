#!/bin/sh

sudo echo "export PATH='$PATH:/usr/sbin/'" >> ~/.bashrc
sudo source ~/.bashrc

#D'abord mettre à jour les paquets

apt-get update

#Ensuite installer FTP

apt-get install proftpd

#Puis nous ajoutons l'utilisateur Merry

echo "/bin/false" >> /etc/shells
adduser merry --shell /bin/false --home /home/merry


#Nous devons ensuite configurer l'accès anonyme

mkdir ftpdownload
chmod 755 -R ftpdownload

#Puis

echo "<Anonymous ~ftp>
User ftp
Group nogroup
UserAlias anonymous ftp
DirFakeUser on ftp
FirFakeGroup on ftp
RequireValidShell off
MaxClients 10
<Directory *>
   <Limit WRITE>
    DenyAll
   </Limit>
  </Directory>
  </Anonymous>" >> /etc/proftpd/proftpd.conf

#Enfin il reste à sécuriser en configurant TLS et SSL
#D'abord on créer le certificat et la clef

mkdir /etc/proftpd/ssl
openssl req -new -x509 -days 365 -nodes -out /etc/proftpd/ssl/proftpd.cert.pem -keyout /etc/proftpd/ssl/proftpd.key.pem

#Ensuite il faut activer SSL/TLS

echo "<IfModule mod_tls.c>
TLSEngine on
TLSLog /var/log/proftpd/tls.Log
TLSProtocol TLSv1 TLSv1.1 TLSv1.2
TLSRSACertificateFile /etc/proftpd/ssl/proftpd.cert.pem
TLSRSACertificateKeyFile /etc/proftpd/ssl/proftpd.key.pem
TLSVerifyClient off
TLSRequired on
</Ifmodule>" >> /etc/proftpd/proftpd.conf