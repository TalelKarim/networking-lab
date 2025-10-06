# Security Group pour la base de données RDS
resource "aws_security_group" "db_sg" {
  name        = "rds-db-sg"
  description = "Allow DB access from App VPC"
  vpc_id      = module.vpc_db.vpc_id  # VPC de la base de données

  tags = {
    Name = "rds-db-sg"
    Environment = "lab"
  }
}

# Autoriser MySQL depuis le CIDR du VPC App
resource "aws_security_group_rule" "allow_mysql_from_app_vpc" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  cidr_blocks              = var.vpc_backend_cidr # autoriser tout le VPC app
  security_group_id        = aws_security_group.db_sg.id
  description              = "Allow MySQL traffic from App VPC"
}

# Autoriser le trafic sortant (vers tout)
resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_sg.id
}
