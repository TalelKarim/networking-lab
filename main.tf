module "vpc_web" {
  source               = "./modules/vpc"
  vpc_name             = "vpc-web"
  vpc_cidr             = "10.0.1.0/24"
  is_public            = true
  availability_zones   = ["eu-west-1a", "eu-west-1b"]
  public_subnets_cidrs = ["10.0.1.0/25", "10.0.1.128/25"]
}

module "vpc_app" {
  source                = "./modules/vpc"
  vpc_name              = "vpc-app"
  vpc_cidr              = "10.0.2.0/24"
  is_public             = true
  is_private            = true
  availability_zones    = ["eu-west-1a", "eu-west-1b"]
  public_subnets_cidrs  = ["10.0.2.192/26"]
  private_subnets_cidrs = ["10.0.2.0/25", "10.0.2.128/25"]
  enable_nat_gateway    = true
}


