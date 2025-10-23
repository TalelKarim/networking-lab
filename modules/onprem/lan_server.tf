############################################
# AMI Amazon Linux 2
############################################
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "onprem_test_sg" {
  name        = "lan-server-sg"
  description = "SG pour la VM de test on-prem (LAN)"
  vpc_id      = var.vpc_id

  # ICMP depuis tes VPCs pour tester ping
  ingress {
    description = "ICMP depuis VPC Web"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_web_cidr]
  }
  ingress {
    description = "ICMP depuis VPC App"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_app_cidr]
  }
  ingress {
    description = "ICMP depuis VPC DB"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_shared_cidr]
  }

  # SSH d’admin (depuis ton IP ou un bastion)
  ingress {
    description = "SSH admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }


  ingress {
    description = "HTTP depuis VPCs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_web_cidr, var.vpc_app_cidr, var.vpc_shared_cidr]
  }

  egress {
    description = "Sortie libre"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "lan-server-sg" }
}

############################################
# EC2 de test en subnet privé on-prem
############################################


# (Facultatif) petit cloud-init pour installer ping/httpd
locals {
  onprem_user_data = <<-EOT
    #!/bin/bash
    set -eux
    # Amazon Linux 2 : httpd pour tester en HTTP
    yum -y install httpd || true
    systemctl enable --now httpd || true
    echo "Hello from onprem LAN VM" > /var/www/html/index.html
  EOT
}

resource "aws_instance" "lan_server_vm" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = "t3.micro"
  subnet_id                   = var.onprem_private_subnet_id
  vpc_security_group_ids      = [aws_security_group.onprem_test_sg.id]
  associate_public_ip_address = false
  user_data                   = local.onprem_user_data

  # Optionnel : si tu veux ajouter des tags pour repérer les flux
  tags = {
    Name = "lan-server-vm"
    Role = "onprem-lan"
  }
}
