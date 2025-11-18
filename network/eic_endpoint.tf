############################################
# Entrées stables (clés connues au plan)
############################################
locals {
  # Clés statiques -> valeurs (IDs peuvent être inconnus au plan)
  eic_subnets = {
    app    = module.vpc_app.private_subnets_ids[0]
    onprem = module.vpc_onprem.private_subnets_ids[0]
  }
}

############################################
# Lookup des subnets (pour récupérer le VPC)
############################################
data "aws_subnet" "eic" {
  for_each = local.eic_subnets   # clés stables: app, onprem
  id       = each.value          # valeur = subnet id (peut être inconnue au plan)
}

############################################
# 1 Security Group par endpoint (par clé)
############################################
resource "aws_security_group" "eic_sg" {
  for_each    = local.eic_subnets

  name        = "eic-endpoint-sg-${var.eic_name}-${each.key}"
  description = "Egress SSH from EIC endpoint to instances"
  vpc_id      = data.aws_subnet.eic[each.key].vpc_id

  # Pas d'ingress requis pour un EIC
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ajuste si besoin
  }

  tags = {
    Name = "eic-endpoint-sg-${var.eic_name}-${each.key}"
  }
}

############################################
# 1 EIC par subnet, relié à son SG correspondant
############################################
resource "aws_ec2_instance_connect_endpoint" "eic" {
  for_each  = local.eic_subnets

  subnet_id          = each.value
  security_group_ids = [aws_security_group.eic_sg[each.key].id]

  tags = {
    Name = "eic-${var.eic_name}-${each.key}"
  }
}
