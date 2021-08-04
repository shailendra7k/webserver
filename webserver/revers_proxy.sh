#!/bin/bash
read -p "Enter domain name" DomainName
read -p "press y to configure reverse proxy: " confirmation
if [[ $confirmation = "y" ]];
then
	apt-get install nginx apache2 -y 
	systemctl restart nginx 
	sed -i 's/Listen\ 80/Listen\ 8080/' /etc/apache2/ports.conf
	systemctl restart apache2
	echo "yes install reverse proxy";
else
	echo "Do no configure reverse proxy";
fi
