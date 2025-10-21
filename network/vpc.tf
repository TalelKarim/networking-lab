module "vpc_web" {
  source             = "../modules/vpc"
  vpc_name           = "vpc-web"
  vpc_cidr           = "10.0.1.0/24"
  is_public          = true
  is_private         = true
  is_tgw             = true
  availability_zones = ["eu-west-1a", "eu-west-1b"]

  private_subnets_cidrs = [
    "10.0.1.0/27",  # 1a
    "10.0.1.32/27", # 1b
  ]
  public_subnets_cidrs = [
    "10.0.1.64/27", # 1a
    "10.0.1.96/27", # 1b
  ]
  intra_subnets_cidrs = [
    "10.0.1.128/27", # 1a
    "10.0.1.160/27", # 1b
  ]

  transit_gateway_id         = module.tgw.transit_gateway_id
  tgw_destination_cidr_block = ["10.0.2.0/24", "10.0.4.0/24", "10.255.0.0/24"]
  flow_log                   = true
  flow_log_group_name        = "/aws/vpc/vpc-web-flow-logs"
  role                       = "frontend-vpc"
  tgw_attachment_dep        =  module.tgw_web_attachment.attachment_id

}


module "vpc_app" {
  source             = "../modules/vpc"
  vpc_name           = "vpc-app"
  vpc_cidr           = "10.0.2.0/24"
  is_public          = true
  is_private         = true
  is_tgw             = true
  availability_zones = ["eu-west-1a", "eu-west-1b"]

  private_subnets_cidrs = [
    "10.0.2.0/27",  # 1a
    "10.0.2.32/27", # 1b
  ]
  public_subnets_cidrs = [
    "10.0.2.64/27", # 1a
    "10.0.2.96/27", # 1b
  ]
  intra_subnets_cidrs = [
    "10.0.2.128/27", # 1a
    "10.0.2.160/27", # 1b
  ]

  transit_gateway_id         = module.tgw.transit_gateway_id
  tgw_destination_cidr_block = ["10.0.1.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway         = true
  flow_log                   = true
  flow_log_group_name        = "/aws/vpc/vpc-app-flow-logs"
  role                       = "Backend-vpc"
  tgw_attachment_dep        =  module.tgw_app_attachment.attachment_id

}



module "vpc_db" {
  source             = "../modules/vpc"
  vpc_name           = "vpc-db"
  vpc_cidr           = "10.0.3.0/24"
  is_public          = false
  is_private         = true
  is_tgw             = true
  availability_zones = ["eu-west-1a", "eu-west-1b"]

  private_subnets_cidrs = [
    "10.0.3.0/27",  # 1a
    "10.0.3.32/27", # 1b
  ]
  intra_subnets_cidrs = [
    "10.0.3.64/27", # 1a
    "10.0.3.96/27", # 1b
  ]

  transit_gateway_id         = module.tgw.transit_gateway_id
  tgw_destination_cidr_block = ["10.0.2.0/24", "10.0.4.0/24"]
  enable_nat_gateway         = false
  role                       = "Database-vpc"
  tgw_attachment_dep        =  module.tgw_db_attachment.attachment_id

}



module "vpc_shared" {
  source             = "../modules/vpc"
  vpc_name           = "vpc-shared"
  vpc_cidr           = "10.0.4.0/24"
  is_public          = false
  is_private         = true
  is_tgw             = true
  availability_zones = ["eu-west-1a", "eu-west-1b"]


  private_subnets_cidrs = [
    "10.0.4.0/27",  # NLB A (1a)
    "10.0.4.64/27", # NLB B (1b)
    "10.0.4.32/27", # GWLB A (1a)
    "10.0.4.96/27", # GWLB B (1b)
  ]

  intra_subnets_cidrs = [
    "10.0.4.128/27", # 1a
    "10.0.4.160/27", # 1b
  ]

  transit_gateway_id         = module.tgw.transit_gateway_id
  tgw_destination_cidr_block = ["10.0.2.0/24", "10.0.3.0/24", "10.0.1.0/24", "10.0.0.0/24"]
  role                       = "Shared-vpc"
  tgw_attachment_dep        =  module.tgw_shared_attachment.attachment_id

}





module "vpc_onprem" {
  source                     = "../modules/vpc"
  vpc_name                   = "vpc-onprem"
  vpc_cidr                   = "10.255.0.0/24"

  is_public                  = true
  public_subnets_cidrs  = ["10.255.0.0/25"]


  is_private                 = true
  private_subnets_cidrs = ["10.255.0.128/25"]


  is_tgw                     = false
  availability_zones         = ["eu-west-1a"] # on peut se contenter d’une AZ
  transit_gateway_id         = module.tgw.transit_gateway_id
  # tgw_destination_cidr_block = ["10.0.1.0/24", "10.0.3.0/24", "10.0.2.0/24", "10.0.4.0/24"]
  enable_nat_gateway         = false
  role                       = "Onprem-vpc"
  tgw_attachment_dep        =  module.tgw_onprem_attachment.attachment_id

}


