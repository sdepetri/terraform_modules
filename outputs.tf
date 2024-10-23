output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.sd_ecs.cluster_name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = module.sd_ecs.service_name
}

output "website_url" {
  description = "Website URL"
  value       = "https://${var.domain_name}"
}
output "https_listener_arn" {
  description = "ARN of the HTTPS listener from the ALB module"
  value       = module.alb.https_listener_arn
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = module.sd_ecs.task_definition_arn
}