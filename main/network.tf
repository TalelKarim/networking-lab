module "network" {
  source = "../network"
  vpn_tgw_attachement_id = module.site_site_vpn.vpn_attachment_id
}














