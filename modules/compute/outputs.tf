output "alb_dns_name" {
  description = "DNS endpoint du load balancer (si lb_type = application)"
  value       = try(aws_lb.alb[0].dns_name, null)
}

output "alb_zone_id" {
  value       = try(aws_lb.alb[0].zone_id, null)
}


output "alb_arn" {
  description = "ARN du load balancer (si lb_type = application)"
  value       = try(aws_lb.alb[0].arn, null)
}

output "alb_target_group_arn" {
  description = "ARN du target group associé à l'ALB"
  value       = try(aws_lb_target_group.alb_tg[0].arn, null)
}