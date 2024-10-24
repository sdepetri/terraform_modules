output "asg_name" {
  description = "Name of the created Auto Scaling Group"
  value       = aws_autoscaling_group.sd_asg.name
}

output "asg_arn" {
  description = "ARN of the created Auto Scaling Group"
  value       = aws_autoscaling_group.sd_asg.arn
}

output "launch_template_id" {
  description = "ID of the created Launch Template"
  value       = aws_launch_template.sd_lt.id
}

# variable "user_data_file" {
#   description = "Path to the user data file"
#   type        = string
# }