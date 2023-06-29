#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Nginx\033[0m"
sudo apt-get install -y nginx

echo -e "$MSG_COLOR$(hostname): Install PHP-FPM and necessary modules\033[0m"
sudo apt-get install -y php-fpm php-common php-cli php-mysql php-pgsql php-pdo php-mbstring php-zip zip unzip

sudo systemctl restart nginx

##

# Download and install Consul
CONSUL_VERSION="1.11.0"
wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip

unzip consul_${CONSUL_VERSION}_linux_amd64.zip

mv consul /usr/local/bin/
rm consul_${CONSUL_VERSION}_linux_amd64.zip

sudo mkdir /etc/consul.d
sudo mkdir /var/consul.d

# Find IP address starting with "192.168.44"
ip=$(ip addr | grep -oP 'inet \K[\d.]+')
filtered_ip=$(echo "$ip" | grep '^192.168.44')

# Check if IP address is found
if [ -z "$filtered_ip" ]; then
  echo "No IP address starting with 192.168.44 found."
  exit 1
fi

#members_count=$(consul members | wc -l)
#members_count=$((members_count - 1))
vmNum=$1

# Retrieve the IP address of the target machine from its SSH configuration
#target_ip=$(vagrant ssh-config consulmaster | awk '/HostName/ { if ($2 ~ /^192\.168\.44/) print $2 }')

#echo -e "$MSG_COLOR$(hostname): $filtered_ip\033[0m"
#echo -e "$MSG_COLOR$(hostname): $vmNum\033[0m"

echo -e "$MSG_COLOR$(hostname): $filtered_ip\033[0m"
echo -e "$MSG_COLOR$(hostname): $vmNum\033[0m"

# Run the consul agent command with the IP address
sudo -u vagrant screen -d -m sudo consul agent -data-dir /var/consul.d -config-dir /etc/consul.d -node "consul-client$vmNum" -bind "$filtered_ip"

#sudo -u vagrant screen -d -m consul agent -data-dir /var/consul.d -config-dir /etc/consul.d -node consul-client2 -bind ${WEBAPP1}

sudo consul join 192.168.44.15

sudo cat /vagrant/provision/webserver.json | tee /etc/consul.d/webserver.json

sudo consul reload
##

echo -e "$MSG_COLOR$(hostname): Install Composer (PHP)\033[0m"
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

echo -e "$MSG_COLOR$(hostname): Install dependencies for webapp\033[0m"
cd /vagrant/app
sudo -u vagrant bash -c 'composer install'

#echo -e "$MSG_COLOR$(hostname): Copying webapp files to nginx default folder\033[0m"
sudo cp -r /vagrant/* /var/www/html/
sudo chmod -R 777 /var/www/html/
#sudo cp -r /vagrant/.* /var/www/html/

echo -e "$MSG_COLOR$(hostname): Copy Nginx config, disable the default site / enable ours\033[0m"
sudo cp /vagrant/provision/projectA.conf /etc/nginx/sites-available/
sudo unlink /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/projectA.conf /etc/nginx/sites-enabled/
sudo systemctl reload nginx

echo -e "$MSG_COLOR$(hostname): Update deploy date @ .env file\033[0m"
cd /vagrant/app
ISO_DATE=$(TZ=Europe/Lisbon date -Iseconds)
sed -i "s/^DEPLOY_DATE=.*/DEPLOY_DATE=\"$ISO_DATE\"/" .env

echo -e "$MSG_COLOR$(hostname): Finished! Visit http://192.168.44.10\033[0m"
