


module "compute_web" {
  source             = "../modules/compute"
  name               = "web"
  lb_type            = "application"
  vpc_id             = module.network.vpc_web_id
  subnet_ids         = module.network.vpc_web_public_subnets_ids
  ami_id             = data.aws_ami.amzn2.id
  instance_type      = var.general_instance_type
  web_app_port       = 80
  web_backend_scheme = "http"
  web_app_endpoint   = module.compute_app.alb_dns_name

  frontend_cert_arn = aws_acm_certificate.web.arn
  app_listen_port   = 80
  count_per_az      = 1
  open_ports = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = -1, to_port = -1, protocol = "icmp", cidr_blocks = ["0.0.0.0/0"] }

  ]
  ssh_allowed_cidrs = var.ssh_allowed_cidrs

  depends_on = [aws_acm_certificate_validation.web]

}



module "compute_app" {
  source           = "../modules/compute"
  name             = "app"
  instance_type    = var.general_instance_type
  count_per_az     = 1
  vpc_id           = module.network.vpc_app_id
  app_db_user      = var.db_user
  app_db_name      = var.db_name
  app_db_password  = var.db_password
  web_app_port     = 80
  app_rds_endpoint = module.database.rds_database_endpoint
  web_app_endpoint = module.compute_app.alb_dns_name
  app_listen_port  = 80
  lb_type          = "application"
  subnet_ids       = module.network.vpc_app_private_subnets_ids
  ami_id           = data.aws_ami.amzn2.id
  open_ports = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = [module.network.vpc_web_cidr_block] },
    { from_port = -1, to_port = -1, protocol = "icmp", cidr_blocks = ["0.0.0.0/0"] }

  ]
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
}


# EC2 pour StrongSwan dans le VPC-Shared
module "compute_strongswan" {
  source        = "../modules/compute"
  name          = "strongswan"
  vpc_id        = module.network.vpc_onprem_id
  subnet_ids    = module.network.vpc_onprem_private_subnets_ids
  ami_id        = data.aws_ami.amzn2.id
  instance_type = var.general_instance_type
  count_per_az  = 1

  # Ports nécessaires pour IPsec / IKEv2
  open_ports = [
    # IKE (ISAKMP)
    { from_port = 500, to_port = 500, protocol = "udp", cidr_blocks = ["0.0.0.0/0"] },
    # NAT-T
    { from_port = 4500, to_port = 4500, protocol = "udp", cidr_blocks = ["0.0.0.0/0"] },

    { from_port = -1, to_port = -1, protocol = "icmp", cidr_blocks = ["0.0.0.0/0"] },

  ]

  # SSH depuis votre poste d’administration
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
}











