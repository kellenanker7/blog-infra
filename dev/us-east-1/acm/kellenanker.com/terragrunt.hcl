terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/acm/aws//?version=5.0.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  validation_method   = "DNS"
  wait_for_validation = true
}
