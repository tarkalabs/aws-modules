include "root" {
  path    = find_in_parent_folders()
}

locals {
  tgvars  = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source  = "${get_path_to_repo_root()}//s3/encrypted_private_bucket"
}

inputs    = {
  name    = "${local.tgvars.app_slug_name}-${local.tgvars.env_prefix}-assets"
  tags    = {
    Application   = local.tgvars.app_name
    IacProvider   = "terragrunt"
    Environment   = local.tgvars.environment
    AdminEmail    = local.tgvars.admin_email
  }
}
