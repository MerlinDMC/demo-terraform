# VPC for EC2 resources

- VPC and routing tables
- Multi-tier networking based on /24 subnets
- Internet Gateway to allow public networks egress internet access
- NAT Gateways to allow private networks egress internet access

This configuration is missing lower level security features like NACL for simplicity.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) |
| [aws_vpc_dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) |
| [aws_vpc_dhcp_options_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | The availability zones to use for the VPC and it's resources | `set(string)` | n/a | yes |
| cidr | CIDR range used by the VPC.<br>Should be at least a /16 to fit multiple /24 networks | `string` | `"10.1.0.0/16"` | no |
| domain\_name\_servers | n/a | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| extra\_tags | Extra tags to assign to resources | `map(string)` | `{}` | no |
| name | Name for the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| availability\_zones | Availability zones in use by this VPC configuration |
| cidr\_block | The VPC CIDR range |
| id | The VPC ID |
| name | The VPC name |
| region | The VPC region |
| subnets\_private | n/a |
