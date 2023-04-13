#!/bin/bash
sleep 30s
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq -y
apt-get install ssl-cert nginx -y

sed -i 's|# listen 443|listen 443|' /etc/nginx/sites-available/default
sed -i 's|# include snippets/snakeoil|include snippets/snakeoil|' /etc/nginx/sites-available/default

echo "Hello, I am $HOSTNAME" > /var/www/html/index.html

systemctl enable nginx
systemctl stop nginx
systemctl start nginx
systemctl status nginx
