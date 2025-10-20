module "tgw_web_attachment" {
  source               = "../modules/tgw_attachment"
  tgw_attachement_name = "vpc-web-tgw-attachement"
  transit_gateway_id   = module.tgw.transit_gateway_id
  subnet_ids           = module.vpc_web.intra_subnets_ids
  vpc_id               = module.vpc_web.vpc_id
}



module "tgw_app_attachment" {
  source               = "../modules/tgw_attachment"
  tgw_attachement_name = "vpc-app-tgw-attachement"
  transit_gateway_id   = module.tgw.transit_gateway_id
  subnet_ids           = module.vpc_app.intra_subnets_ids
  vpc_id               = module.vpc_app.vpc_id
}



module "tgw_db_attachment" {
  source               = "../modules/tgw_attachment"
  tgw_attachement_name = "vpc-db-tgw-attachment"
  transit_gateway_id   = module.tgw.transit_gateway_id
  vpc_id               = module.vpc_db.vpc_id

  # Les deux subnets privés du VPC-DB
  subnet_ids = module.vpc_db.intra_subnets_ids

}





module "tgw_shared_attachment" {
  source               = "../modules/tgw_attachment"
  tgw_attachement_name = "vpc-shared-tgw-attachment"
  transit_gateway_id   = module.tgw.transit_gateway_id
  vpc_id               = module.vpc_shared.vpc_id

  subnet_ids = module.vpc_shared.intra_subnets_ids

}



# module "tgw_onprem_attachment" {
#   source               = "../modules/tgw_attachment"
#   tgw_attachement_name = "vpc-onprem-tgw-attachment"
#   transit_gateway_id   = module.tgw.transit_gateway_id
#   vpc_id               = module.vpc_onprem.vpc_id

#   # Les deux subnets privés du VPC-DB
#   subnet_ids = module.vpc_onprem.intra_subnets_ids

# }