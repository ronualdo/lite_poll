resource "aws_security_group" "loadbalancer" {
  description = "security_group_alb"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  name = "security_group_alb"

  tags = {
    Env  = "production"
    Name = "security-group--alb"
  }

  vpc_id = var.vpc_id
}

resource "aws_alb" "default" {
  name            = "alb"
  security_groups = [aws_security_group.loadbalancer.id]

  subnets = var.subnets_ids
}

resource "aws_alb_target_group" "default" {
  health_check {
    path = "/health_check"
  }

  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  vpc_id = var.vpc_id
}

resource "aws_alb_listener" "default" {
  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type             = "forward"
  }

  load_balancer_arn = aws_alb.default.arn
  port              = 80
  protocol          = "HTTP"
}
