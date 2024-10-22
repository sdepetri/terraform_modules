variable "alb_name" {
  description = "Name of application Load Balancer"
  default     = "sd_alb"
}

variable "asg_name" {
  description = "Name of Auto Scaling Group"
  default     = "sd_asg"
}

variable "target_group_name" {
  description = "Name of Target Group"
  default     = "sd_tg"
}

variable "instance_type" {
  description = "Instance tipe EC2 para ECS"
  default     = "t2.micro"
}

#el variables.tfvars tiene
# alb_name         = "sd_alb"
# asg_name         = "sd_asg"
# target_group_name = "sd_tg"
# instance_type    = "t2.micro"