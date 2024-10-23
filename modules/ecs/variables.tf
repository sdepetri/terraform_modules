variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "service_desired_count" {
  description = "Desired number of tasks in the service"
  type        = number
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

# Variables adicionales para la task definition
variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the task in MiB"
  type        = number
  default     = 512
}

variable "container_cpu" {
  description = "CPU units for the container"
  type        = number
  default     = 64
}

variable "container_memory" {
  description = "Memory for the container in MiB"
  type        = number
  default     = 128
}