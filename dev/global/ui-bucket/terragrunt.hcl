terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/s3-bucket/aws//?version=4.1.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  bucket = "kellenanker.com"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = { sse_algorithm = "AES256" }
    }
  }

  object_ownership         = "BucketOwnerEnforced"
  control_object_ownership = true
  restrict_public_buckets  = true
  block_public_policy      = true
  block_public_acls        = true
}
