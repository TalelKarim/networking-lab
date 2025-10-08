# 1) Security group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "${var.name} alb tier security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.open_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb-sg"
    Role = var.name
  }
}

# 2) Security group for the EC2 instances
resource "aws_security_group" "instance_sg" {
  name        = "${var.name}-inst-sg"
  description = "${var.name} instance SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-inst-sg"
    Role = var.name
  }
}

# Allow HTTP from the ALB SG
resource "aws_security_group_rule" "allow_alb" {
  description              = "Allow HTTP from the ALB"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.instance_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}

# Allow SSH from your office
resource "aws_security_group_rule" "allow_ssh" {
  description       = "Allow SSH from office"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.instance_sg.id
  cidr_blocks       = var.ssh_allowed_cidrs
}

resource "aws_security_group_rule" "allow_icmp_from_anywhere" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.instance_sg.id
  cidr_blocks       = ["0.0.0.0/0"]

}



# Allow all outbound traffic
resource "aws_security_group_rule" "egress_all" {
  description       = "Allow all outbound"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.instance_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}