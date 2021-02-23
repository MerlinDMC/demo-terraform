data "ignition_config" "website_assets" {
  directories = [
    data.ignition_directory.htdocs.rendered,
  ]

  files = [
    for fn, asset in data.ignition_file.assets : asset.rendered
  ]

  systemd = [
    data.ignition_systemd_unit.nginx.rendered
  ]
}

data "ignition_directory" "htdocs" {
  filesystem = "root"
  path       = "/var/www/htdocs"
  mode       = 365 # 0555
}

data "ignition_file" "assets" {
  for_each = var.assets

  filesystem = "root"
  path       = "/var/www/htdocs/${each.key}"
  mode       = 292 # 0444

  source {
    source = "data:application/octet-stream;base64,${filebase64(each.value)}"
  }
}

data "ignition_systemd_unit" "nginx" {
  name    = "nginx.service"
  enabled = true
  content = <<EOF
[Unit]
Description=Nginx ${module.vpc.name}
After=network-online.target

[Service]
Type=simple
Restart=on-failure
ExecStart=/usr/bin/docker run \
  --name=nginx \
  --net=host \
  --rm \
  -v /var/www/htdocs:/usr/share/nginx/html:ro \
  nginx:alpine

[Install]
WantedBy=multi-user.target
EOF
}

# tfsec:ignore:AWS002
resource "aws_s3_bucket" "ignition" {
  bucket_prefix = "ignition-"

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.extra_tags, {
    Name = "Ignition",
  })
}

resource "aws_s3_bucket_object" "ignition_website" {
  bucket  = aws_s3_bucket.ignition.id
  key     = "website.json"
  content = data.ignition_config.website_assets.rendered
}

data "ignition_config" "website" {
  append {
    source = "s3://${aws_s3_bucket_object.ignition_website.bucket}/${aws_s3_bucket_object.ignition_website.key}"
  }

  files = [
    data.ignition_file.assets_version.rendered,
  ]
}

locals {
  assets_version = sha256(jsonencode([
    for fn, asset in data.ignition_file.assets : asset.rendered
  ]))
}

data "ignition_file" "assets_version" {
  filesystem = "root"
  path       = "/var/www/assets_version"
  mode       = 292 # 0444

  content {
    content = local.assets_version
  }
}
