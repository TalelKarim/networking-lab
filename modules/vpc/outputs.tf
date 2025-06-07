output "vpc_id" {
  description = "The ID of the created vpc"
  value       = module.vpc.vpc_id
}


output "public_subnets_ids" {
  description = "The list of ids of public subnets in the vpc"
  value = module.vpc.public_subnets
}

output "private_subnets_ids" {
  description = "The list of ids of private subnets in the vpc"
  value = module.vpc.private_subnets
}