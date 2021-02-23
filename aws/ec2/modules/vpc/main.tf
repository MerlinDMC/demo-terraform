/**
 * # VPC for EC2 resources
 *
 * - VPC and routing tables
 * - Multi-tier networking based on /24 subnets
 * - Internet Gateway to allow public networks egress internet access
 * - NAT Gateways to allow private networks egress internet access
 *
 * This configuration is missing lower level security features like NACL for simplicity.
 */

variable "extra_tags" {
  description = "Extra tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "cidr" {
  description = <<EOF
CIDR range used by the VPC.
Should be at least a /16 to fit multiple /24 networks
EOF

  type    = string
  default = "10.1.0.0/16"

  validation {
    condition     = tonumber(regex("\\/(\\d+)$", var.cidr)[0]) <= 16
    error_message = "The given CIDR range should be at least of size /16."
  }
}

variable "name" {
  description = "Name for the VPC"
  type        = string
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.extra_tags,
    {
      Name = "${var.name} VPC"
    }
  )
}

output "name" {
  description = "The VPC name"
  value       = var.name
}

output "id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "cidr_block" {
  description = "The VPC CIDR range"
  value       = aws_vpc.main.cidr_block
}

variable "domain_name_servers" {
  type    = list(string)
  default = ["AmazonProvidedDNS"]
}

data "aws_region" "current" {
}

output "region" {
  description = "The VPC region"
  value       = data.aws_region.current.name
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = var.domain_name_servers

  tags = merge(var.extra_tags,
    {
      Name = "${var.name} DHCP Options"
    }
  )
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

variable "availability_zones" {
  description = "The availability zones to use for the VPC and it's resources"
  type        = set(string)
}

output "availability_zones" {
  description = "Availability zones in use by this VPC configuration"
  value       = var.availability_zones
}
