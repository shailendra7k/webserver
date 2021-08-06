#!/bin/bash
echo "Server should be Fresh to configure webserver on server."
read -p "press y to confirm the installation else abort the work." confirmation
if [[ "$confirmation" = "y" ]];
then
read -p "Enter domain name: " domain_name
sudo apt update -y
sudo apt install apache2 -y 
mkdir -p /var/www/$domain_name/public_html
echo "
<VirtualHost *:80>
    ServerAdmin webmaster@$domain_name
    ServerName $domain_name
    ServerAlias www.$domain_name
    DocumentRoot /var/www/$domain_name/public_html
    ErrorLog /var/log/apache2/$domain_name.error.log
    CustomLog /var/log/apache2/$domain_name.access.log combined
</VirtualHost>
<Directory /var/www/$domain_name/public_html>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
" >> /etc/apache2/sites-available/$domain_name.conf

sudo a2ensite $domain_name.conf 
sudo a2dissite 000-default.conf

echo  "\n Installing PHP on server..."
sudo apt install php libapache2-mod-php php7.4-mysql php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl -y

echo  "<?php phpinfo(); ?>" >> /var/www/$domain_name/public_html/info.php

echo "\n Installing Mariadb on Server...\n "

sudo apt install -y mariadb-server mariadb-client
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service

echo "Access website http://$domain_name/info.php or http://`ifconfig  | grep inet  | grep -v '127.0.0.1' | grep -v 'inet6' | awk '{print $2 }'`/info.php"

#web-Server has configured.

else
	echo "Operation aborted!!"
fi
