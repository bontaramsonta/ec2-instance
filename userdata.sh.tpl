#!/bin/bash
# Install nginx
apt-get update
apt-get install -y nginx

# Write the HTML content to default web root
cat << 'EOF' > /var/www/html/index.html
${html_content}
EOF

chown www-data:www-data /var/www/html/index.html

# Start nginx and enable it to start on boot
systemctl start nginx
systemctl enable nginx
