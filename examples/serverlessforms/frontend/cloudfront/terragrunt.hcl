include "root" {
  path      = find_in_parent_folders()
}

dependency "assets_s3_bucket" {
  config_path = "${get_parent_terragrunt_dir()}/frontend/s3_bucket"
}

dependency "acm_cert" {
  config_path = "${get_parent_terragrunt_dir()}/acm_certificate"
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
  tags       = local.tgvars.tags

  wait_for_deployment             = false
  s3_bucket_name                  = dependency.assets_s3_bucket.outputs.id
  s3_bucket_arn                   = dependency.assets_s3_bucket.outputs.arn
  default_root_object             = "index.html"
  s3_bucket_regional_domain_name  = dependency.assets_s3_bucket.outputs.regional_domain_name
  aliases                         = local.tgvars.cloudfront_aliases
  viewer_certificate               = {
    acm_certificate_arn            = dependency.acm_cert.outputs.certificate_arn
    minimum_protocol_version      = "TLSv1"
    ssl_support_method            = "sni-only"
  }
}
