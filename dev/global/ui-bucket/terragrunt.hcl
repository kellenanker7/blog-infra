terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/s3-bucket/aws//?version=4.1.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  bucket_name = "kellenanker.com"
}

inputs = {
  # General
  bucket     = local.bucket_name
  versioning = { status = "Enabled" }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = { sse_algorithm = "AES256" }
    }
  }

  # Object ownership
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # Bucket permissions
  block_public_acls                     = true
  block_public_policy                   = true
  ignore_public_acls                    = true
  restrict_public_buckets               = true
  attach_deny_insecure_transport_policy = true
  attach_policy                         = true
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "RootAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${get_aws_account_id()}:root"
        }
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*",
        ]
      },
      {
        Sid    = "CloudFrontAccess"
        Action = "s3:GetObject"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Resource = "arn:aws:s3:::${local.bucket_name}/*"
        Condition = {
          StringEquals = {
            "aws:PrincipalAccount" = get_aws_account_id()
          }
        }
      }
    ]
  })
}
