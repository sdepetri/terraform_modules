data "aws_vpc" "internship_vpc" {
  id = "vpc-01fc1ec68a8b03eb9"
}
data "aws_subnet" "public_subnet_1" {
  id = "subnet-0d4b3436fdda9803f"
}
data "aws_subnet" "public_subnet_2" {
  id = "subnet-09d1848907ea68bca"
}
data "aws_subnet" "private_subnet_1" {
  id = "subnet-0d5a03c63e1d24a17"
}
data "aws_subnet" "private_subnet_2" {
  id = "subnet-00ec5ce7c1e376323"
}
data "aws_nat_gateway" "NG2" {
  subnet_id = data.aws_subnet.public_subnet_2.id
}
data "aws_nat_gateway" "NG1" {
  subnet_id = data.aws_subnet.public_subnet_1.id
}
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.internship_vpc.id]
  }
}
data "aws_route53_zone" "hosted_zone" {
  name = "sdepetri.site."
  # private_zone = false
}

data "aws_acm_certificate" "sd-certificate" {
  domain      = "sdepetri.site"
  statuses    = ["ISSUED"]
  most_recent = true
}




# Auto Scaling Module

module "autoscaling" {
  source = "./modules/autoscaling"

  launch_template_name   = var.launch_template_name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  security_group_id      = aws_security_group.ecs_sg.id # Corregido para usar el security group que creamos
  user_data_file         = var.user_data_file
  autoscaling_group_name = var.asg_name
  private_subnets        = module.network.private_subnets # Usando el output del módulo network
}

# Network Module
module "network" {
  source = "./modules/network"
}

# Security Groups
resource "aws_security_group" "alb_sg" {
  name        = "sd-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "sd-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  alb_name          = var.alb_name
  certificate_arn   = data.aws_acm_certificate.sd-certificate.arn
  security_group_id = aws_security_group.alb_sg.id
  public_subnets    = module.network.public_subnets
  vpc_id            = module.network.vpc_id
  target_group_name = "sd-target-group"
}

# HTTP to HTTPS redirect
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = module.alb.alb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ECS Module
module "sd-ecs" {
  source = "./modules/sd-ecs"

  cluster_name          = var.cluster_name
  container_image       = var.container_image
  execution_role_arn    = var.execution_role_arn
  service_desired_count = var.service_desired_count
  target_group_arn      = module.alb.target_group_arn
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  container_cpu         = var.container_cpu
  container_memory      = var.container_memory
}

# Route53 Record
resource "aws_route53_record" "alb_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    module.alb
  ]
}
# resource "aws_dynamodb_table" "sd_terraform_lock" {
#   name         = "sd_terraform_lock"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }