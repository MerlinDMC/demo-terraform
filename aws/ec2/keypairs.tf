locals {
  key_name_prefix    = "demo"
  timestamp_yyyymmdd = replace(substr(timestamp(), 0, 10), "-", "")
}

resource "tls_private_key" "demo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "demo" {
  key_name   = join("_", [local.key_name_prefix, local.timestamp_yyyymmdd])
  public_key = tls_private_key.demo.public_key_openssh

  lifecycle {
    ignore_changes = [
      key_name,
    ]
  }
}

resource "local_file" "private_key_pem" {
  content = tls_private_key.demo.private_key_pem

  filename        = "${path.root}/.terraform/${aws_key_pair.demo.key_name}.pem"
  file_permission = "0400"
}
