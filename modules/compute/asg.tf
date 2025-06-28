# modules/compute/asg.tf

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.lab.key_name

  # Apply the instance‐SG you defined earlier
  vpc_security_group_ids = [
    aws_security_group.instance_sg.id
  ]

  user_data = filebase64("${path.module}/templates/user_data_gen.tpl")


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

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
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
