resource "aws_ecs_cluster" "sd_cluster" {
  name = var.cluster_name


}

resource "aws_ecs_task_definition" "sd_task" {
  family                   = var.task_family
  execution_role_arn       = var.excu_role
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
    target_group_arn = var.target_group_arn #here is the atachment problem 
    container_name   = var.container_name
    container_port   = var.container_port
  }

  #depends_on = [aws_ecs_task_definition.sd_task] #if its necesary used, uncomment
}

resource "aws_ecs_capacity_provider" "sd_cap_prov" {
  name = "sd_cap_prov"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.autoscaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 1
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.sd_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.sd_cap_prov.name]

}