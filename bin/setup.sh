#!/bin/bash

echo "Provisioning virtual machine..."

echo "Installing common packages"
apt-get -y update
apt-get -y install vim curl unzip git debconf-utils

echo "Installing Apache + activate modules"
apt-get -y install apache2
a2enmod rewrite headers expires deflate

echo "Destroy default configuration Apache"
if [ -f /etc/apache2/sites-available/000-default.conf ]
then
    rm -f /etc/apache2/sites-available/000-default.conf
    rm -f /etc/apache2/sites-enabled/000-default.conf
fi
if [ -f /etc/apache2/sites-available/default-ssl.conf ]
then
    rm -f /etc/apache2/sites-available/default-ssl.conf
fi
if [ -f /var/www/html/index.html ]
then
    rm -f /var/www/html/index.html
fi

echo "Installing mysql"
debconf-set-selections <<< "mysql-server mysql-server/root_password password ezplatform"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ezplatform"
apt-get -y install mysql-server

echo "Installing php + modules"
apt-get -y install php5 php5-mysql php5-xsl php5-intl php5-curl php5-gd

echo "Installing APC"
apt-get -y install php-pear
pear upgrade pear
apt-get -y install php-apc
ln -s /usr/share/doc/php-apc/apc.php /var/www/apc.php

echo "Installing imagemagick"
apt-get -y install imagemagick

echo "Installing Java jre7 + utils packages for solr engine search"
apt-get -y install openjdk-7-jre poppler-utils wv

echo "Restart Apache for the config to take effect"
service apache2 restart

echo "Finished provisioning."