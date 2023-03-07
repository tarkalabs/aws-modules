include "root" {
  path = find_in_parent_folders()
}

dependency "api_sg" {
  config_path = "${get_original_terragrunt_dir()}/../ecs_svc_api_security_group"
}

dependency "ecs_cluster" {
  config_path = "${get_original_terragrunt_dir()}/../ecs_fargate_cluster"
}

dependency "networking" {
  config_path = "${get_original_terragrunt_dir()}/../networking"
}

locals {
  tgvars = yamldecode(file("${get_original_terragrunt_dir()}/../tgvars.yml"))
}

terraform {
  source = "${get_path_to_repo_root()}//ecs/service"
}

inputs = {
  name                = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-api"
  cluster_name        = dependency.ecs_cluster.outputs.cluster_name
  launch_type         = "FARGATE"
  placement_strategy  = []

  assign_public_ip    = true
  security_group_ids  = [dependency.api_sg.outputs.security_group_id]
  subnet_ids          = dependency.networking.outputs.public_subnet_ids

  enable_load_balancer = false
  task_def_family_name = "${local.tgvars.env_prefix}-${local.tgvars.app_slug_name}-api"
  container_name       = "api"

  tags = {
    Application = local.tgvars.app_name
    IacProvider = "terragrunt"
    Environment = local.tgvars.environment
    AdminEmail  = local.tgvars.admin_email
  }
}
