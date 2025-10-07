output "rds_database_endpoint" {
  value = module.db.db_instance_endpoint	
  description = "The endpoint used to connect to the database simply :)"
}