resource "aws_iam_role" "website" {
  name_prefix = "website-"
  path        = "/system/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "website" {
  name_prefix = "website-"
  role        = aws_iam_role.website.name
}

resource "aws_iam_role_policy" "website_ignition_config" {
  name_prefix = "website-"
  role        = aws_iam_role.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
        ]
        Resource = "${aws_s3_bucket.ignition.arn}/${aws_s3_bucket_object.ignition_website.key}"
      },
    ]
  })
}
