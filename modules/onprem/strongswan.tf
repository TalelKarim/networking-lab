#########################################
# VPC et sous-réseau cible
#########################################

#########################################
# Groupe de sécurité openswan
#########################################
resource "aws_security_group" "openswan_sg" {
  name        = "openswan-sg"
  description = "Security group for openswan VPN Gateway"
  vpc_id      = var.vpc_id

  # UDP 500 (IKE) + 4500 (NAT-T)
  ingress {
    description = "IKE (IPsec)"
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NAT-T (IPsec)"
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP (ping)
  ingress {
    description = "ICMP (Ping)"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH (administration)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "openswan-sg"
  }
}

#########################################
# Elastic IP pour le WAN
#########################################
resource "aws_eip" "openswan" {
  domain = "vpc"
  tags = {
    Name = "openswan-eip"
  }
}

#########################################
# Instance EC2 openswan
#########################################


resource "aws_instance" "openswan" {
  ami                         = var.ami_id_openswan
  instance_type               = "t3.micro"
  subnet_id                   = var.router_subnet_id
  vpc_security_group_ids      = [aws_security_group.openswan_sg.id]
  associate_public_ip_address = true  # nécessaire si le subnet est public
  source_dest_check           = false # autorise le routage VPN


  user_data = templatefile("${path.module}/templates/user-data-libreswan.sh.tpl", {
    TUN1_OUTSIDE_IP = var.tunn_1_outside_ip
    TUN2_OUTSIDE_IP = var.tunn_2_outside_ip
    TUN1_PSK        = var.tunn_1_psk
    TUN2_PSK        = var.tunn_2_psk
    ONPREM_CIDR     = var.vpc_onprem_cidr
    PUB_IP          = aws_eip.openswan.public_ip
    AWS_AGG_CIDR    = "10.0.0.0/8"
  })
  tags = {
    Name = "openswan"
  }
}

#########################################
# Association de l’EIP à l’instance
#########################################
resource "aws_eip_association" "openswan_assoc" {
  instance_id   = aws_instance.openswan.id
  allocation_id = aws_eip.openswan.id
}




resource "aws_instance" "openswan_shadow" {
  ami                         = var.ami_id_openswan
  instance_type               = "t3.micro"
  subnet_id                   = var.router_subnet_id
  vpc_security_group_ids      = [aws_security_group.openswan_sg.id]
  associate_public_ip_address = true  
  source_dest_check           = false # autorise le routage VPN


  tags = {
    Name = "openswan_shadow"
  }
}