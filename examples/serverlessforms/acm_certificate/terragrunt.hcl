include "root" {
  path    = find_in_parent_folders()
}

locals {
  tgvars  = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source  = "${get_path_to_repo_root()}//acm/validate_with_route53"
}

inputs    = {
  domain_name                 = local.tgvars.domain_name
  subject_alternative_names   = local.tgvars.subject_alternative_names
  tags                        = {
    Application   = local.tgvars.app_name
    IacProvider   = "terragrunt"
    Environment   = local.tgvars.environment
    AdminEmail    = local.tgvars.admin_email
  }
}
