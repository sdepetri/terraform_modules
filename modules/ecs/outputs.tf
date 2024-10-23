output "cluster_id" {
  description = "ID of the created ECS cluster"
  value       = aws_ecs_cluster.sd_cluster.id
}

output "cluster_name" {
  description = "Name of the created ECS cluster"
  value       = aws_ecs_cluster.sd_cluster.name
}

output "service_name" {
  description = "Name of the created ECS service"
  value       = aws_ecs_service.sd_service.name
}

output "task_definition_arn" {
  description = "ARN of the created task definition"
  value       = aws_ecs_task_definition.sd_task.arn
}