# Terraform demonstration

A small Terraform configuration that will deploy a simple website to AWS and make it available via HTTPS.

## Requirements

In order to run this configuration you need AWS IAM credentials with enough access privileges to manage the resources.  
An account in the Free Tier is sufficient.

The credentials can be exported directly into the environment like:

```shell
export AWS_ACCESS_KEY_ID=<access key id>
export AWS_SECRET_ACCESS_KEY=<secret access key>
export AWS_REGION=<region to operate agains>
```

Alternatively a named profile can be configured using the awscli tools and stored in `~/.aws/credentials`. [Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)

To enable this new profile for the current shell session:

```shell
export AWS_PROFILE=<profile name>
export AWS_REGION=<region to operate agains>
```

## Usage

```shell
terraform init
terraform apply
```

This configuration will create a serverless deployment for the website stored in `./app` and make it available via HTTPS.  
The URL will be part of the Terraform outputs and should be available right after the creation does finish.

## Cleanup

After you're done the whole setup can be cleaned up by running a `destroy` using Terraform:

```shell
terraform destroy
```

## Requirements

No requirements.

## Providers

No provider.

## Modules

| Name | Source | Version |
|------|--------|---------|
| serverless | ./aws/serverless |  |

## Resources

No resources.

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| serverless\_url | Serverless deployment |
