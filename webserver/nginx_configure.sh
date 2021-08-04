#!/bin/bash
echo "Server should be Fresh to configure webserver on server."
read -p "press y to confirm the installation else abort the work." confirmation
if [[ "$confirmation" = "y" ]];
then
read -p "Enter domain name: " domain_name
sudo apt update -y
sudo apt install nginx -y 
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
mkdir -p /var/www/$domain_name/public_html
echo "
server {
        listen 80;
        root /var/www/$domain_name/public_html;
        index index.php index.html index.htm;
        server_name $domain_name www.$domain_name;
 
        location / {
            try_files $uri $uri/ =404;
        }
 
        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        }
}
" >> /etc/nginx/sites-available/$domain_name.conf
sudo ln -s /etc/nginx/sites-available/$domain_name.conf /etc/nginx/sites-enabled/$domain_name.conf

echo  "\n Installing PHP on server..."
sudo apt install php7.4 php7.4-fpm -y 

echo  "<?php phpinfo(); ?>" >> /var/www/$domain_name/public_html/info.php

#echo "\n Installing Mariadb on Server...\n "

#sudo apt install -y mariadb-server mariadb-client
#sudo systemctl start mariadb.service
#sudo systemctl enable mariadb.service

echo "Access website http://$domain_name/info.php or http://`ifconfig  | grep inet  | grep -v '127.0.0.1' | grep -v 'inet6' | awk '{print $2 }'`/info.php"

#web-Server has configured.

else
	echo "Operation aborted!!"
fi
