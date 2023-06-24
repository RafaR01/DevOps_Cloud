#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Apache HTTP Server\033[0m"
sudo apt-get install -y apache2

echo -e "$MSG_COLOR$(hostname): Install PHP-FPM and necessary modules\033[0m"
sudo apt-get install -y php php-fpm php-common php-cli php-mysql php-pgsql php-pdo php-mbstring php-zip zip unzip

# sudo sh -c 'echo -e "<?php\nphpinfo();\n?>" > /var/www/html/phpinfo.php'

sudo systemctl restart apache2

echo -e "$MSG_COLOR$(hostname): Install PostgreSQL and its PHP extension\033[0m"
sudo apt-get install -y postgresql postgresql-contrib php-pgsql

echo -e "$MSG_COLOR$(hostname): Create a new PostgreSQL user and database\033[0m"
sudo -u postgres psql -c "CREATE USER myuser WITH PASSWORD 'mypassword';"
sudo -u postgres psql -c "CREATE DATABASE mydatabase OWNER myuser;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;"

# peer access to myuser
# sudo sh -c 'echo "local   all             myuser                                  peer" >> /etc/postgresql/14/main/pg_hba.conf'
sudo service postgresql restart

sudo -u postgres psql -d mydatabase -c "DROP TABLE test;"


echo -e "$MSG_COLOR$(hostname): Import dump.sql and set user privileges\033[0m"
# PGPASSWORD=mypassword sudo -u postgres psql -U myuser -h localhost -d mydatabase -f /vagrant/provision/dump.sql # change to ./provision/dump.sql
sudo -u postgres psql -d mydatabase -f /vagrant/provision/dump.sql
sudo -u postgres psql -d mydatabase -c "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE messages TO myuser;" # uneeded?
sudo -u postgres psql -d mydatabase -c "GRANT USAGE, SELECT, UPDATE ON SEQUENCE messages_id_seq TO myuser;"
sudo -u postgres psql -d mydatabase -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO myuser;"
sudo -u postgres psql -d mydatabase -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO myuser;"
sudo -u postgres psql -d mydatabase -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;"



# Permitior todo o tipo de acessos ao servidor de base de dados, vindos destes IP's, que correspondem aos app server

# Modify pg_hba.conf to allow connections from web app server
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/14/main/postgresql.conf
#sudo sed -i '$ a host    all    all    192.168.44.10/32    scram-sha-256' /etc/postgresql/14/main/pg_hba.conf
#sudo sed -i '$ a host    all    all    192.168.44.11/32     scram-sha-256' /etc/postgresql/14/main/pg_hba.conf
sudo sh -c "echo \"host    all     all     192.168.44.0/24     scram-sha-256\" >> /etc/postgresql/14/main/pg_hba.conf"


echo -e "$MSG_COLOR$(hostname): View users and databases in PostgreSQL\033[0m"
sudo -u postgres psql -c "\du"
sudo -u postgres psql -c "\list"
sudo -u postgres psql -d mydatabase -c "\dt"

sudo service postgresql restart