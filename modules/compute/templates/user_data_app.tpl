#!/bin/bash
set -euo pipefail

# -------- params from templatefile() --------
RDS_ENDPOINT="${rds_endpoint}"    # ex: demodb.xxxxxx.eu-west-1.rds.amazonaws.com
DB_NAME="${db_name}"              # ex: appdb
DB_USER="${db_user}"              # ex: appuser
DB_PASSWORD="${db_password}"      # mot de passe fort
LISTEN_PORT="${listen_port}"      # ex: 8080

# -------- base system + docker --------
yum update -y
yum install -y docker
systemctl enable --now docker

# (facultatif) permettre à ec2-user d'utiliser docker
usermod -aG docker ec2-user || true

# -------- lancer WordPress (backend) --------
docker rm -f app-backend >/dev/null 2>&1 || true

docker run -d --name app-backend -p ${LISTEN_PORT}:80 \
  -e WORDPRESS_DB_HOST="${RDS_ENDPOINT}:3306" \
  -e WORDPRESS_DB_USER="${DB_USER}" \
  -e WORDPRESS_DB_PASSWORD="${DB_PASSWORD}" \
  -e WORDPRESS_DB_NAME="${DB_NAME}" \
  --restart unless-stopped wordpress:latest
