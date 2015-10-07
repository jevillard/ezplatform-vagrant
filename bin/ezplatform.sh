#!/bin/bash

echo "Installing eZPLatform on virtual machine..."

echo "Download ezplatform by composer..."
rm -rf /var/www/html/ezplatform && cd /var/www/html
curl -s http://getcomposer.org/installer | php
php -d memory_limit=-1 composer.phar create-project --no-dev ezsystems/ezplatform /var/www/html/ezplatform

echo "Create database for eZPlatform"
DB_NAME="ezplatform"
DB_PASSWD="ezplatform"
DB_RESULT=`mysqlshow -u root -p$DB_PASSWD $DB_NAME | grep -v Wildcard | grep -o $DB_NAME`
if [ "$DB_RESULT" == $DB_NAME ]
  # if it's already installed, just indicate such
  then
    echo "Database $DB_NAME already installed."

  # if it's not installed, install it using the daptive_dma profile
  else
    echo "Database $DB_NAME not yet installed... installing using mysql"
    mysql -u root -p$DB_PASSWD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8;"
fi

echo "Update database settings for ezplatform..."
sed -i 's/database_password:/database_password: ezplatform/g' /var/www/html/ezplatform/ezpublish/config/parameters.yml.dist
sed -i 's/database_password: null/database_password: ezplatform/g' /var/www/html/ezplatform/ezpublish/config/parameters.yml

echo "Implementation of eZPlatform vhost..."
cp /var/www/html/ezplatform/doc/apache2/vhost.template /etc/apache2/sites-available/ezplatform.conf
sed -i 's/%IP_ADDRESS%/*/g' /etc/apache2/sites-available/ezplatform.conf
sed -i 's/%PORT%/80/g' /etc/apache2/sites-available/ezplatform.conf
sed -i 's/%HOST%/ezplatform.local/g' /etc/apache2/sites-available/ezplatform.conf
sed -i 's/%HOST_ALIAS%/admin.ezplatform.local/g' /etc/apache2/sites-available/ezplatform.conf
sed -i 's/%BASEDIR%/\/var\/www\/html\/ezplatform/g' /etc/apache2/sites-available/ezplatform.conf
sed -i 's/%ENV%/dev/g' /etc/apache2/sites-available/ezplatform.conf
sed -i 's/AllowOverride None/AllowOverride all/g' /etc/apache2/sites-available/ezplatform.conf
sed -i 's/#SetEnv CUSTOM_CLASSLOADER_FILE/SetEnv CUSTOM_CLASSLOADER_FILE/g' /etc/apache2/sites-available/ezplatform.conf
sed -i 's/#SetEnv USE_HTTP_CACHE 1/SetEnv USE_HTTP_CACHE 1/g' /etc/apache2/sites-available/ezplatform.conf

echo "Update php.ini..."
sed -i 's/;date.timezone =/date.timezone = "Europe\/Paris"/g' /etc/php5/apache2/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 60/g' /etc/php5/apache2/php.ini
sed -i 's/max_input_time = 60/max_input_time = 120/g' /etc/php5/apache2/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 2048M/g' /etc/php5/apache2/php.ini

echo "Run installation command..."
cd /var/www/html/ezplatform && rm -rf ezpublish/cache/*
cd /var/www/html/ezplatform && php -d memory_limit=-1 ezpublish/console ezplatform:install demo

echo "Restart Apache2..."
cd /etc/apache2/sites-available
a2ensite ezplatform.conf
service apache2 restart

echo "Finished installing eZPlatform."