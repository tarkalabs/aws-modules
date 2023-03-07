include "root" {
  path = find_in_parent_folders()
}

locals {
  tgvars = yamldecode(file("${get_original_terragrunt_dir()}/../tgvars.yml"))
}

terraform {
  source = "${get_path_to_repo_root()}//networking/no-private-subnets"
}

inputs = {
  vpc_name = "slf-${local.tgvars.env_prefix}-vpc"
  vpc_cidr_block = local.tgvars.vpc_cidr_block

  availability_zones = local.tgvars.availability_zones
  public_subnets_cidr = local.tgvars.public_subnets_cidr

  tags = {
    Application = local.tgvars.app_name
    IacProvider = "terragrunt"
    Environment = local.tgvars.environment
    AdminEmail  = local.tgvars.admin_email
  }
}
