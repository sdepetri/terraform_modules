resource "aws_security_group" "sd_alb_sg" {
  name        = "sd-alb-sg"
  description = "Security group for the ALB"
  vpc_id      = data.aws_vpc.internship_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "sd_ec2_sg" {
  name        = "sd-ec2-sg"
  description = "Security group for ECS instances"
  vpc_id      = data.aws_vpc.internship_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #security_groups = [aws_security_group.sd_alb_sg_alb_sg.id]
    security_groups = [aws_security_group.sd_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}