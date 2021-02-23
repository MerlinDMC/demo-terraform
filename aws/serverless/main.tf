/**
 * # Website serverless
 *
 * Hosting a website in a private S3 bucket behind CloudFront.
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

output "url" {
  value = "https://${aws_cloudfront_distribution.website.domain_name}/"
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

resource "aws_iam_role" "s3_gateway" {
  name_prefix = "s3-gateway-"
  path        = "/serverless/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3_gateway_read_assets" {
  name = "ReadAssets"
  role = aws_iam_role.s3_gateway.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      },
    ]
  })
}

resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "Website"
}

resource "aws_s3_bucket_policy" "assets" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.bucket.arn}/*"
        Effect   = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.website.iam_arn
        }
      },
    ]
  })
}

# tfsec:ignore:AWS045
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Website"
  default_root_object = "index.html"

  # tfsec:ignore:AWS021
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 30
    default_ttl            = 3600
    max_ttl                = 86400
  }

  tags = merge(var.extra_tags, {
    Name = "Website",
  })
}
