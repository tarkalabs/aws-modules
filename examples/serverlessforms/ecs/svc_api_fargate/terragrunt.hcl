include "root" {
  path        = find_in_parent_folders()
}

dependency "api_sg" {
  config_path  = "${get_parent_terragrunt_dir()}/ecs/sg_api_svc"
}

dependency "ecs_cluster" {
  config_path  = "${get_parent_terragrunt_dir()}/ecs/fargate_cluster"
}

dependency "load_balancer" {
  config_path  = "${get_parent_terragrunt_dir()}/load_balancer/alb"
}

dependency "networking" {
  config_path  = "${get_parent_terragrunt_dir()}/networking"
}

locals {
  tgvars      = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source      = "${get_path_to_repo_root()}//ecs/service"
}

inputs        = {
  name        = "${local.tgvars.env_prefix}-${local.tgvars.app_name}-api"
  tags        = local.tgvars.tags

  cluster_name          = dependency.ecs_cluster.outputs.cluster_name
  launch_type           = "FARGATE"
  placement_strategy    = []
  assign_public_ip      = true
  security_group_ids    = [dependency.api_sg.outputs.security_group_id]
  subnet_ids            = dependency.networking.outputs.public_subnet_ids
  enable_load_balancer  = false
  task_def_family_name  = "${local.tgvars.env_prefix}-${local.tgvars.app_slug_name}-api"
  container_name        = "api"
  container_port        = 4000

  enable_load_balancer  = true
  target_group_arns     = [dependency.load_balancer.outputs.target_group_arns[0]]
}
