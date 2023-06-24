#!/bin/bash

# Install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# APP_SERVERS=(
#   "192.168.44.11"
#   "192.168.44.12"
# )

# # Generate the Nginx configuration
# config=""
# for server in "${APP_SERVERS[@]}"; do
#   config+='    server '"$server"';\n'
# done

# # Add the Nginx configuration to the load balancer file
# sudo sh -c "cat <<EOT > /etc/nginx/sites-available/default
# log_format custom '\$remote_adds - \$remote_user [\$time_local] '
# '"\$request" \$status \$body_bytes_sent '
# '"\$http_referer" "\$http_user_agent" '
# '"\$sent_http_x_custom_header"';

# upstream backend {
# least_conn;
# $config}
# server {
#     listen 80;
#     server_name lb;
    
#     location / {
#         proxy_pass http://backend;
#         proxy_set_header Host \$host;

#         add_header X-Custom-Header "Custom Value";
#         access_log /var/log/nginx/access.log custom;
#     }
# }
# EOT"

Restart Nginx
sudo systemctl restart nginx