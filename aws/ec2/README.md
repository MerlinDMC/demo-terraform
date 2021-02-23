# Website on EC2

Hosting a website in a private VPC using EC2 instances and a load balancer.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc | ./modules/vpc |  |

## Resources

| Name |
|------|
| [aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| assets | Website files as a map filename=>path | `map(string)` | `{}` | no |
| availability\_zones\_count | Number of availability zones to fan out into | `number` | `2` | no |
| extra\_tags | Extra tags to assign to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
