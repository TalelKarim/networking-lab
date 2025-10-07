#!/bin/bash
set -euo pipefail

yum update -y
yum install -y docker || dnf -y install docker
systemctl enable --now docker
usermod -aG docker ec2-user || true

# (re)lance WordPress côté app, exposé en ${listen_port}
docker rm -f app-backend >/dev/null 2>&1 || true

docker run -d --name app-backend -p ${listen_port}:80 \
  -e WORDPRESS_DB_HOST="${rds_endpoint}" \
  -e WORDPRESS_DB_USER="${db_user}" \
  -e WORDPRESS_DB_PASSWORD="${db_password}" \
  -e WORDPRESS_DB_NAME="${db_name}" \
  --restart unless-stopped wordpress:latest
