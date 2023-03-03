include {
  path = find_in_parent_folders()
}

locals {
  tgvars = yamldecode(file("${get_original_terragrunt_dir()}/../tgvars.yml"))
}

terraform {
  source = "${get_path_to_repo_root()}//ecs/cluster-fargate"
}

inputs = {
  cluster_name = "${local.tgvars.env_prefix}-serverlessforms"
  default_capacity_provider = "FARGATE"

  tags = {
    Environment = local.tgvars.environment
    AdminEmail = local.tgvars.admin_email
  }
}
