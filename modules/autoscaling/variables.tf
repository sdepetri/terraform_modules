variable "launch_template_name" {
  description = "Name of the Launch Template"
  type = string
}

variable "ami_id" {
  description = "AMI ID for the instances"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling Group"
  type = string
}

variable "security_group_id" {
  description = "Security Group ID for the instances"
  type = string
}

variable "user_data_file" {
  description = "Path to the user data file"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  type = string
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
  description = "ARN of the Target Group"
  type = string
}

variable "iam_inst_profile_arn" {
  description = "Iam instance profile ARN"
  type = string
}