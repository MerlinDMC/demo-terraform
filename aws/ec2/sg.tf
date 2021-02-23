resource "aws_security_group" "lb_binding" {
  name_prefix = "lb-binding-"
  description = "Allow access between the load balancer and the instance"

  vpc_id = module.vpc.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.extra_tags,
    {
      Name = "LB binding"
    }
  )
}

resource "aws_security_group_rule" "lb_binding_http" {
  type              = "ingress"
  security_group_id = aws_security_group.lb_binding.id
  description       = "Allow HTTP access between load balancer and instance"

  protocol  = "tcp"
  from_port = 80
  to_port   = 80
  self      = true
}

resource "aws_security_group" "ssh_access" {
  name_prefix = "ssh-access-"
  description = "Allow SSH access"

  vpc_id = module.vpc.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.extra_tags,
    {
      Name = "SSH access"
    }
  )
}

resource "aws_security_group_rule" "ssh_access_ingress_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.ssh_access.id
  description       = "Allow SSH access from VPC"

  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = [module.vpc.cidr_block]
}

resource "aws_security_group" "egress" {
  name_prefix = "egress-"
  description = "Allow egress connections"

  vpc_id = module.vpc.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.extra_tags,
    {
      Name = "Egress rules"
    }
  )
}

resource "aws_security_group_rule" "egress_dns_udp" {
  type              = "egress"
  security_group_id = aws_security_group.egress.id
  description       = "Allow DNS queries to the VPC resolver"

  protocol    = "udp"
  from_port   = 53
  to_port     = 53
  cidr_blocks = [module.vpc.cidr_block]
}

resource "aws_security_group_rule" "egress_dns_tcp" {
  type              = "egress"
  security_group_id = aws_security_group.egress.id
  description       = "Allow DNS queries to the VPC resolver"

  protocol    = "tcp"
  from_port   = 53
  to_port     = 53
  cidr_blocks = [module.vpc.cidr_block]
}

resource "aws_security_group_rule" "egress_metadata" {
  type              = "egress"
  security_group_id = aws_security_group.egress.id
  description       = "Allow HTTP requests to the EC2 metadata service"

  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["169.254.169.254/32"]
}

resource "aws_security_group_rule" "egress_https" {
  type              = "egress"
  security_group_id = aws_security_group.egress.id
  description       = "Allow HTTPS egress requests"

  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"] # tfsec:ignore:AWS007
}

data "aws_ip_ranges" "local_s3" {
  regions  = [aws_s3_bucket.ignition.region]
  services = ["s3"]
}

resource "aws_security_group_rule" "egress_s3" {
  type              = "egress"
  security_group_id = aws_security_group.egress.id
  description       = "Allow egress access to port 443 for S3"

  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = data.aws_ip_ranges.local_s3.cidr_blocks
}
