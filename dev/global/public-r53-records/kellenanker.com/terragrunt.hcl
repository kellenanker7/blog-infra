terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/route53/aws//modules/records?version=2.11.0"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  records = [
    {
      name = "blog"
      type = "CNAME"
      ttl  = 300
      records = [
        "modernizing-infra.netlify.app",
      ]
    },
  ]
}
