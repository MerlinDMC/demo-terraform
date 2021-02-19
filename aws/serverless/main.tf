/**
 * # Serverless website
 *
 * Hosting a website in a private S3 bucket fronted by API Gateway.
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

# tfsec:ignore:AWS002
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "website-"

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.extra_tags, {
    Name = "Website",
  })
}

locals {
  mime_types = {
    ".htm"  = "text/html"
    ".html" = "text/html"
    ".js"   = "text/plain"
    ".jpg"  = "image/jpeg"
    ".png"  = "image/png"
    ".gif"  = "image/gif"
  }
}

resource "aws_s3_bucket_object" "assets" {
  for_each = var.assets

  bucket = aws_s3_bucket.bucket.id
  key    = each.key
  source = each.value

  content_type = lookup(local.mime_types, lower(regex("\\.[^.]+$", each.key)), null)
}
