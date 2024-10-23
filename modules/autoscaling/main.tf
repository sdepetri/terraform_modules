resource "aws_launch_template" "sd_lt" {
  name          = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.security_group_id]
  }

  user_data = file(var.user_data_file)
}

resource "aws_autoscaling_group" "sd_asg" {
  name                = var.autoscaling_group_name
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  vpc_zone_identifier = var.private_subnets
  health_check_type = "EC2"
  health_check_grace_period = 60
  launch_template {
    id      = aws_launch_template.sd_lt.id
    version = "$Latest"
  }
}
