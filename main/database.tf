module "database" {
  source        = "../modules/database"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3a.small"
  identifier = "lab-db"
  db_subnet_ids = module.network.vpc_db_private_subnets_ids
  db_username = "admin"
  db_name = "demo"
  db_password = var.db_password
  vpc_backend_cidr = module.network.vpc_app_cidr_block
}