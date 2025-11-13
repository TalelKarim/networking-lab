############################################
# Entrées
############################################
locals {
  eic_subnet_ids = [
    module.vpc_app.private_subnets_ids[0],
    module.vpc_onprem.private_subnets_ids[0],
  ]
}

# Récupérer le VPC de chaque subnet
data "aws_subnet" "eic" {
  for_each = { for sid in local.eic_subnet_ids : sid => sid }
  id       = each.value
}

# Ensemble des VPC uniques correspondants aux subnets
locals {
  eic_vpc_ids = toset([for s in data.aws_subnet.eic : s.vpc_id])
}

############################################
# SG par VPC (un SG pour chaque VPC touché)
############################################
resource "aws_security_group" "eic_sg" {
  for_each    = { for id in local.eic_vpc_ids : id => id }
  name        = "eic-endpoint-sg-${each.key}"
  description = "Egress SSH from EIC endpoint to instances"
  vpc_id      = each.key

  # Pas d'ingress requis pour un endpoint EIC
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # tu peux restreindre vers les CIDR de tes VPC
  }

  tags = {
    Name = "eic-endpoint-sg-${each.key}"
  }
}

############################################
# EIC par subnet, associé au SG du bon VPC
############################################
resource "aws_ec2_instance_connect_endpoint" "eic" {
  for_each  = { for sid in local.eic_subnet_ids : sid => sid }
  subnet_id = each.value

  # Prend le SG correspondant au VPC du subnet
  security_group_ids = [
    aws_security_group.eic_sg[data.aws_subnet.eic[each.key].vpc_id].id
  ]

  tags = {
    Name = "eic-${var.eic_name}-${each.key}"
  }
}
