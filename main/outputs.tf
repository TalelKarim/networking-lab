output "vpc_db_private_subnets_ids" {
  value = module.network.vpc_db_private_subnets_ids
}


output "public_eip" {
  value = module.datacenter.eip_openswan_static
}