# Website on EC2

Hosting a website in a private VPC using EC2 instances and a load balancer.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| ignition | n/a |
| local | n/a |
| tls | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc | ./modules/vpc |  |

## Resources

| Name |
|------|
| [aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) |
| [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) |
| [aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) |
| [aws_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) |
| [aws_ip_ranges](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ip_ranges) |
| [aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) |
| [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [aws_s3_bucket_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) |
| [ignition_config](https://registry.terraform.io/providers/terraform-providers/ignition/latest/docs/data-sources/config) |
| [ignition_directory](https://registry.terraform.io/providers/terraform-providers/ignition/latest/docs/data-sources/directory) |
| [ignition_file](https://registry.terraform.io/providers/terraform-providers/ignition/latest/docs/data-sources/file) |
| [ignition_systemd_unit](https://registry.terraform.io/providers/terraform-providers/ignition/latest/docs/data-sources/systemd_unit) |
| [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| assets | Website files as a map filename=>path | `map(string)` | `{}` | no |
| availability\_zones\_count | Number of availability zones to fan out into | `number` | `2` | no |
| cl\_channel | Container Linux release channel | `string` | `"stable"` | no |
| cl\_version | Container Linux version (can include wildcards) | `string` | `"*"` | no |
| extra\_tags | Extra tags to assign to resources | `map(string)` | `{}` | no |
| instance\_type | EC2 instance type (x86\_64) | `string` | `"t3a.small"` | no |

## Outputs

| Name | Description |
|------|-------------|
