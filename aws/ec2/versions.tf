terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    ignition = {
      source = "terraform-providers/ignition"
    }
    local = {
      source = "hashicorp/local"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = ">= 0.13"
}
