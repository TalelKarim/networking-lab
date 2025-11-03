#!/bin/bash -xe
#
# User-data: Libreswan pour VPN site-to-site (AWS TGW, IKEv1 statique)
# Compatible Amazon Linux 2

# --- Variables injectées par Terraform (templatefile) ---
TUN1_OUTSIDE_IP="${TUN1_OUTSIDE_IP}"
TUN2_OUTSIDE_IP="${TUN2_OUTSIDE_IP}"
TUN1_PSK='${TUN1_PSK}'
TUN2_PSK='${TUN2_PSK}'

# Sous-réseaux
ONPREM_CIDR="${ONPREM_CIDR}"      # ex: 10.255.0.0/24  (ton VPC on-prem simulé)
AWS_AGG_CIDR="${AWS_AGG_CIDR}"    # ex: 10.0.0.0/8     (agrégat de tes VPC)

# Si tu veux éventuellement passer aussi les inside-IP via variables, tu peux,
# mais pour le mode "policy-based" de base ce n'est pas nécessaire.

# # --- Détection de l’IP publique de l’instance (leftid) ---
# PUB_IP="$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || true)"
# if [ -z "$PUB_IP" ]; then
#   PUB_IP="$(curl -s https://ifconfig.me || true)"
# fi

# --- Mises à jour & installation ---
yum -y update
yum -y install libreswan

# --- sysctl requis par IPsec ---
cat >/etc/sysctl.d/99-ipsec.conf <<'EOF'
net.ipv4.ip_forward = 1

# rp_filter doit être à 0 avec IPsec
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0

# éviter les (accept|send)_redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
EOF
sysctl --system

# --- /etc/ipsec.conf minimal qui inclut nos conns ---
cat >/etc/ipsec.conf <<'EOF'
# géré par user-data
config setup
  uniqueids=yes
include /etc/ipsec.d/*.conf
EOF

# --- Conns AWS (IKEv1 statique) ---
# NB: syntaxe Libreswan moderne: "esp=" au lieu de phase2/phase2alg
cat >/etc/ipsec.d/aws.conf <<EOF
conn Tunnel1
  auto=start
  type=tunnel
  authby=secret
  ike=aes128-sha1;modp1024
  esp=aes128-sha1;modp1024
  ikelifetime=8h
  salifetime=1h
  keyingtries=%forever
  ikev2=never

  left=%defaultroute
  leftid=${PUB_IP}
  leftsubnet=${ONPREM_CIDR}

  right=${TUN1_OUTSIDE_IP}
  rightsubnet=${AWS_AGG_CIDR}

  dpddelay=10
  dpdtimeout=30
  dpdaction=restart_by_peer

conn Tunnel2
  auto=add
  type=tunnel
  authby=secret
  ike=aes128-sha1;modp1024
  esp=aes128-sha1;modp1024
  ikelifetime=8h
  salifetime=1h
  keyingtries=%forever
  ikev2=never

  left=%defaultroute
  leftid=${PUB_IP}
  leftsubnet=${ONPREM_CIDR}

  right=${TUN2_OUTSIDE_IP}
  rightsubnet=${AWS_AGG_CIDR}

  dpddelay=10
  dpdtimeout=30
  dpdaction=restart_by_peer
EOF

# --- PSK par tunnel (indispensable) ---
install -m 600 -o root -g root /dev/null /etc/ipsec.d/aws.secrets
cat >/etc/ipsec.d/aws.secrets <<EOF
${PUB_IP} ${TUN1_OUTSIDE_IP} : PSK "${TUN1_PSK}"
${PUB_IP} ${TUN2_OUTSIDE_IP} : PSK "${TUN2_PSK}"
EOF
chmod 600 /etc/ipsec.d/aws.secrets

# --- Service & démarrage des tunnels ---
systemctl enable ipsec
systemctl restart ipsec

# On (re)charge les secrets et on force l’init Tunnel1
ipsec auto --rereadsecrets || true
ipsec auto --add Tunnel1 || true
ipsec auto --add Tunnel2 || true
ipsec auto --up Tunnel1 || true

# logs utiles
sleep 5
ipsec status > /var/log/ipsec-status.log || true
ipsec whack --trafficstatus > /var/log/ipsec-trafficstatus.log || true
