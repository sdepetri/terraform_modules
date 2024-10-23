resource "aws_ecs_cluster" "sd_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "sd_task" {
  family                   = "sd-task"
  network_mode            = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                     = var.task_cpu
  memory                  = var.task_memory
  execution_role_arn      = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "sd-container"
      image     = var.container_image
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort     = 0
          protocol     = "tcp"
        }
      ]
      environment = [
        {
          name  = "ENV"
          value = "dev"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "sd_service" {
  name            = "sd-service"
  cluster         = aws_ecs_cluster.sd_cluster.id
  task_definition = aws_ecs_task_definition.sd_task.arn
  desired_count   = var.service_desired_count

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "sd-container"
    container_port   = 80
  }

}

# resource "aws_cloudwatch_metric_alarm" "service_cpu" {
#   alarm_name          = "sd-service-cpu-high"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = "2"
#   metric_name        = "CPUUtilization"
#   namespace          = "AWS/ECS"
#   period             = "60"
#   statistic          = "Average"
#   threshold          = "80"
#   alarm_description  = "This metric monitors ECS service CPU utilization"
  
#   dimensions = {
#     ClusterName = aws_ecs_cluster.sd_cluster.name
#     ServiceName = aws_ecs_service.sd_service.name
#   }
# }