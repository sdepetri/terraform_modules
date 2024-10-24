resource "aws_lb" "sd_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "sd_tg" {
  name     = "sd-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id


  health_check {
    interval            = 30
    path                = "/"
    timeout             = 25
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.sd_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sd_tg.arn
  }
}

# Listener HTTPS agregado aqui, antes lo tenia en el main raiz
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.sd_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sd_tg.arn
  }
}