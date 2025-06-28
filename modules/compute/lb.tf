#  modules/compute/main.tf

# Security Group pour le LB (ALB/NLB/GWLB)
resource "aws_security_group" "lb_sg" {
  count       = var.lb_type == "none" ? 0 : 1
  name        = "${var.name}-lb-sg"
  description = "SG du ${var.lb_type} LB pour ${var.name}"
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

  # Sur un NLB ou GWLB, l’ELB gère le SG ; sur ALB, c’est ok aussi.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-lb-sg"
    Role = var.name
  }
}



# ALB
resource "aws_lb" "alb" {
  count              = var.lb_type == "application" ? 1 : 0
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.lb_sg[*].id
  subnets            = var.subnet_ids

  tags = { Name = "${var.name}-alb" }
}

# NLB
resource "aws_lb" "nlb" {
  count              = var.lb_type == "network" ? 1 : 0
  name               = "${var.name}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = { Name = "${var.name}-nlb" }
}

# GWLB
resource "aws_lb" "gwlb" {
  count              = var.lb_type == "gateway" ? 1 : 0
  name               = "${var.name}-gwlb"
  internal           = false
  load_balancer_type = "gateway"
  subnets            = var.subnet_ids

  tags = { Name = "${var.name}-gwlb" }
}
#################################
# 5) Target Group & Listener ALB
#################################

resource "aws_lb_target_group" "alb_tg" {
  count    = var.lb_type == "application" ? 1 : 0
  name     = "${var.name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    port                = "traffic-port"
  }

  tags = {
    Name = "${var.name}-alb-tg"
  }
}

resource "aws_lb_listener" "alb_http" {
  count             = var.lb_type == "application" ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg[0].arn
  }
}


#################################
# 6) Target Group & Listener NLB
#################################

resource "aws_lb_target_group" "nlb_tg" {
  count       = var.lb_type == "network" ? 1 : 0
  name        = "${var.name}-nlb-tg"
  port        = 500   # exemple pour UDP 500
  protocol    = "UDP" # protocole UDP
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol            = "TCP" # NLB ne supporte que TCP pour health-check
    port                = "500"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
  }

  tags = {
    Name = "${var.name}-nlb-tg"
  }
}

resource "aws_lb_listener" "nlb_udp" {
  count             = var.lb_type == "network" ? 1 : 0
  load_balancer_arn = aws_lb.nlb[0].arn
  port              = 500
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg[0].arn
  }
}


#################################
# 7) Target Group & Listener GWLB
#################################

resource "aws_lb_target_group" "gwlb_tg" {
  count       = var.lb_type == "gateway" ? 1 : 0
  name        = "${var.name}-gwlb-tg"
  port        = 6081 # port GENEVE par défaut
  protocol    = "GENEVE"
  vpc_id      = var.vpc_id
  target_type = "ip" # on envoie vers l’IP des appliances

  # pas de health_check, GWLB n’en supporte pas
  tags = {
    Name = "${var.name}-gwlb-tg"
  }
}

resource "aws_lb_listener" "gwlb" {
  count             = var.lb_type == "gateway" ? 1 : 0
  load_balancer_arn = aws_lb.gwlb[0].arn
  port              = 6081
  protocol          = "GENEVE"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_tg[0].arn
  }
}
