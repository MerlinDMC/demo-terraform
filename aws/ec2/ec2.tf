variable "cl_channel" {
  description = "Container Linux release channel"
  type        = string
  default     = "stable"
}

variable "cl_version" {
  description = "Container Linux version (can include wildcards)"
  type        = string
  default     = "*"
}

data "aws_ami" "flatcar" {
  most_recent = true
  owners = [
    "075585003325", # official Flatcar
  ]

  filter {
    name = "name"

    values = [
      "Flatcar-${var.cl_channel}-${var.cl_version}-hvm",
    ]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "instance_type" {
  description = "EC2 instance type (x86_64)"
  type        = string
  default     = "t3a.small"
}

resource "aws_launch_template" "website" {
  name_prefix   = "website-"
  image_id      = data.aws_ami.flatcar.id
  instance_type = var.instance_type
  user_data     = base64encode(data.ignition_config.website.rendered)

  update_default_version = true

  key_name = aws_key_pair.demo.key_name

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.website.arn
  }

  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.lb_binding.id,
    aws_security_group.ssh_access.id,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "website" {
  name_prefix = "website-"

  min_size         = 0
  max_size         = 8
  desired_capacity = 0

  lifecycle {
    ignore_changes = [
      desired_capacity,
    ]
  }

  default_cooldown          = 15
  health_check_grace_period = 30
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.website.id
    version = "$Latest"
  }

  vpc_zone_identifier = module.vpc.subnets_private.*.id

  load_balancers = []
  target_group_arns = [
    aws_lb_target_group.website.id,
  ]

  termination_policies = [
    "OldestInstance",
  ]

  suspended_processes = [
    "AZRebalance",
  ]

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }

    triggers = [
      "tag",
    ]
  }

  tag {
    key                 = "Name"
    value               = "${module.vpc.name} Server"
    propagate_at_launch = true
  }

  tag {
    key                 = "AssetsVersion"
    value               = local.assets_version
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.extra_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
