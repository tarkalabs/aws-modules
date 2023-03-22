include "root" {
  path        = find_in_parent_folders()
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source      = "${get_path_to_repo_root()}//key_pair"
}

inputs        = {
  key_name              = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-ssh"
  create_private_key    = true
  private_key_algorithm = "ED25519"
  tags                  = local.tgvars.tags
}
