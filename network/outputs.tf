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