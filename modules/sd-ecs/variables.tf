variable "cluster_name" {
  description = "Name of the ECS cluster"
}

variable "task_family" {
  description = "Family of the ECS task definition"
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
}

variable "task_memory" {
  description = "Memory for the ECS task in MiB"
}

variable "container_name" {
  description = "Name of the container"
}

variable "container_image" {
  description = "URL of the container image"
}

variable "container_cpu" {
  description = "CPU units for the container"
}

variable "container_memory" {
  description = "Memory for the container in MiB"
}

variable "container_port" {
  description = "Port for the container"
}

variable "service_name" {
  description = "Name of the ECS service"
}

variable "task_desired_count" {
  description = "Desired number of tasks"
}

variable "target_group_arn" {
  description = "ARN of the target group for the ECS service"
}

variable "autoscaling_group_arn" {
  description = "ARN of the target group for the ECS service"
}

variable "excu_role" {
  description = "Excelusion role"
}
