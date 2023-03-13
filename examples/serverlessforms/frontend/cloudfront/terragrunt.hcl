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
  tgvars        = yamldecode(file("${get_parent_terragrunt_dir()}/tgvars.yml"))
  api_origin_id = "api_prefix_origin"
}

terraform {
  source     = "${get_path_to_repo_root()}//cloudfront/s3_origin"
}

inputs       = {
  name       = "${local.tgvars.app_slug_name}-${local.tgvars.env_prefix}-assets"
  comment    = "Cloudfront distribution for ${local.tgvars.env_prefix} ${local.tgvars.app_name} application"
  tags       = local.tgvars.tags

  wait_for_deployment             = false
  s3_bucket_name                  = dependency.assets_s3_bucket.outputs.id
  s3_bucket_arn                   = dependency.assets_s3_bucket.outputs.arn
  default_root_object             = "index.html"
  s3_bucket_regional_domain_name  = dependency.assets_s3_bucket.outputs.regional_domain_name
  aliases                         = local.tgvars.app_domains
  viewer_certificate               = {
    acm_certificate_arn            = dependency.acm_cert.outputs.certificate_arn
    minimum_protocol_version      = "TLSv1"
    ssl_support_method            = "sni-only"
  }
  # only set when you use path suffix model for api access
  extra_origins                   = {
    api_origin_id                 = {
      origin_id                   = local.api_origin_id
      domain_name                 = local.tgvars.app_domains[0]
      custom_origin_config         = {
        http_port                 = 80
        https_port                = 443
        origin_protocol_policy    = "https-only"
        origin_ssl_protocols      = ["TLSv1.1"]
      }
    }
  }
  ordered_cache_behavior          = [
    {
      path_pattern                = "/api*"
      target_origin_id            = local.api_origin_id
      viewer_protocol_policy      = "https-only"
      allowed_methods             = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods              = ["GET", "HEAD"]
      compress                    = false
      origin_request_policy_id    = "33f36d7e-f396-46d9-90e0-52428a34d9dc" # Managed-AllViewerAndCloudFrontHeaders-2022-06
      # https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=us-east-1#/policies/origin
      cache_policy_id             = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
      # https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=us-east-1#/policies/cache
      use_forwarded_values        = false # explicitly needed when using cache_policy_id
    }
  ]
}
