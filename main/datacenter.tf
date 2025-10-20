module "datacenter" {
  source           = "../modules/onprem"
  vpc_id = module.network.vpc_onprem_id
  router_subnet_id = module.network.vpc_onprem_public_subnets_ids[0]
}