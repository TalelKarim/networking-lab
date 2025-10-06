module "database" {
  source           = "../modules/database"
  engine           = "mysql"
  engine_version   = "8.0"
  instance_class   = "db.t3a.small"
  identifier       = "lab-db"
  db_subnet_ids    = ["subnet-016a7ee7df61bd29f","subnet-0e1205b2483bf695f" ]
  db_username      = "admin"
  db_name          = "demo"
  vpc_db_id        = module.network.vpc_db_id
  db_password      = var.db_password
  vpc_backend_cidr = module.network.vpc_app_cidr_block
}