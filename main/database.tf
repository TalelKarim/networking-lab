module "database" {
  source           = "../modules/database"
  engine           = "mysql"
  engine_version   = "8.0.42"
  instance_class   = "db.m7i.large"
  identifier       = "lab-db"
  db_subnet_ids    = module.network.vpc_db_private_subnets_ids
  db_username      = "admin"
  db_name          = "demo"
  vpc_db_id        = module.network.vpc_db_id
  db_password      = var.db_password
  vpc_backend_cidr = [module.network.vpc_app_cidr_block]
  family           = "mysql8.0"
}