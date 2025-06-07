module "tgw" {
  source                          = "../modules/transit_gateway"
  name                            = "transit_gateway_vpc_lab"
  amazon_side_asn                 = 64512
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "disable"
}
