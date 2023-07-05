locals {
  tgvars    = yamldecode(file("tgvars.yml"))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region    = "${local.tgvars.aws_region}"
}
EOF
}

remote_state {
  backend     = "s3"
  generate    = {
    path      = "storage-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config       = {
    bucket    = local.tgvars.tf_backend_s3_bucket

    key       = "${local.tgvars.app_name}/${local.tgvars.env_prefix}/${path_relative_to_include()}/terraform.tfstate"
    region    = local.tgvars.tf_backend_s3_bucket_region
    encrypt   = true
  }
}
