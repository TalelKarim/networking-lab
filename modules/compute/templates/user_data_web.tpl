#!/bin/bash
set -euo pipefail

yum update -y
yum install -y nginx

# Page de santé simple
cat >/usr/share/nginx/html/health.html <<'H'
ok
H

# NGINX reverse proxy vers le backend
cat >/etc/nginx/conf.d/reverse.conf <<EOF
server {
    listen 80;
    server_name _;

    location /health {
        root /usr/share/nginx/html;
        try_files /health.html =200;
        add_header Content-Type text/plain;
    }

    location / {
        proxy_pass http://${app_endpoint}:${app_port};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Connection "";
    }
}
EOF

nginx -t
systemctl enable --now nginx
