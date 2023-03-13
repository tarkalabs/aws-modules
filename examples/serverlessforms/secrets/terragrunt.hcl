include "root" {
  path        = find_in_parent_folders()
}

dependency "db" {
  config_path  = "${get_parent_terragrunt_dir()}/database/postgres_db"
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source      = "${get_path_to_repo_root()}//secrets_manager/simple"
}

inputs = {
  name        = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-secrets"
  tags        = local.tgvars.tags
  secrets     = {
    DB_USERNAME = dependency.db.outputs.db_instance_username
  }
}
