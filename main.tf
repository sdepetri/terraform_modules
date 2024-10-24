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
# ECS Module
module "sd_asg" {
  source                 = "./modules/autoscaling"
  launch_template_name   = "sd_launch_template"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  security_group_id      = aws_security_group.sd_ec2_sg.id 
  user_data_file         = "${path.module}/user_data.sh"
  autoscaling_group_name = "sd_asg"
  private_subnets        = [data.aws_subnet.private_subnet_1.id, data.aws_subnet.private_subnet_2.id]
  # variables para mi task definition
  


  # Variables para el Auto Scaling
  min_size               = var.asg_min_size
  desired_capacity       = var.asg_desired_capacity
  max_size               = var.asg_max_size
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

# ECS Module
module "sd_ecs" {
  source                = "./modules/sd-ecs"
  cluster_name          = var.cluster_name
  task_family           = var.task_family
  container_name        = var.container_name
  container_image       = var.container_image  #la cambie a/sd-pipeline-test:latest"
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  container_cpu         = var.container_cpu
  container_memory      = var.container_memory
  container_port        = var.container_port
  service_name          = var.service_name
  task_desired_count    = var.task_desired_count
  target_group_arn      = var.target_group_arn
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