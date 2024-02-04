terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/route53/aws//modules/records?version=2.11.0"
}

include {
  path = find_in_parent_folders()
}

dependency "cdn" {
  config_path = "../../cloudfront"
}

inputs = {
  records = [
    {
      name = ""
      type = "A"
      alias = {
        name    = dependency.cdn.outputs.cloudfront_distribution_domain_name
        zone_id = dependency.cdn.outputs.cloudfront_distribution_hosted_zone_id
      }
    },
  ]
}
