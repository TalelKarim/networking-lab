# Security Group pour la base de données RDS
resource "aws_security_group" "db_sg" {
  name        = "rds-db-sg"
  description = "Allow DB access from App VPC"
  vpc_id      = var.vpc_db_id # VPC de la base de données

  tags = {
    Name        = "rds-db-sg"
    Environment = "lab"
  }
}

# Autoriser MySQL depuis le CIDR du VPC App
resource "aws_security_group_rule" "allow_mysql_from_app_vpc" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.vpc_backend_cidr # autoriser tout le VPC app
  security_group_id = aws_security_group.db_sg.id
  description       = "Allow MySQL traffic from App VPC"
}


resource "aws_security_group_rule" "allow_mysql_from_talel_laptop_lmn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = "131.229.150.44/32" # autoriser tout le VPC app
  security_group_id = aws_security_group.db_sg.id
  description       = "Allow MySQL traffic from Talel's Laptop"
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
