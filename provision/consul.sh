#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Nginx\033[0m"
sudo apt-get install -y nginx

echo -e "$MSG_COLOR$(hostname): Install PHP-FPM and necessary modules\033[0m"
sudo apt-get install -y php-fpm php-common php-cli php-mysql php-pgsql php-pdo php-mbstring php-zip zip unzip

sudo systemctl restart nginx

# Download and install Consul
CONSUL_VERSION="1.11.0"
wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip

unzip consul_${CONSUL_VERSION}_linux_amd64.zip

mv consul /usr/local/bin/
rm consul_${CONSUL_VERSION}_linux_amd64.zip

sudo mkdir /etc/consul.d
sudo mkdir /var/consul.d

# Start Consul agent
#consul agent -dev -bind=127.0.0.1 -client=0.0.0.0 &

# Find IP address starting with "192.168.44"
ip=$(ip addr | grep -oP 'inet \K[\d.]+')
filtered_ip=$(echo "$ip" | grep '^192.168.44')

# Check if IP address is found
if [ -z "$filtered_ip" ]; then
  echo "No IP address starting with 192.168.44 found."
  exit 1
fi

sudo -u vagrant screen -d -m sudo consul agent -server -ui -bootstrap-expect 1 -data-dir /var/consul.d -config-dir /etc/consul.d -node consul-master -bind=$filtered_ip -client=0.0.0.0

echo -e "$MSG_COLOR$(hostname): Copy Nginx config, disable the default site / enable ours\033[0m"
sudo cp /vagrant/provision/projectA_consulDefault.conf /etc/nginx/conf.d/default.conf
#sudo cp /vagrant/provision/projectA_consulNginx.conf /etc/nginx/nginx.conf
sudo cat /vagrant/provision/projectA_consulNginx.conf | tee /etc/nginx/nginx.conf

sudo nginx -s reload

sudo consul reload