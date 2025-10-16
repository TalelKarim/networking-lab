#!/bin/bash
set -euo pipefail


exec > >(tee -a /var/log/user-data.log) 2>&1


# Détection AL2023 (dnf) vs AL2 (yum + amazon-linux-extras)
if command -v dnf >/dev/null 2>&1; then
  # Amazon Linux 2023
  dnf -y update || true
  dnf -y install nginx
else
  # Amazon Linux 2
  yum -y update || true
  amazon-linux-extras enable nginx1
  yum clean metadata
  yum -y install nginx
fi

# Petite page de health
mkdir -p /usr/share/nginx/html
cat >/usr/share/nginx/html/health.html <<'H'
ok
H

# NGINX reverse proxy vers le backend
mkdir -p /etc/nginx/conf.d
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
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Connection "";
    }
}
EOF

nginx -t
systemctl enable --now nginx
