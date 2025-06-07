module "vpc_web" {
  source               = "../modules/vpc"
  vpc_name             = "vpc-web"
  vpc_cidr             = "10.0.1.0/24"
  is_public            = true
  availability_zones   = ["eu-west-1a", "eu-west-1b"]
  public_subnets_cidrs = ["10.0.1.0/25", "10.0.1.128/25"]
  role                 = "frontend-vpc"
}

module "vpc_app" {
  source                = "../modules/vpc"
  vpc_name              = "vpc-app"
  vpc_cidr              = "10.0.2.0/24"
  is_public             = true
  is_private            = true
  availability_zones    = ["eu-west-1a", "eu-west-1b"]
  public_subnets_cidrs  = ["10.0.2.0/26"]
  private_subnets_cidrs = ["10.0.2.64/26", "10.0.2.128/26"]
  enable_nat_gateway    = true
  role                  = "Backend-vpc"
}


module "vpc_db" {
  source                = "../modules/vpc"
  vpc_name              = "vpc-db"
  vpc_cidr              = "10.0.3.0/24"
  is_public             = false
  is_private            = true
  availability_zones    = ["eu-west-1a", "eu-west-1b"]
  public_subnets_cidrs  = []
  private_subnets_cidrs = ["10.0.3.0/25", "10.0.3.128/25"]
  enable_nat_gateway    = false
  role                  = "DAtabase-vpc"
}


module "vpc_shared" {
  source               = "../modules/vpc"
  vpc_name             = "vpc-shared"
  vpc_cidr             = "10.0.4.0/24"
  is_public            = false
  is_private           = true
  availability_zones   = ["eu-west-1a", "eu-west-1b"]
  public_subnets_cidrs = [] # pas de sous-réseaux publics directs
  private_subnets_cidrs = [
    "10.0.4.0/26",   # Subnet-Shared-NLB-AZ-A
    "10.0.4.64/26",  # Subnet-Shared-NLB-AZ-B
    "10.0.4.128/26", # Subnet-Shared-GWLB-AZ-A
    "10.0.4.192/26"  # Subnet-Shared-GWLB-AZ-B
  ]
  role = "Shared-vpc"

}




module "vpc_onprem" {
  source                = "../modules/vpc"
  vpc_name              = "vpc-onprem"
  vpc_cidr              = "10.255.0.0/24"
  is_public             = false
  is_private            = true
  availability_zones    = ["eu-west-1a"] # on peut se contenter d’une AZ
  public_subnets_cidrs  = []
  private_subnets_cidrs = ["10.255.0.0/24"]
  enable_nat_gateway    = false
  role                  = "Onprem-vpc"
}


