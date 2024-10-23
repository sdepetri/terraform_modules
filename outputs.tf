output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = module.ecs.service_name
}

output "website_url" {
  description = "Website URL"
  value       = "https://${var.domain_name}"
}