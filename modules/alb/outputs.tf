output "alb_arn" {
  description = "ARN of the created Application Load Balancer"
  value       = aws_lb.sd_alb.arn
}

output "target_group_arn" {
  description = "ARN of the created Target Group"
  value       = aws_lb_target_group.sd_tg.arn
}

output "alb_dns_name" {
  description = "DNS name of the created Application Load Balancer"
  value       = aws_lb.sd_alb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the created Application Load Balancer"
  value       = aws_lb.sd_alb.zone_id
}