terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/cloudfront/aws//?version=3.2.1"
}

include {
  path = find_in_parent_folders()
}

dependency "s3_origin" {
  config_path = "../ui-bucket"
}

dependency "acm" {
  config_path = "../../us-east-1/acm/kellenanker.com"
}

locals {
  origin_name = "s3"
}

inputs = {
  aliases             = dependency.acm.outputs.distinct_domain_names
  default_root_object = "index.html"

  comment             = "CDN for Kellen Anker's blog"
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = true

  origin = {
    (local.origin_name) = {
      origin_access_control = local.origin_name
      domain_name           = dependency.s3_origin.outputs.s3_bucket_bucket_regional_domain_name
    }
  }

  create_origin_access_control = true
  origin_access_control = {
    (local.origin_name) = {
      description      = "Access control for S3 origin"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  default_cache_behavior = {
    target_origin_id       = local.origin_name
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    use_forwarded_values   = false
  }

  viewer_certificate = {
    acm_certificate_arn      = dependency.acm.outputs.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}
