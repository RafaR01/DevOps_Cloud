#!/bin/bash


MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Nginx\033[0m"
sudo apt-get install -y nginx

echo -e "$MSG_COLOR$(hostname): Install PHP-FPM and necessary modules\033[0m"
sudo apt-get install -y php-fpm php-common php-cli php-mysql php-pgsql php-pdo php-mbstring php-zip zip unzip

sudo systemctl restart nginx


sudo apt update && sudo apt upgrade

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt install consul

consul version