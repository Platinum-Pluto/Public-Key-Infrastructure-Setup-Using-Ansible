#!/bin/bash

USER=""

mkdir -p /home/$USER/ca/{AcmeRootCA,AcmeSubCAOne,AcmeSubCATwo,server}/{private,certs,newcerts,crl,csr}
chmod -v 777 /home/$USER/ca/{AcmeRootCA,AcmeSubCAOne,AcmeSubCATwo,server}/{private,certs,newcerts,crl,csr}
mkdir -p /home/$USER/ca/ocsp/{private,certs,newcerts,crl,csr}
touch /home/$USER/ca/{AcmeRootCA,AcmeSubCAOne,AcmeSubCATwo}/index
chmod -R 777 /home/$USER/ca
cat cm.opensslConf.j2 > /home/$USER/ca/server/cm.conf
cat cnn.opensslConf.j2 > /home/$USER/ca/server/cnn.conf
cat vss.opensslConf.j2 > /home/$USER/ca/server/vss.conf
cat OCSP.conf.j2 > /home/$USER/ca/ocsp/ocsp.conf
openssl rand -hex 16 > /home/$USER/ca/AcmeRootCA/serial
openssl rand -hex 16 > /home/$USER/ca/AcmeSubCAOne/serial
openssl rand -hex 16 > /home/$USER/ca/AcmeSubCATwo/serial
openssl genrsa -aes256 -out /home/$USER/ca/AcmeRootCA/private/ca.key 4096 
openssl genrsa -aes256 -out /home/$USER/ca/AcmeSubCAOne/private/ca.key 4096 
openssl genrsa -aes256 -out /home/$USER/ca/AcmeSubCATwo/private/ca.key 4096 
openssl genrsa -out /home/$USER/ca/AcmeSubCATwo/private/ca.key 2048
openssl genrsa -out /home/$USER/ca/AcmeSubCAOne/private/ca.key 2048
cat AcmeRootCA.conf.j2 > /home/$USER/ca/AcmeRootCA/AcmeRootCA.conf
cat AcmeSubCAOne.conf.j2 > /home/$USER/ca/AcmeSubCAOne/AcmeSubCAOne.conf
cat AcmeSubCATwo.conf.j2 >  /home/$USER/ca/AcmeSubCATwo/AcmeSubCATwo.conf
cat catwo.conf.j2 > /var/www/cm/AcmeSubCATwo.conf
cat cm.autosigner.j2 > /var/www/cm/handler/testing.py
chmod -R 777 /home/$USER/ca
openssl req -config /home/$USER/ca/AcmeRootCA/AcmeRootCA.conf -key /home/$USER/ca/AcmeRootCA/private/ca.key -new -x509 -days 7500 -sha256 -extensions v3_ca -out /home/$USER/ca/AcmeRootCA/certs/ca.crt -passin pass:phrase -batch
openssl req -config /home/$USER/ca/AcmeSubCAOne/AcmeSubCAOne.conf -new -key /home/$USER/ca/AcmeSubCAOne/private/ca.key -sha256 -out /home/$USER/ca/AcmeSubCAOne/csr/ca.csr -passin pass:phrase -batch
openssl req -config /home/$USER/ca/AcmeSubCATwo/AcmeSubCATwo.conf -new -key /home/$USER/ca/AcmeSubCATwo/private/ca.key -sha256 -out /home/$USER/ca/AcmeSubCATwo/csr/ca.csr -passin pass:phrase -batch
chmod -R 777 /home/$USER/ca
openssl ca -config /home/$USER/ca/AcmeRootCA/AcmeRootCA.conf -extensions v3_intermediate_ca -days 3650 -notext -in /home/$USER/ca/AcmeSubCAOne/csr/ca.csr -out /home/$USER/ca/AcmeSubCAOne/certs/ca.crt -passin pass:phrase -batch
openssl ca -config /home/$USER/ca/AcmeRootCA/AcmeRootCA.conf -extensions v3_intermediate_ca -days 3650 -notext -in /home/$USER/ca/AcmeSubCATwo/csr/ca.csr -out /home/$USER/ca/AcmeSubCATwo/certs/ca.crt -passin pass:phrase -batch
openssl genrsa -out /home/$USER/ca/ocsp/private/ocsp.key 2048
openssl genrsa -out /home/$USER/ca/server/private/cnn.key 2048
openssl genrsa -out /home/$USER/ca/server/private/vss.key 2048
openssl genrsa -out /home/$USER/ca/server/private/cm.key 2048
openssl req -new -key /home/$USER/ca/ocsp/private/ocsp.key -out /home/$USER/ca/ocsp/csr/ocsp.csr -config /home/$USER/ca/ocsp/ocsp.conf -passin pass:phrase -batch 
openssl req -new -key /home/$USER/ca/server/private/cnn.key -out /home/$USER/ca/server/csr/cnn.csr -config /home/$USER/ca/server/cnn.conf -extensions server_cert -passin pass:phrase -batch
openssl req -new -key /home/$USER/ca/server/private/vss.key -out /home/$USER/ca/server/csr/vss.csr -config /home/$USER/ca/server/vss.conf -extensions server_cert -passin pass:phrase -batch
openssl req -new -key /home/$USER/ca/server/private/cm.key -out /home/$USER/ca/server/csr/cm.csr -config /home/$USER/ca/server/cm.conf -extensions server_cert -passin pass:phrase -batch
chmod -R 777 /home/$USER/ca
openssl ca -config /home/$USER/ca/server/cnn.conf -extensions server_cert -days 365 -in /home/$USER/ca/server/csr/cnn.csr -out /home/$USER/ca/server/certs/cnn.crt -notext -md sha256 -passin pass:phrase -batch
openssl ca -config /home/$USER/ca/server/vss.conf -in /home/$USER/ca/server/csr/vss.csr -out /home/$USER/ca/server/certs/vss.crt -extensions server_cert -days 365 -notext -md sha256 -passin pass:phrase -batch
openssl ca -config /home/$USER/ca/server/cm.conf -in /home/$USER/ca/server/csr/cm.csr -out /home/$USER/ca/server/certs/cm.crt -extensions server_cert -days 365 -notext -md sha256 -passin pass:phrase -batch
chmod -R 777 /home/$USER/ca
openssl ca -config /home/$USER/ca/ocsp/ocsp.conf -extensions ocsp -days 365 -in /home/$USER/ca/ocsp/csr/ocsp.csr -out /home/$USER/ca/ocsp/certs/ocsp.crt -passin pass:phrase -batch
chmod -R 777 /home/$USER/ca
cp /home/$USER/ca/AcmeSubCATwo/certs/ca.crt /etc/ssl/certs/AcmeSubCATwo.crt
cp /home/$USER/ca/server/certs/cnn.crt /etc/ssl/certs/cnn.crt
cp /home/$USER/ca/server/certs/vss.crt /etc/ssl/certs/vss.crt
cp /home/$USER/ca/server/certs/cm.crt /etc/ssl/certs/cm.crt
cp /home/$USER/ca/server/private/cnn.key /etc/ssl/certs/cnn.key
cp /home/$USER/ca/server/private/vss.key /etc/ssl/certs/vss.key
cp /home/$USER/ca/server/private/cm.key /etc/ssl/certs/cm.key
systemctl restart apache2
systemctl restart bind9