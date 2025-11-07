locals {
  eic_subnet_ids = [module.vpc_app.private_subnets_ids[0], module.vpc_onprem.private_subnets_ids[0]]
}


resource "aws_ec2_instance_connect_endpoint" "eic" {
  for_each           = toset(local.eic_subnet_ids)
  subnet_id          = each.value # subnet où placer l’ENI
  security_group_ids = [aws_security_group.eic_sg.id]

  tags = {
    Name = "eic-${var.eic_name}-${each.key}"
  }
}

# SG de l’endpoint (sortie vers les instances en SSH)
resource "aws_security_group" "eic_sg" {
  name        = "eic-endpoint-sg-${var.eic_name}"
  description = "Egress SSH from EIC endpoint to instances"
  vpc_id      = module.vpc_app.vpc_id
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ou restreins au CIDR de ton VPC
  }

  # pas d’ingress nécessaire: c’est un endpoint managé
  tags = { Name = "eic-endpoint-sg-${var.eic_name}" }
}