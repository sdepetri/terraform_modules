output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.sd_service.name
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.sd_cluster.name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.sd_task.arn
}