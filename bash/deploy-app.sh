#!/bin/bash
# File in /root/deploy-app.sh

# Install required packages one at a time

sudo apt update
sudo apt install git -y 
sudo apt install nginx -y

# This is a simple Web app to show that the deployment works.

sudo wget https://github.com/interrupt-software/happy-animals/archive/refs/tags/v1.0.0.tar.gz -P /home/ubuntu/
sudo tar xvfz /home/ubuntu/v1.0.0.tar.gz -C /var/www
sudo rm -fR /var/www/html
sudo mv /var/www/happy-animals-1.0.0 /var/www/html

# Show the Web app

sudo systemctl start nginx