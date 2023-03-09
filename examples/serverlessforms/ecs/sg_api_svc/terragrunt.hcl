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

  ingress_ports_and_cidr_blocks = [
    {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = "${dependency.networking.outputs.vpc_cidr_block}"
    }
  ]

  egress_ports_and_cidr_blocks  = [
    {
      protocol = "-1"
      from_port = 0
      to_port = 65535
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags                          = {
    Application = local.tgvars.app_name
    IacProvider = "terragrunt"
    Environment = local.tgvars.environment
    AdminEmail  = local.tgvars.admin_email
  }
}
