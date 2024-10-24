resource "aws_launch_template" "sd_lt" {
  name          = var.launch_template_name
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  iam_instance_profile {
     arn = var.iam_inst_profile_arn
  }


  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.security_group_id]
  }
  user_data = filebase64("${path.module}/user_data.sh")
  #user_data = filebase64(var.user_data_file) para usarlo con la variable
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_autoscaling_group" "sd_asg" {
  name                      = var.autoscaling_group_name
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = var.private_subnets
  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.sd_lt.id
    version = "$Latest"
  }
  #target_group_arns = [var.target_group_arn]
  
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

