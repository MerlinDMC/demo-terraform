/**
 * # Website on EC2
 *
 * Hosting a website in a private VPC using EC2 instances and a load balancer.
 */

variable "extra_tags" {
  description = "Extra tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "assets" {
  description = "Website files as a map filename=>path"
  type        = map(string)
  default     = {}
}

output "url" {
  # TODO: retrieve public endpoint URL when available
  value = ""
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "availability_zones_count" {
  description = "Number of availability zones to fan out into"
  type        = number
  default     = 2
}

locals {
  # TODO: remove once assets are being used - this silences the pre-commit hook
  assets = var.assets

  availability_zones = slice(
    data.aws_availability_zones.available.names,
    length(data.aws_availability_zones.available.names) - var.availability_zones_count,
    length(data.aws_availability_zones.available.names),
  )
}

module "vpc" {
  source = "./modules/vpc"

  name               = "Website Demo"
  availability_zones = local.availability_zones

  extra_tags = var.extra_tags
}
