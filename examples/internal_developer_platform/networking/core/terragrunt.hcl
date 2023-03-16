include "root" {
  path    = find_in_parent_folders()
}

locals {
  tgvars  = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source  = "${get_path_to_repo_root()}//networking/one-nat-gateway"
}

inputs    = {
  vpc_name              = "${local.tgvars.app_name}-${local.tgvars.env_prefix}-vpc"
  vpc_cidr_block        = local.tgvars.vpc_cidr_block
  availability_zones    = local.tgvars.availability_zones
  public_subnets_cidr   = local.tgvars.public_subnets_cidr
  private_subnets_cidr  = local.tgvars.private_subnets_cidr
  tags                  = local.tgvars.tags
}
