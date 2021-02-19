# Serverless website

Hosting a website in a private S3 bucket fronted by API Gateway.

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
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [aws_s3_bucket_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| assets | Website files as a map filename=>path | `map(string)` | `{}` | no |
| extra\_tags | Extra tags to assign to resources | `map(string)` | `{}` | no |

## Outputs

