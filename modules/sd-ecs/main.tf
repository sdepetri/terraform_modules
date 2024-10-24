resource "aws_ecs_cluster" "sd_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "sd_task" {
  family                   = var.task_family
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "sd_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.sd_cluster.id
  task_definition = aws_ecs_task_definition.sd_task.arn
  desired_count   = var.task_desired_count
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.sd_tg #here is the atachment problem 
    container_name   = var.container_name
    container_port   = var.container_port
  }

  #depends_on = [aws_ecs_task_definition.sd_task] #if its necesary used, uncomment
}

resource "aws_lb_target_group" "sd_tg" {
  name     = "sd-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.internship_vpc.id

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
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