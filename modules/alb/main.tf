resource "aws_lb" "sd_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "sd_tg" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.sd_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.sd_tg.arn
  }
}
