module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                     = var.availability_zones
  public_subnets          = var.is_public ? var.public_subnets_cidrs : []
  private_subnets         = var.is_private ? var.private_subnets_cidrs : []
  intra_subnets           = var.is_tgw ? var.intra_subnets_cidrs : []
  map_public_ip_on_launch = true
  enable_nat_gateway      = var.enable_nat_gateway
  enable_vpn_gateway      = var.enable_vpn_gateway

  
  tags = {
    Terraform   = "true"
    Environment = "lab"
    Role        = var.role
  }
}
