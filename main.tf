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

# Network Module
module "network" {
  source = "./modules/network"
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  alb_name          = var.alb_name
  certificate_arn   = data.aws_acm_certificate.sd-certificate.arn
  security_group_id = aws_security_group.sd_alb_sg.id
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
module "sd_ecs" {
  source            = "./modules/sd-ecs"
  cluster_name      = "sd-cluster"
  task_family       = "sd-task"
  container_name    = "sd-container"
  image_url         = "253490770873.dkr.ecr.us-east-2.amazonaws.com/internship/sd-registry-test:V3.0"
  task_cpu          = 512
  task_memory       = 512
  container_cpu     = 64
  container_memory  = 128
  container_port    = 80
  service_name      = "sd-service"
  desired_count     = 2
  target_group_arn  = module.alb.target_group_arn
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