variable "alb_name" {
  description = "Name of the Application Load Balancer"
}

variable "security_group_id" {
  description = "Security Group ID for the ALB"
}

variable "public_subnets" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}

variable "target_group_name" {
  description = "Name of the Target Group"
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for the HTTPS listener"
}