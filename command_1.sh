#!/bin/bash

mkdir /var/www/cnn
mkdir /var/www/vss
mkdir /var/www/cm
mkdir /var/www/cm/handler
cat cnn.php > /var/www/cnn/index.php
cat vss.php > /var/www/vss/index.php
cat cm.php > /var/www/cm/index.php
cat cnn.conf.j2 > /etc/apache2/sites-available/cnn.conf
cat vss.conf.j2 > /etc/apache2/sites-available/vss.conf
cat cm.conf.j2 > /etc/apache2/sites-available/cm.conf
cat cm.autosigner.j2 > /var/www/cm/handler/testing.py
