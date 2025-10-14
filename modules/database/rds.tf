module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier                  = var.identifier
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = 20
  manage_master_user_password = false
  # DB parameter group
  family = var.family

  # DB option group
  major_engine_version = var.engine_version
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  port                 = 3306

  multi_az = true # ✅ clé cruciale pour activer la réplication multi-AZ

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  subnet_ids             = var.db_subnet_ids

  create_db_subnet_group = true

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  deletion_protection = false
}
