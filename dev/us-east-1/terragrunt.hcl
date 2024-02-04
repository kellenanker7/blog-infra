locals {
  global_vars  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account_vars = yamldecode(file(find_in_parent_folders("account.yaml")))
  region_vars  = yamldecode(file("region.yaml"))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region_vars["aws_region"]}"
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "kellenanker-terraform-state"
    key            = "${local.region_vars["aws_region"]}/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "kellenanker-tf-state-lock"
  }
}

inputs = merge(
  local.global_vars,
  local.account_vars,
  local.region_vars,
)
