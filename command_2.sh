#!/bin/bash
mkdir /etc/bind/zones
cat db.cnn.com.j2 > /etc/bind/zones/db.cnn.com
cat db.vss.com.j2 > /etc/bind/zones/db.vss.com
cat db.cm.com.j2 >  /etc/bind/zones/db.cm.com
cat rev.j2 >  /etc/bind/zones/56.168.192.db
cat named.conf.local.j2 > /etc/bind/named.conf.local
cat named.conf.options.j2 > /etc/bind/named.conf.options
cat AcmeSubCATwoSigner.conf.j2 > /var/www/cm/AcmeSubCATwoSigner.conf
ufw enable
ufw allow 80
ufw allow 443
ufw allow 53
ufw allow 3000
systemctl restart ufw
