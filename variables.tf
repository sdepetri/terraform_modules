# provider
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# variables para ECR
variable "ecr_registry" {
  type        = string
  description = "URL del registro ECR"
}

variable "ecr_repository" {
  type        = string
  description = "Nombre del repositorio en ECR"
}

# ECS Variables
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "sd-cluster"
}

variable "container_image" {
  description = "Container image URI"
  type        = string
  default     = "253490770873.dkr.ecr.us-east-2.amazonaws.com/internship/sd-registry-test:V3.0"
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
  default     = "arn:aws:iam::253490770873:role/ECSTaskExecutionRoleLab"
}

variable "service_desired_count" {
  description = "Desired number of tasks in the service"
  type        = number
  default     = 2
}

# Auto Scaling Variables
variable "instance_type" {
  description = "EC2 instance type for ECS cluster"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum size of Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum size of Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired capacity of Auto Scaling Group"
  type        = number
  default     = 2
}

# ALB Variables
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "sd-alb"
}

variable "domain_name" {
  description = "Domain name for Route53 record"
  type        = string
  default     = "sdepetri.site"
}

# variables.tf (raíz)
variable "launch_template_name" {
  description = "Name of the Launch Template"
  type        = string
  default     = "sd-launch-template"
}

variable "ami_id" {
  description = "AMI ID for ECS instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Asegúrate de usar una AMI ECS optimizada actual
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = "sd-asg"
}

variable "user_data_file" {
  description = "Path to the user data file"
  type        = string
  default     = "user_data.sh"
}

# variables.tf (raíz)

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