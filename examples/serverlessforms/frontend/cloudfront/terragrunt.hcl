include "root" {
  path      = find_in_parent_folders()
}

dependency "assets_s3_bucket" {
  config_path = "${get_parent_terragrunt_dir()}/frontend/s3_bucket"
}

locals {
  tgvars     = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
}

terraform {
  source     = "${get_path_to_repo_root()}//cloudfront/s3_origin"
}

inputs       = {
  name       = "${local.tgvars.app_slug_name}-${local.tgvars.env_prefix}-assets"
  comment    = "Cloudfront distribution for ${local.tgvars.environment} ${local.tgvars.app_name} application"

  wait_for_deployment = true
  s3_bucket_name      = dependency.assets_s3_bucket.outputs.id
  s3_bucket_arn       = dependency.assets_s3_bucket.outputs.arn
  default_root_object = "index.html"

  s3_bucket_regional_domain_name  = dependency.assets_s3_bucket.outputs.regional_domain_name

  tags = {
    Application = local.tgvars.app_name
    IacProvider = "terragrunt"
    Environment = local.tgvars.environment
    AdminEmail  = local.tgvars.admin_email
  }
}
