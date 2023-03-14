include "root" {
  path        = find_in_parent_folders()
}

dependency "networking" {
  config_path  = "${get_parent_terragrunt_dir()}/networking"
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source      = "${get_path_to_repo_root()}//networking/security-group"
}

inputs = {
  name        = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-api-sg"
  description = "${local.tgvars.app_name} api security group"
  vpc_id      = dependency.networking.outputs.vpc_id
  tags        = local.tgvars.tags

  security_group_rules  = {
    ingress_allow_http  = {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 4000
      to_port     = 4000
      cidr_blocks = [dependency.networking.outputs.vpc_cidr_block]
    },
    egress_allow_all    = {
      type        = "egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = local.tgvars.open_to_all_cidr_blocks
    }
  }
}