include "root" {
  path = find_in_parent_folders()
}

locals {
  tgvars = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source = "${get_path_to_repo_root()}//ecs/cluster-fargate"
}

inputs = {
  cluster_name = "${local.tgvars.env_prefix}-${local.tgvars.app_name}"
  default_capacity_provider = "FARGATE"

  tags = {
    Application = local.tgvars.app_name
    IacProvider = "terragrunt"
    Environment = local.tgvars.environment
    AdminEmail  = local.tgvars.admin_email
  }
}
