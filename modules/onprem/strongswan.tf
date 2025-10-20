#########################################
# VPC et sous-réseau cible
#########################################

#########################################
# Groupe de sécurité StrongSwan
#########################################
resource "aws_security_group" "strongswan_sg" {
  name        = "strongswan-sg"
  description = "Security group for StrongSwan VPN Gateway"
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
    Name = "strongswan-sg"
  }
}

#########################################
# Elastic IP pour le WAN
#########################################
resource "aws_eip" "strongswan" {
  domain = "vpc"
  tags = {
    Name = "strongswan-eip"
  }
}

#########################################
# Instance EC2 StrongSwan
#########################################
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "strongswan" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.strongswan_sg.id]
  associate_public_ip_address  = true  # nécessaire si le subnet est public
  source_dest_check           = false # autorise le routage VPN

  user_data = <<-EOF
              #!/bin/bash
              set -eux
              yum -y update
              yum -y install strongswan
              systemctl enable strongswan
              systemctl start strongswan
              EOF

  tags = {
    Name = "strongswan"
  }
}

#########################################
# Association de l’EIP à l’instance
#########################################
resource "aws_eip_association" "strongswan_assoc" {
  instance_id   = aws_instance.strongswan.id
  allocation_id = aws_eip.strongswan.id
}
