resource "aws_lb" "website" {
  name_prefix = "ws-"

  subnets                          = module.vpc.subnets_public.*.id
  internal                         = false # tfsec:ignore:AWS005
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true

  idle_timeout = 3600

  security_groups = [
    aws_security_group.lb_binding.id,
    aws_security_group.lb_http_access.id,
  ]

  tags = merge(var.extra_tags,
    {
      Name = "Website Application"
    }
  )
}

resource "aws_lb_listener" "apiserver" {
  load_balancer_arn = aws_lb.website.arn
  protocol          = "HTTP" # tfsec:ignore:AWS004
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.website.arn
  }
}

resource "aws_lb_target_group" "website" {
  name_prefix = "ws-"

  vpc_id = module.vpc.id

  target_type          = "instance"
  deregistration_delay = 30

  protocol = "HTTP"
  port     = 80

  health_check {
    protocol = "HTTP"

    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 10
  }
}

resource "aws_security_group" "lb_http_access" {
  name_prefix = "lb-http-access-"
  description = "Allow HTTP access"

  vpc_id = module.vpc.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.extra_tags,
    {
      Name = "LB HTTP access"
    }
  )
}

resource "aws_security_group_rule" "lb_http_access_egress" {
  type              = "egress"
  security_group_id = aws_security_group.lb_http_access.id
  description       = "Allow all egress"

  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

resource "aws_security_group_rule" "lb_http_access_ingress_http" {
  type              = "ingress"
  security_group_id = aws_security_group.lb_http_access.id
  description       = "Allow HTTP access from anywhere"

  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"] # tfsec:ignore:AWS006
}
