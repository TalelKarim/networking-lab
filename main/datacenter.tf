module "datacenter" {
  source                   = "../modules/onprem"
  vpc_id                   = module.network.vpc_onprem_id
  router_subnet_id         = module.network.vpc_onprem_public_subnets_ids[0]
  ami_id_openswan          = data.aws_ami.amzn2.id
  vpc_web_cidr             = module.network.vpc_web_cidr_block
  vpc_app_cidr             = module.network.vpc_app_cidr_block
  vpc_shared_cidr          = module.network.vpc_shared_cidr_block
  onprem_private_subnet_id = module.network.vpc_onprem_private_subnets_ids[0]
  cidrs_to_aws             = [module.network.vpc_web_cidr_block, module.network.vpc_app_cidr_block, module.network.vpc_shared_cidr_block]
  onprem_private_rt_id     = module.network.lan_private_route_table_ids[0]
}