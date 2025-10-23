module "datacenter" {
  source                   = "../modules/onprem"
  vpc_id                   = module.network.vpc_onprem_id
  router_subnet_id         = module.network.vpc_onprem_public_subnets_ids[0]
  ami_id_openswan          = data.aws_ami.amzn2.id
  vpc_web_cidr             = module.network.vpc_web_cidr_block
  vpc_app_cidr             = module.network.vpc_app_cidr_block
  vpc_db_cidr              = module.network.vpc_db_cidr_block
  onprem_private_subnet_id = module.network.vpc_onprem_private_subnets_ids[0]
}