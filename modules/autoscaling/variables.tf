variable "launch_template_name" {
  description = "Name of the Launch Template"
}

variable "ami_id" {
  description = "AMI ID for the instances"
}

variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling Group"
}

variable "security_group_id" {
  description = "Security Group ID for the instances"
}

variable "user_data_file" {
  description = "Path to the user data file"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
}

variable "private_subnets" {
  description = "List of private subnets for the Auto Scaling Group"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
}

variable "target_group_arn" {
  description = "Name of the Target Group"
}