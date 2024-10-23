# module "alb" {
#   source = "./alb"

#   alb_name          = var.alb_name
#   security_group_id = aws_security_group.alb_sg.id
#   public_subnets    = module.network.public_subnets
#   vpc_id            = module.network.vpc_id
#   target_group_name = "sd-target-group"
# }

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

  depends_on = [
    aws_lb_listener.http_listener,
    aws_lb_target_group.sd_tg
  ]

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "sd-container"
    container_port   = 80
  }
  #   depends_on = [
  #   module.alb
  # ]
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