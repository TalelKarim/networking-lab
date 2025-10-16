# modules/compute/asg.tf




locals {
  is_web = lower(var.name) == "web"

  # user-data pour WEB
  web_ud = templatefile("${path.module}/templates/user_data_web.tpl", {
    app_endpoint = var.web_app_endpoint # IP/DNS privé du backend
    app_port     = var.web_app_port
    scheme       = var.web_backend_scheme
  })

  # user-data pour APP
  app_ud = templatefile("${path.module}/templates/user_data_app.tpl", {
    rds_endpoint = var.app_rds_endpoint
    db_name      = var.app_db_name
    db_user      = var.app_db_user
    db_password  = var.app_db_password
    listen_port  = var.app_listen_port
  })
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.lab.key_name

  update_default_version = true




  # Apply the instance‐SG you defined earlier
  vpc_security_group_ids = [
    aws_security_group.instance_sg.id
  ]

  user_data = base64encode(local.is_web ? local.web_ud : local.app_ud)


  # Optional: pass user_data, tags, etc.
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-lt"
      Role = var.name
    }
  }
}


resource "aws_autoscaling_group" "asg" {
  name_prefix         = "${var.name}-asg-"
  vpc_zone_identifier = var.subnet_ids

  desired_capacity = var.desired_capacity
  min_size         = var.min_capacity
  max_size         = var.max_capacity

  # ELB Health Checks Base

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 0    # garde au moins 90% de capacité healthy
      skip_matching          = true # ne remplace pas les instances déjà conformes au dernier LT
    }

    triggers = ["launch_template"] # déclenche sur changement de LT (version)
  }

  # on référence conditionnellement l’ARN du TG adapté
  target_group_arns = compact([
    var.lb_type == "application" ? aws_lb_target_group.alb_tg[0].arn : null,
    var.lb_type == "network" ? aws_lb.nlb[0].arn : null,
    var.lb_type == "gateway" ? aws_lb.gwlb[0].arn : null,
  ])

  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }
}



