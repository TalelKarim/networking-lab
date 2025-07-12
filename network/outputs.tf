output "vpc_web_id" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_web.vpc_id
}


output "vpc_app_id" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_app.vpc_id
}


output "vpc_db_id" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_db.vpc_id
}


output "vpc_shared_id" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_shared.vpc_id
}


output "vpc_onprem_id" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_onprem.vpc_id
}


output "vpc_web_public_subnets_ids" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_web.public_subnets_ids
}


output "vpc_app_private_subnets_ids" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_app.private_subnets_ids
}


output "vpc_db_private_subnets_ids" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_db.private_subnets_ids
}


output "vpc_shared_private_subnets_ids" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_shared.private_subnets_ids
}


output "vpc_onprem_private_subnets_ids" {
  description = "The ID of the Web Vpc"
  value       = module.vpc_onprem.private_subnets_ids
}


output "vpc_web_cidr_block" {
  description = "Main CIDR block of vpc web"
  value       = module.vpc_web.vpc_cidr_blocks
}

output "vpc_app_cidr_block" {
  description = "Main CIDR block of vpc web"
  value       = module.vpc_app.vpc_cidr_blocks
}
