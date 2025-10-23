module "site_site_vpn" {
  source              = "../modules/site-site-vpn"
  openswan_ip_address = module.datacenter.eip_openswan_static
  transit_gateway_id  = module.network.transit_gateway_id
}